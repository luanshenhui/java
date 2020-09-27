package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.SendOutSystemDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.*;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.trade.service.OrderSendForO2OService;
import cn.com.cgbchina.trade.vo.SystemEnvelopeVo;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by xiehongri on 2016/7/28.
 */
@Component
@Slf4j
public class SendOutSystemManager {
    @Resource
    private SendOutSystemDao sendOutSystemDao;
    @Value("#{app.limitTimes}")
    private String limitTimes;

    @Autowired
    private SendOutSystemSubManager subManager;

    @Autowired
    private OrderSendForO2OService orderSendForO2OService;
    // 线程池
    private ExecutorService executorService = Executors.newCachedThreadPool();

    public void sendOrders2Outsystem() throws BatchException {
        //log.info("into SendOutSystemServiceImpl");
        //获取需要推送的外网合作商id
        List<String> idlist = sendOutSystemDao.findOutsytemIds();
        //外系统合作商id
        try {
            if(idlist != null && !idlist.isEmpty()){
                for (String sid : idlist) {
                    //大订单号
                    String orderno = "";
                    if(sid != null){
                        //获取大订单号的List,以大订单号为单位，批次推送
                        List<String> mainIdList = sendOutSystemDao.findOrderMainList(sid);
                        if(mainIdList != null && !mainIdList.isEmpty()){
                            //计算出推送的次数，每次推送5000条，然后释放所有的资源，并且睡眠3秒钟，让出时间让垃圾回收器回收
                            int limitSum = Integer.valueOf(limitTimes);
                            int runTimes = getRumTimes(limitSum , mainIdList.size());

                            for(int z = 1 ; z <= runTimes  ; z ++){
                                log.info("第" + z + "次执行！");
                                //该次推送对应的小订单数量
                                int sum = 0;
                                //该次推送对应的订单总额
                                BigDecimal payment = new BigDecimal("0");
                                //推送的商家ID
                                String shopId = "";
                                //推送的URL
                                String actionUrl = "";
                                //推送的加密KEY
                                String shopKey = "";
                                String csgPhone1 = "";
                                //需要推送的订单list
                                List<OrderList1Model> olist = null;
//                                ItemModel item = new ItemModel();
                                for (int j = limitSum * (z - 1); j < limitSum * z; j++) {
                                    if(j == mainIdList.size()){
                                        break;
                                    }
                                    //推送报文中一次推送里大订单包含的的小订单集合
                                    final List<Map<String, Object>> vlist = Lists.newArrayList();//多线程处理，请勿clear
                                    orderno = mainIdList.get(j);
                                    try{
                                        olist = sendOutSystemDao.findOrderList1(sid, orderno);
                                        if(olist != null && !olist.isEmpty()){
                                            sum = olist.size();
                                            for (OrderList1Model orderList1Model : olist) {
                                                Map<String, Object> vmap = Maps.newHashMap();
                                                //小订单号
                                                String strOrderId = StringUtils.dealNullObject(orderList1Model.getOrderId());
                                                ItemModel item = sendOutSystemDao.findByCode(StringUtils.dealNullObject(orderList1Model.getGoodsId()));
                                                csgPhone1 = sendOutSystemDao.findByOrderMainId(orderno);
                                                shopId = StringUtils.dealNullObject(orderList1Model.getShopId());
                                                actionUrl = StringUtils.dealNullObject(orderList1Model.getActionUrl());
                                                shopKey = StringUtils.dealNullObject(orderList1Model.getShopKey());
                                                //外系统编号
                                                String outsystemId = StringUtils.dealNullObject(orderList1Model.getOutsystemId());
                                                //小订单对应的总额
                                                BigDecimal total_money = orderList1Model.getTotalMoney();
                                                //小订单对应的商品数目
                                                String goods_num = StringUtils.dealNullObject(orderList1Model.getGoodsNum());
                                                //小订单单个商品对应的价格
                                                BigDecimal single_price = orderList1Model.getSinglePrice();
                                                //订单类型
                                                String ordertype_id = StringUtils.dealNullObject(orderList1Model.getOrdertypeId());
                                                //采购价
                                                BigDecimal calMoney = orderList1Model.getCalMoney();
                                                if("JF".equals(ordertype_id) && !"".equals(calMoney)){
                                                    payment = payment.add(calMoney);
                                                    single_price = calMoney;
                                                    total_money = calMoney;
                                                } else {
                                                    payment = payment.add(total_money);
                                                }
                                                log.info("orderId:"+strOrderId+"|shopId："+shopId+"|actionUrl:"+actionUrl+"|shopKey:"+shopKey+"|outsystemId:"+
                                                        outsystemId+"|total_money:"+total_money+"|goods_num:"+goods_num
                                                        +"|single_price:"+single_price+"|ordertype_id:"+ordertype_id+"|calMoney:"+calMoney+"|calMoney:"+payment);
                                                //子订单号
                                                vmap.put("suborderno", strOrderId);
                                                //订单编号
                                                vmap.put("sorder_id", item.getO2oCode());
                                                //兑换券编号
                                                vmap.put("goods_id", item.getO2oVoucherCode());
                                                //类型
                                                vmap.put("type", "0");
                                                //商品单价
                                                vmap.put("price", single_price);
                                                //分发数量
                                                vmap.put("number", goods_num);
                                                //交易金额
                                                vmap.put("amount", total_money);
                                                //接收手机号码
                                                vmap.put("mobile", csgPhone1);
                                                vlist.add(vmap);
                                            }
                                            //将任务添加至线程池
                                            final String finalOrderno = orderno;
                                            final BigDecimal finalPayment = payment;
                                            executorService.submit(new Runnable() {
                                                public void run() {
                                                    try {
                                                        sendAndUpdateOrderOutSys(finalOrderno, finalPayment, vlist);
                                                    } catch (Exception e) {
                                                        log.error("异常订单号：" + finalOrderno + "异常信息：" + Throwables.getStackTraceAsString(e));
                                                    }
                                                }
                                            });
                                        } else {
                                            log.error("can't find the little orders to transfer !");
                                        }
                                    }catch(Exception e){
                                        log.error("异常订单号：" + orderno + "异常信息：" + Throwables.getStackTraceAsString(e));
                                    }
                                }
                                if(olist != null){
                                    olist.clear();
                                }
                            }
                        }else{
                            log.info("can't find the mainorders to transfer !");
                        }
                    }
                }
            }else{
                log.info("can't find the o2o vendor ids to transfer !");
            }
        } catch (Exception e) {
            log.error("Exception occurs when execute threadpool："+ Throwables.getStackTraceAsString(e));
        }
    }
    /**
     *
     * <p>Description:计算执行次数</p>
     * @param limitSum
     * @param orderSumSize
     * @return
     */
    private int getRumTimes(int limitSum, int orderSumSize) {
        log.info("限制每次执行条数：" + limitSum + "|||订单总数：" + orderSumSize );
        BigDecimal deLimitSum = new BigDecimal(limitSum);
        BigDecimal deOrderSize = new BigDecimal(orderSumSize);
        BigDecimal runTimes = new BigDecimal(0);
        try{
            runTimes = deOrderSize.divide(deLimitSum , 0 ,BigDecimal.ROUND_UP);
        }catch(Exception e){
        	log.error("计算执行次数出错：" + Throwables.getStackTraceAsString(e));
        }
        return runTimes.intValue();
    }

