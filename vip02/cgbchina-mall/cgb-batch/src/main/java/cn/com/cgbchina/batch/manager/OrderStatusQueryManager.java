package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.OrderStatusQueryDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.ItemModel;
import cn.com.cgbchina.batch.model.OrderCheckModel;
import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import cn.com.cgbchina.batch.model.OrderMainModel;
import cn.com.cgbchina.batch.model.OrderStatusQueryModel;
import cn.com.cgbchina.batch.model.TblCfgProCodeModel;
import cn.com.cgbchina.batch.model.TblGoodsPaywayModel;
import cn.com.cgbchina.batch.model.TblOrderExtend1Model;
import cn.com.cgbchina.batch.model.TblOrderOutSystemModel;
import cn.com.cgbchina.batch.model.TblVendorRatioModel;
import cn.com.cgbchina.batch.model.VendorInfoModel;
import cn.com.cgbchina.batch.model.VendorPayNoModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.CardUtil;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionService;
import cn.com.cgbchina.rest.visit.model.payment.OrderBaseInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResult;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResultInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.trade.service.DealO2OOrderService;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.service.NewMessageService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Xiehongri on 2016/7/11.
 * 企业网银状态回查-商城
 */
@Component
@Slf4j
public class OrderStatusQueryManager {
    @Resource
    private OrderStatusQueryDao orderStatusQueryDao;
    @Resource
    PaymentService paymentService;
    @Resource
    StagingRequestService stagingRequestService;
    @Autowired
    private IdGenarator idGenarator;
    @Resource
    private ItemService itemService;
    @Resource
    private PromotionService promotionService;
    @Resource
    private MallPromotionService mallPromotionService;
    @Resource
    private NewMessageService newMessageService;

    private static long gwSeq = 1000;
    /** 大机试运行标识 1：试运行  0：试运行结束 */
    private static String runFlag;
    /** 大机试运行卡号8,9位 */
    private static String cardNoSubStr;
    @Autowired
    private DealO2OOrderService dealO2OOrderService;

    @Transactional
    public void orderStatusQuery() {
        log.info("企业网银状态回查-商城job beginning");
        String time = "";
        PaymentRequeryResult nsct002Response = null;//返回报文接收
        List<PaymentRequeryResultInfo> responseOrders = Lists.newArrayList();//返回信息订单集合
        
        
        
        /*************************************借记卡一期订单  start********************************/
        try{
            //step1查出偏移时间time
            // 偏移时间 获取30分钟之前数据
            time = DateTime.now().minusMinutes(30).toString(DateHelper.YYYY_MM_DD_HH_MM_SS);

            // 处理小订单 乐购一期
            // 加条件-查询某段时间之前的(如半个小时)
            List<OrderStatusQueryModel> orders = orderStatusQueryDao.getUnCommOrder(time,"YG");
            if(orders != null && orders.size() != 0) {
                //step2调用Nsct002Server，获取返回的报文document
                try{
                    //调用订单状态查询接口                    
                    List<OrderBaseInfo> orderBaseInfos = Lists.newArrayList();
                                        
                    for(OrderStatusQueryModel orderSubModel : orders){
                        if(orderSubModel!=null){
                            OrderBaseInfo orderBaseInfo = new OrderBaseInfo();
                            orderBaseInfo.setOrderId(orderSubModel.getOrderId());
                            orderBaseInfo.setPayDate(orderSubModel.getCreateTime());
                            orderBaseInfo.setMerId(orderSubModel.getMerId());
                            orderBaseInfos.add(orderBaseInfo);
                        }
                    }
                    // NSCT002 每次最多能接受5条数据 
                    List<List<OrderBaseInfo>> order5s = Lists.partition(orderBaseInfos, 5);
                    for (List<OrderBaseInfo> order5 : order5s) {
                    	PaymentRequeryInfo paymentRequeryInfo = new PaymentRequeryInfo();
                    	paymentRequeryInfo.setOrderAmount(String.valueOf(order5.size()));
                        paymentRequeryInfo.setOrderBaseInfos(order5);
                        nsct002Response  = paymentService.paymentRequery(paymentRequeryInfo);
                        // step3将返回的报文转化为Nsct002Response对象如果返回“000000”报文成功，取到返回信息订单集合responseOrders
                        if (nsct002Response != null){
                            if ("000000".equals(nsct002Response.getRetCode())) {// 如果返回报文成功
                                responseOrders = nsct002Response.getInfos();
                                // step4 更新子订单集合responseOrders。处理字段：【payAccountNo卡号、cardType借记卡信用卡标识、orderId订单号】
                                updateOrderStatus(responseOrders);
                                // step5 遍历小订单信息，获取每一个小订单的订单号，调用dealO2OOrderService推送支付成功的O2O订单。
                                // 如果支付成功，查询该订单的商户信息是否为020商品商户，表示存在O2O商品，将订单推送到外系统。
                                for(OrderStatusQueryModel orderSubModel : orders){
                                    String orderId = orderSubModel.getOrderId();// 订单号
                                    // 推送支付成功的O2O订单
                                    dealO2OOrderService.dealO2OOrdersAfterPaySucc(orderId);
                                }
                            }
                        }                                               
                    } 
                }catch(Exception e){
                    log.error("乐购一期回查订单处理异常，异常信息：{}",Throwables.getStackTraceAsString(e));
                }   
            }
        }catch(Exception e1){
            log.error("乐购一期处理推送信息异常：{}",Throwables.getStackTraceAsString(e1));
        }
        /*************************************借记卡一期订单  end********************************/
        
        
        
        
        
        /******************************分期订单   start*******************************/
        try{
            //处理小订单 乐购分期
            //step21 根据time获取昨天和今天的状态是待付款和状态未明的分期小订单List(需要回查电子支付平台的)sumFQOrder
                List<OrderStatusQueryModel> orders = orderStatusQueryDao.getUnCommOrder(time, "FQ");
            if (orders != null && orders.size() != 0) {
                //step22调用Nsct002Server，将小订单信息发送，获取返回的报文document将返回的报文转化为Nsct002Response对象
                try {
                    List<OrderBaseInfo> orderBaseInfos = Lists.newArrayList();
                    
                    for (OrderStatusQueryModel orderSubModel : orders) {
                        if (orderSubModel != null) {
                            OrderBaseInfo orderBaseInfo = new OrderBaseInfo();
                            orderBaseInfo.setOrderId(orderSubModel.getOrderId());
                            orderBaseInfo.setPayDate(orderSubModel.getCreateTime());
                            orderBaseInfo.setMerId(orderSubModel.getMerId());
                            orderBaseInfos.add(orderBaseInfo);
                        }
                    }
                    List<List<OrderBaseInfo>> order5s = Lists.partition(orderBaseInfos, 5);
                    for (List<OrderBaseInfo> order5 : order5s) {
                    	PaymentRequeryInfo paymentRequeryInfo = new PaymentRequeryInfo();
                    	paymentRequeryInfo.setOrderAmount(String.valueOf(order5.size()));
                        paymentRequeryInfo.setOrderBaseInfos(order5);
                        nsct002Response  = paymentService.paymentRequery(paymentRequeryInfo);
                        //step23调用Nsct002Server，如果返回报文成功，取到返回信息订单集合responseOrders
                        if (nsct002Response != null){
                            if ("000000".equals(nsct002Response.getRetCode())) {// 如果电子支付返回报文成功
                                responseOrders = nsct002Response.getInfos();
                                // 020业务与商城供应商平台对接
                                List<Map<String,Object>> returnList = dealFQOrderStatus(responseOrders);//更新订单状态
                                //step28取得每一个订单信息的cur_status_id，如果cur_status_id=0308（订单支付成功，进行O2O推送处理），调用dealO2OOrderService推送支付成功的O2O订单，根据小订单推送
                                if (returnList != null && returnList.size() > 0) {
                                    for (int jj = 0; jj < returnList.size(); jj++) {
                                        Map<String,Object> rm = returnList.get(jj);
                                        String cur_status_id = (String) rm.get("cur_status_id");
                                        //订单支付成功，进行O2O推送处理
                                        if ("0308".equals(cur_status_id)) {
                                            String orderId = (String) rm.get("orderId");
                                            String orderMainId = (String) rm.get("orderMainId");
                                            String vendorId = (String) rm.get("vendorId");
                                            // 推送支付成功的O2O订单
                                            dealO2OOrderService.dealO2OOrdersAfterPaySucc(orderId, orderMainId, vendorId);
                                        }
                                    }
                                }
                            }
                        }                       
                    }
                } catch (Exception e1) {
                    log.error("乐购回查订单处理异常，异常信息：{}", Throwables.getStackTraceAsString(e1));
                }               
            }
        }catch(Exception e){
            log.error("乐购分期处理推送信息异常：{}" ,Throwables.getStackTraceAsString(e));
        }
        /******************************分期订单   end*******************************/
        
        
        
        /*********************************回查积分商城订单 start******************************************/
        try {
            // 处理大订单 积分(纯积分不处理)
            //step31 根据time获取大订单list（获取昨天和今天的状态是待付款和状态未明的积分大订单总数）sumOrderMain
            List<OrderMainModel> orders = orderStatusQueryDao.getUnCommOrderMain(time, "JF");// 获取大订单信息 // 加条件-查询某段时间之前的(如半个小时)
            if (orders != null && orders.size() != 0) {
                //step32调用Nsct002Server，将小订单信息发送，获取返回的报文document 将返回的报文转化为Nsct002Response对象
                try {                    
                    List<OrderBaseInfo> orderBaseInfos = new ArrayList<OrderBaseInfo>();
                    for (OrderMainModel orderMainModel : orders) {
                        OrderBaseInfo orderBaseInfo = new OrderBaseInfo();
                        orderBaseInfo.setMerId(String.valueOf(orderMainModel.getMerId()));
                        orderBaseInfo.setPayDate(orderMainModel.getCreateTime());
                        orderBaseInfo.setOrderId(orderMainModel.getOrdermainId());
                        orderBaseInfos.add(orderBaseInfo);
                    }
                    List<List<OrderBaseInfo>> order5s = Lists.partition(orderBaseInfos, 5);
                    for(List<OrderBaseInfo> order5 : order5s){
                    	PaymentRequeryInfo paymentRequeryInfo = new PaymentRequeryInfo();
                    	paymentRequeryInfo.setOrderAmount(String.valueOf(order5.size()));
                        paymentRequeryInfo.setOrderBaseInfos(order5);
                        nsct002Response = paymentService.paymentRequery(paymentRequeryInfo);
                        //step33如果返回报文成功，取到返回信息订单集合responseOrders 更新子订单集合responseOrders
                        if (nsct002Response != null) {
                            if ("000000".equals(nsct002Response.getRetCode())) {// 如果返回报文成功
                                responseOrders = nsct002Response.getInfos();
                                updateOrderMainStatus(responseOrders);
                            }
                        }
                    } 
                } catch (Exception e) {
                    log.error("积分回查订单处理异常，异常信息：{}", Throwables.getStackTraceAsString(e));
                }               
            }
        } catch (Exception e) {
            log.error("积分状态回查任务碰到异常:{}", Throwables.getStackTraceAsString(e));
        }
        /*********************************回查积分商城订单 end******************************************/
    }

