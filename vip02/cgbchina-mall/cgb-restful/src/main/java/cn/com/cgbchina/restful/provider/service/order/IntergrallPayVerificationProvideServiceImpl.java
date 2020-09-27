package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.related.model.CustLevelInfo;
import cn.com.cgbchina.related.service.RestACardCustToelectronbankService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.IntergrallPayVerificationOrderInfoVO;
import cn.com.cgbchina.rest.provider.vo.order.IntergrallPayVerificationReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.IntergrallPayVerificationVO;
import cn.com.cgbchina.rest.provider.vo.order.PayReturnOrderVo;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.*;
import cn.com.cgbchina.user.service.UserInfoService;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import lombok.extern.slf4j.Slf4j;
import org.apache.xmlbeans.SystemProperties;
import org.elasticsearch.common.base.Strings;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * MAL325 积分商城支付校验接口 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL325")
@Slf4j
public class IntergrallPayVerificationProvideServiceImpl implements SoapProvideService<IntergrallPayVerificationVO, IntergrallPayVerificationReturnVO> {
    @Resource
    RestACardCustToelectronbankService restACardCustToelectronbankService;
    @Resource
    UserInfoService userInfoService;
    @Resource
    SmsMessageService smsMessageService;
    @Resource
    DealO2OOrderService dealO2OOrderService;
    @Resource
    PayService payService;
    @Resource
    OrderService orderService;
    @Resource
    OrderCheckService orderCheckService;
    @Autowired
    private JedisTemplate jedisTemplate;
    private final ThreadLocal<String> threadLocalLockId = new ThreadLocal<String>();

    @Override
    public IntergrallPayVerificationReturnVO process(SoapModel<IntergrallPayVerificationVO> model, IntergrallPayVerificationVO content) {
        IntergrallPayVerificationReturnVO intergrallPayVerificationReturnVO = new IntergrallPayVerificationReturnVO();

        log.info("【MAL325】流水：" + model.getSenderSN() + "，进入支付校验接口");
        String origin = content.getOrigin(); //发起方  调用方标识:如手机商城:03
        final String ordermain_id = content.getOrdermainId(); //大订单号
        Map<String,String> resultMap=new HashMap<>();//小订单状态
        String payAccountNo = content.getPayAccountNo(); //支付账号
        String cardType = content.getCardType(); //卡类型  C：信用卡
        String orders = content.getOrders(); //订单信息串:[ 商户号|大订单号|金额|积分|响应码]
        String crypt = content.getCrypt();  //签名 [签名因子：大订单号|支付帐号|卡类型|订单信息串]
        //支付时间
//        String payTimeStr = content.getPayTime();
//        Date payTime = DateHelper.string2Date(payTimeStr, DateHelper.YYYYMMDDHHMMSS);
        try {
        	/**
        	 * ============订单信息检查 start==========
        	 */
            String singGene = ordermain_id + "|" + payAccountNo + "|" + cardType + "|" + orders;
            boolean isCrypt = false;
            try {
                log.info("【MAL325】流水：" + model.getSenderSN() + "，singGene:" + singGene);
                isCrypt = orderCheckService.verify_md(singGene, crypt);// 验签
                if (!isCrypt) {// 如果验签失败
                    log.info("【MAL325】流水：" + model.getSenderSN() + "isCrypt is false");
                    intergrallPayVerificationReturnVO.setReturnCode("000011");
                    intergrallPayVerificationReturnVO.setReturnDes("验签失败");
                    return intergrallPayVerificationReturnVO;
                }
            } catch (Exception e) {
                log.error("exception", e);
                intergrallPayVerificationReturnVO.setReturnCode("000042");
                intergrallPayVerificationReturnVO.setReturnDes("验签异常");
                return intergrallPayVerificationReturnVO;
            }
            
            // 二次提交校验
        	// 获取分布式锁
        	String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate,
        			"ORDERID"+ordermain_id, 50, 5000);
        	if (lockId == null) {
        	    log.info("二次提交，订单号：" + ordermain_id);
        	    intergrallPayVerificationReturnVO.setReturnCode("000050");
        	    intergrallPayVerificationReturnVO.setReturnDes("支付处理中，不能进行重复支付");
        	    return intergrallPayVerificationReturnVO;
        	}
        	threadLocalLockId.set(lockId);
            
            List<PayReturnOrderVo> checkList = Lists.newArrayList();
            try {
                //解析订单信息串 --信息串拆分 【商户号|大订单号|金额|积分|响应码】
                checkList = parseOrders(orders);
                log.info("子订单串大小：" + checkList.size());
            } catch (Exception e) {
                log.error("【MAL325】流水：" + model.getSenderSN()+"[订单无法修改]", e);
                DistributedLocks.releaseLock(jedisTemplate, "ORDERID"
                        + ordermain_id, threadLocalLockId.get());
                intergrallPayVerificationReturnVO.setReturnCode("000014");
                intergrallPayVerificationReturnVO.setReturnDes("订单无法修改");
                return intergrallPayVerificationReturnVO;
            }
            OrderMainModel orderMain=null;
          //查询主订单信息，用来判断订单是否可以进行更新
            Response<OrderMainModel> responseMainOrder = orderService.findOrderMainById(ordermain_id);
            orderMain = responseMainOrder.getResult();
            if(orderMain==null){
                DistributedLocks.releaseLock(jedisTemplate, "ORDERID"
                        + ordermain_id, threadLocalLockId.get());
            	intergrallPayVerificationReturnVO.setReturnCode("000050");
                intergrallPayVerificationReturnVO.setReturnDes("订单不存在");
                return intergrallPayVerificationReturnVO;
            }
            if(!Contants.SUB_ORDER_STATUS_0301.equals(orderMain.getCurStatusId())){
                DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + ordermain_id, threadLocalLockId.get());
            	intergrallPayVerificationReturnVO.setReturnCode("000050");
                intergrallPayVerificationReturnVO.setReturnDes("支付结果已存在，不能进行重复支付");
                return intergrallPayVerificationReturnVO;
            }
            /**
        	 * ============订单信息检查 end==========
        	 */
            