    /**
     * 将任务添加至线程池
     * @param ordermainId
     * @param payment
     * @param list
     */
    public void sendAndUpdateOrderOutSys(String ordermainId, BigDecimal payment, List<Map<String, Object>> list) {
        log.info("O2O:" + Thread.currentThread().getName() + " | " + ordermainId + " | " + payment+ " | " + list.size());
        //组装返回报文
        SystemEnvelopeVo systemEnvelopeVo = new SystemEnvelopeVo();
        systemEnvelopeVo.setOrderno(ordermainId);
        systemEnvelopeVo.setPayment(String.valueOf(payment));
        systemEnvelopeVo.setMessageCirculateList(list);

        try {
            Response<BaseResult> baseResult = orderSendForO2OService.sendO2OOrderProcess(systemEnvelopeVo);
            log.info("O2O:" + Thread.currentThread().getName() + " | " + ordermainId + " | " + payment+ " | " + list.size() + "|"+baseResult.isSuccess());
            if(baseResult.getResult() != null){
                updateOrderOutSysWithTxn(list, baseResult.getResult());
            }
        } catch (Exception e) {
            log.error("Exceptions occurs while calling CgbMallService：" + Throwables.getStackTraceAsString(e));
        }
    }

    private void updateOrderOutSysWithTxn(List<Map<String, Object>> ordersList, BaseResult baseResult) {
        if(ordersList != null && !ordersList.isEmpty()){
            for (Map<String, Object> info : ordersList) {
                String orderId = info.get("suborderno").toString();
                String msg = baseResult.getRetErrMsg();
                OrderOutSystemModel orderOutSystemModel = new OrderOutSystemModel();
                //更新对应的订单表
                if("0".equals(baseResult.getRetCode())) { //推送成功
                    if(msg == null || msg.equals("no error")) {
                        orderOutSystemModel.setTuisongFlag("1");
                        orderOutSystemModel.setModifyOper("批量推送成功");
                        orderOutSystemModel.setOrderId(orderId);
                    } else {
                        orderOutSystemModel.setTuisongFlag("00");
                        orderOutSystemModel.setModifyOper(msg);
                        orderOutSystemModel.setOrderId(orderId);
                    }

                }else{ //推送失败
                    if(msg == null) {
                        orderOutSystemModel.setOrderId(orderId);
                        orderOutSystemModel.setTimes(1);
                        orderOutSystemModel.setModifyOper("批量推送失败");
                    } else {
                        orderOutSystemModel.setOrderId(orderId);
                        orderOutSystemModel.setTimes(1);
                        orderOutSystemModel.setModifyOper(msg);
                    }
                }
                subManager.updateOrderOutSystem(orderOutSystemModel);
            }
        }
    }
}
