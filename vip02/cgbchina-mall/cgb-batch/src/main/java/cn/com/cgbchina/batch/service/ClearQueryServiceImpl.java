package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.ClearQueryDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.ClearQueryManager;
import cn.com.cgbchina.batch.model.OrderSubModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.batch.model.ClearQueryModel;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReqMoneyInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

/**
 * Created by CuiZhengwei on 2016/7/15.
 */
@Service
@Slf4j
public class ClearQueryServiceImpl implements ClearQueryService {
    @Resource
    private ClearQueryManager clearQueryManager;
    @Resource
    private ClearQueryDao clearQueryDao;
    @Resource
    private PaymentService paymentService;

    @Value("#{app.merchId}")
    private String merId;
    @Override
    public Response<Boolean> clearQuery() {
        Response<Boolean> response = new Response<>();
        try{
            log.info("请款批处理开始......");
            clearQ();
            log.info("请款批处理结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("请款批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }
    private void clearQ() throws BatchException {
        log.info("请款批处理开始......");
        try {
            clearQueryManager.updateClearFlagStatus();
            sendFQSoap(); // 分期请款
            sendJFSoap(); // 积分商城请款
        } catch (Exception e) {
            log.error("请款批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            clearQueryManager.updateClearFlagStatus2();
            throw new BatchException(e);
        }
        log.info("请款批处理结束......");
    }

    /**
     * 广发分期请款文件
     */
    private void sendFQSoap() throws InterruptedException, ExecutionException {
        List<ClearQueryModel> modelList = clearQueryDao.getClearOrders(Contants.SUB_SIN_STATUS_0350);
        if (modelList.size() == 0) return;

        List<List<ClearQueryModel>> clearQueryLists = Lists.partition(modelList, 10);
        ExecutorService executorService = Executors.newFixedThreadPool(modelList.size());
        CompletionService completionService = new ExecutorCompletionService(executorService);
        int cnt = 0;
        for (List<ClearQueryModel> list : clearQueryLists) {
            log.debug("**********************"+list.size());
            for (ClearQueryModel clearQueryModel : list) {
                completionService.submit(callSingleFQ(clearQueryModel));
            }
            for (int idx = 0; idx < list.size(); idx++) {
                ClearQueryModel r = (ClearQueryModel) completionService.take().get();;
                cnt = cnt + r.getErrorCnt();
                if (cnt == 6) {
                    log.info("nSCT007 exception times: " + cnt);
                    clearQueryManager.changeOrderstatusWithTxn(r.getOrderId(), r.getOrderClearId());
                    throw new BatchException("发送请款报文异常");
                } else if (r.getErrorCnt() == 1) {
                    clearQueryManager.changeOrderstatusWithTxn(r.getOrderId(), r.getOrderClearId());
                }
            }
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                new BatchException(e);
            }
        }
        executorService.shutdown();
    }
    /**
     * 异步执行处理
     */
    private Callable<ClearQueryModel> callSingleFQ(final ClearQueryModel clearQueryModel) {
        Callable<ClearQueryModel> ret = new Callable<ClearQueryModel>() {
        	
            @Override
            public ClearQueryModel call() throws Exception {
                return singleFQQps(clearQueryModel);
            }
        };
        return ret;
    }
    /**
     * 异步执行处理
     */
    private Callable<ClearQueryModel> callSingleJF(final ClearQueryModel clearQueryModel, final BigDecimal total) {
        Callable<ClearQueryModel> ret = new Callable<ClearQueryModel>() {
            @Override
            public ClearQueryModel call() throws Exception {
                return singleJFQps(clearQueryModel, total);
            }
        };
        return ret;
    }
    /**
     * 积分请款文件
     */
    private void sendJFSoap() throws InterruptedException, ExecutionException {
        // 获取生日设置比例
        BigDecimal argument_other = null;
        Map<String, Object> map = clearQueryDao.getCfgMsg(Contants.BIRTH_LEVEL);
        if (map != null){
            argument_other = new BigDecimal(String.valueOf(map.get("argument_other")));
        }
        // 查询需要发送请款信息的订单集合
        List<ClearQueryModel> clearOrdersJF = clearQueryDao.getClearOrdersJF(Contants.SUB_SIN_STATUS_0350);
        if (clearOrdersJF.size() == 0) return;
        log.info("需要发送请款信息的订单集合size" + clearOrdersJF.size());
        List<List<ClearQueryModel>> clearQueryLists = Lists.partition(clearOrdersJF, 10);
        ExecutorService executorService = Executors.newFixedThreadPool(clearOrdersJF.size());
        CompletionService completionService = new ExecutorCompletionService(executorService);
        int cnt = 0;
        for (List<ClearQueryModel> list : clearQueryLists) {
            log.debug("**********************"+list.size());
            for (ClearQueryModel clearQueryModel : list) {
                completionService.submit(callSingleJF(clearQueryModel, argument_other));
            }
            for (int idx = 0; idx < list.size(); idx++) {
                ClearQueryModel r = (ClearQueryModel) completionService.take().get();;
                cnt = cnt + r.getErrorCnt();
                if (cnt == 6) {
                    log.info("nSCT007 exception times: " + cnt);
                    clearQueryManager.changeOrderstatusWithTxn(r.getOrderId(), r.getOrderClearId());
                    clearQueryManager.updateClearFlagStatus2();
                    throw new BatchException("发送请款报文异常");
                } else if (r.getErrorCnt() == 1) {
                    clearQueryManager.changeOrderstatusWithTxn(r.getOrderId(), r.getOrderClearId());
                }
            }
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                new BatchException(e);
            }
        }
        executorService.shutdown();
    }

    private ClearQueryModel singleJFQps(ClearQueryModel clearQueryModel, BigDecimal argument_other) {
        ClearQueryModel ret = clearQueryModel;
        Long orderClearId = clearQueryModel.getOrderClearId();
        String orderId = clearQueryModel.getOrderId();
        PointsMallReqMoneyInfo info = new PointsMallReqMoneyInfo();
        info.setOrderNumber(clearQueryModel.getOrderMainId());
        info.setOrderId(orderId);
        info.setOrderTime(clearQueryModel.getCreateTime());
        info.setOperTime(clearQueryModel.getOperTime());
        info.setAcrdNo(clearQueryModel.getCardNo());
        // 交易总金额
        BigDecimal calMoney = clearQueryModel.getCalMoney();
        // 生日价
        if(Contants.IS_BIRTH_FLAG.equals(clearQueryModel.getIsBirth())){//如果是生日价，则清算价需要乘以生日比例
            calMoney = setCalMon(calMoney,argument_other);
        }
        info.setTradeMoney(calMoney);
        // 现金支付金额
        info.setCashMoney(clearQueryModel.getTotalMoney());
        // 积分抵扣金额=订单表.本金减免金额
        info.setIntegralMoney(BigDecimal.ZERO);
        if (clearQueryModel.getUitdrtamt()!=null){
            info.setIntegralMoney(clearQueryModel.getUitdrtamt());
        }
        info.setMerId(merId);
        info.setMERNO("");
        // 银联商户号
        String qsvendorNo = clearQueryModel.getUnionPayNo();
        info.setQsvendorNo(qsvendorNo);
        info.setCategoryNo("");
        info.setOrderNbr("");
        info.setStagesNum("");

        BaseResult result = null;
        try {
            if (qsvendorNo != null && !"".equals(qsvendorNo)) {
                log.info("发送请款报文。。。。");
                result = paymentService.pointsMallReqMoney(info);
            }
        } catch (Exception e) {
            log.error("发送请款报文异常:{}" + Throwables.getStackTraceAsString(e));
            ret.setErrorCnt(1);
            return ret;
        }
        log.info("发送请款报文返回结果：" + result);
        if (result != null) {
            String retCode = result.getRetCode();
            /**
             * 如果电子支付平台返回成功,请款批次任务完成后， 需要将该订单请款状态为“请款成功”， 同时结算状态为“结算成功”，
             * 如果因调子支付导致某订单请款失败， 则该订单请款状态不变，结算状态，
             * 需改为“结算失败”，后续再次进行重新任务，直至成功 如果退货，可以将失败的任务剔除
             */
            if ("000000".equals(retCode)) {
                OrderSubModel orderSubModel = clearQueryDao.findOrderById(orderId);
                clearQueryManager.updateOrderstatusWithTxn(orderId, orderClearId, orderSubModel); //结算成功的场合，更新请款状态=请款成功，结算状态=结算成功
            } else {
                clearQueryManager.changeOrderstatusWithTxn(orderId, orderClearId); //结算状态=结算失败
            }
        } else {
            clearQueryManager.changeOrderstatusWithTxn(orderId, orderClearId);
        }
        return ret;
    }


    private ClearQueryModel singleFQQps(ClearQueryModel clearQueryModel) {
        ClearQueryModel ret = clearQueryModel;
        // 发送报文 参数组装
        ReqMoneyInfo info = new ReqMoneyInfo();
        Long orderClearId = clearQueryModel.getOrderClearId();
        String orderId = clearQueryModel.getOrderId();
        info.setOrderId(orderId);
        // 日期格式转换
        String orderTime = DateHelper.date2string(clearQueryModel.getCreateTime(), DateHelper.YYYYMMDDHHMMSS);
        info.setOrderTime(orderTime);
        String operTime = DateHelper.date2string(clearQueryModel.getOperTime(), DateHelper.YYYYMMDDHHMMSS);
        info.setOperTime(operTime);
        info.setAcrdNo(clearQueryModel.getCardNo());
        // 交易总金额 = 订单表.现金总金额 + 订单表.优惠金额 + 订单表.本金减免金额
        BigDecimal tradeMoney = new BigDecimal(0.00);
//        tradeMoney =  clearQueryModel.getTotalMoney() == null ? tradeMoney : tradeMoney.add(clearQueryModel.getTotalMoney());
//        tradeMoney =  clearQueryModel.getVoucherPrice() == null ? tradeMoney : tradeMoney.add(clearQueryModel.getVoucherPrice());
//        tradeMoney =  clearQueryModel.getUitdrtamt() == null ? tradeMoney : tradeMoney.add(clearQueryModel.getUitdrtamt());
        tradeMoney = tradeMoney.add(clearQueryModel.getGoodsPrice());
        info.setTradeMoney(tradeMoney);
        // 现金支付金额
        info.setCashMoney(clearQueryModel.getTotalMoney());
        // 积分抵扣金额=订单表.本金减免金额
        info.setIntegralMoney(clearQueryModel.getUitdrtamt());
        info.setMerId(clearQueryModel.getMerId());
        info.setQsvendorNo(clearQueryModel.getReserved1());
        info.setCategoryNo(clearQueryModel.getSpecShopno());
        info.setOrderNbr(clearQueryModel.getOrderNbr());
        info.setStagesNum(clearQueryModel.getStagesNum());
        // 如果有活动
        if (StringUtils.isNotEmpty(clearQueryModel.getActType())) {
            info.setDiscountMoney(clearQueryModel.getFenefit()); // 差额
            info.setTradeCode(codeChange(clearQueryModel.getActType()));// 活动代码
            String costBy = clearQueryModel.getCostBy(); // 费用承担方
            if("0".equals(costBy)) {
                info.setBalancePayer("01");  // 行方
            }else if("1".equals(costBy)) {
                info.setBalancePayer("02");  // 供应商
            }
        } else {
            info.setDiscountMoney(BigDecimal.ZERO);
            info.setTradeCode("");
            info.setBalancePayer("");
        }
        BaseResult result = null;
        try {
            log.info("发送请款报文。。。。");
            result = paymentService.reqMoney(info);
        } catch (Exception e) {
            log.error("发送请款报文异常:{}" + Throwables.getStackTraceAsString(e));
            ret.setErrorCnt(1);
            return ret;
        }
        log.info("发送请款报文返回结果：" + result);
        if (result != null) {
            String retCode = result.getRetCode();
            /**
             * 如果电子支付平台返回成功,请款批次任务完成后， 需要将该订单请款状态为“请款成功”， 同时结算状态为“结算成功”，
             * 如果因调子支付导致某订单请款失败， 则该订单请款状态不变，结算状态，
             * 需改为“结算失败”，后续再次进行重新任务，直至成功 如果退货，可以将失败的任务剔除
             */
            if ("000000".equals(retCode)) {
                OrderSubModel orderSubModel = clearQueryDao.findOrderById(orderId);
                clearQueryManager.updateOrderstatusWithTxn(orderId, orderClearId, orderSubModel); //结算成功的场合，更新请款状态=请款成功，结算状态=结算成功
            } else {
                clearQueryManager.changeOrderstatusWithTxn(orderId, orderClearId); //结算状态=结算失败
            }
        } else {
            clearQueryManager.changeOrderstatusWithTxn(orderId, orderClearId);
        }
        return ret;
    }


    /**
     * 生日价计算清算金额
     * @param calMoney
     * @param argument_other
     * @return
     */
    private static BigDecimal setCalMon(BigDecimal calMoney, BigDecimal argument_other) {
        if(argument_other != null && calMoney != null && !"".equals(calMoney)){
            calMoney = calMoney.multiply(argument_other).setScale(2, BigDecimal.ROUND_HALF_UP);
        }else if(calMoney == null || "".equals(calMoney)){
            calMoney = new BigDecimal("0.00");
        }
        return calMoney;
    }

    /**
     * 活动类型转换
     * @param tradeCode
     * @return
     */
    private static String codeChange(String tradeCode ) {
        String code = "";
        if(tradeCode != null && !"".equals(tradeCode)) {
            if (Contants.PROMOTION_PROM_TYPE_STRING_10.equals(tradeCode)) { // 折扣
                code = "12";
            } else if(Contants.PROMOTION_PROM_TYPE_STRING_20.equals(tradeCode)) { // 满减
                code = "11";
            } else if(Contants.PROMOTION_PROM_TYPE_STRING_30.equals(tradeCode)) { // 秒杀
                code = "13";
            } else if(Contants.PROMOTION_PROM_TYPE_STRING_40.equals(tradeCode)) { // 团购
                code = "14";
            } else if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(tradeCode)) { // 荷兰拍
                code = "08";
            }
        }
        return code;
    }
}
