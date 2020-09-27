package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.CustLevelChangeUtil;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.service.IdGeneratorImpl;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.util.PropertyPlaceholder;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.AppStageMallPayVerification;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.AppStageMallPayVerificationReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.AppStageMallPayVerificationVO;
import cn.com.cgbchina.rest.provider.vo.order.OrderInfoVo;
import cn.com.cgbchina.rest.visit.model.order.O2OOrderInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.trade.dto.AppStageMallPayVerificationReturnSubVO;
import cn.com.cgbchina.trade.dto.GateWayEnvolopeDto;
import cn.com.cgbchina.trade.dto.PayOrderSubDto;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.service.*;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.UserInfoService;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

/**
 * MAL315 订单支付结果校验接口(分期商城) 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL315")
@Slf4j
public class AppStageMallPayVerificationProvideServiceImpl
        implements
        SoapProvideService<AppStageMallPayVerificationVO, AppStageMallPayVerificationReturnVO> {
    @Resource
    OrderService orderService;
    @Resource
    OrderCheckService orderCheckService;
    @Resource
    GoodsPayWayService goodsPayWayService;
    @Resource
    ItemService itemService;
    @Resource
    VendorService vendorService;
    @Resource
    SmsMessageService smsMessageService;
    @Autowired
    private UserInfoService userInfoService;
    @Resource
    DealO2OOrderService dealO2OOrderService;
    @Resource
    StagingRequestService stagingRequestService;
    @Resource
    private IdGeneratorImpl idGeneratorImpl;
    @Resource
    private PaymentService paymentService;
    @Resource
    private OrderDealService orderDealService;
    @Autowired
    private JedisTemplate jedisTemplate;
    private final ThreadLocal<String> threadLocalLockId = new ThreadLocal<String>();

    @Override
    public AppStageMallPayVerificationReturnVO process(
            SoapModel<AppStageMallPayVerificationVO> model,
            AppStageMallPayVerificationVO content) {
        AppStageMallPayVerification appStageMallPayVerification = BeanUtils
                .copy(content, AppStageMallPayVerification.class);
        AppStageMallPayVerificationReturnVO appStageMallPayVerificationReturnVO = new AppStageMallPayVerificationReturnVO();
        // 接收参数
        final String ordermain_id = appStageMallPayVerification
                .getOrdermainId();

        //支付时间
        String payTimeStr = content.getPayTime();
        Date payTime = null;
        if (!Strings.isNullOrEmpty(payTimeStr)) {
            payTime = DateHelper.string2Date(payTimeStr, DateHelper.YYYYMMDDHHMMSS);
        }

        // 验签
        boolean isCrypt = false;
        try {
            String singGene = ordermain_id + "|"
                    + appStageMallPayVerification.getPayAccountNo() + "|"
                    + appStageMallPayVerification.getCardType() + "|"
                    + appStageMallPayVerification.getOrders();
            isCrypt = orderCheckService.verify_md(singGene,
                    appStageMallPayVerification.getCrypt());
            // 如果验签失败
            if (!isCrypt) {
                appStageMallPayVerificationReturnVO.setReturnCode("000042");
                appStageMallPayVerificationReturnVO.setReturnDes("验签异常");
                log.info("验签异常,暂时不返回     000042    !!");
                return appStageMallPayVerificationReturnVO;
            }
        } catch (Exception e) {
            log.error("验签异常 error:{}", Throwables.getStackTraceAsString(e));
            log.info("验签异常，订单号：" + ordermain_id);
            appStageMallPayVerificationReturnVO.setReturnCode("000042");
            appStageMallPayVerificationReturnVO.setReturnDes("验签异常");
            return appStageMallPayVerificationReturnVO;
        }

        // 二次提交校验
        // 获取分布式锁
        String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate,
                "ORDERID" + ordermain_id, 50, 5000);
        if (lockId == null) {
            log.info("二次提交，订单号：" + ordermain_id);
            appStageMallPayVerificationReturnVO.setReturnCode("000050");
            appStageMallPayVerificationReturnVO.setReturnDes("支付处理中，不能进行重复支付");
            return appStageMallPayVerificationReturnVO;
        }
        threadLocalLockId.set(lockId);
        // 更新订单sourceid
        orderDealService.createOrderSourceId(content.getOrigin(), ordermain_id);

        Response<OrderMainModel> response = orderService
                .findOrderMainById(ordermain_id);
        if (!response.isSuccess()) {
            DistributedLocks.releaseLock(jedisTemplate,
                    "ORDERID" + ordermain_id, threadLocalLockId.get());
            throw new RuntimeException(response.getError());
        }
        OrderMainModel orderMainModel = response.getResult();
        // 如果查不出大订单记录
        if (orderMainModel == null) {
            DistributedLocks.releaseLock(jedisTemplate,
                    "ORDERID" + ordermain_id, threadLocalLockId.get());
            appStageMallPayVerificationReturnVO.setReturnCode("000012");
            appStageMallPayVerificationReturnVO.setReturnDes("查不出大订单记录");
            return appStageMallPayVerificationReturnVO;
        }
        // FIXME: 2016/12/17 stage 分支旧版支付时间，上十二月版后去掉
        if (payTime == null && orderMainModel.getCreateTime() != null){
            payTime  = orderMainModel.getCreateTime();
        }
        // 解析子订单字符串
        List<PayOrderSubDto> payReturnOrderVos = null;
        try {
            payReturnOrderVos = parseOrders(
                    appStageMallPayVerification.getOrders(),
                    appStageMallPayVerification.getOptFlag());
        } catch (Exception e) {
            DistributedLocks.releaseLock(jedisTemplate,
                    "ORDERID" + ordermain_id, threadLocalLockId.get());
            appStageMallPayVerificationReturnVO.setReturnCode("000014");
            appStageMallPayVerificationReturnVO.setReturnDes("订单无法修改");
            return appStageMallPayVerificationReturnVO;
        }

        // 查出当前子订单状态
        List<AppStageMallPayVerificationReturnSubVO> subVOs = Lists
                .newArrayList();

        // 构建支付信息
        log.debug("构建支付信息 s");
        if (payReturnOrderVos.size() == 1) {
            AppStageMallPayVerificationReturnSubVO subVo = makeAndSendPaySubOrderInfo(
                    payReturnOrderVos.get(0), orderMainModel,
                    appStageMallPayVerification, payTime);
            if (subVo.getReturnCode() != null) {
                DistributedLocks.releaseLock(jedisTemplate, "ORDERID"
                        + ordermain_id, threadLocalLockId.get());
                return subVo;
            }
            subVOs.add(subVo);
        } else {
            ExecutorService executorService = Executors
                    .newFixedThreadPool(payReturnOrderVos.size());

            CompletionService completionService = new ExecutorCompletionService(
                    executorService);
            for (PayOrderSubDto payReturnOrderVo : payReturnOrderVos) {
                completionService.submit(execSendderInfo(payReturnOrderVo,
                        orderMainModel, appStageMallPayVerification, payTime));
            }
            for (int j = 0; j < payReturnOrderVos.size(); j++) {
                AppStageMallPayVerificationReturnSubVO subVo = null;
                try {
                    subVo = (AppStageMallPayVerificationReturnSubVO) completionService
                            .take().get();
                    if (subVo.getReturnCode() != null) {
                        DistributedLocks.releaseLock(jedisTemplate, "ORDERID"
                                + ordermain_id, threadLocalLockId.get());
                        return subVo;
                    }
                    subVOs.add(subVo);
                } catch (Exception e) {
                    log.error("构建支付信息, error:{}",
                            Throwables.getStackTraceAsString(e));
                    DistributedLocks.releaseLock(jedisTemplate, "ORDERID"
                            + ordermain_id, threadLocalLockId.get());
                    appStageMallPayVerificationReturnVO.setReturnCode("000009");
                    appStageMallPayVerificationReturnVO
                            .setReturnDes("构建支付信息失败");
                    return appStageMallPayVerificationReturnVO;
                }
            }
            executorService.shutdown();
        }
        log.debug("构建支付信息 e");
        // 更新订单状态
        log.debug("更新订单状态 s");
        appStageMallPayVerificationReturnVO = createOrderInfo(subVOs,
                orderMainModel.getOrdertypeId());
        if (appStageMallPayVerificationReturnVO.getReturnCode() != null) {
            DistributedLocks.releaseLock(jedisTemplate,
                    "ORDERID" + ordermain_id, threadLocalLockId.get());
            return appStageMallPayVerificationReturnVO;
        }
        log.debug("更新订单状态 e");
        // 返回数据
        // 成功受理件数
        int amountsuc = 0;
        List<OrderInfoVo> orderInfoVos = Lists.newArrayList();
        for (AppStageMallPayVerificationReturnSubVO subVO : subVOs) {
            OrderSubModel tblOrder_return = subVO.getSubOrder();
            OrderInfoVo ovo = new OrderInfoVo();
            ovo.setOrderId(subVO.getOrderId());
            ovo.setCurStatusId(tblOrder_return.getCurStatusId());
            ovo.setErrorCode(tblOrder_return.getErrorCode());
            ovo.setErrorCodeText(subVO.getErrorCodeText());
            ovo.setBpserrorCode(subVO.getBpserrorCode());
            ovo.setBpserrorCodeText(subVO.getBpserrorCodeText());
            ovo.setBpsapproveResult(subVO.getBpsapproveResult());
            orderInfoVos.add(ovo);

            if (orderMainModel.getOrdertypeId() != null
                    && "YG".equals(orderMainModel.getOrdertypeId().trim())) {
                if ("0308".equals(tblOrder_return.getCurStatusId())) {
                    amountsuc++;
                }
            }
        }
        appStageMallPayVerificationReturnVO.setOrderInfo(orderInfoVos);

        DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + ordermain_id,
                threadLocalLockId.get());

        // 如果是一期支付，才发短信
        if (amountsuc > 0) {
            // 发短信
            try {
                log.debug("一期支付，发短信");
                smsMessageService.sendLGSucess(payReturnOrderVos.size(),
                        amountsuc, orderMainModel.getContMobPhone());
            } catch (Exception e) {
                log.error("发短信异常,error:{}", Throwables.getStackTraceAsString(e));
            }
        }
        // 当子订单处理完成，更新订单状态后，并且发送短信之后，再进行O2O订单的推送
        ExecutorService o2oService = Executors.newSingleThreadExecutor();
        o2oService.submit(new Runnable() {
            @Override
            public void run() {
                try {
                    o2oOrder(ordermain_id);
                } catch (Exception e) {
                    log.error("推送O2O异常:{}", e.getMessage());
                }
            }
        });
        appStageMallPayVerificationReturnVO.setReturnCode("000000");
        return appStageMallPayVerificationReturnVO;
    }

    /**
     * O2O推送
     *
     * @param ordermain_id
     */
    private void o2oOrder(String ordermain_id) {
        Response<List<O2OOrderInfo>> findpushOrder = orderService
                .findpushOrder(ordermain_id);
        if (findpushOrder != null && findpushOrder.isSuccess()) {
            List<O2OOrderInfo> orderSubModels = findpushOrder.getResult();
            if (orderSubModels != null) {
                for (int i = 0; i < orderSubModels.size(); i++) {
                    String id = orderSubModels.get(i).getSubOrderId();
                    dealO2OOrderService.dealO2OOrdersAfterPaySucc(id);
                }
            }
        }
    }

    /**
     * 异步执行处理
     */
    private Callable<AppStageMallPayVerificationReturnSubVO> execSendderInfo(
            final PayOrderSubDto payReturnOrderVo,
            final OrderMainModel orderMainModel,
            final AppStageMallPayVerification appStageMallPayVerification,
            final Date payTime) {
        Callable<AppStageMallPayVerificationReturnSubVO> ret = new Callable<AppStageMallPayVerificationReturnSubVO>() {
            @Override
            public AppStageMallPayVerificationReturnSubVO call()
                    throws Exception {
                return makeAndSendPaySubOrderInfo(payReturnOrderVo,
                        orderMainModel, appStageMallPayVerification, payTime);
            }
        };
        return ret;
    }

    /**
     * 更新订单状态
     *
     * @param subVOs
     * @param orderTypeId
     * @return
     */
    private AppStageMallPayVerificationReturnVO createOrderInfo(
            List<AppStageMallPayVerificationReturnSubVO> subVOs,
            String orderTypeId) {
        AppStageMallPayVerificationReturnVO appStageMallPayVerificationReturnVO = new AppStageMallPayVerificationReturnVO();
        try {
            Map<String, Integer> rollBackStockMap = Maps.newHashMap();
            Map<String, Long> pointMap = Maps.newHashMap();
            // 更新订单状态
            if (orderTypeId != null && "YG".equals(orderTypeId.trim())) {// 一期
                dealYGOrderwithTX(subVOs, rollBackStockMap, pointMap);
                log.debug("处理邮购支付信息 S");
                Response<?> r = orderCheckService.dealProcess(subVOs,
                        rollBackStockMap, pointMap);
                if (!r.isSuccess()) {
                    appStageMallPayVerificationReturnVO.setReturnCode("000027");
                    appStageMallPayVerificationReturnVO.setReturnDes("数据库操作异常");
                    return appStageMallPayVerificationReturnVO;
                }
                log.debug("处理邮购支付信息 E");
            } else if (orderTypeId != null && "FQ".equals(orderTypeId.trim())) {// 分期
                dealBpsFQorderwithTX(subVOs, rollBackStockMap, pointMap);
                log.debug("处理分期支付信息 S");
                Response<?> r = orderCheckService.dealProcess(subVOs,
                        rollBackStockMap, pointMap);
                if (!r.isSuccess()) {
                    appStageMallPayVerificationReturnVO.setReturnCode("000027");
                    appStageMallPayVerificationReturnVO.setReturnDes("数据库操作异常");
                    return appStageMallPayVerificationReturnVO;
                }
                log.debug("处理分期支付信息 E");
            } else { // 如果查出的orderTypeId不是YG和FQ
                appStageMallPayVerificationReturnVO.setReturnCode("000013");
                appStageMallPayVerificationReturnVO.setReturnDes("找不到订单");
                return appStageMallPayVerificationReturnVO;
            }
        } catch (Exception e) {
            appStageMallPayVerificationReturnVO.setReturnCode("000027");
            appStageMallPayVerificationReturnVO.setReturnDes("数据库操作异常");
            return appStageMallPayVerificationReturnVO;
        }
        return appStageMallPayVerificationReturnVO;
    }

    /**
     * 手机商城处理BPS分期支付信息
     */
    private void dealBpsFQorderwithTX(
            List<AppStageMallPayVerificationReturnSubVO> subVOs,
            Map<String, Integer> rollBackStockMap, Map<String, Long> pointMap) {
        boolean orderMainFlag = true;
        OrderMainModel orderMainModel = subVOs.get(0).getTblOrderMain();
        for (AppStageMallPayVerificationReturnSubVO subVO : subVOs) {
            final OrderSubModel tblOrder = subVO.getSubOrder();
            final String cardNo = subVO.getCardNo();
            final String cardType = subVO.getCardType();
            if (cardNo != null && !"".equals(cardNo.trim())) {
                tblOrder.setCardno(cardNo);
            }
            if (null != cardType && cardType.trim().length() > 0) {
                tblOrder.setCardtype(cardType);
            }
            StagingRequestResult returnGateWayEnvolopeVo = subVO
                    .getStagingRequestResult();
            final String error_code = subVO.getErrorCode();
            tblOrder.setErrorCode(error_code);
            if (isSucess(error_code)) {// 如果支付网关返回验证成功
                // 插入积分正交易，用订单时间
                OrderCheckModel checkModel = new OrderCheckModel();
                checkModel = insertIntoOrderCheck(tblOrder,
                        "0308", "支付成功", false, true, DateHelper.date2string(
                                tblOrder.getCreateTime(), "yyyyMMdd"),
                        DateHelper.date2string(tblOrder.getCreateTime(),
                                "HHmmss"), "");
                subVO.setOrderCheckModelPlus(checkModel);
                if (returnGateWayEnvolopeVo != null) {
                    String errorCode = returnGateWayEnvolopeVo.getErrorCode(); // bps错误码
                    errorCode = subTopString(errorCode, 4);
                    String approveResult = returnGateWayEnvolopeVo
                            .getApproveResult(); // bps返回码
                    if (errorCode != null) {
                        if (isBp0005Sucess(errorCode, approveResult)) { // 如果支付成功
                            tblOrder.setCurStatusId("0308");
                            tblOrder.setCurStatusNm("支付成功");
                            if (subVO.getTblEspCustCartModel() != null) {
                                subVO.getTblEspCustCartModel().setPayFlag("1");
                            }
                            checkModel = new OrderCheckModel();
                            checkModel = insertIntoOrderCheck(
                                    tblOrder,
                                    "0308",
                                    "支付成功",
                                    true,
                                    false,
                                    DateHelper.date2string(
                                            tblOrder.getCreateTime(),
                                            "yyyyMMdd"),
                                    DateHelper.date2string(
                                            tblOrder.getCreateTime(), "HHmmss"),
                                    "");
                            subVO.setOrderCheckModel(checkModel);
                        } else if (isBp0005Dealing(errorCode, approveResult)) { // 如果处理中
                            tblOrder.setCurStatusId("0305");
                            tblOrder.setCurStatusNm("处理中");
                            if (subVO.getTblEspCustCartModel() != null) {
                                subVO.getTblEspCustCartModel().setPayFlag("1");
                            }
                        } else if (isBp0005NoSure(errorCode, approveResult)) { // 如果状态未明
                            tblOrder.setCurStatusId("0316");
                            tblOrder.setCurStatusNm("状态未明");
                        } else {
                            // 保存回滚库存
                            addRollBackStock(rollBackStockMap,
                                    subVO.getItemCode(), 1);
                            // 回滚积分池
                            addPoint(pointMap, tblOrder.getBonusTotalvalue());

                            tblOrder.setCurStatusId("0307");
                            tblOrder.setCurStatusNm("支付失败");
                            orderMainFlag = false;
                            final String curDate = DateHelper.getyyyyMMdd();
                            final String curTime = DateHelper.getHHmmss();
                            String jfRefundSerialno = "";
                            if (tblOrder.getBonusTotalvalue() != null
                                    && tblOrder.getBonusTotalvalue() != 0L) {
                                jfRefundSerialno = idGeneratorImpl
                                        .jfRefundSerialNo();
                            }
                            checkModel = new OrderCheckModel();
                            checkModel = insertIntoOrderCheck(tblOrder, "0307",
                                    "支付失败", true, true, curDate, curTime,
                                    jfRefundSerialno);
                            subVO.setOrderCheckModel(checkModel);
                            if (tblOrder.getBonusTotalvalue() != null
                                    && tblOrder.getBonusTotalvalue() != 0L) {
                                tblOrder.setCardno(cardNo);
                                tblOrder.setCardtype(cardType);
                                tblOrder.setErrorCode(error_code);
                                // bsp分期失败需要调用积分撤销接口
                                ExecutorService o2oService = Executors
                                        .newSingleThreadExecutor();
                                final OrderSubModel synstblOrder = tblOrder;
                                final String finalJfRefundSerialno = jfRefundSerialno;
                                o2oService.submit(new Runnable() {
                                    @Override
                                    public void run() {
                                        try {
                                            sendNSCT009(synstblOrder, curDate,
                                                    curTime,
                                                    finalJfRefundSerialno);
                                        } catch (Exception e) {
                                            log.error(
                                                    "撤销积分申请异常,error:{}",
                                                    Throwables
                                                            .getStackTraceAsString(e));
                                        }
                                    }
                                });
                            }
                        }
                    }
                    // 插入订单扩展表
                    if (subVO.getTblOrderExtendU() == null) {
                        TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
                        tblOrderExtend1.setOrderId(tblOrder.getOrderId());
                        tblOrderExtend1.setErrorcode(errorCode);
                        tblOrderExtend1.setApproveresult(approveResult);
                        tblOrderExtend1.setFollowdir(returnGateWayEnvolopeVo
                                .getFollowDir());
                        tblOrderExtend1.setCaseid(returnGateWayEnvolopeVo
                                .getCaseId());
                        tblOrderExtend1.setSpecialcust(returnGateWayEnvolopeVo
                                .getSpecialCust());
                        tblOrderExtend1.setReleasetype(returnGateWayEnvolopeVo
                                .getReleaseType());
                        tblOrderExtend1.setRejectcode(returnGateWayEnvolopeVo
                                .getRejectcode());
                        tblOrderExtend1.setAprtcode(returnGateWayEnvolopeVo
                                .getAprtcode());
                        tblOrderExtend1.setOrdernbr(returnGateWayEnvolopeVo
                                .getOrdernbr());
                        subVO.setTblOrderExtendI(tblOrderExtend1);
                    } else { // 更新扩展表
                        TblOrderExtend1Model tblOrderExtend1 = subVO
                                .getTblOrderExtendU();
                        tblOrderExtend1.setOrderId(tblOrder.getOrderId());
                        tblOrderExtend1.setErrorcode(errorCode);
                        tblOrderExtend1.setApproveresult(approveResult);
                        tblOrderExtend1.setFollowdir(returnGateWayEnvolopeVo
                                .getFollowDir());
                        tblOrderExtend1.setCaseid(returnGateWayEnvolopeVo
                                .getCaseId());
                        tblOrderExtend1.setSpecialcust(returnGateWayEnvolopeVo
                                .getSpecialCust());
                        tblOrderExtend1.setReleasetype(returnGateWayEnvolopeVo
                                .getReleaseType());
                        tblOrderExtend1.setRejectcode(returnGateWayEnvolopeVo
                                .getRejectcode());
                        tblOrderExtend1.setAprtcode(returnGateWayEnvolopeVo
                                .getAprtcode());
                        tblOrderExtend1.setOrdernbr(returnGateWayEnvolopeVo
                                .getOrdernbr());
                    }
                } else { // bps调用异常returnGateWayEnvolopeVo==null,返回状态未明
                    tblOrder.setCurStatusId("0316");
                    tblOrder.setCurStatusNm("状态未明");
                }
                tblOrder.setCashAuthType("1");
            } else if (isStateNoSure(error_code)) { // 支付网关返回状态未明
                tblOrder.setCurStatusId("0316");
                tblOrder.setCurStatusNm("状态未明");
            } else { // 支付网关返回验证失败
                // 保存回滚库存
                addRollBackStock(rollBackStockMap, subVO.getItemCode(), 1);
                // 回滚积分池
                addPoint(pointMap, tblOrder.getBonusTotalvalue());

                tblOrder.setCurStatusId("0307");
                tblOrder.setCurStatusNm("支付失败");
                tblOrder.setCashAuthType("1");
                orderMainFlag = false;
                OrderCheckModel checkModel = new OrderCheckModel();
                checkModel = insertIntoOrderCheck(tblOrder,
                        "0307", "支付失败", true, false, DateHelper.getyyyyMMdd(),
                        DateHelper.getHHmmss(), "");// 失败时只有优惠劵时插入表
                subVO.setOrderCheckModel(checkModel);
            }
            // 插入历史记录
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setOrderId(tblOrder.getOrderId());
            orderDoDetailModel.setDoTime(new Date());
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setStatusId(tblOrder.getCurStatusId());
            orderDoDetailModel.setStatusNm(tblOrder.getCurStatusNm());
            orderDoDetailModel.setDoDesc("手机商城广发分期支付");
            orderDoDetailModel.setCreateOper("System");
            orderDoDetailModel.setModifyOper("System");
            orderDoDetailModel.setDelFlag(0);
            subVO.setOrderDoDetailModel(orderDoDetailModel);
        }
        if (orderMainFlag) { // 大订单成功
            orderMainModel.setCurStatusId("0308");
            orderMainModel.setCurStatusNm("支付成功");
        } else { // 大订单异常
            orderMainModel.setCurStatusId("0307");
            orderMainModel.setCurStatusNm("支付失败");
        }
    }

    /**
     * 发起撤销积分申请
     *
     * @param order
     */
    private void sendNSCT009(OrderSubModel order, String createDate,
                             String createTime, String jfRefundSerialno) throws Exception {
        // bsp分期失败需要调用积分撤销接口
        String consumeTypeStr = "1";
        if (order.getVoucherNo() != null
                && !"".equals(order.getVoucherNo().trim())) {
            consumeTypeStr = "2";
        }
        ReturnPointsInfo rpi = new ReturnPointsInfo();
        rpi.setChannelID(CustLevelChangeUtil.sourceIdChangeToChannel(order
                .getSourceId()));
        rpi.setMerId(order.getMerId());
        rpi.setOrderId(order.getOrderId());
        rpi.setConsumeType(consumeTypeStr);
        rpi.setCurrency("CNY");
        rpi.setTranDate(createDate);
        rpi.setTranTiem(createTime);
        rpi.setTradeSeqNo(jfRefundSerialno);
        rpi.setSendDate(DateHelper.getyyyyMMdd(order.getOrder_succ_time()));
        rpi.setSendTime(DateHelper.getHHmmss(order.getOrder_succ_time()));
        rpi.setSerialNo(order.getOrderIdHost());
        rpi.setCardNo(order.getCardno());
        rpi.setExpiryDate("0000");
        rpi.setPayMomey(new BigDecimal(0));
        rpi.setJgId(Contants.JGID_COMMON);
        rpi.setDecrementAmt(order.getBonusTotalvalue());
        rpi.setTerminalNo("01");
        paymentService.returnPoint(rpi);
    }

    /**
     * 截取s字符串的前i个字节
     *
     * @param s
     * @param i
     * @return
     */
    private static String subTopString(String s, int i) {
        if (s == null || "".equals(s.trim())) {// 如果s为空
            return s;
        } else {
            if (i < s.length()) {
                return s.substring(0, i);
            } else {
                return s;
            }
        }
    }

    /**
     * @param subVOs
     * @param rollBackStockMap
     */
    private void dealYGOrderwithTX(
            List<AppStageMallPayVerificationReturnSubVO> subVOs,
            Map<String, Integer> rollBackStockMap, Map<String, Long> pointMap) {
        boolean orderMainFlag = true;
        OrderSubModel order;
        OrderMainModel orderMainModel = subVOs.get(0).getTblOrderMain();
        for (AppStageMallPayVerificationReturnSubVO subVO : subVOs) {
            String errorCode = subVO.getErrorCode();
            order = subVO.getSubOrder();
            // 成功支付
            if (isSucess(errorCode)) {
                order.setCardno(subVO.getCardNo());
                order.setCardtype(subVO.getCardType());
                order.setCurStatusId("0308");
                order.setCurStatusNm("支付成功");
                order.setErrorCode(subVO.getReturnCode());

                if (subVO.getTblEspCustCartModel() != null) {
                    subVO.getTblEspCustCartModel().setPayFlag("1");
                }
                OrderCheckModel checkModel = insertIntoOrderCheck(
                        order,
                        "0308",
                        "支付成功",
                        true,
                        true,
                        DateHelper.date2string(order.getCreateTime(),
                                "yyyyMMdd"),
                        DateHelper.date2string(order.getCreateTime(), "HHmmss"),
                        "");
                subVO.setOrderCheckModelPlus(checkModel);
            } else if (isStateNoSure(errorCode)) { // 状态未明
                order.setCurStatusId("0316");
                order.setCurStatusNm("状态未明");
                orderMainFlag = false;
            } else { // 支付失败
                // 保存回滚库存
                addRollBackStock(rollBackStockMap, subVO.getItemCode(), 1);
                // 回滚积分池
                addPoint(pointMap, order.getBonusTotalvalue());
                order.setCurStatusId("0307");
                order.setCurStatusNm("支付失败");
                orderMainFlag = false;
                OrderCheckModel checkModel = insertIntoOrderCheck(order,
                        "0307", "支付失败", true, false, DateHelper.getyyyyMMdd(),
                        DateHelper.getHHmmss(), "");
                subVO.setOrderCheckModel(checkModel);
            }
            // 插入历史记录
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setOrderId(subVO.getOrderId());
            orderDoDetailModel.setDoTime(new Date());
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setStatusId(order.getCurStatusId());
            orderDoDetailModel.setStatusNm(order.getCurStatusNm());
            orderDoDetailModel.setDoDesc("手机商城广发一期支付");
            orderDoDetailModel.setCreateOper("System");
            orderDoDetailModel.setModifyOper("System");
            orderDoDetailModel.setDelFlag(0);
            subVO.setOrderDoDetailModel(orderDoDetailModel);
        }
        if (orderMainFlag) {// 大订单成功
            orderMainModel.setCurStatusId("0308");
            orderMainModel.setCurStatusNm("支付成功");
        } else {// 大订单异常
            orderMainModel.setCurStatusId("0307");
            orderMainModel.setCurStatusNm("支付失败");
        }
    }

    /**
     * 判断是否状态未明
     *
     * @param returnCode
     * @return
     */
    private static boolean isStateNoSure(String returnCode) {
        String stateNoSure[] = {"PP028001", "CS000012", "CS000888", "EBLN2000"};// 状态未明返回码
        for (int i = 0; i < stateNoSure.length; i++) {
            if (stateNoSure[i].equals(returnCode.trim())) {
                return true;
            }
        }
        return false;
    }

    /**
     * 积分优惠券对账文件保存
     *
     * @param order
     * @param curStatusId 需要出优惠券
     * @param curStatusNm
     * @param checkFlag
     * @param pointFlag   需要出积分
     */
    private OrderCheckModel insertIntoOrderCheck(OrderSubModel order,
                                                 String curStatusId, String curStatusNm, boolean checkFlag,
                                                 boolean pointFlag, String createDate, String createTime,
                                                 String jfRefundSerialno) {
        OrderCheckModel orderCheck;
        String ischeck = "";// 优惠券对账文件标志
        String ispont = "";// 积分对账文件标志
        if (order.getVoucherNo() != null && !"".equals(order.getVoucherNo())
                && checkFlag) {
            ischeck = "0";
        }
        if (order.getBonusTotalvalue() != null
                && order.getBonusTotalvalue().longValue() != 0 && pointFlag) {
            ispont = "0";
        }
        if (!"".equals(ischeck) || !"".equals(ispont)) {
            orderCheck = getObject(order.getOrderId(), curStatusId,
                    curStatusNm, ischeck, ispont);
            orderCheck.setDoDate(createDate);
            orderCheck.setDoTime(createTime);
            orderCheck.setJfRefundSerialno(jfRefundSerialno);
            orderCheck.setDelFlag(0);
            return orderCheck;
        } else {
            return null;
        }
    }

    /**
     * 获取优惠券对账文件表对象
     *
     * @param order_id
     * @param cur_status_id
     * @param cur_status_nm
     * @param ischeck       1代表优惠券需要出对账文件，2代表积分需要出对账文件
     * @return
     */
    private OrderCheckModel getObject(String order_id, String cur_status_id,
                                      String cur_status_nm, String ischeck, String ispoint) {
        OrderCheckModel orderCheck = new OrderCheckModel();
        orderCheck.setOrderId(order_id);
        orderCheck.setCurStatusId(cur_status_id);
        orderCheck.setCurStatusNm(cur_status_nm);
        orderCheck.setDoDate(DateHelper.getyyyyMMdd());
        orderCheck.setDoTime(DateHelper.getHHmmss());
        orderCheck.setIscheck(ischeck);
        orderCheck.setIspoint(ispoint);
        return orderCheck;
    }

    /**
     * 发送BPS,构建支付信息
     *
     * @param payReturnOrderVo
     * @param orderMainModel
     * @param appStageMallPayVerification
     * @param payTime                     支付时间
     * @return
     */
    private AppStageMallPayVerificationReturnSubVO makeAndSendPaySubOrderInfo(
            PayOrderSubDto payReturnOrderVo, OrderMainModel orderMainModel,
            AppStageMallPayVerification appStageMallPayVerification, Date payTime) {
        log.debug("发送BPS,构建支付信息");
        AppStageMallPayVerificationReturnSubVO returnVO = new AppStageMallPayVerificationReturnSubVO();
        try {
            String order_id = payReturnOrderVo.getOrder_id();
            String error_code = payReturnOrderVo.getReturnCode();// 支付网关返回码
            if ("PP030004".equals(error_code)) {// 支付网关返回重复支付
                returnVO.setReturnCode("000050");
                returnVO.setReturnDes("支付结果已存在，不能进行重复支付");
                return returnVO;
            }
            OrderSubModel tblOrder = orderService.findOrderId(order_id);
            if (tblOrder == null) {
                returnVO.setReturnCode("000012");
                returnVO.setReturnDes("查不出小订单记录");
                return returnVO;
            }
            if (payTime == null) {
                log.error("###电子支付问题###包含积分且没有上送支付时间 orderMainId:" + orderMainModel.getOrdermainId());
            } else {
                tblOrder.setOrder_succ_time(payTime);//xiewl 添加支付时间
            }
            tblOrder.setModifyTime(new Date());

            String error_code_text = getReturnCode(error_code);
            if (("000000".equals(error_code) || "RC000".equals(error_code))
                    && "FQ".equals(orderMainModel.getOrdertypeId())) {// 如果是分期订单，支付网关验证通过，则返回
                error_code_text = "验证通过";
            }
            Response<ItemModel> responseFindByItemCode = itemService
                    .findByItemcode(tblOrder.getGoodsId());
            if (!responseFindByItemCode.isSuccess()) {
                throw new RuntimeException(responseFindByItemCode.getError());
            }
            Response<TblGoodsPaywayModel> responsePayWay = goodsPayWayService
                    .findMaxGoodsPayway(tblOrder.getGoodsId());
            if (!responsePayWay.isSuccess()) {
                throw new RuntimeException(responsePayWay.getError());
            }
            TblOrderExtend1Model tblOrderExtend1 = orderCheckService
                    .queryTblOrderExtend1(new Long(order_id));
            TblEspCustCartModel tblEspCustCartModel = orderCheckService
                    .getTblEspCustCart(tblOrder.getCustCartId());
            if (tblOrderExtend1 != null) {
                returnVO.setTblOrderExtendU(tblOrderExtend1);
            }
            returnVO.setTblEspCustCartModel(tblEspCustCartModel);
            returnVO.setOrderId(order_id);
            returnVO.setErrorCode(error_code);
            returnVO.setTblOrderMain(orderMainModel);
            returnVO.setSubOrder(tblOrder);
            returnVO.setErrorCodeText(error_code_text);
            returnVO.setItemCode(responseFindByItemCode.getResult().getCode());
            returnVO.setItemMid(responseFindByItemCode.getResult().getMid());
            returnVO.setGoodsPrice(responsePayWay.getResult().getGoodsPrice() == null ? ""
                    : responsePayWay.getResult().getGoodsPrice().toString());
            returnVO.setCardNo(appStageMallPayVerification.getPayAccountNo());
            returnVO.setCardType(appStageMallPayVerification.getCardType());
            // 分期订单申请bps接口调用
            if ("FQ".equals(orderMainModel.getOrdertypeId())
                    && isSucess(error_code)) {
                sendFQQps(returnVO, tblOrder, orderMainModel);
            }
        } catch (Exception e) {
            log.debug("分期订单 异常,error:{}", Throwables.getStackTraceAsString(e));
            returnVO.setReturnCode("000009");
            returnVO.setReturnDes(e.getMessage());
            return returnVO;
        }
        return returnVO;
    }

    /**
     * 分期订单申请bps接口调用
     */
    private void sendFQQps(AppStageMallPayVerificationReturnSubVO subVO,
                           OrderSubModel tblOrder, OrderMainModel orderMainModel) {
        log.debug("分期订单申请bps接口调用");
        try {
            String bpserrorCode;
            /**
             * 如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求 mod by dengbing
             * start
             */
            BigDecimal comResult = tblOrder.getTotalMoney() == null ? new BigDecimal("0") : tblOrder
                    .getTotalMoney();
            // 如果现金部分为0，并且是走新流程
            if (BigDecimal.ZERO.compareTo(comResult) == 0) {
                log.debug("现金部分为0");

                if (subVO.getTblOrderExtendU() != null) {
                    TblOrderExtend1Model tempTblOrderExtend1 = subVO
                            .getTblOrderExtendU();
                    tempTblOrderExtend1.setOrderId(tblOrder.getOrderId());
                    tempTblOrderExtend1.setExtend1("1");
                    tempTblOrderExtend1.setExtend2(new SimpleDateFormat(
                            "yyyyMMddHHmmss").format(new Date()));// 向bps发起ops分期申请的请求时间
                } else {
                    TblOrderExtend1Model tempTblOrderExtend1 = new TblOrderExtend1Model();
                    tempTblOrderExtend1.setOrderId(tblOrder.getOrderId());
                    tempTblOrderExtend1.setExtend1("1");
                    tempTblOrderExtend1.setExtend2(new SimpleDateFormat(
                            "yyyyMMddHHmmss").format(new Date()));// 向bps发起ops分期申请的请求时间
                    subVO.setTblOrderExtendI(tempTblOrderExtend1);
                }

                StagingRequestResult stagingRequestResult = new StagingRequestResult();
                stagingRequestResult.setErrorCode("0000");// Bps返回的错误码
                stagingRequestResult.setApproveResult("0010");// Bps返回的返回码0000-全额,0010-逐期,0100-拒绝,0200-转人工,0210-异常转人工
                stagingRequestResult.setFollowDir("");// 后续流转方向0-不流转,1-流转
                stagingRequestResult.setCaseId("");// BPS工单号
                stagingRequestResult.setSpecialCust("");// 是否黑灰名单,0-黑名单,1-灰名单,2-其他
                stagingRequestResult.setRejectcode("");// 拒绝代码
                stagingRequestResult.setAprtcode("");// 逐期代码
                stagingRequestResult.setOrdernbr("00000000000");// 核心订单号、银行订单号,默认11个0
                if (stagingRequestResult != null) {
                    bpserrorCode = "0000";// BPS错误码
                    subVO.setBpserrorCode(bpserrorCode); // BPS错误码
                    subVO.setBpserrorCodeText(getReturnCode(bpserrorCode)); // BPS错误码说明
                    subVO.setBpsapproveResult("0010");// BPS返回码
                }
                subVO.setStagingRequestResult(stagingRequestResult);

                /** 如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求 end */
            } else { // 如果现金部分不为0 或者走旧流程，调用BPS的接口
                log.debug("现金部分不为0，调用BPS的接口");
                GateWayEnvolopeDto sendGateWayEnvolopeVo = new GateWayEnvolopeDto();
                sendGateWayEnvolopeVo.setMessageEntityValue("SRCCASEID",
                        subVO.getOrderId());
                sendGateWayEnvolopeVo.setMessageEntityValue("INTERFACETYPE",
                        "0");
                sendGateWayEnvolopeVo.setMessageEntityValue("CARDNBR",
                        subVO.getCardNo());
                sendGateWayEnvolopeVo.setMessageEntityValue("IDNBR",
                        orderMainModel.getContIdcard());
                sendGateWayEnvolopeVo.setMessageEntityValue("CHANNEL", "070");
                sendGateWayEnvolopeVo.setMessageEntityValue("PROJECT", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("REQUESTTYPE", "2");
                sendGateWayEnvolopeVo.setMessageEntityValue("CASETYPE", "0500");
                sendGateWayEnvolopeVo.setMessageEntityValue("SUBCASETYPE",
                        "0501");
                sendGateWayEnvolopeVo.setMessageEntityValue("CREATOR",
                        orderMainModel.getCreateOper());
                sendGateWayEnvolopeVo.setMessageEntityValue("BOOKDESC",
                        orderMainModel.getCsgPhone1());
                sendGateWayEnvolopeVo
                        .setMessageEntityValue("RECEIVEMODE", "02");
                sendGateWayEnvolopeVo.setMessageEntityValue(
                        "ADDR",
                        orderMainModel.getCsgProvince()
                                + orderMainModel.getCsgCity()
                                + orderMainModel.getCsgBorough()
                                + orderMainModel.getCsgAddress());// 省+市+区+详细地址
                sendGateWayEnvolopeVo.setMessageEntityValue("POSTCODE",
                        orderMainModel.getCsgPostcode());
                sendGateWayEnvolopeVo.setMessageEntityValue("DRAWER",
                        orderMainModel.getInvoice());
                sendGateWayEnvolopeVo.setMessageEntityValue("SENDCODE", "D");
                sendGateWayEnvolopeVo.setMessageEntityValue("REGULATOR", "1");
                sendGateWayEnvolopeVo.setMessageEntityValue("SMSNOTICE", "1");
                sendGateWayEnvolopeVo.setMessageEntityValue("SMSPHONE", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("CONTACTNBR1",
                        orderMainModel.getCsgPhone1());
                sendGateWayEnvolopeVo.setMessageEntityValue("CONTACTNBR2",
                        orderMainModel.getCsgPhone2());
                sendGateWayEnvolopeVo.setMessageEntityValue("SBOOKID",
                        orderMainModel.getOrdermainId());
                sendGateWayEnvolopeVo.setMessageEntityValue("BBOOKID", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("RESERVATION", "0");
                sendGateWayEnvolopeVo.setMessageEntityValue("RESERVETIME", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("CERTTYPE",
                        orderMainModel.getContIdType());
                sendGateWayEnvolopeVo
                        .setMessageEntityValue("URGENTLVL", "0200");
                sendGateWayEnvolopeVo.setMessageEntityValue("MICHELLEID", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("OLDBANKID", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("PRODUCTCODE",
                        subVO.getItemMid());// 分期编码
                sendGateWayEnvolopeVo.setMessageEntityValue("PRODUCTNAME",
                        tblOrder.getGoodsNm());
                sendGateWayEnvolopeVo.setMessageEntityValue("PRICE",
                        subVO.getGoodsPrice());// 商品总价
                sendGateWayEnvolopeVo.setMessageEntityValue("COLOR",
                        tblOrder.getGoodsColor());
                sendGateWayEnvolopeVo.setMessageEntityValue("AMOUNT", "1");
                sendGateWayEnvolopeVo.setMessageEntityValue("SUMAMT", tblOrder
                        .getTotalMoney().toString());
                sendGateWayEnvolopeVo.setMessageEntityValue("SUBORDERID",
                        tblOrder.getOrderId());
                sendGateWayEnvolopeVo.setMessageEntityValue("FIRSTPAYMENT", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("BILLS", tblOrder
                        .getStagesNum().toString());
                sendGateWayEnvolopeVo.setMessageEntityValue("PERPERIODAMT",
                        tblOrder.getIncTakePrice().toString());// 检查
                sendGateWayEnvolopeVo.setMessageEntityValue("SUPPLIERCODE",
                        tblOrder.getVendorId());
                Response<VendorInfoModel> vendorInfo = vendorService
                        .findVendorById(tblOrder.getVendorId());
                if (!vendorInfo.isSuccess()) {
                    subVO.setReturnCode("000050");
                    subVO.setReturnDes("供应商不存在");
                    return;
                }
                sendGateWayEnvolopeVo.setMessageEntityValue("VIRTUALSTORE",
                        vendorInfo.getResult().getVirtualVendorId());
                Response<List<TblVendorRatioModel>> responseFindVendorRatioInfo = userInfoService
                        .findVendorRatioInfo(tblOrder.getVendorId(), tblOrder
                                .getStagesNum().toString());
                if (!responseFindVendorRatioInfo.isSuccess()
                        || responseFindVendorRatioInfo.getResult().size() <= 0) {
                    throw new RuntimeException(
                            responseFindVendorRatioInfo.getError());
                }
                vendorRatioMessage(sendGateWayEnvolopeVo,
                        responseFindVendorRatioInfo.getResult().get(0),
                        tblOrder.getTotalMoney().toString());
                sendGateWayEnvolopeVo.setMessageEntityValue("SUPPLIERDESC", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("RECOMMENDCARDNBR",
                        "");
                sendGateWayEnvolopeVo
                        .setMessageEntityValue("RECOMMENDNAME", "");
                sendGateWayEnvolopeVo.setMessageEntityValue(
                        "RECOMMENDCERTTYPE", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("RECOMMENDID", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("PREVCASEID", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("CUSTNAME",
                        orderMainModel.getContNm());
                sendGateWayEnvolopeVo.setMessageEntityValue("INCOMINGTEL", "");
                sendGateWayEnvolopeVo
                        .setMessageEntityValue("ORDERMEMO", "正常订单");
                sendGateWayEnvolopeVo
                        .setMessageEntityValue("FORCETRANSFER", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("SUPPLIERNAME",
                        tblOrder.getVendorSnm());
                sendGateWayEnvolopeVo.setMessageEntityValue("MEMO", "");
                sendGateWayEnvolopeVo.setMessageEntityValue("RECEIVENAME",
                        orderMainModel.getCsgName());
                sendGateWayEnvolopeVo.setMessageEntityValue("MERCHANTCODE", "");// 特店号暂时约定传空

                /****************** 使用优惠券或积分情况start *************************/
                String ACCEPTAMT = tblOrder.getTotalMoney().toString();// 申请分期金额(抵扣后的产品金额)
                sendGateWayEnvolopeVo.setMessageEntityValue("ACCEPTAMT",
                        ACCEPTAMT);
                String FAVORABLETYPE = "";// 优惠类型
                String DEDUCTAMT = "";// 抵扣金额
                if (tblOrder.getVoucherNo() != null
                        && !"".equals(tblOrder.getVoucherNo())) {
                    FAVORABLETYPE = "01";
                    DEDUCTAMT = tblOrder.getVoucherPrice().toString();
                }
                if (tblOrder.getBonusTotalvalue() != null
                        && tblOrder.getBonusTotalvalue() != 0L) {
                    FAVORABLETYPE = "02";
                    DEDUCTAMT = tblOrder.getUitdrtamt().toString();
                }
                if ((tblOrder.getVoucherNo() != null && !"".equals(tblOrder
                        .getVoucherNo()))
                        && (tblOrder.getBonusTotalvalue() != null && tblOrder
                        .getBonusTotalvalue() != 0L)) {
                    FAVORABLETYPE = "03";
                    // 金额的计算需要转化成BigDecimal计算
                    DEDUCTAMT = dataAdd(tblOrder.getVoucherPrice().toString(),
                            tblOrder.getUitdrtamt().toString());
                }
                if ((tblOrder.getVoucherNo() == null || "".equals(tblOrder
                        .getVoucherNo()))
                        && (tblOrder.getBonusTotalvalue() == null || tblOrder
                        .getBonusTotalvalue() == 0L)) {
                    FAVORABLETYPE = "00";
                }
                sendGateWayEnvolopeVo.setMessageEntityValue("FAVORABLETYPE",
                        FAVORABLETYPE);// 优惠类型
                sendGateWayEnvolopeVo.setMessageEntityValue("DEDUCTAMT",
                        DEDUCTAMT);// 抵扣金额
                /****************** 使用优惠券或积分情况end *************************/
                sendGateWayEnvolopeVo.setReceiverIdFlag("true");// 方在VO中，以便后续判断接收方标识

                if (subVO.getTblOrderExtendU() != null) {
                    TblOrderExtend1Model tempTblOrderExtend1 = subVO
                            .getTblOrderExtendU();
                    tempTblOrderExtend1.setOrderId(tblOrder.getOrderId());
                    tempTblOrderExtend1.setExtend1("1");
                    tempTblOrderExtend1.setExtend2(DateHelper.date2string(
                            new Date(), DateHelper.YYYY_MM_DD_HH_MM_SS));// 向bps发起ops分期申请的请求时间
                } else {
                    TblOrderExtend1Model tempTblOrderExtend1 = new TblOrderExtend1Model();
                    tempTblOrderExtend1.setOrderId(tblOrder.getOrderId());
                    tempTblOrderExtend1.setExtend1("1");
                    tempTblOrderExtend1.setExtend2(DateHelper.date2string(
                            new Date(), DateHelper.YYYY_MM_DD_HH_MM_SS));// 向bps发起ops分期申请的请求时间
                    subVO.setTblOrderExtendI(tempTblOrderExtend1);
                }
                StagingRequest req = vo2req(sendGateWayEnvolopeVo);
                StagingRequestResult returnGateWayEnvolopeVo = stagingRequestService
                        .getStagingRequest(req);
                if (returnGateWayEnvolopeVo != null) {
                    subVO.setBpserrorCode(returnGateWayEnvolopeVo
                            .getErrorCode()); // BPS错误码
                    subVO.setBpserrorCodeText(getReturnCode(returnGateWayEnvolopeVo
                            .getErrorCode())); // BPS错误码说明
                    subVO.setBpsapproveResult(returnGateWayEnvolopeVo
                            .getApproveResult());// BPS返回码
                }
                subVO.setStagingRequestResult(returnGateWayEnvolopeVo);
            }
        } catch (Exception e) {
            log.error("分期订单申请bps接口调用 error{}",
                    Throwables.getStackTraceAsString(e));
        }
    }

    /**
     * 解析订单字符串 1）如果optFlag为0，上送：商户号|订单号|金额|响应码
     * 2）如果optFlag为2，上送：小流水号|商户号|订单号|交易结果|异常码|异常描述信息 说明：交易结果：01成功；02失败；00异常；
     * 异常码：交易结果01时为000000；交易结果00、02时为相应的错误码 描述信息：交易结果01时为空；交易结果00、02时不为空
     *
     * @param orders
     * @return
     */
    private List<PayOrderSubDto> parseOrders(String orders, String optFlag)
            throws Exception {
        List<PayOrderSubDto> list = Lists.newArrayList();
        if (orders == null || "".equals(orders)) {
            throw new RuntimeException("orders is null");
        }
        if (orders.endsWith("|")) {// 如果最后一个域为空，则加上结束符#以方便处理
            orders = orders + "#";
        }
        String orderArray[] = orders.split("\\|");
        if ("0".equals(optFlag)) {
            if (orderArray.length % 4 != 0) {// 如果除以4余数不为0
                throw new Exception("orderArray.length % 4 must be 0");
            }
            for (int i = 0; i < orderArray.length; i = i + 4) {
                PayOrderSubDto payOrderSubDto = new PayOrderSubDto();
                payOrderSubDto.setVendor_id(orderArray[i]);
                payOrderSubDto.setOrder_id(orderArray[i + 1]);
                payOrderSubDto.setMoney(orderArray[i + 2]);
                payOrderSubDto.setReturnCode(orderArray[i + 3]);
                list.add(payOrderSubDto);
            }
        } else if ("2".equals(optFlag)) {
            if (orderArray.length % 6 != 0) {// 如果除以6余数不为0
                throw new Exception("orderArray.length % 6 must be 0");
            }
            for (int i = 0; i < orderArray.length; i = i + 6) {
                PayOrderSubDto payOrderSubDto = new PayOrderSubDto();
                payOrderSubDto.setVendor_id(orderArray[i + 1]);
                payOrderSubDto.setOrder_id(orderArray[i + 2]);
                payOrderSubDto.setReturnCode(orderArray[i + 4]);
                list.add(payOrderSubDto);
            }
        }
        return list;
    }

    /**
     * 判断是否状态成功
     *
     * @param returnCode
     * @return
     */
    public static boolean isSucess(String returnCode) {
        String stateSucess[] = {"RC000", "000000"};// 成功返回码
        for (int i = 0; i < stateSucess.length; i++) {
            if (stateSucess[i].equals(returnCode.trim())) {
                return true;
            }
        }
        return false;
    }

    /**
     * 配合信用卡大机改造BP0005接口新增字段-接口工程公共方法
     *
     * @param sendGateWayEnvolopeVo
     * @param vendorRatio
     * @param totalMoney
     */
    public static void vendorRatioMessage(
            GateWayEnvolopeDto sendGateWayEnvolopeVo,
            TblVendorRatioModel vendorRatio, String totalMoney) {
        if (vendorRatio != null) {
            sendGateWayEnvolopeVo.setMessageEntityValue("FIXEDFEEHTFLAG",
                    vendorRatio.getFixedfeehtFlag());
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "FIXEDAMTFEE",
                    vendorRatio.getFixedamtFee() == null ? "" : String
                            .valueOf(vendorRatio.getFixedamtFee().setScale(2,
                                    BigDecimal.ROUND_DOWN)));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "FEERATIO1",
                    vendorRatio.getFeeratio1() == null ? "" : String
                            .valueOf(vendorRatio.getFeeratio1().setScale(5,
                                    BigDecimal.ROUND_DOWN)));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "RATIO1PRECENT",
                    vendorRatio.getRatio1Precent() == null ? "" : String
                            .valueOf(vendorRatio.getRatio1Precent().setScale(2,
                                    BigDecimal.ROUND_DOWN)));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "FEERATIO2",
                    vendorRatio.getFeeratio2() == null ? "" : String
                            .valueOf(vendorRatio.getFeeratio2().setScale(5,
                                    BigDecimal.ROUND_DOWN)));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "RATIO2PRECENT",
                    vendorRatio.getRatio2Precent() == null ? "" : String
                            .valueOf(vendorRatio.getRatio2Precent().setScale(2,
                                    BigDecimal.ROUND_DOWN)));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "FEERATIO2BILL",
                    vendorRatio.getFeeratio2Bill() == null ? "" : String
                            .valueOf(vendorRatio.getFeeratio2Bill()));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "FEERATIO3",
                    vendorRatio.getFeeratio3() == null ? "" : String
                            .valueOf(vendorRatio.getFeeratio3().setScale(5,
                                    BigDecimal.ROUND_DOWN)));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "RATIO3PRECENT",
                    vendorRatio.getRatio3Precent() == null ? "" : String
                            .valueOf(vendorRatio.getRatio3Precent().setScale(2,
                                    BigDecimal.ROUND_DOWN)));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "FEERATIO3BILL",
                    vendorRatio.getFeeratio3Bill() == null ? "" : String
                            .valueOf(vendorRatio.getFeeratio3Bill()));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "REDUCERATEFROM",
                    vendorRatio.getReducerateFrom() == null ? "" : String
                            .valueOf(vendorRatio.getReducerateFrom()));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "REDUCERATETO",
                    vendorRatio.getReducerateTo() == null ? "" : String
                            .valueOf(vendorRatio.getReducerateTo()));
            sendGateWayEnvolopeVo.setMessageEntityValue(
                    "REDUCEHANDINGFEE",
                    vendorRatio.getReducerate() == null ? "" : String
                            .valueOf(vendorRatio.getReducerate()));
            sendGateWayEnvolopeVo.setMessageEntityValue("HTFLAG", vendorRatio
                    .getHtflag() == null ? "" : vendorRatio.getHtflag());
            // 如果“首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，默认送现金金额，如果小于等于现金金额,就送首尾付本金值--大机补充需求
            // mod by dengbing start
            String htcapital = "";
            BigDecimal TotalMoneyDe = null;
            if (!"".equals(totalMoney)) {
                TotalMoneyDe = new BigDecimal(totalMoney);
            }
            if (vendorRatio.getHtant() == null || TotalMoneyDe == null) {
                htcapital = vendorRatio.getHtant() == null ? "" : String
                        .valueOf(vendorRatio.getHtant().setScale(2,
                                BigDecimal.ROUND_DOWN));
            } else {
                int compareResult = vendorRatio.getHtant().compareTo(
                        TotalMoneyDe);
                if (compareResult > 0) {// “首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，送现金金额
                    htcapital = String.valueOf(TotalMoneyDe.setScale(2,
                            BigDecimal.ROUND_DOWN));
                } else {// 如果小于等于现金金额,就送首尾付本金值
                    htcapital = String.valueOf(vendorRatio.getHtant().setScale(
                            2, BigDecimal.ROUND_DOWN));
                }
            }
            sendGateWayEnvolopeVo.setMessageEntityValue("HTCAPITAL", htcapital);
        }
    }

    /**
     * 计算两个值相加的结果
     *
     * @param value1
     * @param value2
     * @return
     * @throws Exception
     */
    public static String dataAdd(String value1, String value2) throws Exception {
        String returnVal = "";
        try {
            returnVal = new BigDecimal(value1).add(new BigDecimal(value2))
                    .toString();
            return returnVal;
        } catch (Exception e) {
            throw new Exception("金额转换错误");
        }
    }

    public static String getReturnCode(String error_code) {
        return PropertyPlaceholder.getProperty(error_code);
    }

    private StagingRequest vo2req(GateWayEnvolopeDto sendGateWayEnvolopeVo) {
        StagingRequest req = new StagingRequest();
        req.setSrcCaseId(sendGateWayEnvolopeVo
                .getMessageEntityValue("SRCCASEID"));
        req.setInterfaceType(sendGateWayEnvolopeVo
                .getMessageEntityValue("INTERFACETYPE"));
        req.setCaseType(sendGateWayEnvolopeVo.getMessageEntityValue("CASETYPE"));
        req.setSubCaseType(sendGateWayEnvolopeVo
                .getMessageEntityValue("SUBCASETYPE"));
        req.setChannel(sendGateWayEnvolopeVo.getMessageEntityValue("CHANNEL"));
        req.setProject(sendGateWayEnvolopeVo.getMessageEntityValue("PROJECT"));
        req.setRequestType(sendGateWayEnvolopeVo
                .getMessageEntityValue("REQUESTTYPE"));
        req.setCreator(sendGateWayEnvolopeVo.getMessageEntityValue("CREATOR"));
        req.setMichelleId(sendGateWayEnvolopeVo
                .getMessageEntityValue("MICHELLEID"));
        req.setBookDesc(sendGateWayEnvolopeVo.getMessageEntityValue("BOOKDESC"));
        req.setReceiveMode(sendGateWayEnvolopeVo
                .getMessageEntityValue("RECEIVEMODE"));
        req.setAddr(sendGateWayEnvolopeVo.getMessageEntityValue("ADDR"));
        req.setPostcode(sendGateWayEnvolopeVo.getMessageEntityValue("POSTCODE"));
        req.setDrawer(sendGateWayEnvolopeVo.getMessageEntityValue("DRAWER"));//
        req.setSendCode(sendGateWayEnvolopeVo.getMessageEntityValue("SENDCODE"));
        req.setRegulator(sendGateWayEnvolopeVo
                .getMessageEntityValue("REGULATOR"));
        req.setSmsnotice(sendGateWayEnvolopeVo
                .getMessageEntityValue("SMSNOTICE"));
        req.setSmsPhone(sendGateWayEnvolopeVo.getMessageEntityValue("SMSPHONE"));
        req.setContactNbr1(sendGateWayEnvolopeVo
                .getMessageEntityValue("CONTACTNBR1"));
        req.setContactNbr2(sendGateWayEnvolopeVo
                .getMessageEntityValue("CONTACTNBR2"));
        req.setSbookid(sendGateWayEnvolopeVo.getMessageEntityValue("SBOOKID"));
        req.setSuborderid(sendGateWayEnvolopeVo
                .getMessageEntityValue("SUBORDERID"));
        req.setBbookid(sendGateWayEnvolopeVo.getMessageEntityValue("BBOOKID"));
        req.setReservation(sendGateWayEnvolopeVo
                .getMessageEntityValue("RESERVATION"));
        req.setReserveTime(sendGateWayEnvolopeVo
                .getMessageEntityValue("RESERVETIME"));
        req.setCardnbr(sendGateWayEnvolopeVo.getMessageEntityValue("CARDNBR"));
        req.setIdNbr(sendGateWayEnvolopeVo.getMessageEntityValue("IDNBR"));
        req.setCerttype(sendGateWayEnvolopeVo.getMessageEntityValue("CERTTYPE"));
        req.setUrgentLvl(sendGateWayEnvolopeVo
                .getMessageEntityValue("CERTTYPE"));
        req.setOldBankId(sendGateWayEnvolopeVo
                .getMessageEntityValue("OLDBANKID"));
        req.setProductCode(sendGateWayEnvolopeVo
                .getMessageEntityValue("PRODUCTCODE"));
        req.setProductName(sendGateWayEnvolopeVo
                .getMessageEntityValue("PRODUCTNAME"));
        req.setPrice(new BigDecimal(sendGateWayEnvolopeVo
                .getMessageEntityValue("PRICE")));
        req.setColor(sendGateWayEnvolopeVo.getMessageEntityValue("COLOR"));
        req.setAmount(sendGateWayEnvolopeVo.getMessageEntityValue("AMOUNT"));
        req.setSumAmt(new BigDecimal(sendGateWayEnvolopeVo
                .getMessageEntityValue("SUMAMT")));
        req.setBills(sendGateWayEnvolopeVo.getMessageEntityValue("BILLS"));
        req.setPerPeriodAmt(new BigDecimal(sendGateWayEnvolopeVo
                .getMessageEntityValue("PERPERIODAMT")));
        req.setSupplierCode(sendGateWayEnvolopeVo
                .getMessageEntityValue("SUPPLIERCODE"));
        req.setSupplierDesc(sendGateWayEnvolopeVo
                .getMessageEntityValue("SUPPLIERDESC"));
        req.setRecommendCardnbr(sendGateWayEnvolopeVo
                .getMessageEntityValue("RECOMMENDCARDNBR"));
        req.setRecommendname(sendGateWayEnvolopeVo
                .getMessageEntityValue("RECOMMENDNAME"));
        req.setRecommendCerttype(sendGateWayEnvolopeVo
                .getMessageEntityValue("RECOMMENDCERTTYPE"));
        req.setRecommendid(sendGateWayEnvolopeVo
                .getMessageEntityValue("RECOMMENDID"));
        req.setPrevCaseId(sendGateWayEnvolopeVo
                .getMessageEntityValue("PREVCASEID"));
        req.setCustName(sendGateWayEnvolopeVo.getMessageEntityValue("CUSTNAME"));
        req.setIncomingTel(sendGateWayEnvolopeVo
                .getMessageEntityValue("INCOMINGTEL"));
        req.setOrdermemo(sendGateWayEnvolopeVo
                .getMessageEntityValue("ORDERMEMO"));
        req.setForceTransfer(sendGateWayEnvolopeVo
                .getMessageEntityValue("FORCETRANSFER"));
        req.setSupplierName(sendGateWayEnvolopeVo
                .getMessageEntityValue("SUPPLIERNAME"));
        req.setMemo(sendGateWayEnvolopeVo.getMessageEntityValue("MEMO"));
        req.setReceiveName(sendGateWayEnvolopeVo
                .getMessageEntityValue("RECEIVENAME"));
        req.setMerchantCode(sendGateWayEnvolopeVo
                .getMessageEntityValue("MERCHANTCODE"));
        req.setAcceptAmt(new BigDecimal(sendGateWayEnvolopeVo
                .getMessageEntityValue("ACCEPTAMT")));
        req.setFavorableType(sendGateWayEnvolopeVo
                .getMessageEntityValue("FAVORABLETYPE"));
        req.setDeductAmt(StringUtils.isNotEmpty(sendGateWayEnvolopeVo
                .getMessageEntityValue("DEDUCTAMT")) ? new BigDecimal(
                sendGateWayEnvolopeVo.getMessageEntityValue("DEDUCTAMT"))
                : null);
        req.setFixedFeeHTFlag(sendGateWayEnvolopeVo
                .getMessageEntityValue("FIXEDFEEHTFLAG"));
        req.setFixedAmtFee(new BigDecimal(sendGateWayEnvolopeVo
                .getMessageEntityValue("FIXEDAMTFEE")));
        req.setFeeRatio1(new BigDecimal(sendGateWayEnvolopeVo
                .getMessageEntityValue("FEERATIO1")));
        req.setRatio1Precent(new BigDecimal(sendGateWayEnvolopeVo
                .getMessageEntityValue("RATIO1PRECENT")));
        req.setRatio2Precent(convertNum(sendGateWayEnvolopeVo
                .getMessageEntityValue("RATIO2PRECENT")));
        req.setFeeRatio2Bill(convertInt(sendGateWayEnvolopeVo
                .getMessageEntityValue("FEERATIO2BILL")));
        req.setFeeRatio3(convertNum(sendGateWayEnvolopeVo
                .getMessageEntityValue("FEERATIO3")));
        req.setRatio3Precent(convertNum(sendGateWayEnvolopeVo
                .getMessageEntityValue("RATIO3PRECENT")));
        req.setFeeRatio3Bill(convertInt(sendGateWayEnvolopeVo
                .getMessageEntityValue("FEERATIO3BILL")));
        req.setReducerateFrom(convertInt(sendGateWayEnvolopeVo
                .getMessageEntityValue("REDUCERATEFROM")));
        req.setReducerateTo(new Integer(sendGateWayEnvolopeVo
                .getMessageEntityValue("REDUCERATETO")));
        req.setReduceHandingFee(new Integer(sendGateWayEnvolopeVo
                .getMessageEntityValue("REDUCEHANDINGFEE")));
        req.setHtFlag(sendGateWayEnvolopeVo.getMessageEntityValue("HTFLAG"));
        req.setHtCapital(new BigDecimal(sendGateWayEnvolopeVo
                .getMessageEntityValue("HTCAPITAL")));
        req.setVirtualStore(sendGateWayEnvolopeVo
                .getMessageEntityValue("VIRTUALSTORE"));
        return req;
    }

    /**
     * 判断Bp0005是否支付成功
     *
     * @param errorCode
     * @param approveResult
     * @return
     */
    private static boolean isBp0005Sucess(String errorCode, String approveResult) {
        String errorCodeSucess[] = {"0000"};// errorCode为成功的
        String approveResultSucess[] = {"0000", "0010"};// approveResult为支付成功的
        boolean falg = false;
        for (int i = 0; i < errorCodeSucess.length; i++) {
            if (errorCodeSucess[i].equals(errorCode)) {
                falg = true;
                break;
            }
        }
        if (falg == true) {
            falg = false;
            for (int i = 0; i < approveResultSucess.length; i++) {
                if (approveResultSucess[i].equals(approveResult)) {
                    falg = true;
                    break;
                }
            }
        }
        return falg;
    }

    /**
     * 判断Bp0005是否处理中
     *
     * @param errorCode
     * @param approveResult
     * @return
     */
    private static boolean isBp0005Dealing(String errorCode,
                                           String approveResult) {
        String errorCodeSucess[] = {"0000"};// errorCode为成功的
        String approveResultDealing[] = {"0200", "0210"};// approveResult为处理中
        boolean falg = false;
        for (int i = 0; i < errorCodeSucess.length; i++) {
            if (errorCodeSucess[i].equals(errorCode)) {
                falg = true;
                break;
            }
        }
        if (falg == true) {
            falg = false;
            for (int i = 0; i < approveResultDealing.length; i++) {
                if (approveResultDealing[i].equals(approveResult)) {
                    falg = true;
                    break;
                }
            }
        }
        return falg;
    }

    /**
     * 判断是否状态未明
     *
     * @param errorCode
     * @param approveResult
     * @return
     */
    private static boolean isBp0005NoSure(String errorCode, String approveResult) {
        if (errorCode == null || "".equals(errorCode)) {
            return true;
        } else if ("0000".equals(errorCode)) {
            if (approveResult == null || "".equals(approveResult)) {
                return true;
            } else if (!("0000".equals(approveResult)
                    || "0010".equals(approveResult)
                    || "0100".equals(approveResult)
                    || "0200".equals(approveResult) || "0210"
                    .equals(approveResult))) {
                return true;
            }
        }
        return false;
    }

    private void addPoint(Map<String, Long> pointMap, Long point) {
        if (point == null || point == 0L)
            return;
        if (pointMap == null) {
            pointMap = Maps.newHashMap();
        }
        String ymd = DateHelper.getyyyyMM();
        if (pointMap.containsKey(ymd)) {
            pointMap.put(ymd, pointMap.get(ymd) + point);
        } else {
            pointMap.put(ymd, point);
        }
    }

    private void addRollBackStock(Map<String, Integer> stockMap, String code,
                                  Integer stock) {
        if (stockMap.containsKey(code)) {
            stockMap.put(code, stockMap.get(code) + stock);
        } else {
            stockMap.put(code, stock);
        }
    }

    private static BigDecimal convertNum(String str, BigDecimal... def) {
        return StringUtils.isNotEmpty(str) ? new BigDecimal(str) : def != null
                && def.length > 0 ? def[0] : null;
    }

    private static Integer convertInt(String str, Integer... def) {
        return StringUtils.isNotEmpty(str) ? new Integer(str) : def != null
                && def.length > 0 ? def[0] : null;
    }
}