    /**
     * 更新大订单集合
     * @param orders
     * @throws Exception
     */
    @Transactional
    public void updateOrderMainStatus(List<PaymentRequeryResultInfo> orders) throws Exception{
        log.info("into updateOrderMainStatus");
        for (PaymentRequeryResultInfo order : orders) {
            String payAccountNo=order.getPayAccountNo();//卡号
            String cardType= CardUtil.getCardType(payAccountNo);//借记卡信用卡标识
            String orderMainId=order.getOrderId();
            String tradeStatus=order.getTradeStatus();
            Date payTime=order.getPayTime();
            updateOrderMainStatuWithTxn(orderMainId, tradeStatus, payAccountNo, cardType, payTime);
        }
    }

    /**
     * 更新单个大订单
     * @param orderMainId
     * @param tradeStatus
     * @param payAccountNo
     * @param cardType
     * @throws Exception
     */
    @Transactional
    public void updateOrderMainStatuWithTxn(String orderMainId,String tradeStatus,String payAccountNo,String cardType, Date payTime) throws Exception{
        String CUR_STATUS_ID = "0308";// 已下单
        String CUR_STATUS_NM ="支付成功";// 已下单
        if ("1".equals(tradeStatus)) {// 如果大订单状态成功
            CUR_STATUS_ID = "0308";// 已下单
            CUR_STATUS_NM ="支付成功";// 已下单
            //orderStatusQueryDao.updateTblEspCustCart(orderMainId, "1");//更新购物车
            List<OrderStatusQueryModel> oList = orderStatusQueryDao.getOrderList(orderMainId);
			if (oList != null && oList.size() > 0) {
                TblOrderOutSystemModel too = new TblOrderOutSystemModel();
                for (int i = 0; i < oList.size(); i++) {
                	OrderStatusQueryModel model = oList.get(i);
                    String orderId = model.getOrderId();
                    too.setOrderId(orderId);
                    too.setOrderMainId(orderMainId);
                    too.setTimes(0);
                    too.setTuisongFlag("0");
                    too.setCreateTime(new Date());
                    too.setSystemRole("00");//O2O
                    too.setCreateOper("来自状态回查");
                    orderStatusQueryDao.insertOrderOutSystem(too);
                    // 更新销量
                    OrderStatusQueryModel orderModel = orderStatusQueryDao.findOrderById(orderId);
                    updateSaleCount(orderModel);
                }
            }
        } else if ("2".equals(tradeStatus)) {// 如果大订单状态交易失败
            CUR_STATUS_ID = "0307";// 下单失败
            CUR_STATUS_NM = "支付失败";// 下单失败
            orderStatusQueryDao.updateBirthday(orderMainId);//更新生日件数(只有商城渠道才回滚)
            dealGoodsByorderMainId(orderMainId);//回滚库存
        } else if ("3".equals(tradeStatus)) {// 如果大订单状态未明,因为肯定是信用卡,所以更新本地数据为支付失败
            CUR_STATUS_ID = "0307";// 支付失败
            CUR_STATUS_NM = "支付失败";// 支付失败
            orderStatusQueryDao.updateBirthday(orderMainId);//更新生日件数(只有商城渠道才回滚)
            dealGoodsByorderMainId(orderMainId);//回滚库存
        } else if ("4".equals(tradeStatus)) {// 如果大订单已撤单
            CUR_STATUS_ID = "0312";// 已撤单
            CUR_STATUS_NM = "已撤单";// 已撤单
            orderStatusQueryDao.updateBirthday(orderMainId);//更新生日件数(只有商城渠道才回滚)
            dealGoodsByorderMainId(orderMainId);//回滚库存
        } else if ("9".equals(tradeStatus)||"8".equals(tradeStatus)) {// 订单不存在或企业网银查数据异常
            return;
        }else{
            return;
        }
        OrderMainModel orderMainModel = new OrderMainModel();
        OrderStatusQueryModel orderSubModel = new OrderStatusQueryModel();
        if(payAccountNo!=null&&!"".equals(payAccountNo.trim())&&!"9".equals(payAccountNo)){//如果有返回帐号，就更新帐号和帐号标识
            orderMainModel.setCurStatusId(CUR_STATUS_ID);
            orderMainModel.setCurStatusNm(CUR_STATUS_NM);
            orderMainModel.setOrdermainId(orderMainId);
            orderMainModel.setPayResultTime(DateHelper.date2string(payTime, DateHelper.YYYYMMDDHHMMSS));
            orderMainModel.setCardno(payAccountNo);
            orderStatusQueryDao.updateOrderMainStatus(orderMainModel);
            orderSubModel.setCardno(payAccountNo);
            orderSubModel.setOrdermainId(orderMainId);
            orderSubModel.setCardtype(cardType);
            orderSubModel.setCurStatusId(CUR_STATUS_ID);
            orderSubModel.setCurStatusNm(CUR_STATUS_NM);
            orderSubModel.setOrder_succ_time(payTime);
            orderStatusQueryDao.updateOrderStatusbyId(orderSubModel);
        }else{
            orderMainModel.setCurStatusId(CUR_STATUS_ID);
            orderMainModel.setCurStatusNm(CUR_STATUS_NM);
            orderMainModel.setOrdermainId(orderMainId);
            orderMainModel.setPayResultTime(DateHelper.date2string(payTime, DateHelper.YYYYMMDDHHMMSS));
            orderStatusQueryDao.updateOrderMainStatus(orderMainModel);
            orderSubModel.setOrdermainId(orderMainId);
            orderSubModel.setCurStatusId(CUR_STATUS_ID);
            orderSubModel.setCurStatusNm(CUR_STATUS_NM);
            orderSubModel.setOrder_succ_time(payTime);
            orderStatusQueryDao.updateOrderStatusbyId(orderSubModel);
        }
        // 插入操作履历
        insertOrderDodetailFromOrderMain(orderMainId, CUR_STATUS_ID, CUR_STATUS_NM);
    }