            /**
             * ============处理订单支付结果 start=============
             */
            String curStatusId=null;
            try {
                String custType = "";//客户级别
                // 先查询订单信息，再事务控制
                Response<List<OrderSubModel>> responseList = orderService.findByOrderMainId(ordermain_id); //根据主订单号查询子订单表数据
                List<OrderSubModel> orderList = responseList.getResult();
                log.info("findById（）查询出大订单的信息个数为：1");
                for (OrderSubModel order : orderList) {
                	if(!Strings.isNullOrEmpty(content.getPayTime())){
                		order.setOrder_succ_time(DateHelper.string2Date(content.getPayTime(),
                                 DateHelper.YYYYMMDDHHMMSS));
                        order.setOrder_succ_timeStr(DateHelper.date2string(order.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
                	} else if(order.getBonusTotalvalue()!=null&&order.getBonusTotalvalue()>0) {
                        if (orderMain != null && orderMain.getCreateTime() != null){
                            order.setOrder_succ_time(orderMain.getCreateTime());
                            order.setOrder_succ_timeStr(DateHelper.date2string(orderMain.getCreateTime(),DateHelper.YYYY_MM_DD_HH_MM_SS));
                            orderMain.setPayResultTime(DateHelper.date2string(orderMain.getCreateTime(),DateHelper.YYYYMMDDHHMMSS));
                        }else {
                            order.setOrder_succ_time(new Date());
                            order.setOrder_succ_timeStr(DateHelper.date2string(order.getOrder_succ_time(),DateHelper.YYYY_MM_DD_HH_MM_SS));
                            orderMain.setPayResultTime(DateHelper.date2string(order.getOrder_succ_time(),DateHelper.YYYYMMDDHHMMSS));
                        }
                        log.error("###电子支付问题###包含积分且没有上送支付时间 orderMainId:"+content.getOrdermainId());
                	}
                    /**
                     * 南航白金卡vip客户最优等级需求
                     * 判断客户级别是否为空，
                     * 如果为空则说明第一次下单保存订单的时候没有在南航白金卡数据来源取得客户级别
                     * 先查询南航白金卡数据来源取得客户级别
                     * 如果没有数据，则调用积分系统
                     */
                    if (order.getCustType() == null || "".equals(order.getCustType())) {
                        CustLevelInfo custInfo = new CustLevelInfo();
                        String custCardId = orderMain.getContIdcard();//获取证件号码
                        log.info("查询出证件号码为：" + custCardId);
                        if (custCardId != null && !"".equals(custCardId.trim())) {
                            Response<CustLevelInfo> response =
                                    restACardCustToelectronbankService.getCustLevelInfo(custCardId);//查询客户信息
                            custInfo = response.getResult();
                            custType=custInfo.getCustType();
                        }
                    } else {
                        custType = order.getCustType();
                    }
                    log.info("手机商城最终保存的客户等级为：" + custType);
                    //当客户等级获取成功或者不为空，跳出当前循环
                    if (!"".equals(custType)) {
                        break;
                    }
                }
            	//更新订单信息
                Response<Map<String,String>> response = payService.dealJFOrderWithTX(ordermain_id, payAccountNo, cardType, checkList, orderList, custType);// 修改订单支付状态
                if(response.isSuccess()){
                    resultMap=response.getResult();
                    curStatusId=resultMap.get(ordermain_id);
                }
            } catch (Exception e) {
                DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + ordermain_id, threadLocalLockId.get());
                log.error("【MAL325】流水：" + model.getSenderSN() + "," + "exception", e);
                intergrallPayVerificationReturnVO.setReturnCode("000027");
                intergrallPayVerificationReturnVO.setReturnDes("数据库操作异常");
                return intergrallPayVerificationReturnVO;
            }
            /**
             * ============处理订单支付结果 end=============
             */
            
            PayReturnOrderVo vo = checkList.get(0);
            Response<List<OrderSubModel>> responseList = orderService.findByOrderMainId(ordermain_id); //根据主订单号查询子订单表数据
            final List<OrderSubModel> orderList = responseList.getResult();
            List<IntergrallPayVerificationOrderInfoVO> returnList = Lists.newArrayList();
            final List<String> vendorIds = Lists.newArrayList();
            for (OrderSubModel order : orderList) {
                IntergrallPayVerificationOrderInfoVO voForReturn = new IntergrallPayVerificationOrderInfoVO();
                log.info("查询小订单数目：" + orderList.size() + " order_id:" + order.getOrderId());
                voForReturn.setOrderId(order.getOrderId());// 订单号
                voForReturn.setCur_statusId(resultMap.get(order.getOrderId()));// 当前状态
                voForReturn.setErrorCode(vo.getReturnCode());// 支付网关返回码
                String error_code_text = getReturnCode(vo.getReturnCode());// 支付网关返回码说明
                voForReturn.setErrorCodeText(error_code_text);// 返回码说明
                returnList.add(voForReturn);
                vendorIds.add(order.getVendorId());
            }
            intergrallPayVerificationReturnVO.setOrdersInfo(returnList);
            
            /**
             * ==========支付成功发送短信 start===============
             */
            try {
                long totalBonus = orderMain.getTotalBonus();
                double totalPrice = orderMain.getTotalPrice().doubleValue();
                String mobilePhone = orderMain.getContMobPhone();
                if ("0308".equals(curStatusId)) {
                    smsMessageService.sendJFSMSMessage(totalBonus, totalPrice, mobilePhone, null);
                }
            } catch (Exception e) {
                log.info("【MAL325】流水：" + model.getSenderSN() + "发短信出现异常");
                log.error("exception", e);
            }
            intergrallPayVerificationReturnVO.setReturnCode("000000");
            /**
             * ==========支付成功发送短信 end ===============
             */
            
            /**
             * ==========O2O订单信息推送 start============
             */
            try {
				threadPool.execute(new Runnable() {
					@Override
					public void run() {
						log.info("大订单号中有需要实时推送：" + ordermain_id);
						// 订单推送接口
						for (OrderSubModel order : orderList) {
							dealO2OOrderService.dealO2OOrdersAfterPaySucc(
									order.getOrderId(), order.getOrdermainId(),
									order.getVendorId());
						}
					}
				});
            } catch (Exception e) {
                log.error("手机积分支付调用外网o2o系统失败：" ,e);
            }
            /**
             * ==========O2O订单信息推送 end============
             */
            
        } catch (Exception e) {
            DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + ordermain_id, threadLocalLockId.get());
            log.error("【MAL325】流水：" + model.getSenderSN() + "Exception:", e);
            intergrallPayVerificationReturnVO.setReturnCode("000009");
            intergrallPayVerificationReturnVO.setReturnDes("系统异常");
            return intergrallPayVerificationReturnVO;
        }
        DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + ordermain_id, threadLocalLockId.get());
        return intergrallPayVerificationReturnVO;
    }
    ExecutorService threadPool=Executors.newCachedThreadPool();
    /**
     * 解析订单信息串
     *
     * @param orders
     * @return payReturnOrderVo list
     * @throws Exception
     */
    private List<PayReturnOrderVo> parseOrders(String orders) throws Exception {
        log.info("进入parseOrders");
        log.info("子订单信息：" + orders);
        List<PayReturnOrderVo> list = Lists.newArrayList();
        if (orders == null || "".equals(orders)) {
            log.info("拼xml报文时子订单为空");
            throw new Exception("orders is null");
        }
        String orderArray[] = orders.split("\\|");
        if (orderArray.length % 5 != 0) {// 如果除以5余数不为0
            log.info("子订单数据错误");
            throw new Exception("orderArray.length % 5 must be 0");
        }
        for (int i = 0; i < orderArray.length; i = i + 5) {
            PayReturnOrderVo payReturnOrderVo = new PayReturnOrderVo();
            payReturnOrderVo.setVendor_id(orderArray[i]);//商户号
            payReturnOrderVo.setOrder_id(orderArray[i + 1]);//订单号
            payReturnOrderVo.setMoney(orderArray[i + 2]);//金额
            payReturnOrderVo.setPoint(orderArray[i + 3]);//积分
            payReturnOrderVo.setReturnCode(orderArray[i + 4]);//响应码
            list.add(payReturnOrderVo);
        }
        return list;
    }

    public  String getReturnCode(String error_code){
        String error_code_text = "";
        Properties prop = new Properties();
        try {
            InputStream in = SystemProperties.class.getClassLoader().getResourceAsStream(
                    "returnCode.properties");
            prop.load(in);
            error_code_text = prop.getProperty(error_code);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return error_code_text;
    }
}
