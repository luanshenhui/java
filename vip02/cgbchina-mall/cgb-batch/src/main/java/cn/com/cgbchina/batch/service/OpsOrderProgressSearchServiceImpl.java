package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.OpsOrderProgressSearchDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.OpsOrderProgressSearchManager;
import cn.com.cgbchina.batch.manager.OpsOrderStatusUpdateManager;
import cn.com.cgbchina.batch.model.OpsOrderModel;
import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import cn.com.cgbchina.batch.model.OrderSubModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQuery;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQueryResult;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.trade.service.DealO2OOrderService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by dhc on 2016/7/19.
 */
@Service
@Slf4j
public class OpsOrderProgressSearchServiceImpl implements OpsOrderProgressSearchService {
    @Resource
    private OpsOrderProgressSearchDao opsOrderProgressSearchDao;
    @Resource
    private StagingRequestService stagingRequestService;
    @Resource
    private OpsOrderStatusUpdateManager opsOrderStatusUpdateManager;
    @Autowired
    private DealO2OOrderService dealO2OOrderService;
    @Override
    public Response<Boolean> sendOPSOrderToBPS() {
        Response<Boolean> response = new Response<>();
        try {
            log.info("发送OPS订单至BPS开始......");
            sendOPSToBPS();
            log.info("发送OPS订单至BPS结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("发送OPS订单至BPS失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    private void sendOPSToBPS() throws BatchException {
        try {
            //获取当前时间前5分钟的时间
            String preTime = DateTime.now().minusMinutes(5).toString(DateHelper.YYYY_MM_DD_HH_MM_SS);
            log.info("preTime:" + preTime);
            int counts = opsOrderProgressSearchDao.getSumOPSOrderCount();    //取全部订单数
            log.info("本次进展查询共有" + counts + "条订单需要发送BPS");
            if (counts == 0) return;
            ExecutorService executorService = Executors.newFixedThreadPool(counts);
            /*循环订单集合，发送BPS*/
            for (int i = 0; i < counts; i = i + 10) {
                log.info("i:" + i);
                List<OpsOrderModel> modelList = opsOrderProgressSearchDao.getAllOPSOrderByStatus(preTime, i, 10);
                if (modelList == null || modelList.size() == 0) {
                    log.info("没有待处理订单，任务停止..");
                    break;
                }
                log.info("此批进展查询共有" + modelList.size() + "条订单需要发送BPS");
                for (final OpsOrderModel opsOrderModel : modelList) {
                    executorService.submit(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                singleExeOrder(opsOrderModel);
                            } catch (Exception e) {
                                log.error("发送BPS异常:"+opsOrderModel.getOrderId()+";error:{}",  Throwables.getStackTraceAsString(e));
                            }
                        }
                    });
                }
                Thread.sleep(4000);
            }
            executorService.shutdown();
        } catch (Exception e) {
            log.error("发送BPS异常:{}", Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }

    private void singleExeOrder(OpsOrderModel opsOrderModel) {
        Date nowDate = new Date();//系统当前时间
        long sysTime = nowDate.getTime();
        log.info("nowDate:" + nowDate);
        log.info("sysTime:" + sysTime);
        log.info("OrderId:" + opsOrderModel.getOrderId());
        String nowDateString = DateHelper.getyyyyMMdd(new Date());
        String nowTimeString = DateHelper.getCurrentTime();

        String orderDate = DateHelper.getyyyyMMddHHmmss(opsOrderModel.getCreateTime());
        long orderTime = new DateTime(opsOrderModel.getCreateTime()).toDate().getTime();
        log.info("OrderId:" + opsOrderModel.getOrderId() + ",orderDate:" + orderDate);
        log.info("OrderId:" + opsOrderModel.getOrderId() + ",orderTime:" + orderTime);
        // 调用接口请求参数
        WorkOrderQuery query = new WorkOrderQuery();
        query.setSrcCaseId(opsOrderModel.getOrderId()); //商城订单号
        query.setChannel("070");
        query.setCaseID(opsOrderModel.getCaseId()); // BPS工单号??

        log.info("发送订单至BPS..");
        WorkOrderQueryResult returnGateWayEnvolopeVo = stagingRequestService.workOrderQuery(query); //发送报文至BPS
        log.info("receive returnGateWayEnvolopeVo=" + returnGateWayEnvolopeVo);
        if (returnGateWayEnvolopeVo != null) {
            log.info("OrderId:" + opsOrderModel.getOrderId() + "returnGateWayEnvolopeVo不为null");
            String errorCode = returnGateWayEnvolopeVo.getErrorCode();
            String processStatus = returnGateWayEnvolopeVo.getProcessStatus();
            String processResult = returnGateWayEnvolopeVo.getProcessResult();
            log.info("errorCode：" + errorCode);
            log.info("processStatus：" + processStatus);
            log.info("processResult：" + processResult);
            if (errorCode != null && !"".equals(errorCode.trim())) { //如果错误码不为空
                log.info("本次进展查询流水号【srcCaseId】:" + returnGateWayEnvolopeVo.getSrcCaseId());
                log.info("BPS工单号【caseId】:" + returnGateWayEnvolopeVo.getCaseId());

                String caseId = returnGateWayEnvolopeVo.getCaseId();
                // 有工单号
                if (Contants.bps_success.equals(errorCode) && StringUtils.isTrimEmpty(caseId)) {
                    log.info("OrderId:" + opsOrderModel.getOrderId() + "有工单号");
                    // 判断订单是否支付成功并返回订单号、订单状态
                    OrderSubModel orderInfo = OpsOrderProgressSearchManager.checkOrderStatus(returnGateWayEnvolopeVo);
                    log.info("orderInfo:" + orderInfo);
                    if (orderInfo != null) {    //如果orderInfo不为空
                        //更新orderDodetail表
                        OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
                        orderDodetail.setOrderId(opsOrderModel.getOrderId());
                        orderDodetail.setStatusId(orderInfo.getCurStatusId());
                        orderDodetail.setStatusNm(orderInfo.getCurStatusNm());
                        orderDodetail.setDoTime(new Date());
                        orderDodetail.setCreateTime(new Date());
                        orderDodetail.setCreateOper("SYSTEM");
                        orderDodetail.setDoUserid("SYSTEM");
                        orderDodetail.setUserType("0");
                        orderDodetail.setDelFlag(0);
                        orderDodetail.setDoDesc("定时调用BPS OPS进展查询接口");
                        log.info("order.getOrderId:" + opsOrderModel.getOrderId());
                        log.info("orderInfo.getCurStatusId:" + orderInfo.getCurStatusId());
                        log.info("orderInfo.getCurStatusNm:" + orderInfo.getCurStatusNm());
                        log.info("orderDodetail:" + orderDodetail);
                        String orderNbr = orderInfo.getOrderId();//银行订单号
                        log.info("orderNbr:" + orderNbr);
                        // 回查时控制订单状态是支付成功（0308）不更新订单状态和银行订单号
                        String nowCurStatusId = opsOrderProgressSearchDao.findCurStatusIdById(opsOrderModel.getOrderId());
                        log.info("nowCurStatusId==" + nowCurStatusId);
                        if (!"0308".equals(nowCurStatusId)) {
                            log.info("支付成功更新订单信息");
                            opsOrderStatusUpdateManager.updateOPSOrderWithTxn(opsOrderModel.getOrderId(),
                                    orderInfo.getCurStatusId(), orderInfo.getCurStatusNm(),
                                    nowDateString, nowTimeString, orderDodetail, orderNbr);
                            // 020业务与商城供应商平台对接
                            if ("0308".equals(orderInfo.getCurStatusId())) {
                                ExecutorService exeService = Executors.newSingleThreadExecutor();
                                final String orderId = opsOrderModel.getOrderId();
                                final String ordermainId = opsOrderModel.getOrderMainId();
                                final String vendorId = opsOrderModel.getVendorId();
                                // 推送支付成功的O2O订单
                                exeService.submit(new Runnable() {
                                    @Override
                                    public void run() {
                                        dealO2OOrderService.dealO2OOrdersAfterPaySucc(orderId, ordermainId, vendorId);
                                    }
                                });
                                exeService.shutdown();
                            }
                        }
                    }
                } else if (Contants.bps_empty.equals(errorCode)) { //无工单
                    log.info("OrderId:" + opsOrderModel.getOrderId() + "bps返回无此工单");
                    log.info("nowDate:" + nowDate);
                    log.info("sysTime:" + sysTime);
                    log.info("OrderId:" + opsOrderModel.getOrderId() + ",orderDate:" + opsOrderModel.getCreateTime());
                    log.info("OrderId:" + opsOrderModel.getOrderId() + ",orderTime:" + orderTime);
                    /*
                     * 无工单情况下
                     * CC,IVR渠道，下单时间与当前时间相比超过10分钟，置为支付失败
                     * 商城，手机渠道，下单时间与当前时间相比超过30分钟，置为支付失败
                     * 其他渠道，下单时间与当前时间相比超过30分钟，置为支付失败
                     * */
                    //不限制渠道更新
                    if ((("01".equals(opsOrderModel.getSourceId())
                            || "02".equals(opsOrderModel.getSourceId())) && (sysTime - orderTime) > (30 * 60 * 1000))
                            || ((sysTime - orderTime) > (1 * 30 * 60 * 1000))) {
                        log.info("OrderId:" + opsOrderModel.getOrderId() + "支付失败");
                        //更新orderDodetail表
                        OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
                        orderDodetail.setOrderId(opsOrderModel.getOrderId());
                        orderDodetail.setStatusId("0307");
                        orderDodetail.setStatusNm("支付失败");
                        orderDodetail.setDoTime(new Date());
                        orderDodetail.setCreateTime(new Date());
                        orderDodetail.setDoUserid("SYSTEM");
                        orderDodetail.setCreateOper("SYSTEM");
                        orderDodetail.setUserType("0");
                        orderDodetail.setDelFlag(0);
                        orderDodetail.setDoDesc("定时调用BPS OPS进展查询接口");
                        log.info("支付失败更新订单信息");
                        opsOrderStatusUpdateManager.updateOPSOrderWithTxn(opsOrderModel.getOrderId(),
                                "0307", "支付失败", nowDateString, nowTimeString, orderDodetail, null);
                    }
                    // 如果原订单状态=“已取消”，更新该订单【是否已取消】字段=1（已取消）。{未取消是NULL或""}。
                    opsOrderStatusUpdateManager.updateIsCancelOps(opsOrderModel.getOrderId());
                }
            }
        }
    }

}