    /**
     * 更新子订单集合
     * @param orders
     * @throws Exception
     */
    @Transactional
    public void updateOrderStatus(List<PaymentRequeryResultInfo> orders) throws Exception{
        log.info("into updateOrderStatus");
        for (PaymentRequeryResultInfo paymentRequeryResultInfo : orders){
            String payAccountNo = paymentRequeryResultInfo.getPayAccountNo();//卡号
            String cardType = CardUtil.getCardType(payAccountNo);//借记卡信用卡标识
            String orderId = paymentRequeryResultInfo.getOrderId();
            String tradeStatus = paymentRequeryResultInfo.getTradeStatus();
            Date payTime = paymentRequeryResultInfo.getPayTime();
            updateOrderStatuWithTxn(orderId, tradeStatus, payAccountNo, cardType, payTime);
        }
    }

    /**
     * 更新单个子订单
     * @param orderId
     * @param tradeStatus
     * @param payAccountNo
     * @param cardType
     * @throws Exception
     */
    @Transactional
    public void updateOrderStatuWithTxn(String orderId, String tradeStatus, String payAccountNo, String cardType, Date payTime) throws Exception{
        String CUR_STATUS_ID="";
        String CUR_STATUS_NM="";
        OrderStatusQueryModel orderModel = orderStatusQueryDao.findOrderById(orderId);
        if ("1".equals(tradeStatus)) {// 如果小订单状态成功
            CUR_STATUS_ID = "0308";// 已下单
            CUR_STATUS_NM = "支付成功";// 已下单
            //orderStatusQueryDao.updateTblEspCustCartByOrderId(orderId, "1");//更新购物车
            // 更新销量
            updateSaleCount(orderModel);
        } else if ("2".equals(tradeStatus)) {// 如果小订单状态交易失败
            CUR_STATUS_ID = "0307";// 下单失败
            CUR_STATUS_NM = "支付失败";// 下单失败
            //tblOrderDao.updateOrderAct(orderId);//回滚活动人数
            dealGoodsByorderId(orderId);//回滚库存
        } else if ("3".equals(tradeStatus)) {// 如果小订单状态未明,如果是信用卡，更新本地数据为支付失败，如果是借记卡，更新本地数据为状态未明
            if("C".equals(cardType.trim())){//如果是信用卡
                CUR_STATUS_ID = "0307";// 支付失败
                CUR_STATUS_NM = "支付失败";// 支付失败
                dealGoodsByorderId(orderId);//回滚库存
            }else {
                CUR_STATUS_ID = "0316";// 下单异常
                CUR_STATUS_NM = "订单状态未明";// 下单异常
            }
        } else if ("9".equals(tradeStatus)) {// 订单不存在或企业网银查数据异常
            if ("0360".equals(orderModel.getCurStatusId())) {// 已取消
                orderStatusQueryDao.updateOrderIsCancelNetbank(orderId);
            }
            return;
        } else if ("8".equals(tradeStatus)) {// 订单不存在或企业网银查数据异常
            return;
        } else {
            return;
        }
        OrderStatusQueryModel orderSubModel = new OrderStatusQueryModel();
		if (payAccountNo != null && !"".equals(payAccountNo) && !"9".equals(payAccountNo)){//如果有返回帐号，就更新帐号和帐号标识
            orderSubModel.setCurStatusNm(CUR_STATUS_NM);
            orderSubModel.setCurStatusId(CUR_STATUS_ID);
            orderSubModel.setOrderId(orderId);
            orderSubModel.setCardno(payAccountNo);
            orderSubModel.setCardtype(cardType);
            orderSubModel.setOrder_succ_time(payTime);
            orderStatusQueryDao.updateTblOrderStatus(orderSubModel);
        }else{
            orderSubModel.setCurStatusNm(CUR_STATUS_NM);
            orderSubModel.setCurStatusId(CUR_STATUS_ID);
            orderSubModel.setOrderId(orderId);
            orderSubModel.setOrder_succ_time(payTime);
            orderStatusQueryDao.updateTblOrderStatus(orderSubModel);
        }
        OrderDoDetailModel orderDodetail=new OrderDoDetailModel();
        orderDodetail.setOrderId(orderId);
        orderDodetail.setDoTime(new Date());
        orderDodetail.setDoUserid("System");
        orderDodetail.setUserType("0");
        orderDodetail.setStatusId(CUR_STATUS_ID);
        orderDodetail.setStatusNm(CUR_STATUS_NM);
        orderDodetail.setDoDesc("定时调用企业网银状态回查接口");
        orderDodetail.setCreateOper("System");
        orderDodetail.setDelFlag(0);
        orderStatusQueryDao.insertOrderDodetailByOrders(orderDodetail);//插入履历
        try {
            // 插入履历后再插入消息
            MessageDto messageDto = new MessageDto();
            messageDto.setOrderId(orderId);
            messageDto.setOrderStatus(CUR_STATUS_ID);
            messageDto.setCustId("System");
            messageDto.setGoodName(orderModel.getGoodsNm());
            messageDto.setVendorId(orderModel.getVendorId());
            messageDto.setUserType("0");
            messageDto.setCreateOper("System");
            newMessageService.insertUserMessage(messageDto);
        } catch (Exception e) {
            log.error("exception{}",Throwables.getStackTraceAsString(e));
        }

    }


