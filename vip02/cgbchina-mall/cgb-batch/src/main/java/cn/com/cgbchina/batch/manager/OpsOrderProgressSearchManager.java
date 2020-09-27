package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import cn.com.cgbchina.batch.model.OrderSubModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQuery;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQueryResult;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Date;

/**
 * Created by dhc on 2016/7/19.
 */
@Component
@Slf4j
public class OpsOrderProgressSearchManager {
    @Resource
    private OpsOrderStatusUpdateManager opsOrderStatusUpdateManager;
    @Resource
    private StagingRequestService stagingRequestService;
    /**
     * 处理单个订单发送
     *
     * @param order
     * @throws Exception
     */
    public void sendOneOPS(OrderSubModel order) throws Exception {
        Date nowDate = new Date();//系统当前时间
        long sysTime = nowDate.getTime();
        String nowDateString = DateHelper.getyyyyMMdd(nowDate);
        String nowTimeString = DateHelper.getCurrentTime();

        // 用于接收调用接口的返回结果
        WorkOrderQueryResult returnGateWayEnvolopeVo = null;
        long orderTime = 0;        //下单时间
        log.info("OrderId:" + order.getOrderId());
        String orderDate = DateHelper.getyyyyMMddHHmmss(order.getCreateTime());
        orderTime = new DateTime(order.getCreateTime()).toDate().getTime();
        log.info("OrderId:" + order.getOrderId() + ",orderDate:" + orderDate);
        log.info("OrderId:" + order.getOrderId() + ",orderTime:" + orderTime);

        // 调用接口请求参数
        WorkOrderQuery query = new WorkOrderQuery();
        query.setSrcCaseId(order.getOrderId()); //商城订单号
        query.setChannel("070");
        query.setCaseID(""); // BPS工单号
        log.info("发送订单至BPS..");
        returnGateWayEnvolopeVo = stagingRequestService.workOrderQuery(query); //发送报文至BPS
        log.info("receive returnGateWayEnvolopeVo=" + returnGateWayEnvolopeVo);
        if (returnGateWayEnvolopeVo != null) {//如果returnGateWayEnvolopeVo不为空
            log.info("OrderId:" + order.getOrderId() + "returnGateWayEnvolopeVo不为null");
            String errorCode = returnGateWayEnvolopeVo.getErrorCode();
            String processStatus = returnGateWayEnvolopeVo.getProcessStatus();
            String processResult = returnGateWayEnvolopeVo.getProcessResult();
            log.info("errorCode：" + errorCode);
            log.info("processStatus：" + processStatus);
            log.info("processResult：" + processResult);
            if (errorCode != null && !"".equals(errorCode.trim())) {//如果错误码不为空

                log.info("本次进展查询流水号【srcCaseId】:" + returnGateWayEnvolopeVo.getSrcCaseId());
                log.info("BPS工单号【caseId】:" + returnGateWayEnvolopeVo.getCaseId());

                String caseId = returnGateWayEnvolopeVo.getCaseId();
                //有工单号
                if (Contants.bps_success.equals(errorCode) && StringUtils.isTrimEmpty(caseId)) {
                    log.info("OrderId:" + order.getOrderId() + "有工单号");
                    //判断订单是否支付成功并返回订单号、订单状态
                    OrderSubModel orderInfo = checkOrderStatus(returnGateWayEnvolopeVo);
                    log.info("orderInfo:" + orderInfo);
                    if (orderInfo != null) {    //如果orderInfo不为空
                        //更新orderDodetail表
                        OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
                        orderDodetail.setOrderId(order.getOrderId());
                        orderDodetail.setStatusId(orderInfo.getCurStatusId());
                        orderDodetail.setStatusNm(orderInfo.getCurStatusNm());
                        orderDodetail.setDoTime(new Date());
                        orderDodetail.setCreateTime(new Date());
                        orderDodetail.setCreateOper("SYSTEM");
                        orderDodetail.setDoUserid("SYSTEM");
                        orderDodetail.setUserType("0");
                        orderDodetail.setDelFlag(0);
                        orderDodetail.setDoDesc("定时调用BPS OPS进展查询接口");
                        log.info("order.getOrderId:" + order.getOrderId());
                        log.info("orderInfo.getCurStatusId:" + orderInfo.getCurStatusId());
                        log.info("orderInfo.getCurStatusNm:" + orderInfo.getCurStatusNm());
                        log.info("nowDateString:" + nowDateString);
                        log.info("nowTimeString:" + nowTimeString);
                        log.info("orderDodetail:" + orderDodetail);
                        String orderNbr = orderInfo.getOrderId();//银行订单号
                        log.info("orderNbr:" + orderNbr);

                        log.info("支付成功更新订单信息");
                        opsOrderStatusUpdateManager.updateOPSOrderWithTxn(order.getOrderId(),
                                orderInfo.getCurStatusId(), orderInfo.getCurStatusNm(),
                                nowDateString, nowTimeString, orderDodetail, orderNbr);
                    }
                } else if (Contants.bps_empty.equals(errorCode)) {//无工单
                    log.info("OrderId:" + order.getOrderId() + "bps返回无此工单");
                    log.info("nowDate:" + nowDate);
                    log.info("sysTime:" + sysTime);
                    log.info("OrderId:" + order.getOrderId() + ",orderDate:" + orderDate);
                    log.info("OrderId:" + order.getOrderId() + ",orderTime:" + orderTime);
                    /*
                     * 无工单情况下
					 * CC,IVR渠道，下单时间与当前时间相比超过10分钟，置为支付失败
					 * 商城，手机渠道，下单时间与当前时间相比超过30分钟，置为支付失败
					 * */
                    if ((("01".equals(order.getSourceId()) || "02".equals(order.getSourceId()))
                            && (sysTime - orderTime) > (30 * 60 * 1000))
                            || ((sysTime - orderTime) > (1 * 30 * 60 * 1000) && ("00".equals(order.getSourceId())
                            || "03".equals(order.getSourceId())))) {
                        log.info("OrderId:" + order.getOrderId() + "支付失败");
                        // 更新orderDodetail表
                        OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
                        orderDodetail.setOrderId(order.getOrderId());
                        orderDodetail.setStatusId("0307");
                        orderDodetail.setStatusNm("支付失败");
                        orderDodetail.setDoTime(new Date());
                        orderDodetail.setCreateTime(new Date());
                        orderDodetail.setCreateOper("SYSTEM");
                        orderDodetail.setDoUserid("SYSTEM");
                        orderDodetail.setUserType("0");
                        orderDodetail.setDelFlag(0);
                        orderDodetail.setDoDesc("定时调用BPS OPS进展查询接口");
                        log.info("支付失败更新订单信息");
                        opsOrderStatusUpdateManager.updateOPSOrderWithTxn(order.getOrderId(), "0307", "支付失败",
                                nowDateString, nowTimeString, orderDodetail, null);
                    }
                    // 如果原订单状态=“已取消”，更新该订单【是否已取消】字段=1（已取消）。{未取消是NULL或""}。
                    opsOrderStatusUpdateManager.updateIsCancelOps(order.getOrderId());
                }
            }
        }
    }


