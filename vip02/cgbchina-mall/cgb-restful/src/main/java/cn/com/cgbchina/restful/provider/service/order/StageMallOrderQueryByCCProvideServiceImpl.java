package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderQueryByCCDetailVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderQueryByCCReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderQueryByCCVO;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQuery;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQueryResult;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.trade.dto.OrderCCInfoDto;
import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.DealO2OOrderService;
import cn.com.cgbchina.trade.service.OrderQueryService;
import cn.com.cgbchina.trade.service.OrderService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * MAL113 CC订单查询(分期商城) 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL113")
@Slf4j
public class StageMallOrderQueryByCCProvideServiceImpl implements SoapProvideService<StageMallOrderQueryByCCVO, StageMallOrderQueryByCCReturnVO> {
    @Resource
    OrderQueryService orderQueryService;
    @Resource
    private StagingRequestService stagingRequestService;
    @Resource
    private OrderService orderService;
    @Resource
    private DealO2OOrderService dealO2OOrderService;
    @Resource
    private IdGenarator idGenarator;

    @Override
    public StageMallOrderQueryByCCReturnVO process(SoapModel<StageMallOrderQueryByCCVO> model, StageMallOrderQueryByCCVO content) {
        log.info("【MAL113】流水：" + model.getSenderSN() + "，进入CC订单查询接口");
        StageMallOrderQueryByCCReturnVO envolopeVo = new StageMallOrderQueryByCCReturnVO();
        try {
            String orderId = content.getOrderId();
            String cardNo = content.getCardNo();
            String cont_idcard = content.getContIdcard();
            String acceptedNo = content.getAcceptedNo();
            String endDate = content.getEndDate();
            String startDate = content.getStartDate();
            String rowsPage = content.getRowsPage();
            String currentPage = content.getCurrentPage();
            //增加银行订单号-bankOrderId 对应核心订单号tbl_order_extend1.ordernbr
            String bankOrderId = content.getBankOrderId();
            log.info("【MAL113】查询条件信息:" + orderId + "|" + cardNo + "|" + cont_idcard + "|" + acceptedNo + "|" + startDate + "|" + endDate + "|" + bankOrderId);
            log.info("【MAL113】分页条件:【当前页】-" + currentPage + "|【每页记录数】-" + rowsPage);
            // 页面大小
            int rowsPageInt = Integer.parseInt(rowsPage);
            // 当前页
            if (currentPage == null || "".equals(currentPage.trim())) {//如果currentPage为空
                currentPage = "1";
            }
            int currentPageInt = Integer.parseInt(currentPage);//当前页数

            //组装查询日期查询条件
            String betweenDate = null;
            if (orderId == null || "".equals(orderId)) {//如果orderId为空
                if ((startDate != null && !"".equals(startDate)) && (endDate != null && !"".equals(endDate)) && (orderId == null || "".equals(orderId))) {
                    betweenDate = startDate + "|" + endDate;
                } else {    //默认查询90天内的全部订单条件
                    endDate = DateHelper.getyyyyMMdd();
                    startDate = DateHelper.date2string(DateHelper.addMonth(new Date(),-12), DateHelper.YYYYMMDD);
                    betweenDate = startDate + "|" + endDate;
                }
            }else {
            	endDate = DateHelper.getyyyyMMdd();
                startDate = DateHelper.addDay(endDate, -712);
            	betweenDate = startDate + "|" + endDate;
			}
            Response<Pager<OrderCCInfoDto>> resultResponse = new Response<Pager<OrderCCInfoDto>>();
            resultResponse = orderQueryService.queryOrderInfo(currentPageInt, rowsPageInt, orderId, cardNo, cont_idcard, acceptedNo, betweenDate, bankOrderId);
            List<OrderCCInfoDto> orders = null;
            long totalPages = 0L;
            if (resultResponse.isSuccess() && resultResponse.getResult() != null) {
                orders = resultResponse.getResult().getData();
                double rowpage = 10.00;
                try {
					rowpage  = Double.valueOf(rowsPageInt);
				} catch (Exception e) {
					log.error("【MAL113】每页行数转换错误");
					rowpage =10.00; 
				}
                // 获取总的分页数
                totalPages = resultResponse.getResult().getTotal();
            }
            log.info("【MAL113】当前页码：" + currentPageInt + ",总的页数是：" + totalPages);
            envolopeVo.setTotalPages(String.valueOf(totalPages));

            //组装返回查询信息
            if (orders == null || orders.size() == 0) {//如果查不到订单
                log.info("【MAL113】返回订单信息为空");
                envolopeVo.setReturnCode("000013");
                envolopeVo.setReturnDes("找不到该订单的任何信息");
            } else {
                log.info("orders.size:" + orders.size());
                List<StageMallOrderQueryByCCDetailVO> voList = Lists.newArrayList();
                for (int i = 0; i < orders.size(); i++) {
                    OrderCCInfoDto order = orders.get(i);

                    if (order != null) {
                        WorkOrderQueryResult returnEnvolope = null;
                        String errorCode = null;
                        String processStatus = null;
                        String processResult = null;
                        String bpsSucess = "0";//0:成功  1：失败
                        if (order.getCurStatusId() == null || "".equals(order.getCurStatusId()) || "0301".equals(order.getCurStatusId()) || "0316".equals(order.getCurStatusId())) {//如果为待付款或状态未明或者为空,调接口
                            log.info("订单状态:" + order.getCurStatusId());
                            try {
                                WorkOrderQuery envolopeToBps = new WorkOrderQuery();
                                envolopeToBps.setSrcCaseId(order.getOrderId());
                                envolopeToBps.setChannel("070");
                                // 调用bps工单进展查询
                                returnEnvolope = stagingRequestService.workOrderQuery(envolopeToBps);
                                log.info("本次进展查询流水号【SRCCASEID】:" + returnEnvolope.getSrcCaseId());
                                log.info("BPS工单号【CASEID】:" + returnEnvolope.getCaseId());
                                errorCode = returnEnvolope.getErrorCode();
                                processStatus = returnEnvolope.getProcessStatus();
                                processResult = returnEnvolope.getProcessResult();
                                log.info("errorCode：" + errorCode);
                                log.info("processStatus：" + processStatus);
                                log.info("processResult：" + processResult);
                                if (!"0000".equals(errorCode)) {
                                    bpsSucess = "1";
                                } else if (processStatus == null || "".equals(processStatus.trim())) {
                                    bpsSucess = "1";
                                } else if ("0002".equals(processStatus) && (processResult == null || "".equals(processResult.trim()))) {
                                    bpsSucess = "1";
                                }
                            } catch (Exception e) {
                                log.error("调用BPS查询失败：" + e.getMessage(), e);
                                returnEnvolope = null;
                                bpsSucess = "1";
                            }
                        }
                        String timeIsOut = "1";//是否超过30分钟 0:否 1:是
                        if ("1111".equals(errorCode)) {//如果bps返回没此工单
                            long sysTime = new Date().getTime();    //系统当前时间
                            long orderTime = 0;        //下单时间
                            orderTime = order.getCreateTime().getTime(); //转换下单时间
                            if ((sysTime - orderTime) < (1 * 30 * 60 * 1000)) {//小于30分钟
                                timeIsOut = "0";
                            }
                        }

                        //数据库查询出不为待付款或者状态未明的订单，直接返回CC否则，调用BPS进展查询接口查询订单状态
                        if ((!("0301".equals(order.getCurStatusId()) || "0316".equals(order.getCurStatusId()))) || "1".equals(bpsSucess) || "0".equals(timeIsOut)) {//如果是非(状态未明或待付款)和调bps接口失败和时间小于30分钟
                            StageMallOrderQueryByCCDetailVO vo = new StageMallOrderQueryByCCDetailVO();
                            vo.setOrderId(order.getOrderId()); //订单号
                            vo.setOrdermainId(order.getOrdermainId()); //大订单号
                            vo.setStagesNum(order.getStagesNum()==null?"":StringUtil.intToString(order.getStagesNum(), 2)); //分期数
                            vo.setPerStage(String.valueOf(order.getIncTakePrice())); //分期金额
                            //查询该订单的批核日期
                            log.info("order_id:" + order.getOrderId());
                            Response<OrderDoDetailModel> response = orderService.findByStatusAndOrderId(order.getOrderId());
                            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
                            if (response.isSuccess() && response.getResult() != null) {
                                orderDoDetailModel = response.getResult();
                            }

                            vo.setSinglePrice(order.getTotalMoney() == null ? "0" : order.getTotalMoney().toString()); //总金额
                            vo.setCreateDate(DateHelper.date2string(order.getCreateTime(), DateHelper.YYYYMMDD)); //下单时间
                            vo.setCurStatusId(order.getCurStatusId()); //当前状态
                            vo.setGoodssendFlag(order.getGoodssendFlag()); //发货标志
                            vo.setGoodsNm(order.getGoodsNm()); //商品名称
                            vo.setCardNo(order.getCardno()); //卡号(待确定);
                            String concludeDate = orderDoDetailModel.getDoTime() == null ? "" : DateHelper.getyyyyMMdd(orderDoDetailModel.getDoTime());
                            String concludeTime = orderDoDetailModel.getDoTime() == null ? "" : DateHelper.getHHmmss(orderDoDetailModel.getDoTime());
                            vo.setConcludeDate(concludeDate); //审核日期
                            vo.setConcludeTime(concludeTime); //审核时间
                            vo.setSourceId(order.getSourceId()); //渠道标识
                            vo.setPrePrice(String.valueOf(order.getGoodsPrice())); //扣减前的订单金额
                            vo.setPrivilegeId(order.getVoucherId()); //优惠券id
                            vo.setPrivilegeName(order.getVoucherNm()); //优惠券名称
                            vo.setPrivilegeMoney(order.getVoucherPrice()==null ? "0.00" : order.getVoucherPrice().toString()); //优惠券金额
                            vo.setDiscountPrivMon(order.getUitdrtamt() ==null ? "0.00" :order.getUitdrtamt().toString()); //积分抵扣金额
                            vo.setDiscountPrivilege(order.getBonusTotalvalue() == null ? "0" :order.getBonusTotalvalue().toString()); //抵扣积分数
                            vo.setVendorId(order.getVendorId()); //合作商编码
                            vo.setVendorFnm(order.getVendorSnm()); //合作商名称
                            vo.setBankOrderId(order.getOrderNbr()==null? " ": order.getOrderNbr()); //银行订单号
                            voList.add(vo);
                        } else {//如果是待付款或状态未明并且调bps接口成功
                            OrderSubModel subModel = new OrderSubModel();
                            subModel.setOrderId(order.getOrderId());
                            subModel.setOrdermainId(order.getOrdermainId());
                            subModel.setStagesNum(order.getStagesNum());
                            subModel.setSinglePrice(order.getTotalMoney());
                            subModel.setGoodssendFlag(order.getGoodssendFlag());
                            subModel.setCurStatusId(order.getCurStatusId());
                            subModel.setGoodsNm(order.getGoodsNm());
                            subModel.setCardno(order.getCardno());
                            subModel.setSourceId(order.getSourceId());

                            String act_type = null == order.getActType() ? "" : order.getActType(); // act_type
                            String cust_cart_id = null == order.getCustCartId() ? "" : order.getCustCartId(); // 荷兰订单号cust_cart_id
                            String goods_id = null == order.getGoodsId() ? "" : order.getGoodsId(); // 商品订单号
                            String order_id = order.getOrderId();
                            try {
                                if ("0000".equals(errorCode)) {//如果bps返回成功
                                    /**
                                     * remark 注意：
                                     * 这里的orderInfo 里面只有 cur_status_id订单状态代码 cur_status_nm订单状态名称 order_id银行工单号（非小订单号）
                                     */
                                    OrderSubModel orderInfo = checkOrderStatus(returnEnvolope);    //判断订单是否支付成功并返回订单号、订单状态

                                    String orderNbr = order.getOrderNbr();//orderNbr银行工单号
                                    String dodate = DateHelper.getyyyyMMdd();//审核日期
                                    String doTime = DateHelper.getHHmmss();//审核时间
                                    Date nowDate = new Date();
                                    //更新订单状态修改时间
                                    if (orderInfo == null && returnEnvolope != null) {
                                        log.info("本次查询失败，结果描述:" + returnEnvolope.getResultDesc());
                                    } else {
                                        orderNbr = orderInfo.getOrderId();//设置银行订单号
                                        subModel.setCurStatusId(orderInfo.getCurStatusId());//设置订单状态id
                                        subModel.setCurStatusNm(orderInfo.getCurStatusNm());//设置订单状态

                                        OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
                                        orderDodetail.setOrderId(order.getOrderId());//订单状态
                                        orderDodetail.setStatusId(orderInfo.getCurStatusId());
                                        orderDodetail.setStatusNm(orderInfo.getCurStatusNm());
                                        orderDodetail.setDoTime(nowDate);
                                        orderDodetail.setDoUserid("System");
                                        orderDodetail.setUserType("0");
                                        orderDodetail.setDoDesc("CC订单查询，商城状态未明，调用BPS OPS进展查询接口");
                                        orderDodetail.setCreateTime(nowDate);
                                        orderDodetail.setCreateOper("System");
                                        orderDodetail.setDelFlag(0);

										/*-- 更新补跑任务表--*/
                                        String creatDate = DateHelper.date2string(order.getCreateTime(), DateHelper.YYYYMMDD);//下单时间
                                        SimpleDateFormat format1 = new SimpleDateFormat("yyyyMMdd");
                                        String strDate = format1.format(nowDate);
                                        int todayInt = Integer.parseInt(strDate);
                                        int creatDateInt = Integer.parseInt(creatDate);
                                        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
                                        Calendar cal = Calendar.getInstance();
                                        cal.setTime(new SimpleDateFormat("yyyyMMdd").parse(creatDate));
                                        cal.add(Calendar.DAY_OF_WEEK, Calendar.SUNDAY - cal.get(Calendar.DAY_OF_WEEK));
                                        String creatWeek = formatter.format(cal.getTime());
                                        cal.setTime(new SimpleDateFormat("yyyyMMdd").parse(creatDate));
                                        cal.add(Calendar.DAY_OF_MONTH, 1 - cal.get(Calendar.DAY_OF_MONTH));
                                        String creatMonth = formatter.format(cal.getTime());
                                        Map<String, String> runTime = Maps.newHashMap();

                                        if (todayInt > creatDateInt) {
                                            runTime.put("creatDate", creatDate);
                                            runTime.put("creatWeek", creatWeek);
                                            runTime.put("creatMonth", creatMonth);
                                        }
                                        /*-- 更新补跑任务表结束--*/

                                        // 修改更新方法 增加荷兰式订单号cust_cart_id 订单活动类型act_type 商品IDgoods_id 银行订单号orderNbr
                                        // 回查时控制订单状态是支付成功（0308）不更新订单状态和银行订单号
                                        Response<OrderSubModel> orderSubResponse = orderService.findOrderSubById(order_id);

                                        String nowCurStatusId = "";
                                        if (orderSubResponse.isSuccess() && orderSubResponse.getResult() != null) {
                                            nowCurStatusId = orderSubResponse.getResult().getCurStatusId();
                                        }
                                        log.info("nowCurStatusId==" + nowCurStatusId);
                                        if (!"0308".equals(nowCurStatusId)) {
                                            log.info("order_id:" + order_id + "orderNbr:" + orderNbr + ",cust_cart_id:" + cust_cart_id + ",act_type:" + act_type + "，goods_id:" + goods_id);
                                            orderQueryService.updateOpsOrderChangewithTX(orderInfo.getCurStatusId(), orderInfo.getCurStatusNm(), order_id, orderDodetail, runTime, cust_cart_id, act_type, goods_id, orderNbr, null);
                                            // 020业务与商城供应商平台对接 ,当更新订单信息后，进行O2O推送处理，本单需求只做广发下单部分，积分暂时不支持。
                                            // 当回查完成，且支付成功后进行小订单推送,首先判断是否为O2O商品，若是，则分实时推送和批量推送
                                            if ("0308".equals(orderInfo.getCurStatusId())) {
                                                dealO2OOrderService.dealO2OOrdersAfterPaySucc(orderInfo.getOrderId(), orderInfo.getOrdermainId(), orderInfo.getVendorId());
                                            }
                                        }

                                    }
                                    //组装返回报文因子
                                    StageMallOrderQueryByCCDetailVO vo = new StageMallOrderQueryByCCDetailVO();
                                    vo.setOrderId(subModel.getOrderId()); //订单号
                                    vo.setOrdermainId(subModel.getOrdermainId()); //大订单号
                                    vo.setStagesNum(subModel.getStagesNum()==null?"":StringUtil.intToString(subModel.getStagesNum(),2)); //分期数
                                    vo.setPerStage(String.valueOf(order.getIncTakePrice())); //分期金额
                                    vo.setSinglePrice(order.getTotalMoney() == null ? "0" : order.getTotalMoney().toString()); //总金额
                                    vo.setCreateDate(DateHelper.date2string(order.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS)); //下单时间
                                    vo.setCurStatusId(subModel.getCurStatusId()); //当前状态
                                    vo.setGoodssendFlag(subModel.getGoodssendFlag()); //发货标志
                                    vo.setGoodsNm(subModel.getGoodsNm()); //商品名称
                                    vo.setCardNo(subModel.getCardno()); //卡号
                                    vo.setConcludeDate(dodate); //审核日期
                                    vo.setConcludeTime(doTime); //审核时间
                                    vo.setSourceId(subModel.getSourceId()); //渠道标识
                                    vo.setPrePrice(String.valueOf(order.getGoodsPrice())); //扣减前的订单金额
                                    vo.setPrivilegeId(order.getVoucherId()); //优惠券id
                                    vo.setPrivilegeName(order.getVoucherNm()); //优惠券名称
                                    vo.setPrivilegeMoney(order.getVoucherPrice()==null ? "0.00" : order.getVoucherPrice().toString()); //优惠券金额
                                    vo.setDiscountPrivMon(order.getUitdrtamt() ==null ? "0.00" :order.getUitdrtamt().toString()); //积分抵扣金额
                                    vo.setDiscountPrivilege(order.getBonusTotalvalue() == null ? "0" :order.getBonusTotalvalue().toString()); //抵扣积分数
                                    vo.setVendorId(order.getVendorId()); //合作商编码
                                    vo.setBankOrderId(orderNbr == null ? " ":orderNbr); //银行订单号
                                    voList.add(vo);
                                    envolopeVo.setReturnCode("000000");
                                } else if ("1111".equals(errorCode)) {//如果无此工单,肯定大于30分钟
                                    String order_Id = order.getOrderId();
                                    //下单时间 > 1h
                                    log.info("无此工单");
                                    log.info("BPS无工单，开始判断下单时间是否大于1小时");
                                    String doDate = DateHelper.getyyyyMMdd();
                                    String doTime = DateHelper.getHHmmss();
                                    Date nowDate = new Date();

                                    String curStatusId = "0307";
                                    String curStatusNm = "支付失败";

                                    // 更新orderDodetail表
                                    OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
                                    orderDodetail.setOrderId(order.getOrderId());
                                    orderDodetail.setStatusId("0307");
                                    orderDodetail.setStatusNm("支付失败");
                                    orderDodetail.setDoTime(nowDate);
                                    orderDodetail.setDoUserid("System");
                                    orderDodetail.setUserType("0");
                                    orderDodetail.setDoDesc("CC订单查询，商城状态未明，调用BPS OPS进展查询接口");
                                    orderDodetail.setCreateTime(nowDate);
                                    orderDodetail.setCreateOper("System");
                                    orderDodetail.setDelFlag(0);

									/*-- 更新补跑任务表--*/
                                    String creatDate = DateHelper.date2string(order.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS);//下单时间
                                    SimpleDateFormat format1 = new SimpleDateFormat("yyyyMMdd");
                                    String strDate = format1.format(nowDate);

                                    int todayInt = Integer.parseInt(strDate);
                                    int creatDateInt = Integer.parseInt(creatDate);

                                    SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
                                    Calendar cal = Calendar.getInstance();
                                    cal.setTime(new SimpleDateFormat("yyyyMMdd").parse(creatDate));
                                    cal.add(Calendar.DAY_OF_WEEK, Calendar.SUNDAY - cal.get(Calendar.DAY_OF_WEEK));
                                    String creatWeek = formatter.format(cal.getTime());

                                    cal.setTime(new SimpleDateFormat("yyyyMMdd").parse(creatDate));
                                    cal.add(Calendar.DAY_OF_MONTH, 1 - cal.get(Calendar.DAY_OF_MONTH));
                                    String creatMonth = formatter.format(cal.getTime());

                                    Map<String, String> runTime = new HashMap<String, String>();

                                    if (todayInt > creatDateInt) {
                                        runTime.put("creatDate", creatDate);
                                        runTime.put("creatWeek", creatWeek);
                                        runTime.put("creatMonth", creatMonth);
                                    }

									/*-- 更新补跑任务表结束--*/
                                    log.info("进入事物控制");
                                    OrderCheckModel orderCheck = null;
                                    BigDecimal totalBonusValue = null;
                                    if (null != order.getBonusTotalvalue()) {
                                        try {
                                            log.info("积分:" + order.getBonusTotalvalue());
                                            totalBonusValue = new BigDecimal(order.getBonusTotalvalue());
                                        } catch (Exception e) {
                                            log.error("转换积分失败:" + order.getBonusTotalvalue(), e);
                                        }
                                    }
                                    //积分不为0
                                    if (null != totalBonusValue && totalBonusValue.compareTo(new BigDecimal("0")) > 0) {
                                        orderCheck = getObject(order.getOrderId(), curStatusId, curStatusNm, "", "0");
                                        orderCheck.setJfRefundSerialno(idGenarator.jfRefundSerialNo());//积分退款流水
                                    }
                                    orderQueryService.updateOpsOrderChangewithTX(curStatusId, curStatusNm, order_Id, orderDodetail, runTime, cust_cart_id, act_type, goods_id, null, orderCheck);

                                    log.info("更新记录成功");
                                    StageMallOrderQueryByCCDetailVO vo = new StageMallOrderQueryByCCDetailVO();
                                    vo.setOrderId(subModel.getOrderId()); //订单号
                                    vo.setOrdermainId(subModel.getOrdermainId()); //大订单号
                                    vo.setStagesNum(subModel.getStagesNum()==null?"":subModel.getStagesNum().toString()); //分期数
                                    vo.setPerStage(String.valueOf(order.getIncTakePrice())); //分期金额
                                    vo.setSinglePrice(order.getTotalMoney() == null ? "0" : order.getTotalMoney().toString()); //总金额
                                    vo.setCreateDate(DateHelper.date2string(order.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS)); //下单时间
                                    vo.setCurStatusId(curStatusId); //当前状态
                                    vo.setGoodssendFlag(subModel.getGoodssendFlag()); //发货标志
                                    vo.setGoodsNm(subModel.getGoodsNm()); //商品名称
                                    vo.setCardNo(subModel.getCardno()); //卡号
                                    vo.setConcludeDate(doDate); //审核日期
                                    vo.setConcludeTime(doTime); //审核时间
                                    vo.setSourceId(subModel.getSourceId()); //渠道标识
                                    vo.setPrePrice(String.valueOf(order.getGoodsPrice())); //扣减前的订单金额
                                    vo.setPrivilegeId(order.getVoucherId()); //优惠券id
                                    vo.setPrivilegeName(order.getVoucherNm()); //优惠券名称
                                    vo.setPrivilegeMoney(order.getVoucherPrice()==null ? "0.00" : order.getVoucherPrice().toString()); //优惠券金额
                                    vo.setDiscountPrivMon(order.getUitdrtamt() ==null ? "0.00" :order.getUitdrtamt().toString()); //积分抵扣金额
                                    vo.setDiscountPrivilege(order.getBonusTotalvalue() == null ? "0" :order.getBonusTotalvalue().toString()); //抵扣积分数
                                    vo.setVendorId(order.getVendorId()); //合作商编码
                                    vo.setBankOrderId(order.getOrderNbr()); //银行订单号
                                    voList.add(vo);
                                }
                            } catch (Exception e) {
                                log.error("BPS返回成功后更新数据异常：" + e.getMessage(), e);
                                envolopeVo.setReturnCode("000027");
                                envolopeVo.setReturnDes("数据库异常");
                                return envolopeVo;
                            }
                        }
                    }
                }
                envolopeVo.setOrders(voList);
            }
        } catch (Exception e) {
            log.error("exception", e);
            envolopeVo.setReturnCode("000009");
            envolopeVo.setReturnDes("订单查询失败");
            return envolopeVo;
        }
        envolopeVo.setReturnCode("000000");
        envolopeVo.setReturnDes("");
        return envolopeVo;
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

        // 调用接口失败
        if (errorCode == null && processStatus == null && processResult == null) {
            log.info("BPS接口返回空值，调用接口失败");
            order.setCurStatusId("0316");
            order.setCurStatusNm("订单状态未明");
            return order;
        }

        String[] processResults = processResult.split("\\$+");

        String approveResult = null;    //批核结果
        String orderId = null;    //订单号
        String approveType = null;    //结案类型

        if (processResults != null && processResults.length == 3) {
            approveResult = processResults[0];
            orderId = processResults[1];
            approveType = processResults[2];
        }

        log.info("BPS返回码【errorCode】" + errorCode);
        if (!Contants.bps_success.equals(errorCode)) {
            log.info("交易失败");
            order.setCurStatusId("0307");
            order.setCurStatusNm("支付失败");
            order.setOrderId(orderId);
            return order;
        } else {
            //BPS返回处理状态为批核中
            if (Contants.bps_processStatus_processing.equals(processStatus)) {
                log.info("批核中");
                order.setCurStatusId("0305");
                order.setCurStatusNm("处理中");
                order.setOrderId(orderId);
                return order;
            } else {    //BPS返回已批核状态
                /*批核结果为全额或者逐期，并且工单正常结案才算支付成功；如果批核结果为拒绝，无论工单状态正常或异常，都为支付失败；如果工单异常结案，无论批核结果是什么都是支付失败；*/
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

    /**
     * 获取优惠券对账文件表对象
     *
     * @param order_id
     * @param cur_status_id
     * @param cur_status_nm
     * @param ischeck       1代表优惠券需要出对账文件，2代表积分需要出对账文件
     * @param ispoint
     * @return
     */
    public OrderCheckModel getObject(String order_id, String cur_status_id, String cur_status_nm, String ischeck, String ispoint) {
        OrderCheckModel orderCheck = new OrderCheckModel();
        orderCheck.setOrderId(order_id);
        orderCheck.setCurStatusId(cur_status_id);
        orderCheck.setCurStatusNm(cur_status_nm);
        orderCheck.setDoDate(DateHelper.getyyyyMMdd());
        orderCheck.setDoTime(DateHelper.getHHmmss());
        orderCheck.setIscheck(ischeck);
        orderCheck.setIspoint(ispoint);
        orderCheck.setDelFlag(0);
        return orderCheck;
    }

}