    /**
     * 更新分期子订单集合
     * @param orders
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Transactional
    public List<Map<String,Object>> dealFQOrderStatus(List<PaymentRequeryResultInfo> orders) throws Exception{
        log.info("into updateFQOrderStatus");
        List<Map<String,Object>> returnList = new ArrayList();
        //step24得到每一个Nsct002ResponseOrder对象，得到卡号、借记卡信用卡标识、订单ID、TradeStatus，
		for (PaymentRequeryResultInfo paymentRequeryResultInfo : orders) {
			String payAccountNo = paymentRequeryResultInfo.getPayAccountNo();// 卡号
			String cardType = CardUtil.getCardType(payAccountNo);// 借记卡信用卡标识
			String orderId = paymentRequeryResultInfo.getOrderId();
			String tradeStatus = paymentRequeryResultInfo.getTradeStatus();
            Date payTime=paymentRequeryResultInfo.getPayTime();
			// step25 根据订单ID获取订单信息子表信息orderInf 主订单信息 商品信息 商品支付编码获取商品支付方式信息
			OrderStatusQueryModel orderInf = orderStatusQueryDao.findOrderById(orderId);
			OrderMainModel orderMain = orderStatusQueryDao.findOrderMainModelById(orderInf.getOrdermainId());
			ItemModel tblGoodsInf = orderStatusQueryDao.findItemById(orderInf.getGoodsId());
			TblGoodsPaywayModel tblGoodsPayway = orderStatusQueryDao.findTblGoodsPaywayModelById(orderInf.getGoodsPaywayId());
			// step26 判断电子支付验证状态，然后发报文去bps，得到返回报文returnGateWayEnvolopeVo
			StagingRequestResult returnGateWayEnvolopeVo = dealBPS(orderId, payAccountNo, tradeStatus, orderInf, orderMain,
					tblGoodsInf, tblGoodsPayway);// 判断电子支付验证状态，然后发报文去bps
			// step27 更新单个子订单
			String cur_status_id = updateFQOrderStatuWithTxn(orderId, tradeStatus, payAccountNo, cardType,
					returnGateWayEnvolopeVo, orderInf, orderMain, tblGoodsInf, tblGoodsPayway,payTime);// 操作数据库
			Map<String, Object> rm = new HashMap();
			rm.put("orderId", orderInf.getOrderId());
			rm.put("orderMainId", orderInf.getOrdermainId());
			rm.put("vendorId", orderInf.getVendorId());
			// 这里放入的是最新状态，根据tblOrderDaoService.updateFQOrderStatuWithTxn返回实时状态，方便后续判断
			rm.put("cur_status_id", cur_status_id);
			returnList.add(rm);
			orderInf = null;
			orderMain = null;
			tblGoodsInf = null;
			tblGoodsPayway = null;
		}
        return returnList;
    }
    
    // 发报文去bps
    @Transactional
    public StagingRequestResult dealBPS(String orderId,String payAccountNo,
                                        String tradeStatus,
                                        OrderStatusQueryModel orderInf,
                                        OrderMainModel orderMain,
                                        ItemModel tblGoodsInf,TblGoodsPaywayModel tblGoodsPayway) throws Exception{

        StagingRequestResult returnGateWayEnvolopeVo=null;
        if(tradeStatus!=null&&"1".equals(tradeStatus)){
            returnGateWayEnvolopeVo=sendToBps(orderId,payAccountNo, orderInf, orderMain, tblGoodsInf, tblGoodsPayway);
        }
        return returnGateWayEnvolopeVo;
    }

    @Transactional
    public StagingRequestResult sendToBps(String orderId,String payAccountNo,
                                          OrderStatusQueryModel orderInf,
                                          OrderMainModel orderMain,
                                          ItemModel tblGoodsInf,
                                          TblGoodsPaywayModel tblGoodsPayway) throws Exception{

        boolean isPractiseRun = isPractiseRun(orderInf.getCardno());
        /**如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求 mod by dengbing start*/
        BigDecimal comResult = orderInf.getTotalMoney() == null ? new BigDecimal("0") : orderInf.getTotalMoney();
        if(BigDecimal.ZERO.compareTo(comResult) == 0 && isPractiseRun){//如果现金部分为0，并且是走新流程
            Integer count = orderStatusQueryDao.getSumOrderExtend1ById(orderId);
            if(count == 0){//如果没有OrderExtend1对象
                orderStatusQueryDao.insertTblOrderExtend1(orderId, "0", new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
            }
            log.info("开始调用发送bps接口:"+orderInf.getOrderId());
            StagingRequestResult returnGateWayEnvolopeVo = new StagingRequestResult();
            //BpsMessageUtil.returnBPSVO(returnGateWayEnvolopeVo);
            returnGateWayEnvolopeVo.setErrorCode("0000");// Bps返回的错误码
            returnGateWayEnvolopeVo.setApproveResult("0010");// Bps返回的返回码0000-全额 0010-逐期 0100-拒绝 0200-转人工 0210-异常转人工
            returnGateWayEnvolopeVo.setFollowDir("");//后续流转方向0-不流转 1-流转
            returnGateWayEnvolopeVo.setCaseId("");// BPS工单号
            returnGateWayEnvolopeVo.setSpecialCust("");//是否黑灰名单 0-黑名单 1-灰名单 2-其他
            returnGateWayEnvolopeVo.setReleaseType("");//释放类型
            returnGateWayEnvolopeVo.setRejectcode("");//拒绝代码
            returnGateWayEnvolopeVo.setAprtcode("");//逐期代码
            returnGateWayEnvolopeVo.setOrdernbr("00000000000");//核心订单号、银行订单号:  默认11个0
            try {
                orderStatusQueryDao.updateTblOrderExtend1ByExtend1(orderId, "1");
            } catch (Exception e) {
                log.error("exception: {}",Throwables.getStackTraceAsString(e));
                throw new Exception();
            }
            return returnGateWayEnvolopeVo;
           /* *如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求 mod by dengbing end */
        }else{//如果现金部分不为0或者走旧流程 ，调用BPS的接口
            StagingRequest gateWayEnvolopeVo = new StagingRequest();
            gateWayEnvolopeVo.setSrcCaseId(orderInf.getOrderId());
            gateWayEnvolopeVo.setInterfaceType("0");
            gateWayEnvolopeVo.setCardnbr(payAccountNo);
            gateWayEnvolopeVo.setIdNbr(orderMain.getContIdcard());
            gateWayEnvolopeVo.setChannel("070");
            gateWayEnvolopeVo.setProject("");
            gateWayEnvolopeVo.setRequestType("2");
            gateWayEnvolopeVo.setCaseType("0500");
            gateWayEnvolopeVo.setSubCaseType("0501");
            gateWayEnvolopeVo.setCreator(orderMain.getCreateOper());
            gateWayEnvolopeVo.setBookDesc(orderMain.getCsgPhone1());
            gateWayEnvolopeVo.setReceiveMode("02");
            gateWayEnvolopeVo.setAddr(orderMain.getCsgProvince()+orderMain.getCsgCity()+orderMain.getCsgBorough()+orderMain.getCsgAddress());//省+市+区+详细地址
            gateWayEnvolopeVo.setPostcode(orderMain.getCsgPostcode());
            gateWayEnvolopeVo.setDrawer(orderMain.getInvoice());
            gateWayEnvolopeVo.setSendCode("D");
            gateWayEnvolopeVo.setRegulator("1");
            gateWayEnvolopeVo.setSmsnotice("1");
            gateWayEnvolopeVo.setSmsPhone("");
            gateWayEnvolopeVo.setContactNbr1(orderMain.getCsgPhone1());
            gateWayEnvolopeVo.setContactNbr2(orderMain.getCsgPhone2());
            gateWayEnvolopeVo.setSbookid(orderMain.getOrdermainId());
            gateWayEnvolopeVo.setBbookid("");
            gateWayEnvolopeVo.setReservation("0");
            gateWayEnvolopeVo.setReserveTime("");
            gateWayEnvolopeVo.setCerttype(orderMain.getContIdType());
            gateWayEnvolopeVo.setUrgentLvl("0200");
            gateWayEnvolopeVo.setMichelleId("");
            gateWayEnvolopeVo.setOldBankId("");
            gateWayEnvolopeVo.setProductCode(tblGoodsInf.getMid());//分期编码
            gateWayEnvolopeVo.setProductName(orderInf.getGoodsNm());
            // 交易总金额 = 订单表.现金总金额 + 订单表.优惠金额 + 订单表.本金减免金额
            BigDecimal totalMoney = orderInf.getTotalMoney() == null ? new BigDecimal("0.00") : orderInf.getTotalMoney();
            BigDecimal voucherPrice = orderInf.getVoucherPrice() == null ? new BigDecimal("0.00") : orderInf.getVoucherPrice();
            BigDecimal uitdrtamt = orderInf.getUitdrtamt() == null ? new BigDecimal("0.00") : orderInf.getUitdrtamt();
            BigDecimal price = totalMoney.add(voucherPrice).add(uitdrtamt);
            gateWayEnvolopeVo.setPrice(price);//分期总价
            gateWayEnvolopeVo.setColor(orderInf.getGoodsColor());
            gateWayEnvolopeVo.setAmount("1");
            gateWayEnvolopeVo.setSumAmt(orderInf.getTotalMoney());
            gateWayEnvolopeVo.setSuborderid(orderInf.getOrderId());
            gateWayEnvolopeVo.setBills(orderInf.getStagesNum().toString());
            gateWayEnvolopeVo.setPerPeriodAmt(orderInf.getIncTakePrice());//检查
            gateWayEnvolopeVo.setSupplierCode(orderInf.getVendorId());
            if(isPractiseRun){//走新流程 orderStatusQueryDao
                TblVendorRatioModel vendorRatio=orderStatusQueryDao.getTblVendorRatio(orderInf.getVendorId(),Integer.parseInt(orderInf.getStagesNum().toString()) );
                VendorInfoModel vendor = orderStatusQueryDao.queryVendor(orderInf.getVendorId());
                gateWayEnvolopeVo.setFixedFeeHTFlag(vendorRatio.getFixedfeehtFlag());
                gateWayEnvolopeVo.setFixedAmtFee(vendorRatio.getFixedamtFee() == null ? new BigDecimal (0): vendorRatio.getFixedamtFee().setScale(2, BigDecimal.ROUND_DOWN));
                gateWayEnvolopeVo.setFeeRatio1(vendorRatio.getFeeratio1() == null ? new BigDecimal(0) : vendorRatio.getFeeratio1().setScale(5, BigDecimal.ROUND_DOWN));
                gateWayEnvolopeVo.setRatio1Precent(vendorRatio.getRatio1Precent() == null ? new BigDecimal(0) : vendorRatio.getRatio1Precent().setScale(2, BigDecimal.ROUND_DOWN));
                gateWayEnvolopeVo.setFeeRatio2(vendorRatio.getFeeratio2() == null ? new BigDecimal(0) : vendorRatio.getFeeratio2().setScale(5, BigDecimal.ROUND_DOWN));
                gateWayEnvolopeVo.setRatio2Precent(vendorRatio.getRatio2Precent() == null ? new BigDecimal(0) : vendorRatio.getRatio2Precent().setScale(2, BigDecimal.ROUND_DOWN));
                gateWayEnvolopeVo.setFeeRatio2Bill(vendorRatio.getFeeratio2Bill());
                gateWayEnvolopeVo.setFeeRatio3(vendorRatio.getFeeratio3() == null ? new BigDecimal(0) : vendorRatio.getFeeratio3().setScale(5, BigDecimal.ROUND_DOWN));
                gateWayEnvolopeVo.setRatio3Precent(vendorRatio.getRatio3Precent() == null ? new BigDecimal(0) : vendorRatio.getRatio3Precent().setScale(2, BigDecimal.ROUND_DOWN));
                gateWayEnvolopeVo.setFeeRatio3Bill(vendorRatio.getFeeratio3Bill());
                gateWayEnvolopeVo.setReducerateFrom(vendorRatio.getReducerateFrom());
                gateWayEnvolopeVo.setReducerateTo(vendorRatio.getReducerateTo());
                gateWayEnvolopeVo.setReduceHandingFee(vendorRatio.getReducerate());
                gateWayEnvolopeVo.setHtFlag(vendorRatio.getHtflag());
                //如果“首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，默认送现金金额，如果小于等于现金金额,就送首尾付本金值--大机补充需求 mod by dengbing start
                BigDecimal htcapital = new BigDecimal (0);
                BigDecimal TotalMoneyDe = null;
                TotalMoneyDe = orderInf.getTotalMoney();
                if(vendorRatio.getHtant()==null || TotalMoneyDe==null){
                    htcapital = vendorRatio.getHtant()==null? new BigDecimal (0):vendorRatio.getHtant().setScale(2, BigDecimal.ROUND_DOWN);
                }else{
                    int compareResult = vendorRatio.getHtant().compareTo(TotalMoneyDe);
                    if(compareResult>0){//“首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，送现金金额
                        htcapital = TotalMoneyDe.setScale(2, BigDecimal.ROUND_DOWN);
                    }else{//如果小于等于现金金额,就送首尾付本金值
                        htcapital = vendorRatio.getHtant().setScale(2, BigDecimal.ROUND_DOWN);
                    }
                }
                gateWayEnvolopeVo.setHtCapital(htcapital);
            if(vendor != null){
                //虚拟特店号
                gateWayEnvolopeVo.setVirtualStore(vendor.getVirtualVendorId());
            }
                //stagingRequestService.getStagingRequest(gateWayEnvolopeVo);
            }else{
                VendorPayNoModel vendorPayNo=orderStatusQueryDao.getTblVendorPayNo(orderInf.getVendorId(),Integer.parseInt(orderInf.getStagesNum().toString()) );
                String PRODUCT = "";
                String PAYMENTPLAN = "";
                if(vendorPayNo!=null){
                    PRODUCT = vendorPayNo.getProduct().toString();
                    PAYMENTPLAN = vendorPayNo.getPayNo();
                }
                // 新的接口传入参数中没有下列参数。
//                gateWayEnvolopeVo.setMessageEntityValue("PRODUCT",PRODUCT);
//                gateWayEnvolopeVo.setMessageEntityValue("PLAN",PRODUCT);//计划暂时与产品传送同一字段
//                gateWayEnvolopeVo.setMessageEntityValue("PAYMENTPLAN",PAYMENTPLAN);
//                gateWayEnvolopeVo.setMessageEntityValue("RELEASETYPE", "1");
//                gateWayEnvolopeVo.setMessageEntityValue("CELLCOUNT", "1");
            }
            gateWayEnvolopeVo.setSupplierDesc("");
            gateWayEnvolopeVo.setRecommendCardnbr("");
            gateWayEnvolopeVo.setRecommendname("");
            gateWayEnvolopeVo.setRecommendCerttype("");
            gateWayEnvolopeVo.setRecommendid("");
            gateWayEnvolopeVo.setPrevCaseId("");
            gateWayEnvolopeVo.setCustName(orderMain.getContNm());
            gateWayEnvolopeVo.setIncomingTel("");
            gateWayEnvolopeVo.setPresentName(tblGoodsInf.getGoodsCode());
            gateWayEnvolopeVo.setOrdermemo("正常订单");
            gateWayEnvolopeVo.setForceTransfer("");
            gateWayEnvolopeVo.setSupplierName(orderInf.getVendorSnm());
            gateWayEnvolopeVo.setMemo("");
            gateWayEnvolopeVo.setReceiveName(orderMain.getCsgName());
            gateWayEnvolopeVo.setMerchantCode("");//特店号暂时约定传空
            gateWayEnvolopeVo.setAcceptAmt(orderInf.getTotalMoney());//申请分期金额
            String FAVORABLETYPE = "";//优惠类型
            BigDecimal DEDUCTAMT = new BigDecimal(0);//抵扣金额
            if(orderInf.getVoucherNo()!=null&&!"".equals(orderInf.getVoucherNo())){
                FAVORABLETYPE = "01";
                DEDUCTAMT = orderInf.getVoucherPrice();
            }
            if(orderInf.getBonusTotalvalue()!=null&&orderInf.getBonusTotalvalue().longValue()!=0){
                FAVORABLETYPE = "02";
                DEDUCTAMT = orderInf.getUitdrtamt();
            }
            if((orderInf.getVoucherNo()!=null&&!"".equals(orderInf.getVoucherNo()))&&(orderInf.getBonusTotalvalue()!=null&&orderInf.getBonusTotalvalue().longValue()!=0)){
                FAVORABLETYPE = "03";
                BigDecimal uitdrtamt1 = orderInf.getUitdrtamt() == null ? BigDecimal.ZERO : orderInf.getUitdrtamt();
                DEDUCTAMT = orderInf.getVoucherPrice().add(uitdrtamt1);
            }
            if((orderInf.getVoucherNo()==null||"".equals(orderInf.getVoucherNo()))&&(orderInf.getBonusTotalvalue()==null||orderInf.getBonusTotalvalue().longValue()==0)){
                FAVORABLETYPE = "00";
            }
            gateWayEnvolopeVo.setFavorableType(FAVORABLETYPE);
            gateWayEnvolopeVo.setDeductAmt(DEDUCTAMT);
            //修正bps回调失败。。。。
            //gateWayEnvolopeVo.setHtFlag(String.valueOf(isPractiseRun));//方在VO中，以便后续判断接收方标识

            Integer count = orderStatusQueryDao.getSumOrderExtend1ById(orderId);
            if(count == 0){//如果没有OrderExtend1对象
                orderStatusQueryDao.insertTblOrderExtend1(orderId, "0", new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
            }
            log.info("开始调用发送bps接口:"+orderInf.getOrderId());
            StagingRequestResult returnGateWayEnvolopeVo=null;
            try {
                returnGateWayEnvolopeVo=stagingRequestService.getStagingRequest(gateWayEnvolopeVo);
                orderStatusQueryDao.updateTblOrderExtend1ByExtend1(orderId, "1");
            } catch (Exception e) {
                log.error("调用发送bps接口 erro:{}", Throwables.getStackTraceAsString(e));
                throw new BatchException(e);
            }
            return returnGateWayEnvolopeVo;
        }
    }

    /**
     * 是否使用新方法
     * 试运行标识是0(试运行结束，使用新方法);试运行标识是1(试运行中,如果卡号8、9为是44,则使用新方法)
     * @param cardNo
     * @return
     */
    public boolean isPractiseRun(String cardNo){
        if(needToUpdateRunFlag()){//判断是否需要更新runFlag
            // 大机试运行
            List<TblCfgProCodeModel> list = orderStatusQueryDao.getBigMachineParam();
            log.info("大机试运行标识 list:"+list);
            if(null == list || 0==list.size()){
                log.info("没有维护大机参数 默认为大机试运行结束");
                runFlag="0";
            }else{
                TblCfgProCodeModel codeModel = list.get(0);
                //如果试运行标识为空，则给默认值1（试运行结束）
                String pro_pri = String.valueOf(codeModel.getProPri());
                log.info("大机试运行标识 pro_pri:"+pro_pri);
                cardNoSubStr = String.valueOf(codeModel.getProDesc());
                log.info("大机试运行卡号8,9位:"+cardNoSubStr);
                if(0 == pro_pri.length()){
                    runFlag="0";
                }else{
                    runFlag=pro_pri;//更新runFlag
                }
                runFlag=pro_pri;//更新runFlag
                list.clear();
            }
        }
        log.info("试运行标识 0试运行结束,1试运行:"+runFlag);
        if("0".equals(runFlag)){//0 试运行结束，使用新方法
            return true;
        } else if ("1".equals(runFlag)){//1试运行中，如果卡号8、9位是44的，就走新流程。
            //卡号为空或者卡长度不够9位
            if(null == cardNo || cardNo.length()<9){
                return false;
            }else{
                //卡号第8、9为是44，走新流程
                if(cardNoSubStr != null && cardNoSubStr.length() == 2){
                    if(cardNoSubStr.charAt(0) == cardNo.charAt(7) && cardNoSubStr.charAt(1) == cardNo.charAt(8)){
                        return true;
                    }
                }
            }
            return false;
        }
        log.error("大机试运行标识异常:"+runFlag);
        return true; //默认试运行结束
    }

    /**
     * 检查runFlag是否需求更新
     * 如果runFlag为空
     */
    private static boolean needToUpdateRunFlag(){
        //初始化时候 标识位空时候，查询数据库
        if(null == runFlag || 0 == runFlag.length() ){
            log.info("runFlag:"+runFlag);
            return true;
        }
        return false;
    }

    /**
     * 增加返回，方便后续进行O2O推送
     * 更新单个子订单
     * @param orderId
     * @param tradeStatus
     * @param payAccountNo
     * @param cardType
     * @param payTime
     * @throws Exception
     */
    @Transactional
    public String updateFQOrderStatuWithTxn(String orderId, String tradeStatus, String payAccountNo, String cardType, StagingRequestResult returnGateWayEnvolopeVo, OrderStatusQueryModel orderInf, OrderMainModel orderMain, ItemModel tblGoodsInf, TblGoodsPaywayModel tblGoodsPayway, Date payTime) throws Exception{
        log.info("orderId:"+orderId);
        log.info("tradeStatus:"+tradeStatus);
        log.info("payAccountNo:"+payAccountNo);
        log.info("cardType:"+cardType);
        log.info("tradeStatus:" + tradeStatus);
        String errorCode = null;
        String approveResult = null;
        if (returnGateWayEnvolopeVo != null) {
            errorCode = returnGateWayEnvolopeVo.getErrorCode();
            approveResult = returnGateWayEnvolopeVo.getApproveResult();
        }
        log.info("errorCode:" + errorCode);
        log.info("approveResult:" + approveResult);
        String CUR_STATUS_ID = null;
        String CASH_AUTH_TYPE = null;
        if ("1".equals(tradeStatus)) {// 如果电子支付验证成功
            CASH_AUTH_TYPE = "1";
            boolean falg1 = false;
            if ("0000".equals(errorCode)) {
                falg1 = true;
            }
            if (falg1) {
                falg1 = false;
                if ("0000".equals(approveResult) || "0010".equals(approveResult)) {
                    falg1 = true;
                }
            }
            boolean falg2 = false;
            if ("0000".equals(errorCode)) {
                falg2 = true;
            }
            if (falg2) {
                falg2 = false;
                if ("0200".equals(approveResult) || "0210".equals(approveResult)) {
                    falg2 = true;
                }
            }
            boolean falg3 = false;
            if (errorCode == null || "".equals(errorCode)) {
                falg3 = true;
            } else if ("0000".equals(errorCode)) {
                if (approveResult == null || "".equals(approveResult)) {
                    falg3 = true;
                } else if (!("0000".equals(approveResult) || "0010".equals(approveResult) || "0100".equals(approveResult) || "0200".equals(approveResult) || "0210".equals(approveResult))) {
                    falg3 = true;
                }
            }

            if (falg1) {// 如果bps返回成功
                CUR_STATUS_ID = "0308";
            } else if (falg2) {// 如果bps返回处理中
                CUR_STATUS_ID = "0305";
            } else if (falg3) {// 如果bps返回状态未明
                CUR_STATUS_ID = "b";
            } else {
                CUR_STATUS_ID = "0307";
            }
        } else if ("2".equals(tradeStatus)||"4".equals(tradeStatus)) {// 如果电子支付验证失败
            CUR_STATUS_ID = "0307";
            CASH_AUTH_TYPE = "1";
        } else {// 如果电子支付验证状态不确认
            CUR_STATUS_ID = "b";
            CASH_AUTH_TYPE = "b";
        }
        log.info("CUR_STATUS_ID:" + CUR_STATUS_ID);
        log.info("CASH_AUTH_TYPE:" + CASH_AUTH_TYPE);
        
        String CUR_STATUS_NM = "";
        String ischeck = "";
        String ispoint = "";
        OrderCheckModel orderCheck = null;
        /** 支付成功，积分插正交易 start */
        List<OrderCheckModel> jfOrderCheckList = new ArrayList<>();//积分对账记录
        //支付成功，插积分正交易
        if ("1".equals(tradeStatus) && orderInf.getBonusTotalvalue() != null && orderInf.getBonusTotalvalue() != 0) {
            OrderCheckModel tempOrderCheck = new OrderCheckModel();
            tempOrderCheck.setOrderId(orderId);
            tempOrderCheck.setCurStatusId("0308");
            tempOrderCheck.setCurStatusNm("支付成功");
            tempOrderCheck.setIscheck("");
            tempOrderCheck.setIspoint("0");
            tempOrderCheck.setDoDate(DateHelper.getyyyyMMdd(orderInf.getCreateTime()));
            tempOrderCheck.setDoTime(DateHelper.getHHmmss(orderInf.getCreateTime()));
            tempOrderCheck.setCreateOper("orderStatus");
            tempOrderCheck.setModifyOper("orderStatus");
            //如果是 分期且cash_auth_type 是1就表示 去电子支付成功了
            if (!("FQ".equals(orderInf.getOrdertypeId()) && "1".equals(orderInf.getCashAuthType()))) {
                jfOrderCheckList.add(tempOrderCheck);
            }
        }
        /** 支付成功，积分插正交易 end */
        if("0308".equals(CUR_STATUS_ID)){//如果支付成功
            CUR_STATUS_NM = "支付成功";// 已下单
			if(orderInf.getVoucherNo() != null && !"".equals(orderInf.getVoucherNo())){
                ischeck = "0";
            }
            if(!"".equals(ischeck)){
                //获取优惠券对账表的对象
                orderCheck = new OrderCheckModel();
                orderCheck.setOrderId(orderId);
                orderCheck.setCurStatusId("0308");
                orderCheck.setCurStatusNm("支付成功");
                orderCheck.setIscheck(ischeck);
                orderCheck.setIspoint("");
                orderCheck.setDoDate(DateHelper.getyyyyMMdd(orderInf.getCreateTime()));
                orderCheck.setDoTime(DateHelper.getHHmmss(orderInf.getCreateTime()));
                orderCheck.setCreateOper("orderStatus");
                orderCheck.setModifyOper("orderStatus");
            }
            // 荷兰式订单判断(支付成功)
			if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderInf.getActType())){
                orderStatusQueryDao.updateRecordSucc(orderInf.getCustCartId());
			}
            // 更新销量
            OrderStatusQueryModel orderModel = orderStatusQueryDao.findOrderById(orderId);
            updateSaleCount(orderModel);
        }else if("0307".equals(CUR_STATUS_ID)){ //如果支付失败
            CUR_STATUS_NM = "支付失败";// 下单失败
			if (orderInf.getVoucherNo() != null && !"".equals(orderInf.getVoucherNo())){
                ischeck ="0";
                //获取优惠券对账表的对象
                orderCheck = new OrderCheckModel();
                orderCheck.setOrderId(orderId);
                orderCheck.setCurStatusId("0307");
                orderCheck.setCurStatusNm("支付失败");
                orderCheck.setIscheck(ischeck);
                orderCheck.setIspoint("");
                orderCheck.setDoDate(DateHelper.getyyyyMMdd(orderInf.getCreateTime()));
                orderCheck.setDoTime(DateHelper.getHHmmss(orderInf.getCreateTime()));
                orderCheck.setCreateOper("orderStatus");
                orderCheck.setModifyOper("orderStatus");
            }
//            if(orderInf.getBonusTotalvalue()!=null&&orderInf.getBonusTotalvalue().longValue()!=0){
//                Map<String, Object> paramMap = Maps.newHashMap();
//                paramMap.put("used_point", orderInf.getBonusTotalvalue());
//                paramMap.put("create_time", orderInf.getCreateTime());
                // 业务变更：不回滚积分池
                //orderStatusQueryDao.dealPointPool(paramMap); //回切积分池
//            }
//			  tblOrderDao.updateOrderAct(orderId);//回滚活动人数（不回滚）
            dealGoodsByorderId(orderId);//回滚库存
            // 荷兰式订单判断，回滚活动数（调用接口）
            if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderInf.getActType())){
                orderStatusQueryDao.updateRecordOrderReleased(orderInf.getCustCartId());
            }

            if("1".equals(tradeStatus) && orderInf.getBonusTotalvalue()!=null&&orderInf.getBonusTotalvalue().longValue()!=0){
                OrderCheckModel tempOrderCheck  = new OrderCheckModel();//积分负交易
                tempOrderCheck.setOrderId(orderId);
                tempOrderCheck.setCurStatusId("0307");
                tempOrderCheck.setCurStatusNm("支付失败");
                tempOrderCheck.setIscheck("");
                tempOrderCheck.setIspoint("0");
                tempOrderCheck.setDoDate(DateHelper.getyyyyMMdd());
                tempOrderCheck.setDoTime(DateHelper.getHHmmss());
                tempOrderCheck.setCreateOper("orderStatus");
                tempOrderCheck.setModifyOper("orderStatus");
                // 积分撤销流水号
                String jfRefundSerialno = idGenarator.jfRefundSerialNo();//积分撤销流水
                tempOrderCheck.setJfRefundSerialno(jfRefundSerialno);
                jfOrderCheckList.add(tempOrderCheck);
                //支付成功，bps失败 发起积分撤销
                try{
                    sendNSCT009(orderInf,tempOrderCheck.getDoDate(),tempOrderCheck.getDoTime(),jfRefundSerialno);
                }catch(Exception se){
                    log.error("订单回查 支付成功，bps失败时，调用主动退积分:"+se.getMessage());
                }
            }
        }else if("0305".equals(CUR_STATUS_ID)){//如果处理中
            CUR_STATUS_NM = "处理中";// 处理中
            // 荷兰式订单判断
			if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderInf.getActType())){
                orderStatusQueryDao.updateRecordSucc(orderInf.getCustCartId());
			}
        }else{//状态未明
            if(!"1".equals(CASH_AUTH_TYPE)){//如果没通过电子支付平台验证
                return "";
            }
			CUR_STATUS_ID = orderInf.getCurStatusId();
			CUR_STATUS_NM = orderInf.getCurStatusNm();
        }
        //取得bps返回的部分信息
		String followdir=null;
		String caseid=null;
		String specialcust=null;
		String releasetype=null;
		String rejectcode=null;
		String aprtcode=null;
		String ordernbr=null;
		errorCode=null;
		approveResult=null;
		log.info("returnGateWayEnvolopeVo:"+returnGateWayEnvolopeVo);
		if (returnGateWayEnvolopeVo != null) {
			errorCode = returnGateWayEnvolopeVo.getErrorCode();
			approveResult = returnGateWayEnvolopeVo.getApproveResult();
			followdir = returnGateWayEnvolopeVo.getFollowDir();
			caseid = returnGateWayEnvolopeVo.getCaseId();
			specialcust = returnGateWayEnvolopeVo.getSpecialCust();
			releasetype = returnGateWayEnvolopeVo.getReleaseType();
			rejectcode = returnGateWayEnvolopeVo.getRejectcode();
			aprtcode = returnGateWayEnvolopeVo.getAprtcode();
			ordernbr = returnGateWayEnvolopeVo.getOrdernbr();
		}

		log.info("errorCode:" + errorCode);
		log.info("approveResult:" + approveResult);
		log.info("followdir:" + followdir);
		log.info("caseid:" + caseid);
		log.info("specialcust:" + specialcust);
		log.info("releasetype:" + releasetype);
		log.info("rejectcode:" + rejectcode);
		log.info("aprtcode:" + aprtcode);
		log.info("ordernbr:" + ordernbr);

		log.info("CUR_STATUS_ID:" + CUR_STATUS_ID);
		log.info("CUR_STATUS_NM:" + CUR_STATUS_NM);
		log.info("CASH_AUTH_TYPE:" + CASH_AUTH_TYPE);
		log.info("payTime:"+DateHelper.date2string(payTime, DateHelper.YYYY_MM_DD_HH_MM_SS));
        orderStatusQueryDao.updateOrderStatusCashAuthType(orderId, payAccountNo, cardType, CUR_STATUS_ID, CUR_STATUS_NM, CASH_AUTH_TYPE,payTime);//更新订单

        /** 积分对账 start */
		if (null != jfOrderCheckList && !jfOrderCheckList.isEmpty()) {
			for (OrderCheckModel orderCheckModel : jfOrderCheckList) {
				if (null != orderCheckModel) {// 插入积分对账文件对象
					orderStatusQueryDao.saveTblOrderCheck(orderCheckModel);
				}
			}
		}
		/**积分对账 end */
		if(orderCheck != null){
            orderStatusQueryDao.saveTblOrderCheck(orderCheck);//插入优惠券对账文件对象
		}
        /** 修改:增加extend1 查询*/
        TblOrderExtend1Model tempOrderExtend1 = orderStatusQueryDao.getOrderExtend1ById(orderId);
		if (null == tempOrderExtend1) {
			tempOrderExtend1 = new TblOrderExtend1Model();
			tempOrderExtend1.setOrderId(orderId);
			tempOrderExtend1.setErrorcode(errorCode);
			tempOrderExtend1.setApproveresult(approveResult);
			tempOrderExtend1.setFollowdir(followdir);
			tempOrderExtend1.setCaseid(caseid);
			tempOrderExtend1.setSpecialcust(specialcust);
			tempOrderExtend1.setReleasetype(releasetype);
			tempOrderExtend1.setRejectcode(rejectcode);
			tempOrderExtend1.setAprtcode(aprtcode);
			tempOrderExtend1.setOrdernbr(ordernbr);
			orderStatusQueryDao.insertTblOrderExtend1Model(tempOrderExtend1);
		} else {
			tempOrderExtend1.setErrorcode(errorCode);
			tempOrderExtend1.setApproveresult(approveResult);
			tempOrderExtend1.setFollowdir(followdir);
			tempOrderExtend1.setCaseid(caseid);
			tempOrderExtend1.setSpecialcust(specialcust);
			tempOrderExtend1.setReleasetype(releasetype);
			tempOrderExtend1.setRejectcode(rejectcode);
			tempOrderExtend1.setAprtcode(aprtcode);
			tempOrderExtend1.setOrdernbr(ordernbr);
			orderStatusQueryDao.updateTblOrderExtend1Model(tempOrderExtend1);
		}
        OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
        orderDodetail.setOrderId(orderId);
        orderDodetail.setDoTime(new Date());
        orderDodetail.setDoUserid("System");
        orderDodetail.setUserType("0");
        orderDodetail.setStatusId(CUR_STATUS_ID);
        orderDodetail.setStatusNm(CUR_STATUS_NM);
        orderDodetail.setDoDesc("定时调用电子支付状态回查接口,tradeStatus:"+tradeStatus+",payAccountNo:"+payAccountNo+"cardType:"+cardType+",returnGateWayEnvolopeVo:"+returnGateWayEnvolopeVo+",CASH_AUTH_TYPE:"+CASH_AUTH_TYPE+",errorCode:"+errorCode+",approveResult:"+approveResult);
        orderDodetail.setCreateOper("System");
        orderDodetail.setDelFlag(0);
        orderStatusQueryDao.insertOrderDodetailByOrders(orderDodetail);	//插入历史表
        OrderStatusQueryModel orderModel = orderStatusQueryDao.findOrderById(orderId);
        try {
            // 插入履历后再插入消息
            MessageDto messageDto = new MessageDto();
            messageDto.setOrderId(orderId);
            messageDto.setOrderStatus(CUR_STATUS_ID);
            messageDto.setCustId("System");
            messageDto.setGoodName(orderModel.getGoodsNm());
            messageDto.setVendorId(orderModel.getVendorId());
            messageDto.setUserType("0");
            messageDto.setCreateOper("System");
            newMessageService.insertUserMessage(messageDto);
        } catch (Exception e) {
            log.error("exception{}",Throwables.getStackTraceAsString(e));
        }
        //020业务与商城供应商平台对接
        return CUR_STATUS_ID;
    }
    /**
     * 发起撤销积分申请
     * @param order
     * 撤销用当前时间；移除OrderMain参数，增加参数createDate创建日期、createTime创建时间 jfRefundSerialno 积分撤销流水
     */
    private void sendNSCT009(OrderStatusQueryModel order,String createDate,String createTime,String jfRefundSerialno) throws Exception{
        //bsp分期失败需要调用积分撤销接口
        ReturnPointsInfo gateWayEnvolopeVo=new ReturnPointsInfo();

        String  channelID = "MALL";
        if("00".equals(order.getSourceId())){
            channelID = "MALL";
        }
        if("01".equals(order.getSourceId())){
            channelID = "CCAG";
        }
        if("02".equals(order.getSourceId())){
            channelID = "CCAG";
        }
        if("03".equals(order.getSourceId())){
            channelID = "CS";
        }
        if("04".equals(order.getSourceId())){
            channelID = "SMSP";
        }
        if("05".equals(order.getSourceId()) ||"06".equals(order.getSourceId())){
            channelID = "WX";
        }
        if("09".equals(order.getSourceId())){
            channelID = "MH";
        }
		gateWayEnvolopeVo.setChannelID(channelID);//渠道标识
		gateWayEnvolopeVo.setMerId(order.getMerId());//大商户号(商城商户号)
		gateWayEnvolopeVo.setOrderId(order.getOrderId());//订单号(小)
		String consumeTypeStr = "1";
		if(order.getVoucherNo()!=null&&!"".equals(order.getVoucherNo().trim())){
			consumeTypeStr = "2";
		}
		gateWayEnvolopeVo.setConsumeType(consumeTypeStr);//消费类型("0":纯积分(这里不存在)\"1":积分+现金\"2":积分+现金+优惠券)
		gateWayEnvolopeVo.setCurrency("CNY");//币种
		gateWayEnvolopeVo.setTranDate(createDate);//发起方日期(当前日期)
		gateWayEnvolopeVo.setTranTiem(createTime);//发起方时间(当前时间)
		gateWayEnvolopeVo.setTradeSeqNo(jfRefundSerialno );//发起方流水号
		/** 修改:bps失败，用实时时间 end */
		gateWayEnvolopeVo.setSendDate(DateHelper.getyyyyMMdd(order.getOrder_succ_time()));//原发起方日期
		gateWayEnvolopeVo.setSendTime(DateHelper.getHHmmss(order.getOrder_succ_time()));//原发起方时间
		gateWayEnvolopeVo.setSerialNo(order.getOrderIdHost());//原发起方流水号
		gateWayEnvolopeVo.setCardNo(order.getCardno());//卡号
		gateWayEnvolopeVo.setExpiryDate("0000");//卡片有效期
		gateWayEnvolopeVo.setPayMomey(new BigDecimal(0));//现金支付金额(默认送0)
		gateWayEnvolopeVo.setJgId(Contants.JGID_COMMON);//积分类型
		gateWayEnvolopeVo.setDecrementAmt(order.getBonusTotalvalue());//扣减积分额
		gateWayEnvolopeVo.setTerminalNo("01");//终端号("01"广发商城，"02"积分商城)
        log.info("调用积分撤销接口---start");
        paymentService.returnPoint(gateWayEnvolopeVo);
        log.info("调用积分撤销接口---end");
    }

    /**
     * 更新大订单后插入履历
     * @param orderMainId
     * @param curStatusId
     * @param curStatusNm
     */
    @Transactional
    private void insertOrderDodetailFromOrderMain(String orderMainId,String curStatusId,String curStatusNm){
        List<OrderStatusQueryModel> orderList = orderStatusQueryDao.findOrderByOrderMainId(orderMainId);
        if (orderList != null && orderList.size()>0){
            for (OrderStatusQueryModel orderStatusQueryModel : orderList) {
                OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
                orderDoDetailModel.setOrderId(orderStatusQueryModel.getOrderId());
                orderDoDetailModel.setDoTime(new Date());
                orderDoDetailModel.setDoUserid("System");
                orderDoDetailModel.setUserType("0");
                orderDoDetailModel.setStatusId(curStatusId);
                orderDoDetailModel.setStatusNm(curStatusNm);
                orderDoDetailModel.setDoDesc("定时调用企业网银状态回查接口");
                orderDoDetailModel.setRuleId("");
                orderDoDetailModel.setRuleNm("");
                orderDoDetailModel.setCreateOper("System");
                orderDoDetailModel.setDelFlag(0);
                orderStatusQueryDao.insertOrderDodetailByOrders(orderDoDetailModel);

                try {
                    // 插入履历后再插入消息
                    MessageDto messageDto = new MessageDto();
                    messageDto.setOrderId(orderStatusQueryModel.getOrderId());
                    messageDto.setOrderStatus(curStatusId);
                    messageDto.setCustId("System");
                    messageDto.setGoodName(orderStatusQueryModel.getGoodsNm());
                    messageDto.setVendorId(orderStatusQueryModel.getVendorId());
                    messageDto.setUserType("0");
                    messageDto.setCreateOper("System");
                    newMessageService.insertUserMessage(messageDto);
                } catch (Exception e) {
                    log.error("exception{}",Throwables.getStackTraceAsString(e));
                }
            }
        }
    }

    /**
     * 更新销量
     *
     * @param orderSubModel
     */
    @Transactional
    private void updateSaleCount(OrderStatusQueryModel orderSubModel) {
        //支付成功更新销量
        if ("".equals(orderSubModel.getActId()) || null == orderSubModel.getActId()) {
            cn.com.cgbchina.item.model.ItemModel itemModel = new cn.com.cgbchina.item.model.ItemModel();
            itemModel.setCode(orderSubModel.getGoodsId());
            itemModel.setGoodsTotal(Long.valueOf(orderSubModel.getGoodsNum()));
            itemService.updateItemTotal(itemModel);
        } else {
            //内管
            Integer promIdN = Integer.valueOf(orderSubModel.getActId());// 活动id
            String selectCodeN = orderSubModel.getGoodsId(); //单品号
            Integer saleCountN = orderSubModel.getGoodsNum(); //销量
            promotionService.updateSaleCount(promIdN, selectCodeN, saleCountN);
            //商城
            String promId = orderSubModel.getActId();// 活动id
            String periodId = String.valueOf(orderSubModel.getPeriodId());
            String itemCode = orderSubModel.getGoodsId(); //单品号
            String buyCount = String.valueOf(orderSubModel.getGoodsNum()); //销量
            User user = new User();
            user.setId(orderSubModel.getCreateOper());
            mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, buyCount, user);
        }
        //更新radis
        //itemIndexService.deltaItemIndex(orderSubModel.getGoodsId());
    }

    /**
     * 根据orderId回滚商品数量
     *
     * @throws Exception
     */
    public void dealGoodsByorderId(String orderId) throws Exception {
        if (orderId != null && orderId.length() == 18) {// 如果是小订单
            OrderStatusQueryModel orderSubModel = orderStatusQueryDao.findOrderById(orderId);
            // 普通商品都回滚库存
            if (null == orderSubModel.getActId() || "".equals(orderSubModel.getActId())) {
                String goodsId = orderSubModel.getGoodsId();
                Integer goodsNum = orderSubModel.getGoodsNum();
                if (!Strings.isNullOrEmpty(goodsId) && goodsNum != null && goodsNum > 0) {
                    Map<String,Object> params = Maps.newHashMap();
                    params.put("code",goodsId);
                    params.put("goodsNum",goodsNum);
                    orderStatusQueryDao.updateItem(params);
                }
            }else{
                // 只有是荷兰拍时才回滚库存；其他活动不回滚。
                if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderSubModel.getActType())) {
                    String promId = orderSubModel.getActId();// 活动id
                    String periodId = String.valueOf(orderSubModel.getPeriodId());
                    String itemCode = orderSubModel.getGoodsId(); //单品号
                    String buyCount = String.valueOf(0 - orderSubModel.getGoodsNum()); //销量
                    User user = new User();
                    user.setId(orderSubModel.getCreateOper());
                    mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, buyCount, user);
                }
                // 活动回滚库存
                Map<String, Object> proMap = Maps.newHashMap();
                proMap.put("promId", orderSubModel.getActId());
                proMap.put("itemCode", orderSubModel.getGoodsId());
                proMap.put("itemCount", orderSubModel.getGoodsNum());
                Response<Boolean> ret = mallPromotionService.updateRollbackPromotionStock(Lists.newArrayList(proMap));
                if (!ret.isSuccess() || !ret.getResult()) {
                    throw new RuntimeException(ret.getError());
                }
            }
        }
    }

    /**
     * 根据orderMainId回滚商品数量
     *
     * @throws Exception
     */
    public void dealGoodsByorderMainId(String orderMainId) throws Exception {
        if (orderMainId != null && orderMainId.length() == 16) {// 如果是大订单
            List<OrderStatusQueryModel> orderSubModelList = orderStatusQueryDao.findOrderByOrderMainId(orderMainId);
            for (OrderStatusQueryModel orderSubModel : orderSubModelList) {
                if (orderSubModel != null) {
                    // 普通商品都回滚。
                    if (null == orderSubModel.getActId() || "".equals(orderSubModel.getActId())) {
                        String goodsId = orderSubModel.getGoodsId();
                        Integer goodsNum = orderSubModel.getGoodsNum();
                        if (!Strings.isNullOrEmpty(goodsId) && goodsNum != null && goodsNum > 0) {
                            Map<String,Object> params = Maps.newHashMap();
                            params.put("code",goodsId);
                            params.put("goodsNum",goodsNum);
                            orderStatusQueryDao.updateItem(params);
                        }
                    }else{
                        // 只有是荷兰拍时才回滚库存；其他活动不回滚。
                        if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderSubModel.getActType())) {
                            String promId = orderSubModel.getActId();// 活动id
                            String periodId = String.valueOf(orderSubModel.getPeriodId());
                            String itemCode = orderSubModel.getGoodsId(); //单品号
                            String buyCount = String.valueOf(0 - orderSubModel.getGoodsNum()); //销量
                            User user = new User();
                            user.setId(orderSubModel.getCreateOper());
                            mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, buyCount, user);
                        }
                        // 活动回滚库存
                        Map<String, Object> proMap = Maps.newHashMap();
                        proMap.put("promId", orderSubModel.getActId());
                        proMap.put("itemCode", orderSubModel.getGoodsId());
                        proMap.put("itemCount", orderSubModel.getGoodsNum());
                        Response<Boolean> ret = mallPromotionService.updateRollbackPromotionStock(Lists.newArrayList(proMap));
                        if (!ret.isSuccess() || !ret.getResult()) {
                            throw new RuntimeException(ret.getError());
                        }
                    }
                }
            }
        }
    }
}