    /**
     * 检查订单是否支付成功
     *
     * @param returnGateWayEnvolopeVo
     * @return
     */
    public static OrderSubModel checkOrderStatus(WorkOrderQueryResult returnGateWayEnvolopeVo) {
        OrderSubModel order = new OrderSubModel();

        String errorCode = returnGateWayEnvolopeVo.getErrorCode();
        String processStatus = returnGateWayEnvolopeVo.getProcessStatus();
        String processResult = returnGateWayEnvolopeVo.getProcessResult();
        log.info("errorCode：" + errorCode);
        log.info("processStatus：" + processStatus);
        log.info("processResult：" + processResult);

        //		调用接口失败
        if (errorCode == null || processStatus == null) {//如果返回码和批核状态为空
            log.info("errorCode:" + errorCode + ",processStatus=" + processStatus);
            return null;
        } else if (Contants.bps_processStatus_processed.equals(processStatus.trim()) &&
                !StringUtils.isTrimEmpty(processResult)) {//如果批核状态为已批核并且批核结果为空
            log.info("processStatus=" + processStatus);
            return null;
        } else if (Contants.bps_processStatus_processing.equals(processStatus.trim()) &&
                !StringUtils.isTrimEmpty(processResult)) {//如果批核状态为批核中并且批核结果为空
            log.info("processStatus=" + processStatus);
            return null;
        }

        String[] processResults = processResult.split("\\$\\$");

        String approveResult = null;    //批核结果
        String orderId = null;    //银行订单号
        String approveType = null;    //结案类型

        if (processResults != null && processResults.length == 3) {
            approveResult = processResults[0];
            orderId = processResults[1];
            approveType = processResults[2];
        }

        log.info("BPS返回码【errorCode】" + errorCode);
        if (!Contants.bps_success.equals(errorCode)) {//如果返回码不是返回调用接口成功
            log.info("交易调用接口失败");
            return null;
        } else {
            //BPS返回处理状态为批核中
            if (Contants.bps_processStatus_processing.equals(processStatus)) {
                log.info("批核中");
                order.setCurStatusId("0305");
                order.setCurStatusNm("处理中");
                order.setOrderId(orderId);
                return order;
            } else if (Contants.bps_processStatus_processed.equals(processStatus)) {    //BPS返回已批核状态
                /*批核结果为全额或者逐期，并且工单正常结案才算支付成功；如果批核结果为拒绝，
                无论工单状态正常或异常，都为支付失败；如果工单异常结案，无论批核结果是什么都是支付失败；*/
                //拒绝审核
                if (Contants.bps_approveResult_unAccept.equals(approveResult)) {
                    log.info("批核结果为拒绝，订单支付失败");
                    order.setCurStatusId("0307");
                    order.setCurStatusNm("支付失败");
                    order.setOrderId(orderId);
                    return order;
                } else if (Contants.bps_approvetype_failure.equals(approveType)) {    //异常结案
                    log.info("订单异常结案，订单支付失败");
                    order.setCurStatusId("0307");
                    order.setCurStatusNm("支付失败");
                    order.setOrderId(orderId);
                    return order;
                } else if ((Contants.bps_approveResult_all.equals(approveResult)
                        || Contants.bps_approveResult_fq.equals(approveResult))
                        && Contants.bps_approvetype_success.equals(approveType)) {    //批核结果为全额或者逐期，并且工单正常结案
                    log.info("支付成功");
                    order.setCurStatusId("0308");
                    order.setCurStatusNm("支付成功");
                    order.setOrderId(orderId);
                    return order;
                }
            }
        }
        return null;
    }
}
