package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.BpsReturnCode;
import cn.com.cgbchina.common.utils.CardUtil;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.PayReturnCode;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderOutSystemDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dao.TblOrderExtend1Dao;
import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.trade.manager.OrderTradeManager;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.UserInfoService;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;

/**
 * Created by shangqinbin on 2016/6/29.
 */
@Service
@Slf4j
public class OrderDealServiceImpl implements OrderDealService {

    @Autowired
    private StagingRequestService stagingRequestService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private IdGenarator idGenarator;

    @Autowired
    private OrderMainDao orderMainDao;

    @Autowired
    private OrderSubDao orderSubDao;

    @Autowired
    private TblOrderExtend1Dao tblOrderExtend1Dao;

    @Autowired
    private GoodsPayWayService goodsPayWayService;

    @Autowired
    private ItemService itemService;

    @Autowired
    private GoodsService goodsService;

    @Autowired
    private UserInfoService userInfoService;

    @Autowired
    private OrderTradeManager orderTradeManager;

    @Autowired
    private VendorService vendorService;

    @Autowired
    private OrderOutSystemDao orderOutSystemDao;


    /**
     * 处理支付网关返回的报文
     */
    @Override
    public OrderDealDto dealPay(PayOrderInfoDto payOrderInfoDto) {
        // 开始组合返回报文
        OrderDealDto orderDealDto = null;
        OrderMainModel orderMainModel = null;
        String orderType = null;//订单类型
        String payAccountNo = null;
        List returnOrders = new ArrayList();
        String orderMain_id = "";
        // 解析web传过来的dto
        try {
            orderDealDto = new OrderDealDto();
            payAccountNo = payOrderInfoDto.getPayAccountNo();// 支付卡号
            orderDealDto.setType("response");
            orderDealDto.setErrorCode("0000");
            orderDealDto.setErrorDesc("success");
            orderMain_id = payOrderInfoDto.getOrderid();
            String isOver = jugOverdeal(orderMain_id);  //
            if ("1".equals(isOver)) {// 如果是重复收到支付网关结果
                orderDealDto.setErrorCode("3333");
                orderDealDto.setErrorDesc("您好，订单正在受理中，请稍后查询订单信息，谢谢！");
                log.info("您好，订单正在受理中，请稍后查询订单信息，谢谢！");
                return orderDealDto;
            }
        } catch (Exception e) {
            orderDealDto.setErrorCode("9999");
            orderDealDto.setErrorDesc(e.getMessage());
            log.info("解析dto失败");
            return orderDealDto;
        }

        try {
            // 如果是分期订单，查出所有的小订单
            orderMainModel = toOrderMain(orderMain_id);
            orderType = judgeType(orderMainModel);
            if ("FQ".equals(orderType)) {// 分期
                log.info("分期");
                List list = payOrderInfoDto.getPayOrderSubDtoList();
                if (list == null || list.size() < 1) {
                    log.info("没有订单");
                    throw new Exception("没有订单");
                }
                Iterator iter = list.iterator();
                while (iter.hasNext()) {
                    PayOrderSubDto payOrderSubDto = (PayOrderSubDto) iter.next();
                    log.info("小订单号:" + payOrderSubDto.getOrder_id());
                    //取得小订单详情
                    OrderSubModel orderSubModel = orderSubDao.findById(payOrderSubDto.getOrder_id());
                    log.info("取得小订单详情");
                    //取得商品详情
                    ItemModel itemModel = itemService.findByItemcode(orderSubModel.getGoodsId()).getResult();
                    log.info("取得单品详情");
                    GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode()).getResult();
                    log.info("取得商品详情");
                    //取得订单扩展表1
                    TblOrderExtend1Model tblOrderExtend1Model = queryTBLORDEREXTEND1(payOrderSubDto.getOrder_id());
                    log.info("取得订单扩展表1");
                    Map map = new HashMap();
                    map.put("node", payOrderSubDto);
                    //取得上面的信息之后添加
                    map.put("orderInf", orderSubModel);
                    map.put("goods_mid", itemModel.getMid());
                    map.put("goods_present", goodsModel.getGiftDesc());
                    map.put("tblOrderExtend1", tblOrderExtend1Model);
                    returnOrders.add(map);

                }
            }
        } catch (Exception e) {
            log.info("查询分期订单信息异常");
            orderDealDto.setErrorCode("9999");
            orderDealDto.setErrorDesc(e.getMessage());
            return orderDealDto;
        }

        try {
            // 发起ops分期订单申请
            if ("FQ".equals(orderType)) {
                log.info("如果是分期,发起ops分期订单申请");
                for (int i = 0; i < returnOrders.size(); i++) {
                    Map map = (Map) returnOrders.get(i);
                    PayOrderSubDto payOrderSubDto = (PayOrderSubDto) map.get("node");
                    String returnCode = payOrderSubDto.getReturnCode();// 返回码
                    log.info("returnCode:" + returnCode);
                    if (PayReturnCode.isSucess(returnCode)) { // 如果支付网关返回验证成功
                        log.info("支付网关返回验证成功");
                        OrderSubModel orderSubModel = (OrderSubModel) map.get("orderInf");
                        //如果现金部分为0，并且是走新流程则不调用BPS的接口，直接处理为支付成功
                        int comResult = orderSubModel.getTotalMoney().compareTo(BigDecimal.ZERO);
                        if (comResult == 0) {// 如果现金部分为0并且是走新流程
                            log.info("现金部分为0并且是走新流程");
                            // 如果现金部分为0,并且是走新流程
                            String errorcode = null;
                            String approveresult = null;
                            String extend1 = null;// 0或空:没发送过给bps 1:发送过给bps
                            TblOrderExtend1Model tblOrderExtend1 = (TblOrderExtend1Model) map.get("tblOrderExtend1");
                            if (tblOrderExtend1 != null) {
                                errorcode = tblOrderExtend1.getErrorcode();
                                approveresult = tblOrderExtend1.getApproveresult();
                                extend1 = tblOrderExtend1.getExtend1();
                            }
                            log.info("extend1:" + extend1);
                            if (!"1".equals(extend1)) {// 如果没发送过给bps系统
                                log.info("没发送过给bps系统");
                                TblOrderExtend1Model tblOrderExtend = null;
                                try {
                                    tblOrderExtend = new TblOrderExtend1Model();
                                    tblOrderExtend.setOrderId(orderSubModel.getOrderId());
                                    tblOrderExtend.setExtend1("1");
                                    tblOrderExtend.setExtend2(DateHelper.getCurrentTime());// 记录向bps发起请求的时间
                                    tblOrderExtend1Dao.insert(tblOrderExtend);// 保存TblOrderExtend1
                                } catch (Exception e) {
                                    log.info("保存订单扩展表1错误");
                                    log.error("exception", e);
                                    orderDealDto.setErrorCode("9999");
                                    orderDealDto.setErrorDesc(e.getMessage());
                                    return orderDealDto;
                                }
                                map.put("tblOrderExtend1", tblOrderExtend);
                                StagingRequestResult stagingRequestResult = returnBPSVO();
                                log.info("收到结果:" + stagingRequestResult);
                                map.put("returnGateWayEnvolopeVo", stagingRequestResult);
                            } else {// 如果发送过给bps
                                log.info("发送过给bps系统");
                                log.info("errorcode" + errorcode);
                                log.info("approveresult" + approveresult);
                                StagingRequestResult stagingRequestResult = new StagingRequestResult();
                                stagingRequestResult.setErrorCode(errorcode);
                                stagingRequestResult.setApproveResult(approveresult);
                                map.put("returnGateWayEnvolopeVo", stagingRequestResult);
                                map.put("isAlreadySendBps", "1");// 空和0:没发送过,1:发送过给bps
                            }
                        } else {// 如果现金部分不为0 或者走旧流程，调用BPS的接口
                            log.info("现金部分不为0 或者走旧流程，调用BPS的接口");
                            String goods_mid = (String) map.get("goods_mid");
                            String goods_present = (String) map.get("goods_present");
                            String errorcode = null;
                            String approveresult = null;
                            String extend1 = null;// 0或空:没发送过给bps 1:发送过给bps
                            TblOrderExtend1Model tblOrderExtend = (TblOrderExtend1Model) map.get("tblOrderExtend1");
                            if (tblOrderExtend != null) {
                                errorcode = tblOrderExtend.getErrorcode();
                                approveresult = tblOrderExtend.getApproveresult();
                                extend1 = tblOrderExtend.getExtend1();
                            }
                            log.info("extend1:" + extend1);
                            if (!"1".equals(extend1)) {// 如果没发送过给bps系统
                                log.info("没发送过给bps系统");
                                TblGoodsPaywayModel tblGoodsPaywayModel = goodsPayWayService.findGoodsPayWayInfo(orderSubModel.getGoodsPaywayId()).getResult();
                                StagingRequest stagingRequest = new StagingRequest();
                                stagingRequest.setSrcCaseId(orderSubModel.getOrderId());
                                stagingRequest.setInterfaceType("0");
                                stagingRequest.setCardnbr(payAccountNo);
                                stagingRequest.setIdNbr(orderMainModel.getContIdcard());
                                stagingRequest.setChannel("070");
                                stagingRequest.setProject("");
                                stagingRequest.setRequestType("2");
                                stagingRequest.setCaseType("0500");
                                stagingRequest.setSubCaseType("0501");
                                stagingRequest.setCreator(orderMainModel.getCreateOper());
                                stagingRequest.setBookDesc(orderMainModel.getCsgPhone1());
                                stagingRequest.setReceiveMode("02");
                                stagingRequest.setAddr(orderMainModel.getCsgProvince() + orderMainModel.getCsgCity() + orderMainModel.getCsgBorough() + orderMainModel.getCsgAddress());// 省+市+区+详细地址
                                stagingRequest.setPostcode(orderMainModel.getCsgPostcode());
                                stagingRequest.setDrawer(orderMainModel.getInvoice());
                                stagingRequest.setSendCode("D");
                                stagingRequest.setRegulator("1");
                                stagingRequest.setSmsnotice("1");
                                stagingRequest.setSmsPhone("");
                                stagingRequest.setContactNbr1(orderMainModel.getCsgPhone1());
                                stagingRequest.setContactNbr2(orderMainModel.getCsgPhone2());
                                stagingRequest.setSbookid(orderMainModel.getOrdermainId());
                                stagingRequest.setBbookid("");
                                stagingRequest.setReservation("0");
                                stagingRequest.setReserveTime("");
                                stagingRequest.setCerttype(CardUtil.getbpsFromPerBankCardType(orderMainModel.getContIdType()));
                                stagingRequest.setUrgentLvl("0200");
                                stagingRequest.setMichelleId("");
                                stagingRequest.setOldBankId("");
                                stagingRequest.setProductCode(goods_mid);// 分期编码
                                stagingRequest.setProductName(orderSubModel.getGoodsNm());
                                stagingRequest.setPrice(tblGoodsPaywayModel.getGoodsPrice());  // 分期总价
                                stagingRequest.setColor(orderSubModel.getGoodsColor());
                                stagingRequest.setAmount("1");
                                stagingRequest.setSumAmt(orderSubModel.getTotalMoney());
                                stagingRequest.setSuborderid(orderSubModel.getOrderId());
                                stagingRequest.setFirstPayment(BigDecimal.valueOf(0));
                                stagingRequest.setBills(orderSubModel.getStagesNum().toString());
                                stagingRequest.setPerPeriodAmt(orderSubModel.getIncTakePrice());
                                stagingRequest.setSupplierCode(orderSubModel.getVendorId());
                                List<TblVendorRatioModel> vendorRatio = queryVendorRatio(orderSubModel.getStagesNum().toString(),
                                        orderSubModel.getVendorId());
                                String fixedFeeHTFlag = "";
                                BigDecimal fixedAmtFee = null;
                                BigDecimal feeRatio1 = null;
                                BigDecimal ratio1Precent = null;
                                BigDecimal feeRatio2 = null;
                                BigDecimal ratio2Precent = null;
                                Integer feeRatio2Bill = null;
                                BigDecimal feeRatio3 = null;
                                BigDecimal ratio3Precent = null;
                                Integer feeRatio3Bill = null;
                                Integer reducerateFrom = null;
                                Integer reducerateTo = null;
                                Integer reducerate = null;
                                String HTFlag = "";
                                String virtual_vendor_id = "";
                                BigDecimal HTAnt = null;
                                if (vendorRatio.size() > 0) {
                                    TblVendorRatioModel tblVendorRatioModel = (TblVendorRatioModel) vendorRatio.get(0);
                                    fixedFeeHTFlag = tblVendorRatioModel.getFixedfeehtFlag();
                                    stagingRequest.setFixedFeeHTFlag(fixedFeeHTFlag);
                                    fixedAmtFee = tblVendorRatioModel.getFixedamtFee();
                                    stagingRequest.setFixedAmtFee(fixedAmtFee == null ? BigDecimal.valueOf(0)
                                            : fixedAmtFee.setScale(2, BigDecimal.ROUND_DOWN));
                                    feeRatio1 = tblVendorRatioModel.getFeeratio1();
                                    stagingRequest.setFeeRatio1(feeRatio1 == null ? BigDecimal.valueOf(0)
                                            : feeRatio1.setScale(5, BigDecimal.ROUND_DOWN));
                                    ratio1Precent = tblVendorRatioModel.getRatio1Precent();
                                    stagingRequest.setRatio1Precent(ratio1Precent == null
                                            ? BigDecimal.valueOf(0)
                                            : ratio1Precent.setScale(2, BigDecimal.ROUND_DOWN));
                                    feeRatio2 = tblVendorRatioModel.getFeeratio2();
                                    stagingRequest.setFeeRatio2(feeRatio2 == null ? BigDecimal.valueOf(0)
                                            : feeRatio2.setScale(5, BigDecimal.ROUND_DOWN));
                                    ratio2Precent = tblVendorRatioModel.getRatio2Precent();
                                    stagingRequest.setRatio2Precent(ratio2Precent == null
                                            ? BigDecimal.valueOf(0)
                                            : ratio2Precent.setScale(2, BigDecimal.ROUND_DOWN));
                                    feeRatio2Bill = tblVendorRatioModel.getFeeratio2Bill();
                                    stagingRequest.setFeeRatio2Bill(feeRatio2Bill == null ? 0 : feeRatio2Bill);
                                    feeRatio3 = tblVendorRatioModel.getFeeratio3();
                                    stagingRequest.setFeeRatio3(feeRatio3 == null ? BigDecimal.valueOf(0)
                                            : feeRatio3.setScale(5, BigDecimal.ROUND_DOWN));
                                    ratio3Precent = tblVendorRatioModel.getRatio3Precent();
                                    stagingRequest.setRatio3Precent(ratio3Precent == null
                                            ? BigDecimal.valueOf(0)
                                            : ratio3Precent.setScale(2, BigDecimal.ROUND_DOWN));
                                    feeRatio3Bill = tblVendorRatioModel.getFeeratio3Bill();
                                    stagingRequest.setFeeRatio3Bill(feeRatio3Bill == null ? 0 : feeRatio3Bill);
                                    reducerateFrom = tblVendorRatioModel.getReducerateFrom();
                                    stagingRequest.setReducerateFrom(reducerateFrom == null ? 0 : reducerateFrom);
                                    reducerateTo = tblVendorRatioModel.getReducerateTo();
                                    stagingRequest.setReducerateTo(reducerateTo == null ? 0 : reducerateTo);
                                    reducerate = tblVendorRatioModel.getReducerate();
                                    stagingRequest.setReduceHandingFee(reducerate == null ? 0 : reducerate);
                                    HTFlag = tblVendorRatioModel.getHtflag();
                                    stagingRequest.setHtFlag(HTFlag == null ? "" : HTFlag);
                                    // 如果“首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，默认送现金金额，如果小于等于现金金额,就送首尾付本金值--大机补充需求

                                    String htcapital = "";
                                    BigDecimal TotalMoney = orderSubModel.getTotalMoney();
                                    HTAnt = tblVendorRatioModel.getHtant();
                                    if (HTAnt == null || TotalMoney == null) {
                                        htcapital = HTAnt == null ? ""
                                                : String.valueOf(HTAnt.setScale(2, BigDecimal.ROUND_DOWN));
                                    } else {
                                        int compareResult = HTAnt.compareTo(TotalMoney);
                                        if (compareResult > 0) {//// “首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，送现金金额
                                            htcapital = String
                                                    .valueOf(TotalMoney.setScale(2, BigDecimal.ROUND_DOWN));
                                        } else {// 如果小于等于现金金额,就送首尾付本金值
                                            htcapital = String.valueOf(HTAnt.setScale(2, BigDecimal.ROUND_DOWN));
                                        }
                                    }
                                    if(!"".equals(htcapital)) {
                                        BigDecimal bdHtcapital = new BigDecimal(htcapital);
                                        stagingRequest.setHtCapital(bdHtcapital);
                                    }
                                    virtual_vendor_id = tblVendorRatioModel.getVirtualVendorId();
                                    stagingRequest.setVirtualStore(virtual_vendor_id == null ? "" : virtual_vendor_id);
                                }

                                stagingRequest.setSupplierDesc("");
                                stagingRequest.setRecommendCardnbr("");
                                stagingRequest.setRecommendname("");
                                stagingRequest.setRecommendCerttype("");
                                stagingRequest.setRecommendid("");
                                stagingRequest.setPrevCaseId("");
                                stagingRequest.setCustName(orderMainModel.getContNm());
                                stagingRequest.setIncomingTel("");
                                stagingRequest.setPresentName(goods_present);
                                stagingRequest.setOrdermemo("正常订单");
                                stagingRequest.setForceTransfer("");
                                stagingRequest.setSupplierName(orderSubModel.getVendorSnm());
                                stagingRequest.setMemo("");
                                stagingRequest.setReceiveName(orderMainModel.getCsgName());
                                stagingRequest.setMerchantCode("");

                                String ACCEPTAMT = orderSubModel.getTotalMoney().toString();// 申请分期金额
                                if(!"".equals(ACCEPTAMT)) {
                                    BigDecimal bdAcceptAmt = new BigDecimal(ACCEPTAMT);
                                    stagingRequest.setAcceptAmt(bdAcceptAmt);
                                }
                                String FAVORABLETYPE = "";// 优惠类型
                                String DEDUCTAMT = "";// 抵扣金额
                                if (orderSubModel.getVoucherNo() != null && !"".equals(orderSubModel.getVoucherNo())) {
                                    FAVORABLETYPE = "01";
                                    DEDUCTAMT = orderSubModel.getVoucherPrice().toString();
                                }
                                if (orderSubModel.getBonusTotalvalue() != null
                                        && orderSubModel.getBonusTotalvalue().longValue() != 0) {
                                    FAVORABLETYPE = "02";
                                    DEDUCTAMT = orderSubModel.getUitdrtamt().toString();
                                }
                                if ((orderSubModel.getVoucherNo() != null && !"".equals(orderSubModel.getVoucherNo()))
                                        && (orderSubModel.getBonusTotalvalue() != null
                                        && orderSubModel.getBonusTotalvalue().longValue() != 0)) {
                                    FAVORABLETYPE = "03";
                                    DEDUCTAMT = orderSubModel.getVoucherPrice().add(orderSubModel.getUitdrtamt()).toString();
                                }
                                if ((orderSubModel.getVoucherNo() == null || "".equals(orderSubModel.getVoucherNo()))
                                        && (orderSubModel.getBonusTotalvalue() == null
                                        || orderSubModel.getBonusTotalvalue().longValue() == 0)) {
                                    FAVORABLETYPE = "00";
                                }
                                stagingRequest.setFavorableType(FAVORABLETYPE);
                                if(!DEDUCTAMT.equals("")) {
                                    BigDecimal bdDeductamt = new BigDecimal(DEDUCTAMT);
                                    stagingRequest.setDeductAmt(bdDeductamt);
                                }
//                                    gateWayEnvolopeVo.setReceiverIdFlag(String.valueOf(isPractiseRun));// 方在VO中，以便后续判断接收方标识 TODO
                                TblOrderExtend1Model tempTblOrderExtend1 = null;
                                try {
                                    log.info("保存TblOrderExtend1");
                                    tempTblOrderExtend1 = new TblOrderExtend1Model();
                                    tempTblOrderExtend1.setOrderId(orderSubModel.getOrderId());
                                    tempTblOrderExtend1.setExtend1("1");
                                    tempTblOrderExtend1.setExtend2(DateHelper.getCurrentTime());// 记录向bps发起请求的时间
                                    tblOrderExtend1Dao.insert(tempTblOrderExtend1);// 保存TblOrderExtend1
                                } catch (Exception e) {
                                    log.info("保存TblOrderExtend1失败");
                                    log.error("exception", e);
                                    orderDealDto.setErrorCode("9999");
                                    orderDealDto.setErrorDesc(e.getMessage());
                                    return orderDealDto;
                                }
                                map.put("tblOrderExtend1", tempTblOrderExtend1);
                                log.info("开始调用发送bps接口:" + orderSubModel.getOrderId());
                                StagingRequestResult stagingRequestResult = (StagingRequestResult) stagingRequestService
                                        .getStagingRequest(stagingRequest);
                                log.info("收到结果:" + stagingRequestResult);
                                map.put("returnGateWayEnvolopeVo", stagingRequestResult);
                            } else {// 如果发送过给bps
                                log.info("errorcode" + errorcode);
                                log.info("approveresult" + approveresult);
                                StagingRequestResult stagingRequestResult = new StagingRequestResult();
                                stagingRequestResult.setErrorCode(errorcode);
                                stagingRequestResult.setApproveResult(approveresult);
                                map.put("returnGateWayEnvolopeVo", stagingRequestResult);
                                map.put("isAlreadySendBps", "1");// 空和0:没发送过,1:发送过给bps
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {// 如果连bps报异常，订单状态不做修改，等待状态回查
            log.info("调用bps接口异常");
            log.error("exception", Throwables.getStackTraceAsString(e));
        }

        try {
            String messageFlag = "";// 发送短信平台模板标志
            orderMainModel = orderMainDao.findById(orderMainModel.getOrdermainId());
            messageFlag = returnMegFlag(orderMainModel);  //TODO shang20160630 一期对象外
            orderDealDto.setPhone(orderMainModel.getContMobPhone());// 手机号码，发短信用
            orderDealDto.setMessageFlag(messageFlag);// 手机号码，发短信用
            List orders = new ArrayList();
            if ("YG".equals(orderType)) {// 一期
                log.info("一期");
                orders = dealYGOrder(payOrderInfoDto, orderMainModel);
//                DealO2OOrderAfterPaySucc(orders);// 如果包含支付成功的O2O订单，则推送到O2O系统  //TODO shang20160630 一期对象外
                getLGReturnDoc(orderDealDto, orders);// 获取返回报文
                getIsSucessDoc(orderDealDto, orders);
                orderDealDto.setOrderType("YG");
            } else if ("FQ".equals(orderType)) {// 分期
                log.info("分期");
                orders = dealFQOrder(payOrderInfoDto, orderMainModel, returnOrders);
                //DealO2OOrderAfterPaySucc(orders);// 如果包含支付成功的O2O订单，则推送到O2O系统  //TODO shang20160630  一期对象外
                getFQReturnDoc(orderDealDto, orders);// 获取返回报文
                getFQIsSucessDoc(orderDealDto, orders);
                orderDealDto.setOrderType("FQ");
            } else if ("JF".equals(orderType)) {// 积分      //TODO shang20160630  一期对象外
                log.info("积分");
                orders = dealJFOrder(payOrderInfoDto,orderMainModel, orderDealDto);
//                insertJFOrderDodetails(s, orders);// 插入积分的订单处理明细
                getJFReturnDoc(orderDealDto, orderMainModel, orders);// 获取返回报文
                getIsSucessDoc(orderDealDto, orders);
                orderDealDto.setOrderType("JF");
            }
            log.info("更新成功");
        } catch (Exception e) {
            log.info("一期/分期/积分失败");
            log.error("exception", e);
            orderDealDto.setErrorCode("9999");
            orderDealDto.setErrorDesc(e.getMessage());
        }
        // 发起ops分期订单申请
        return orderDealDto;
    }

    /**
     * 判断此订单是否收到重复的支付网关结果请求 0或空:第一次收到支付网关结果 1:重复收到支付网关结果
     *
     * @param ordermain_id
     */
    private String jugOverdeal(String ordermain_id) throws Exception {
        String locked_flag = "0";
        try {
            OrderMainModel orderMainModel = orderMainDao.findById(ordermain_id);
            locked_flag = orderMainModel.getLockedFlag(); // 0或空:第一次收到支付网关结果 1:重复收到支付网关结果
            if ("1".equals(locked_flag)) {// 如果是重复收到支付网关结果
                return "1";
            }
        } catch (Exception e) {
            log.info("查询locked_flag订单信息异常");
            log.error("exception", e);
        }
        int i = 0;// 更新条数
        if ("0".equals(locked_flag)) {// 如果第一次收到支付网关结果,将locked_flag改为1
            // 如果第一次收到支付网关结果,将locked_flag改为1
            try {
                i = orderMainDao.updateLockedFlag(ordermain_id);
            } catch (Exception e) {
                log.error("exception", e);
                log.info("更新locked_flag订单信息异常");
            }
            if (i > 0) {// 如果修改有大于0条
                return "0";
            } else {
                return "1";
            }
        }
        return "0";
    }

    /**
     * 获取大订单对象
     *
     * @param ordermain_id
     * @return
     * @throws Exception
     */
    private OrderMainModel toOrderMain(String ordermain_id) throws Exception {
        OrderMainModel orderMainModel = orderMainDao.findById(ordermain_id);
        return orderMainModel;

    }

    /**
     * 判断返回报文的类型 FQ：广发分期 YG：广发一期 JF：积分支付
     *
     * @param orderMainModel
     * @return
     * @throws Exception
     */
    private String judgeType(OrderMainModel orderMainModel) throws Exception {
        if (orderMainModel == null) {
            throw new Exception("没有此主订单信息");
        }
        return orderMainModel.getOrdertypeId();

    }

    /**
     * 根据小订单号查询TblOrderExtend1
     *
     * @param orderId
     * @return
     * @throws Exception
     */
    private TblOrderExtend1Model queryTBLORDEREXTEND1(String orderId) throws Exception {
        log.info("into queryTBLORDEREXTEND1");
        log.info("orderId:" + orderId);
        if (orderId != null) {// 如果是小订单
            TblOrderExtend1Model tblOrderExtend1Model = tblOrderExtend1Dao.findByOrderId(orderId);
            return tblOrderExtend1Model;
        }
        return null;
    }

    /**
     * 现金部分为0，则不调用BPS的接口，直接处理为支付成功
     */
    private StagingRequestResult returnBPSVO() {
        StagingRequestResult stagingRequestResult = new StagingRequestResult();
        stagingRequestResult.setErrorCode("0000");// Bps返回的错误码
        stagingRequestResult.setApproveResult("0010");// Bps返回的返回码0000-全额,0010-逐期,0100-拒绝,0200-转人工,0210-异常转人工
        stagingRequestResult.setFollowDir("");// 后续流转方向0-不流转,1-流转
        stagingRequestResult.setCaseId("");// BPS工单号
        stagingRequestResult.setSpecialCust("");// 是否黑灰名单,0-黑名单,1-灰名单,2-其他
        stagingRequestResult.setRejectcode("");// 拒绝代码
        stagingRequestResult.setAprtcode("");// 逐期代码
        stagingRequestResult.setOrdernbr("00000000000");// 核心订单号、银行订单号,默认11个0
        return stagingRequestResult;
    }

    /**
     *
     */
    private List<TblVendorRatioModel> queryVendorRatio(String stages_num, String vendor_id) throws Exception {
        Response<List<TblVendorRatioModel>> list = userInfoService.findVendorRatioInfo(vendor_id, stages_num);
        return list.getResult();
    }

    /**
     * @param orderMainModel
     * @return
     */
    private String returnMegFlag(OrderMainModel orderMainModel) {
        //TODO DAO 一期对象外
        return "0";
    }

    /**
     * 处理广发一次性订单
     *
     * @param payOrderInfoDto
     * @param orderMainModel
     */
    private List dealYGOrder(PayOrderInfoDto payOrderInfoDto, OrderMainModel orderMainModel) throws Exception {
        String payAccountNo = payOrderInfoDto.getPayAccountNo();// 支付卡号
        log.info("payAccountNo:" + payAccountNo);
        String cardType = CardUtil.getCardType(payAccountNo);// 借记卡信用卡类型 C：信用卡 Y：借记卡
        log.info("cardType:" + cardType);
        List<OrderSubModel> orders = new ArrayList();
        List<PayOrderSubDto> list = payOrderInfoDto.getPayOrderSubDtoList();
        ;// 获取小订单列表
        PayReturnCode payReturnCode = new PayReturnCode();
        // 判断是否重复支付标志,如果返回错误码PP031001，商城不会改变当前订单的状态，
        // 同时判断此订单当前状态，如果支付成功，提示支付成功，如果支付失败，提示支付失败，如果是待付款或订单状态未明，提示订单状态未明(等待状态回查任务会查到真正的订单状态)
        String isDuplicateFlag = "0";// 0:非重复支付 1:重复支付
        if (list == null || list.size() < 1) {
            log.info("没有订单");
            throw new Exception("没有订单");
        }
        Iterator iter = list.iterator();
        boolean orderMainFlag = true;

        List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();  //事物用，插入子订单表
        List<String> goodsIdList = new ArrayList<String>();                         //事物用，回滚商品库存
        List<OrderSubModel> dealPointPoolList = new ArrayList<OrderSubModel>(); //事物用，回滚积分池
        List<OrderCheckModel> orderCheckModelList = new ArrayList<OrderCheckModel>(); //事物用，优惠券对账文件表
        while (iter.hasNext()) {
            PayOrderSubDto node = (PayOrderSubDto) iter.next();
            OrderCheckModel orderCheck = null;
            OrderSubModel orderSubModel = orderSubDao.findById(node.getOrder_id());
            orderSubModel.setOrder_succ_time(DateHelper.string2Date(payOrderInfoDto.getPayTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
            log.info("小订单号:" + orderSubModel.getOrderId());
            String nowCur_status_id = null;// 订单当前状态
            String returnCode = node.getReturnCode(); // 返回码
            if (payAccountNo != null && !"".equals(payAccountNo.trim())) {// 如果payAccountNo不为空
                orderSubModel.setCardno(payAccountNo);
            }
            if (cardType != null && !"".equals(cardType.trim())) {// 如果payAccountNo不为空
                orderSubModel.setCardtype(cardType);
            }
            log.info("返回码:" + returnCode);

            String ischeck = "";
            String ispoint = "";
            if (PayReturnCode.isSucess(returnCode)) {// 成功支付
                log.info("支付成功");
                orderSubModel.setCurStatusId("0308");// 当前状态代码
                orderSubModel.setCurStatusNm("支付成功");// 当前状态名称
            } else if (PayReturnCode.isStateNoSure(returnCode)) {// 状态未明
                log.info("状态未明");
                orderSubModel.setCurStatusId("0316");// 当前状态代码
                orderSubModel.setCurStatusNm("状态未明");// 当前状态名称
                orderMainFlag = false;
            } else if (PayReturnCode.isDuplicate(returnCode)) {// 重复支付
                log.info("重复支付");
                isDuplicateFlag = "1";
                nowCur_status_id = orderSubModel.getCurStatusId();// 获取订单当前状态
                log.info("nowCur_status_id:" + nowCur_status_id);
            } else {
                log.info("支付失败");
                if (orderSubModel.getErrorCode() == null || "".equals(orderSubModel.getErrorCode().trim())) {// 如果没成功返回过支付结果
                    log.info("没成功返回过支付结果，做相关回滚动作");
                    goodsIdList.add(orderSubModel.getGoodsId());     //事物用 回滚库存
                    if (orderSubModel.getBonusTotalvalue() != null && orderSubModel.getBonusTotalvalue().longValue() != 0) {
                        dealPointPoolList.add(orderSubModel);  //事物用 回切积分池.
                    }
                }
                orderSubModel.setCurStatusId("0307");// 当前状态代码
                orderSubModel.setCurStatusNm("支付失败");// 当前状态名称
                if (orderSubModel.getVoucherNo() != null && !"".equals(orderSubModel.getVoucherNo())) {
                    ischeck = "0";
                    orderCheck = getObject(node.getOrder_id(), "0307", "支付失败", ischeck, ispoint);// 获取优惠券对账表的对象
                }
                orderMainFlag = false;
            }
            orderSubModel.setErrorCode(returnCode);
            orderSubModelList.add(orderSubModel);   //事物用
            if (orderCheck != null) {
                orderCheckModelList.add(orderCheck);// 存储优惠券对账表信息
            }
            orders.add(orderSubModel);
        }
        if (!"1".equals(isDuplicateFlag)) {// 如果非重复支付
            if (orderMainFlag == true) {// 大订单成功
                orderMainModel.setCurStatusId("0308");
                orderMainModel.setCurStatusNm("支付成功");
            } else {// 大订单异常
                orderMainModel.setCurStatusId("0307");
                orderMainModel.setCurStatusNm("支付失败");
            }
        }
        List<OrderDoDetailModel> orderDoDetailModelList = insertYGOrderDodetails(orders); //订单历史明细
        orderTradeManager.processMailOrder(orderSubModelList, goodsIdList, dealPointPoolList, orderCheckModelList, orderMainModel, orderDoDetailModelList);
        return orders;
    }

    /**
     * 处理广发分期订单
     *
     * @param payOrderInfoDto
     * @param orderMainModel
     * @param returnOrders
     */
    private List dealFQOrder(PayOrderInfoDto payOrderInfoDto, OrderMainModel orderMainModel, List returnOrders)
            throws Exception {
        List orders = new ArrayList();
        String payAccountNo = payOrderInfoDto.getPayAccountNo();// 支付卡号
        String cardType = CardUtil.getCardType(payAccountNo);// 借记卡信用卡类型 C：信用卡
        // Y：借记卡
        if (returnOrders == null || returnOrders.size() < 1) {
            log.info("没有订单");
            throw new Exception("没有订单");
        }
        boolean orderMainFlag = true;
        List<OrderCheckModel> orderCheckList2 = new ArrayList<OrderCheckModel>();       //事物用，积分正交易
        List<OrderCheckModel> orderCheckList = new ArrayList<OrderCheckModel>();       //事物用，优惠券
        List<String> goodsIdList = new ArrayList<String>();                         //事物用，回滚商品库存
        List<OrderSubModel> dealPointPoolList = new ArrayList<OrderSubModel>();         //事物用，回滚积分池
        List<TblOrderExtend1Model> tblOrderExtend1ModelIns = new ArrayList<TblOrderExtend1Model>();  //事物用
        List<TblOrderExtend1Model> tblOrderExtend1Modelupd = new ArrayList<TblOrderExtend1Model>();  //事物用
        List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();  //事物用，插入子订单表
        for (int i = 0; i < returnOrders.size(); i++) {
            Map map = (Map) returnOrders.get(i);
            OrderCheckModel orderCheck = null;
            OrderCheckModel orderCheck2 = null;// 支付成功 插入正交易
            OrderSubModel orderInf1 = (OrderSubModel) map.get("orderInf");
            OrderSubModel orderSubModel = orderSubDao.findById(orderInf1.getOrderId());
            OrderSubDto orderInf = new OrderSubDto();
            BeanUtils.copyProperties(orderSubModel, orderInf);
            // 判断是否是荷兰式拍卖订单 act_type=3
            String act_type = orderInf.getActType();
            String errorCode = null;
            String approveResult = null;
            String followdir = null;
            String caseid = null;
            String specialcust = null;
            String rejectcode = null;
            String aprtcode = null;
            String ordernbr = null;
            PayOrderSubDto node = (PayOrderSubDto) map.get("node");
            log.info("小订单号:" + orderInf.getOrderId());
            String returnCode = node.getReturnCode();// 返回码
            orderInf.setOrder_succ_time(DateHelper.string2Date(payOrderInfoDto.getPayTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
            orderInf.setCardno(payAccountNo);
            orderInf.setCardtype(cardType);
            log.info("返回码:" + returnCode);
            // Null或’’:电子支付平台未验证 1:电子支付平台已验证
            StagingRequestResult returnGateWayEnvolopeVo = null;
            String isAlreadySendBps = (String) map.get("isAlreadySendBps");// 空和0:没发送过
            // 1:发送过给bps
            if ("1".equals(isAlreadySendBps)) {// 如果发送过给bps 只返回当前订单对象，不修改订单状态
                orders.add(orderInf);
                orderInf.setBpsErrorcode("");// 填一个不会有的错误码
                continue;
            }
            Object object = map.get("returnGateWayEnvolopeVo");

            if (object != null) {
                returnGateWayEnvolopeVo = (StagingRequestResult) object;
                errorCode = returnGateWayEnvolopeVo.getErrorCode().substring(0, 4);
                approveResult = returnGateWayEnvolopeVo.getApproveResult();
                followdir = returnGateWayEnvolopeVo.getFollowDir();
                caseid = returnGateWayEnvolopeVo.getCaseId();
                specialcust = returnGateWayEnvolopeVo.getSpecialCust();
                rejectcode = returnGateWayEnvolopeVo.getRejectcode();
                aprtcode = returnGateWayEnvolopeVo.getAprtcode();
                ordernbr = returnGateWayEnvolopeVo.getOrdernbr();
            }

            log.info("errorCode:" + errorCode);
            log.info("approveResult:" + approveResult);
            log.info("BpsReturnCode.isBp0005Sucess(errorCode, approveResult):"
                    + BpsReturnCode.isBp0005Sucess(errorCode, approveResult));
            log.info("BpsReturnCode.isBp0005Dealing(errorCode, approveResult):"
                    + BpsReturnCode.isBp0005Dealing(errorCode, approveResult));
            orderInf.setBpsErrorcode(errorCode);// bps错误码
            orderInf.setApproveResult(approveResult);// bps返回码
            String ischeck = "";
            String ispoint = "";
            if (orderInf.getVoucherNo() != null && !"".equals(orderInf.getVoucherNo())) {// 优惠券
                ischeck = "0";
            }
            if (orderInf.getBonusTotalvalue() != null && orderInf.getBonusTotalvalue().longValue() != 0) {// 积分
                ispoint = "0";
            }
            if (PayReturnCode.isSucess(returnCode)) {       // 支付成功
                // 支付成功，cash auth type 更新标识
                orderInf.setCashAuthType("1");// 分期订单电子支付是否已经验证标识
                // Null或’’:电子支付平台未验证 1:电子支付平台已验证
                // 插入积分正交易
                if (!"".equals(ispoint)) {
                    orderCheck2 = getObject(node.getOrder_id(), "0308", "支付成功", "", ispoint);
                    orderCheck2.setDoDate(DateHelper.date2string(orderInf.getCreateTime(), "yyyyMMdd"));
                    orderCheck2.setDoTime(DateHelper.date2string(orderInf.getCreateTime(), "HHmmss"));
                }
                if (null != object && null != errorCode) {
                    // bps 返回成功
                    if (null != errorCode && null != approveResult
                            && BpsReturnCode.isBp0005Sucess(errorCode, approveResult)) {
                        log.info(orderInf.getOrderId() + "分期订单支付成功");
                        orderInf.setCurStatusId("0308");// 当前状态代码
                        orderInf.setCurStatusNm("支付成功");// 当前状态名称
                        if (!"".equals(ischeck)) {// 优惠券正交易
                            orderCheck = getObject(node.getOrder_id(), "0308", "支付成功", ischeck, "");// 获取优惠券对账表的对象
                            orderCheck.setDoDate(DateHelper.date2string(orderInf.getCreateTime(), "yyyyMMdd"));
                            orderCheck.setDoTime(DateHelper.date2string(orderInf.getCreateTime(), "HHmmss"));
                            orderCheckList.add(orderCheck);     //事物用
                        }
                        String custcartid = orderInf.getCustCartId();// 购物车id
                        if (custcartid != null && !"3".equals(act_type)) {
                            dealCustCart(custcartid);// 处理购物车          //TODO DAO
                        }
                        // 荷兰式拍卖订单支付成功之后更新拍卖记录PAY_FLAG
                        if ("3".equals(act_type)) {
                            updatePayFlag(orderInf.getCustCartId().toString());  //TODO DAO
                        }
                    }
                    // bps 处理中
                    else if (null != errorCode && null != approveResult
                            && BpsReturnCode.isBp0005Dealing(errorCode, approveResult)) {
                        log.info("分期订单处理中");
                        orderInf.setCurStatusId("0305");// 当前状态代码
                        orderInf.setCurStatusNm("处理中");// 当前状态名称
                        String custcartid = orderInf.getCustCartId();// 购物车id
                        if (custcartid != null && !"3".equals(act_type)) {
                            dealCustCart(custcartid);// 处理购物车      //TODO shang20160630  一期对象外
                        }
                        // 荷兰式拍卖订单支付成功之后更新拍卖记录PAY_FLAG
                        if ("3".equals(act_type)) {         //TODO shang20160630    一期对象外
                            updatePayFlag(orderInf.getCustCartId().toString());
                        }
                    }
                    // bps 状态未明
                    else if (BpsReturnCode.isBp0005NoSure(errorCode, approveResult)) {
                        log.info("分期订单状态未明");
                        orderInf.setCurStatusId("0316");// 当前状态代码
                        orderInf.setCurStatusNm("状态未明");// 当前状态名称
                    } else if (PayReturnCode.isStateNoSure(returnCode)) {// 电子支付返回状态未明,订单状态置为“状态未明”
                        log.info("电子支付返回状态码：" + returnCode + " 订单状态置为状态未明");
                        orderInf.setCurStatusId("0316");// 当前状态代码
                        orderInf.setCurStatusNm("状态未明");// 当前状态名称
                    } else {
                        log.info("分期订单支付失败");
                        if (orderInf.getErrorCode() == null || "".equals(orderInf.getErrorCode().trim())) {// 如果没成功返回过支付结果
                            log.info("没成功返回过支付结果");
                            if ("3".equals(act_type)) {// 荷兰式拍卖订单
                                // 判断是否在5分钟内，是的话回滚荷兰式购物车，否则回滚活动和库存
                                dealAuctionRecord(orderInf.getCustCartId().toString(), orderInf.getOrderId(),
                                        orderInf.getGoodsColor());      //TODO shang20160630 一期对象外
                            } else {
                                // 团购不回滚活动 --- modified by zwz at 20141212
                                //dealGoods(orderInf.getOrderId());// 回滚库存     //TODO shang20160630 一期对象外
                                goodsIdList.add(orderInf.getGoodsId());
                            }

                            if (orderInf.getBonusTotalvalue() != null
                                    && orderInf.getBonusTotalvalue().longValue() != 0) {
//                                dealPointPool(orderInf.getBonusTotalvalue(), orderInf.getCreateTime().toString());// 回切积分池     //TODO shang20160630 一期对象外
                                dealPointPoolList.add(orderInf);
                            }
                        }
                        orderInf.setCurStatusId("0307");// 当前状态代码
                        orderInf.setCurStatusNm("支付失败");// 当前状态名称
                        orderMainFlag = false;
                        String curDate = DateHelper.getyyyyMMdd();
                        String curTime = DateHelper.getHHmmss();
                        String jfRefundSerialno = "";// 主动退积分流水
                        if (!"".equals(ispoint)) {
                            jfRefundSerialno = idGenarator.jfRefundSerialNo();
                            log.info("主动退积分流水jfRefundSerialno:" + jfRefundSerialno);
                        }
                        if (!"".equals(ischeck) || !"".equals(ispoint)) {// 失败，插入优惠券、积分
                            // 负交易
                            // 电子支付成功，bps失败，负交易用当前时间（这个涉及到积分对账bms202 ）
                            orderCheck = getObject(node.getOrder_id(), "0307", "支付失败", ischeck, ispoint);// 获取优惠券对账表的对象
                            orderCheck.setDoDate(curDate);
                            orderCheck.setDoTime(curTime);
                            orderCheck.setJfRefundSerialno(jfRefundSerialno);
                        }
                        // 存在积分需要发起撤销积分
                        if (!"".equals(ispoint)) {
                            try {
                                sendNSCT009(orderInf, curDate, curTime, jfRefundSerialno);
                            } catch (Exception se) {
                                log.error("商城前端 支付成功，bps失败:" + se.getMessage());
                            }
                        }
                    }
                    // 支付成功，bps返回不为空，更新或插入扩展表
                    TblOrderExtend1Model tblOrderExtend1Object = (TblOrderExtend1Model) map.get("tblOrderExtend1");
                    if (null == tblOrderExtend1Object) {// 如果为空 插入
                        TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
                        tblOrderExtend1.setOrderId(orderInf.getOrderId());
                        tblOrderExtend1.setErrorcode(errorCode);
                        tblOrderExtend1.setApproveresult(approveResult);
                        tblOrderExtend1.setFollowdir(followdir);
                        tblOrderExtend1.setCaseid(caseid);
                        tblOrderExtend1.setSpecialcust(specialcust);
                        tblOrderExtend1.setRejectcode(rejectcode);
                        tblOrderExtend1.setAprtcode(aprtcode);
                        tblOrderExtend1.setOrdernbr(ordernbr);
//                        tblOrderExtend1Dao.insert(tblOrderExtend1);
                        tblOrderExtend1ModelIns.add(tblOrderExtend1);  //事物用

                    } else {// 如果不为空 update
                        TblOrderExtend1Model tblOrderExtend1Model = new TblOrderExtend1Model();
                        tblOrderExtend1Model.setOrderExtend1Id(tblOrderExtend1Object.getOrderExtend1Id());
                        tblOrderExtend1Model.setErrorcode(errorCode);
                        tblOrderExtend1Model.setApproveresult(approveResult);
                        tblOrderExtend1Model.setFollowdir(followdir);
                        tblOrderExtend1Model.setCaseid(caseid);
                        tblOrderExtend1Model.setSpecialcust(specialcust);
                        tblOrderExtend1Model.setRejectcode(rejectcode);
                        tblOrderExtend1Model.setAprtcode(aprtcode);
                        tblOrderExtend1Model.setOrdernbr(ordernbr);
                        tblOrderExtend1Model.setOrderId(orderInf.getOrderId());
                        tblOrderExtend1Model.setExtend3("");
//                        tblOrderExtend1Dao.update(tblOrderExtend1Model);
                        tblOrderExtend1Modelupd.add(tblOrderExtend1Model);  //事物用

                    }
                } else {// bps调用异常returnGateWayEnvolopeVo==null,返回状态未明
                    log.info("bps调用异常:" + orderInf.getOrderId() + "分期订单状态未明");
                    orderInf.setCurStatusId("0316");// 当前状态代码
                    orderInf.setCurStatusNm("状态未明");// 当前状态名称
                }
            } else if (PayReturnCode.isStateNoSure(returnCode)) {// 电子支付状态未明
                log.info("支付网关返回状态未明:" + orderInf.getOrderId() + "分期订单状态未明");
                orderInf.setCurStatusId("0316");
                orderInf.setCurStatusNm("状态未明");
            } else {// 支付返回验证失败
                log.info(orderInf.getOrderId() + "分期订单支付失败");
                if (orderInf.getErrorCode() == null || "".equals(orderInf.getErrorCode().trim())) {// 如果没成功返回过支付结果
                    log.info("没成功返回过支付结果");
                    if ("3".equals(act_type)) {// 荷兰式拍卖订单       //TODO shang20160630 一期对象外
                        // 判断是否在5分钟内，是的话回滚荷兰式购物车，否则回滚活动和库存
                        dealAuctionRecord(orderInf.getCustCartId().toString(), orderInf.getOrderId(),
                                orderInf.getGoodsId());
                    } else {
//                        dealGoods(orderInf.getOrderId());// 回滚库存    //TODO shang20160630 一期对象外
                        goodsIdList.add(orderInf.getGoodsId());
                    }
                    if (orderInf.getBonusTotalvalue() != null && orderInf.getBonusTotalvalue().longValue() != 0) {
//                        dealPointPool(orderInf.getBonusTotalvalue(), orderInf.getCreateTime().toString());// 回切积分池       //TODO shang20160630 一期对象外
                        dealPointPoolList.add(orderInf);
                    }
                }
                orderInf.setCurStatusId("0307");// 当前状态代码
                orderInf.setCurStatusNm("支付失败");// 当前状态名称
                orderMainFlag = false;
                if (!"".equals(ischeck)) {// 支付失败，插入优惠券负交易，不插积分负交易
                    orderCheck = getObject(node.getOrder_id(), "0307", "支付失败", ischeck, "");
                    orderCheck.setDoDate(DateHelper.date2string(orderInf.getCreateTime(), "yyyyMMdd"));
                    orderCheck.setDoTime(DateHelper.date2string(orderInf.getCreateTime(), "HHmmss"));
                }
            }
            orderInf.setErrorCode(returnCode);
            orderSubModelList.add(orderInf);
            orders.add(orderInf);
            if (null != orderCheck2) {// 支付成功，查积分正交易
                orderCheckList2.add(orderCheck2);  //事物用
            }
            if (orderCheck != null) {// 如果使用了优惠券ID
                orderCheckList.add(orderCheck);     //事物用
            }
        }
        if (orderMainFlag == true) {// 大订单成功
            orderMainModel.setCurStatusId("0308");
            orderMainModel.setCurStatusNm("支付成功");
        } else {// 大订单异常
            orderMainModel.setCurStatusId("0307");
            orderMainModel.setCurStatusNm("支付失败");
        }
        orderMainDao.update(orderMainModel);
        List<OrderDoDetailModel> orderDoDetailModelList = insertFQOrderDodetails(orders); //订单历史明细
        orderTradeManager.processInstallment(orderCheckList2, orderCheckList, goodsIdList, dealPointPoolList, tblOrderExtend1ModelIns, tblOrderExtend1Modelupd, orderMainModel, orderSubModelList, orderDoDetailModelList);
        return orders;
    }

    /**
     * 处理积分订单
     *
     * @param payOrderInfoDto
     * @param orderMainModel
     * @param orderDealDto
     */
    private List dealJFOrder(PayOrderInfoDto payOrderInfoDto, OrderMainModel orderMainModel,OrderDealDto orderDealDto)
            throws Exception {
//        List<PayOrderSubDto> list = payOrderInfoDto.getPayOrderSubDtoList();// 获取大订单
//        if (list == null || list.size() < 1) {
//            log.info("没有大订单");
//            throw new Exception("没有大订单");
//        } else if (list.size() != 1) {
//            log.info("订单数量错误");
//            throw new Exception("订单数量错误");
//        }
        List<OrderSubModel> theOrders = new ArrayList();
//        List<OrderSubModel> subList = orderSubDao.findByOrderMainId(orderMainModel.getOrdermainId());  // 获取小订单
//        if (subList == null || subList.size() < 1) {// 如果没有小订单
//            log.info("没有小订单");
//            throw new Exception("没有小订单");
//        }
//        Iterator iter = list.iterator();
//        while (iter.hasNext()) {
//            PayOrderSubDto node = (PayOrderSubDto) iter.next();
//            String returnCode = node.getReturnCode(); // 返回码
//            orderMainModel.setErrorCode(returnCode);// 设置返回码
//            log.info("返回码:" + returnCode);
//
//            if (PayReturnCode.isSucess(returnCode)) {// 成功支付
//                log.info("支付成功");
//                orderMainModel.setCurStatusId("0308");// 当前状态代码
//                orderMainModel.setCurStatusNm("支付成功");// 当前状态名称
//                orderMainModel.setPayResultTime(SeqUtil.getdbtime(s));// 支付结果时间
//                Iterator ordersiter = subList.iterator();
//                while (ordersiter.hasNext()) {// 循环处理小订单状态
//                    OrderSubModel orderInf = (OrderSubModel) ordersiter.next();
//                    orderInf.setCurStatusId("0308");// 当前状态代码
//                    orderInf.setCurStatusNm("支付成功");// 当前状态名称
//                    orderInf.setErrorCode(returnCode);// 设置返回码
//                    s.update(orderInf);
//                    theOrders.add(orderInf);
//                    String custcartid = orderInf.getCustCartId();// 购物车id
//                    if (custcartid != null) {
//                        dealCustCart(custcartid);// 处理购物车
//                    }
//                }
//            } else if (PayReturnCode.isStateNoSure(returnCode)) {// 状态未明
//                log.info("状态未明");
//                orderMainModel.setCurStatusId("0316");// 当前状态代码
//                orderMainModel.setCurStatusNm("状态未明");// 当前状态名称
//                Iterator ordersiter = subList.iterator();
//                while (ordersiter.hasNext()) {// 循环处理小订单状态
//                    OrderSubModel orderInf = (OrderSubModel) ordersiter.next();
//                    orderInf.setCurStatusId("0316");// 当前状态代码
//                    orderInf.setCurStatusNm("状态未明");// 当前状态名称
//                    orderInf.setErrorCode(returnCode);// 设置返回码
//                    s.update(orderInf);
//                    theOrders.add(orderInf);
//                }
//            } else if (PayReturnCode.isDuplicate(returnCode)) {// 重复支付
//                log.info("重复支付");
//                Iterator ordersiter = subList.iterator();
//                while (ordersiter.hasNext()) {// 循环处理小订单状态
//                    OrderSubModel orderInf = (OrderSubModel) ordersiter.next();
//                    String nowCur_status_id = orderInf.getCustCartId();// 获取订单当前状态
//                    log.info("nowCur_status_id:" + nowCur_status_id);
//                    orderInf.setErrorCode(returnCode);// 设置返回码
//                    s.update(orderInf);
//                    theOrders.add(orderInf);
//                }
//            } else {// 支付失败
//                log.info("支付失败");
//                orderMainModel.setCurStatusId("0307");// 当前状态代码
//                orderMainModel.setCurStatusNm("支付失败");// 当前状态名称
//                orderMainModel.setPayResultTime(SeqUtil.getdbtime(s));// 支付结果时间
//                Iterator ordersiter = subList.iterator();
//                while (ordersiter.hasNext()) {// 循环处理小订单状态
//                    OrderSubModel orderInf = (OrderSubModel) ordersiter.next();
//                    if (orderInf.getErrorCode() == null || "".equals(orderInf.getErrorCode().trim())) {// 如果没成功返回过支付结果
//                        log.info("没成功返回过支付结果");
//                        dealAct(s, orderInf.getOrderId());// 回滚活动
//                        dealBirthday(s, orderInf);// 处理生日
//                        dealJFGoods(s, orderInf.getOrderId());// 回滚库存
//                    }
//                    orderInf.setCurStatusId("0307");// 当前状态代码
//                    orderInf.setCurStatusNm("支付失败");// 当前状态名称
//                    orderInf.setErrorCode(returnCode);// 设置返回码
//                    s.update(orderInf);
//                    theOrders.add(orderInf);
//                }
//            }
//        }
//        if ("0308".equals(orderMainModel.getCurStatusId())) {
//            try {
//                /************* 多线程实时调用o2o接口推送begin **************/
////                Query query = s.createQuery(
////                        "select v.action_flag from Vendor v,OrderInf o,OrderMain om where o.orderMain.ordermain_id=om.ordermain_id and o.vendor_id=v.vendor_id and om.ordermain_id=:ordermain_id and v.action_flag='00' ");
////                query.setString("ordermain_id", orderMainModel.getOrdermain_id());
////                List resList = query.list();
////                if (resList != null && resList.size() > 0) {
////                    log.info("大订单号满足实时推送的条件：" + orderMainModel.getOrdermainId());
////                    SendO2OThreadPool.getThreadPool().execute(new SendOutSystemService(orderMainModel.getOrdermainId()));
////                    log.info("调用完成！");
////                }
//
//                List<OrderSubModel> orderSubModel = orderSubDao.findByOrderMainId(orderMainModel.getOrdermainId());
//                if(orderSubModel != null && orderSubModel.size() > 0){
//                    VendorInfoModel vendorInfoModel = vendorService.findVendorById(orderSubModel.get(0).getVendorId()).getResult();
//                    if(vendorInfoModel != null){
//                        log.info("大订单号满足实时推送的条件：" + orderMainModel.getOrdermainId());
//                        SendO2OThreadPool.getThreadPool().execute(new SendOutSystemService(orderMainModel.getOrdermainId()));
//                        log.info("调用完成！");
//                    }
//                }
//
//            } catch (Exception e) {
//                log.error("多线程推送o2o失败：" + e);
//            }
//
//            try {
//                String messageFlag = orderDealDto.getMessageFlag();
//                if (messageFlag != null && "1".equals(messageFlag)) {
//                    log.info("prepaid 移动卡充值：" + orderMainModel.getOrdermainId());
//                    // 调用移动卡充值 多线程推送
//                    PrepaidYDKServicePool prepaidYDKServicePool = new PrepaidYDKServicePool(
//                            orderMain.getOrdermain_id());
//                    prepaidYDKServicePool.sendService();
//                }
//
//            } catch (Exception e) {
//                log.error("移动卡虚拟礼品调用推送失败：" + e);
//            }
//
//        }
//
//        List<OrderDoDetailModel> orderDoDetailModelList = insertJFOrderDodetails(theOrders); //订单历史明细
//
        return theOrders;
    }

    /**
     * 获取优惠券对账文件表对象
     *
     * @param order_id
     * @param cur_status_id
     * @param cur_status_nm
     * @return
     */
    public OrderCheckModel getObject(String order_id, String cur_status_id, String cur_status_nm, String ischeck,
                                     String ispoint) {
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

    /**
     * 如果支付成功，清空购物车
     *
     * @param id
     */
    public void dealCustCart(String id) {
        log.info("购物车id:" + id);
        if (id != null) {
            //TODO DAO
        }
    }

    /*** 插入一次性的订单处理明细
     *
     * @param orders
     * @throws Exception
     */
    private List<OrderDoDetailModel> insertYGOrderDodetails(List<OrderSubModel> orders) throws Exception {
        log.info("into insertYGOrderDodetails");
        Date currTime = new Date();// 时间
        List<OrderDoDetailModel> orderDoDetailModelList = new ArrayList<OrderDoDetailModel>();
        for (int i = 0; i < orders.size(); i++) {
            OrderSubModel orderSubModel = orders.get(i);
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setOrderId((orderSubModel.getOrderId()));
            orderDoDetailModel.setDoTime(currTime);
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
            orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
            orderDoDetailModel.setMsgContent("");
            orderDoDetailModel.setDoDesc("广发一次性支付");
            orderDoDetailModel.setRuleId("");
            orderDoDetailModel.setRuleNm("");
            orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());
            orderDoDetailModel.setDelFlag(0);
            orderDoDetailModelList.add(orderDoDetailModel);
        }
        return orderDoDetailModelList;
    }

    /**
     * 获取广发一期返回报文
     *
     * @param orderDealDto
     * @param orders
     */
    public void getLGReturnDoc(OrderDealDto orderDealDto, List orders) {
        log.info("getLGReturnDoc");
        List<OrderDealPayResultDto> orderList = new ArrayList<OrderDealPayResultDto>();
        for (int i = 0; i < orders.size(); i++) {
            OrderSubModel orderSubModel = (OrderSubModel) orders.get(i);
            OrderDealPayResultDto orderDealPayResultDto = new OrderDealPayResultDto();
            orderDealPayResultDto.setSeq(new Integer(i + 1).toString());
            orderDealPayResultDto.setOrderId(orderSubModel.getOrderId());
            orderDealPayResultDto.setStatusId(orderSubModel.getCurStatusId());
            orderDealPayResultDto.setMoney(orderSubModel.getTotalMoney().toString());
            orderDealPayResultDto.setGoodsId(orderSubModel.getGoodsId());
            orderDealPayResultDto.setGoodName(orderSubModel.getGoodsNm());
            String privilegeMoney = "0.00";
            String single_bonus = "0";
            if (orderSubModel.getVoucherPrice() != null) {
                privilegeMoney = orderSubModel.getVoucherPrice().toString();
            }
            if (orderSubModel.getSingleBonus() != null) {
                single_bonus = orderSubModel.getSingleBonus().toString();
            }
            orderDealPayResultDto.setPrivilegeMoney(privilegeMoney);// 优惠券金额
            orderDealPayResultDto.setSingle_bonus(single_bonus);// 积分抵扣
            orderDealPayResultDto.setErrorCode(orderSubModel.getErrorCode());
            orderDealPayResultDto.setCardType(orderSubModel.getCardtype());// 卡类型,C：信用卡,Y：借记卡
            String payResult = "0";// 1:支付成功
            if ("0308".equals(orderSubModel.getCurStatusId())) {// 支付成功
                orderDealPayResultDto.setErrorMsg("支付成功");
                payResult = "1";
            } else if ("0316".equals(orderSubModel.getCurStatusId()) || "0301".equals(orderSubModel.getCurStatusId())) {// 状态未明
                orderDealPayResultDto.setErrorMsg("订单状态未明:[\" + orderSubModel.getErrorCode() + \"]请稍后查询订单结果");
            } else {
                orderDealPayResultDto.setErrorMsg("支付失败:[" + orderSubModel.getErrorCode() + "]");
            }
            orderDealPayResultDto.setPayResult(payResult);
            orderList.add(orderDealPayResultDto);
        }
        orderDealDto.setOrderList(orderList);
    }

    /**
     * 判断是全部订单成功还是部分订单成功还是全部失败，并且将结果放到返回的xml中(非分期支付)
     *
     * @param orderDealDto
     * @param orders
     */
    public void getIsSucessDoc(OrderDealDto orderDealDto, List orders) {
        log.info("into getIsSucessDoc");
        String sucessFlag = "0";
        String errFlag = "0";
        String wmFlag = "0"; //状态为名
        for (int i = 0; i < orders.size(); i++) {
            OrderSubModel orderSubModel = (OrderSubModel) orders.get(i);
            String statusId = orderSubModel.getCurStatusId();// 状态
            if ("0308".equals(statusId)) {// 如果支付成功
                sucessFlag = "1";
            } else if("0316".equals(statusId)){
                wmFlag = "1";
            } else{
                errFlag = "1";
            }
        }
        if ("1".equals(sucessFlag) && "0".equals(errFlag)) {// 如果全部子订单成功
            orderDealDto.setSucessFlag("0");
        } else if ("0".equals(sucessFlag) && "1".equals(errFlag)) {// 如果全部子订单失败
            orderDealDto.setSucessFlag("1");
        } else {// 如果部分成功部分失败
            orderDealDto.setSucessFlag("2");
        }

        if ("1".equals(wmFlag)) {
            orderDealDto.setSucessFlag("7"); // 状态未明
        }
    }

    /**
     * 插入广发分期的订单处理明细
     *
     * @param orders
     * @throws Exception
     */
    private List<OrderDoDetailModel> insertFQOrderDodetails(List<OrderSubModel> orders) throws Exception {
        Date currTime = new Date();// 时间
        List<OrderDoDetailModel> orderDoDetailModelList = new ArrayList<OrderDoDetailModel>();
        for (int i = 0; i < orders.size(); i++) {
            OrderSubModel orderSubModel = orders.get(i);
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setOrderId((orderSubModel.getOrderId()));
            orderDoDetailModel.setDoTime(currTime);
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
            orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
            orderDoDetailModel.setMsgContent("");
            orderDoDetailModel.setDoDesc("广发分期支付");
            orderDoDetailModel.setRuleId("");
            orderDoDetailModel.setRuleNm("");
            orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());
            orderDoDetailModel.setDelFlag(0);
            orderDoDetailModelList.add(orderDoDetailModel);
        }
        return orderDoDetailModelList;

    }

    /**
     * 获取分期返回报文
     *
     * @param orderDealDto
     * @param orders
     */
    public void getFQReturnDoc(OrderDealDto orderDealDto, List orders) {
        List<OrderDealPayResultDto> orderList = new ArrayList<OrderDealPayResultDto>();
        for (int i = 0; i < orders.size(); i++) {
            OrderSubDto orderSubModel = (OrderSubDto) orders.get(i);
            OrderDealPayResultDto orderDealPayResultDto = new OrderDealPayResultDto();
            orderDealPayResultDto.setSeq(new Integer(i + 1).toString());
            orderDealPayResultDto.setOrderId(orderSubModel.getOrderId());
            orderDealPayResultDto.setStatusId(orderSubModel.getCurStatusId());
            orderDealPayResultDto.setMoney(orderSubModel.getTotalMoney().toString());
            orderDealPayResultDto.setGoodsId(orderSubModel.getGoodsId());
            orderDealPayResultDto.setGoodName(orderSubModel.getGoodsNm());
            String privilegeMoney = "0.00";
            String single_bonus = "0";
            if (orderSubModel.getVoucherPrice() != null) {
                privilegeMoney = orderSubModel.getVoucherPrice().toString();
            }
            if (orderSubModel.getSingleBonus() != null) {
                single_bonus = orderSubModel.getSingleBonus().toString();
            }
            orderDealPayResultDto.setPrivilegeMoney(privilegeMoney);// 优惠券金额
            orderDealPayResultDto.setSingle_bonus(single_bonus);// 积分抵扣
            // 荷兰式新增act_type
            orderDealPayResultDto.setAct_type(orderSubModel.getActType());
            orderDealPayResultDto.setErrorCode(orderSubModel.getErrorCode());
            orderDealPayResultDto.setCardType(orderSubModel.getCardtype());// 卡类型 C：信用卡,Y：借记卡
            String payResult = "0";// 1:验证成功
            if ("0305".equals(orderSubModel.getCurStatusId())) {// 处理中
                orderDealPayResultDto.setErrorMsg("处理中");
                payResult = "1";
            } else if ("0308".equals(orderSubModel.getCurStatusId())) {// 支付成功
                orderDealPayResultDto.setErrorMsg("支付成功");
                payResult = "1";
            } else if ("0301".equals(orderSubModel.getCurStatusId())) {// 待付款
                orderDealPayResultDto.setErrorMsg("待付款");
            } else if ("0316".equals(orderSubModel.getCurStatusId())) {// 状态未明
                if ("RC000".equals(orderSubModel.getErrorCode())) {// 如果支付网关返回验证成功
                    orderDealPayResultDto.setErrorMsg("订单状态未明:[bps返回错误]请稍后查询订单结果");
                } else {// 如果支付网关返回验证不成功
                    orderDealPayResultDto.setErrorMsg("订单状态未明:[" + orderSubModel.getErrorCode() + "]请稍后查询订单结果");
                }
            } else {
                if ("RC000".equals(orderSubModel.getErrorCode())) {// 如果支付网关返回验证成功
                    if (!"0000".equals(orderSubModel.getBpsErrorcode())) {// 如果bps返回不成功
                        if (orderSubModel.getBpsErrorcode() == null || "".equals(orderSubModel.getBpsErrorcode().trim())) {// 如果BpsErrorcode为空(通过状态回查回来的)
                            orderDealPayResultDto.setErrorMsg("支付失败");//
                        } else {
                            orderDealPayResultDto.setErrorMsg("支付失败:[" + orderSubModel.getBpsErrorcode() + "]");
                        }
                    } else {// bps拒绝
                        orderDealPayResultDto.setErrorMsg("支付失败:[bps拒绝]");
                    }
                } else {// 如果支付网关返回验证不成功
                    orderDealPayResultDto.setErrorMsg("支付失败:[" + orderSubModel.getErrorCode() + "]");
                }
            }
            orderDealPayResultDto.setPayResult(payResult);
            orderList.add(orderDealPayResultDto);
        }
        orderDealDto.setOrderList(orderList);
    }

    /**
     * 判断是全部订单成功还是部分订单成功还是全部失败，并且将结果放到返回的xml中(分期支付)
     *
     * @param orderDealDto
     * @param orders
     */
    public void getFQIsSucessDoc(OrderDealDto orderDealDto, List orders) {
        String sucessFlag = "0";
        String errFlag = "0";
        String proFlag = "0"; // 处理中
        String wmFlag = "0"; //状态为名
        for (int i = 0; i < orders.size(); i++) {
            OrderSubDto orderSubModel = (OrderSubDto) orders.get(i);
            String statusId = orderSubModel.getCurStatusId();// 状态
            if ("0308".equals(statusId)) {// 如果支付成功
                sucessFlag = "1";
            } else if ("0316".equals(statusId)) {// 状态未明
                wmFlag = "1";
            } else if ("0305".equals(statusId)) { // 如果处理中
                proFlag = "1";
            } else {
                errFlag = "1";
            }
        }
        if ("1".equals(sucessFlag) && "0".equals(errFlag) && "0".equals(proFlag)) {// 如果全部子订单成功
            orderDealDto.setSucessFlag("0");
        } else if ("0".equals(sucessFlag) && "1".equals(errFlag) && "0".equals(proFlag)) {// 如果全部子订单失败
            orderDealDto.setSucessFlag("1");
        } else if ("1".equals(proFlag) && "0".equals(errFlag) && "0".equals(sucessFlag)) {// 如果全部子订单处理中
            orderDealDto.setSucessFlag("3");
        } else if ("1".equals(proFlag) && "0".equals(errFlag) && "1".equals(sucessFlag)) {// 如果部分成功、部分处理中
            orderDealDto.setSucessFlag("4");
        } else if ("0".equals(proFlag) && "1".equals(errFlag) && "1".equals(sucessFlag)) {// 如果部分成功、部分失败
            orderDealDto.setSucessFlag("5");
        } else if ("1".equals(proFlag) && "1".equals(errFlag) && "0".equals(sucessFlag)) {// 如果部分处理中、部分失败
            orderDealDto.setSucessFlag("6");
        } else if ("1".equals(proFlag) && "1".equals(errFlag) && "1".equals(sucessFlag)) {
            orderDealDto.setSucessFlag("2"); // 三种状态并存 成功 失败 处理中
        }
        if ("1".equals(wmFlag)) {
            orderDealDto.setSucessFlag("7"); // 状态未明
        }
        log.info("sucessFlag:" + orderDealDto.getSucessFlag());
    }

    /**
     * 荷兰式订单支付成功之后更新完成支付字段PAY_FLAG
     *
     * @param id
     */
    private void updatePayFlag(String id) {
        //TODO DAO
    }

    /**
     * 回滚荷兰式商品和活动数
     *
     * @throws Exception
     */
    private void dealAuctionRecord(String id, String order_id, String goods_id) throws Exception {
        //TODO DAO
    }

    /**
     * 发起撤销积分申请
     *
     * @param order
     * @param curDate          撤销日期
     * @param curTime          撤销时间
     * @param jfRefundSerialno 撤销流水
     *                         jfRefundSerialno退积分流水
     */
    private void sendNSCT009(OrderSubModel order, String curDate, String curTime, String jfRefundSerialno) throws Exception {
        // bsp分期失败需要调用积分撤销接口
        log.info("开始获取nTNSCT009bean");
        ReturnPointsInfo gateWayEnvolopeVo = new ReturnPointsInfo();

        gateWayEnvolopeVo.setChannelID(sourceIdChangeToChannel(order.getSourceId()));// 渠道标识
        gateWayEnvolopeVo.setMerId(order.getMerId()); // 大商户号(商城商户号)
        gateWayEnvolopeVo.setOrderId(order.getOrderId()); // 订单号(小)
        String consumeTypeStr = "1";
        if (order.getVoucherNo() != null && !"".equals(order.getVoucherNo().trim())) {
            consumeTypeStr = "2";
        }
        gateWayEnvolopeVo.setConsumeType(consumeTypeStr); // 消费类型("0":纯积分(这里不存在)\"1":积分+现金\"2":积分+现金+优惠券)
        gateWayEnvolopeVo.setCurrency("CNY"); // 币种
        gateWayEnvolopeVo.setTranDate(curDate); // 发起方日期(当前日期)
        gateWayEnvolopeVo.setTranTiem(curTime); // 发起方时间(当前时间)
        gateWayEnvolopeVo.setTradeSeqNo(jfRefundSerialno);// 发起方流水号
        gateWayEnvolopeVo.setSendDate(DateHelper.date2string(order.getCreateTime(), "yyyy-MM-dd")); // 原发起方日期
        gateWayEnvolopeVo.setSendTime(DateHelper.date2string(order.getCreateTime(), "HH:mm:ss")); // 原发起方时间
        gateWayEnvolopeVo.setSerialNo(order.getOrderIdHost()); // 原发起方流水号
        gateWayEnvolopeVo.setCardNo(order.getCardno()); // 卡号
        gateWayEnvolopeVo.setExpiryDate("0000"); // 卡片有效期
        gateWayEnvolopeVo.setPayMomey(new BigDecimal(0)); // 现金支付金额(默认送0)
        gateWayEnvolopeVo.setJgId("001"); // 积分类型
        gateWayEnvolopeVo.setDecrementAmt(order.getBonusTotalvalue()); // 扣减积分额
        gateWayEnvolopeVo.setTerminalNo("01"); // 终端号("01"广发商城，"02"积分商城)
        BaseResult baseResult = paymentService.returnPoint(gateWayEnvolopeVo);
    }

    /**
     * <p>Description:上送积分系统渠道标志转换</p>
     *
     * @param sourceId
     * @return
     * @author:panhui
     * @update:2014-9-4
     */
    private String sourceIdChangeToChannel(String sourceId) {
        if (Contants.SOURCE_ID_MALL.equals(sourceId)) {
            return Contants.SOURCE_ID_MALL_TYPY;
        }
        if (Contants.SOURCE_ID_CC.equals(sourceId)) {
            return Contants.SOURCE_ID_CC_TYPY;
        }
        if (Contants.SOURCE_ID_IVR.equals(sourceId)) {
            return Contants.SOURCE_ID_IVR_TYPY;
        }
        if (Contants.SOURCE_ID_CELL.equals(sourceId)) {
            return Contants.SOURCE_ID_CELL_TYPY;
        }
        if (Contants.SOURCE_ID_MESSAGE.equals(sourceId)) {
            return Contants.SOURCE_ID_MESSAGE_TYPY;
        }
        if (Contants.SOURCE_ID_WX_BANK.equals(sourceId) || Contants.SOURCE_ID_WX_CARD.equals(sourceId)) {
            return Contants.SOURCE_ID_WX_TYPY;
        }
        return Contants.SOURCE_ID_MALL_TYPY;
    }

    /**
     * 支付成功后，进行O2O订单推送处理
     *
     * @param orderList
     * @throws Exception
     */
    private void DealO2OOrderAfterPaySucc(List<OrderSubModel> orderList) throws Exception {
//        log.info("OrderDeal,完成支付后根据小订单列表进行O2O推送.....");
//        try {
//            if (orderList == null || orderList.size() <= 0) {
//                log.info("小订单列表为空不推送 ");
//                return;
//            }
//            boolean isSendFlag = false;
//            VendorInfoModel vendorMap = null;
//            for (int i = 0; i < orderList.size(); i++) {
//                OrderSubModel orderInfo = (OrderSubModel)orderList.get(i);
//                String orderMainId = orderInfo.getOrdermainId();
//                log.info("大订单" + orderMainId + "小订单：" + orderInfo.getOrderId() + " 订单状态："
//                        + orderInfo.getCurStatusId());
//                if (Contants.ORDER_STATUS_CODE_HAS_ORDERS.equals(orderInfo.getCurStatusId())) {
//                    if (vendorMap == null) {
//                        vendorMap = queryVendorInf(orderInfo.getVendorId());
//                    } else {
//                        if (!orderInfo.getVendorId().equals((String) vendorMap.getVendorId())) {
//                            vendorMap = queryVendorInf(orderInfo.getVendorId());
//                        }
//                    }
//                    if (vendorMap == null) {
//                        log.info("orderId=" + orderInfo.getOrderId() + ",合作商为空不推送 ");
//                        continue;
//                    }
//                    log.info(" 合作商角色：" + (String) vendorMap.getVendorRole() + " 推送类型（00实时，01批量）："
//                            + (String) vendorMap.getActionFlag());
//                    if ("3".equals((String) vendorMap.getVendorRole())
//                            && "00".equals((String) vendorMap.getActionFlag()) && !isSendFlag) { // ACTION_FLAG=’00’表示实时推送
//                        // 大订单下如果包含需要实时推送的O2O订单，则开启一个线程推送即可，实时推送会将该大订单下所有支付成功的O2O小单一起推送
//                        log.info("大订单" + orderMainId + " 实时推送O2O商品的订单 " + orderInfo.getOrderId());
//                        // SendOutSystemServicePool.sendService(orderMainId);
//                        SendO2OThreadPool.getThreadPool()
//                                .execute(new  SendOutSystemService(orderMainId, orderInfo.getOrderId()));
//                        // isSendFlag =
//                        // true;//大订单有可能包含不同合作商的小订单，需要一个一个的订单推送--mod by 20160426
//                    }
//                    if ("3".equals((String) vendorMap.getVendorRole())
//                            && "01".equals((String) vendorMap.getActionFlag())) {// ACTION_FLAG =’01’表示批量推送
//                        log.info("大订单" + orderMainId + " 批量推送O2O商品的订单 " + orderInfo.getOrderId());
//                        // 这里没有进行任务是否存在的判断，因为支付一般都是第一次插入数据
//                        log.info("保存到推送队列订单信息：mainOrderId=" + orderMainId + "  suborderno=" + orderInfo.getOrderId());
//                        OrderOutSystemModel orderOutSystemModel = new OrderOutSystemModel();
//                        orderOutSystemModel.setOrderId(orderInfo.getOrderId());
//                        orderOutSystemModel.setOrderMainId(orderMainId);
//                        orderOutSystemModel.setTimes(0);
//                        orderOutSystemModel.setTuisongFlag("0");
//                        orderOutSystemModel.setSystemRole("00");// O2O
//                        orderOutSystemModel.setCreateOper("来自第三方");
//                        orderOutSystemDao.insert(orderOutSystemModel);
//                    }
//                } else {
//                    log.info("大订单" + orderMainId + "小订单：" + orderInfo.getOrderId() + " 订单状态："
//                            + orderInfo.getCurStatusId() + " 不推送");
//                }
//            }
//        } catch (Exception e) {
//            log.error("推送异常：", e);
//            throw new Exception("推送异常：" + e.getMessage());
//        }
    }

    /**
     *查询供应商信息表
     *
     * @param vendorId
     * @return
     */
    private VendorInfoModel queryVendorInf(String vendorId) {
        Response<VendorInfoModel> vendorInfoModel = vendorService.findVendorById(vendorId);
        return vendorInfoModel.getResult();
    }

    /**
     * 获取积分返回报文
     *
     * @param orderDealDto
     * @param orderMainModel
     * @param orders
     */
    public void getJFReturnDoc(OrderDealDto orderDealDto,OrderMainModel orderMainModel, List orders) {
        log.info("into getJFReturnDoc");
        List<OrderDealPayResultDto> orderList = new ArrayList<OrderDealPayResultDto>();
        for (int i = 0; i < orders.size(); i++) {
            OrderSubModel orderInf = (OrderSubModel) orders.get(i);
            ItemModel itemModel = itemService.findByItemcode(orderInf.getGoodsId()).getResult();
            GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode()).getResult();
            OrderDealPayResultDto orderDealPayResultDto = new OrderDealPayResultDto();
            orderDealPayResultDto.setSeq(new Integer(i + 1).toString());
            orderDealPayResultDto.setOrderId(orderInf.getOrderId());
            orderDealPayResultDto.setStatusId(orderInf.getCurStatusId());
            orderDealPayResultDto.setMoney(String.valueOf(orderInf.getTotalMoney()));
            orderDealPayResultDto.setBonus_totalvalue(String.valueOf(orderInf.getBonusTotalvalue()));
            orderDealPayResultDto.setGoodsId(orderInf.getGoodsId());
            orderDealPayResultDto.setGoodName(orderInf.getGoodsNm());
            orderDealPayResultDto.setErrorCode(orderInf.getErrorCode());
            String payResult = "0";// 1:支付成功
            if ("0308".equals(orderInf.getCurStatusId())) {// 支付成功
                orderDealPayResultDto.setErrorMsg("支付成功");
                payResult = "1";
            } else if ("0316".equals(orderInf.getCurStatusId()) || "0301".equals(orderInf.getCurStatusId())) {// 状态未明
                orderDealPayResultDto.setErrorMsg( "订单状态未明:[" + orderInf.getErrorCode() + "]请稍后查询订单结果");
            } else {
                orderDealPayResultDto.setErrorMsg("支付失败:[" + orderInf.getErrorCode() + "]");
            }
            orderDealPayResultDto.setPayResult(payResult);
            orderDealPayResultDto.setGoods_type(goodsModel.getGoodsType());
            orderList.add(orderDealPayResultDto);
        }
        orderDealDto.setOrderList(orderList);
        orderDealDto.setOrderId(orderMainModel.getOrdermainId());
        orderDealDto.setStatusId(orderMainModel.getCurStatusId());
        orderDealDto.setMoney(String.valueOf(orderMainModel.getTotalPrice()));
        orderDealDto.setBonus_totalvalue(String.valueOf(orderMainModel.getTotalBonus()));
        orderDealDto.setErrorCode(orderMainModel.getErrorCode());
        String payResult = "0";// 1:支付成功
        if ("0308".equals(orderMainModel.getCurStatusId())) {// 支付成功
            orderDealDto.setErrorMsg("支付成功");
            payResult = "1";
        } else if ("0316".equals(orderMainModel.getCurStatusId()) || "0301".equals(orderMainModel.getCurStatusId())) {// 状态未明
            orderDealDto.setErrorMsg("订单状态未明:[" + orderMainModel.getErrorCode() + "]请稍后查询订单结果");
        } else {
            orderDealDto.setErrorMsg("支付失败:[" + orderMainModel.getErrorCode() + "]");
        }
        orderDealDto.setPayResult(payResult);
    }
    /**
     * 插入积分的订单处理明细
     *
     * @param orders
     */
    private List<OrderDoDetailModel>  insertJFOrderDodetails(List<OrderSubModel> orders) throws Exception {
        log.info("into insertJFOrderDodetails");
        Date currTime = new Date();// 时间
        List<OrderDoDetailModel> orderDoDetailModelList = new ArrayList<OrderDoDetailModel>();
        for (int i = 0; i < orders.size(); i++) {
            OrderSubModel orderInf = (OrderSubModel) orders.get(i);
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setOrderId(orderInf.getOrderId());
            orderDoDetailModel.setDoTime(currTime);
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setStatusId(orderInf.getCurStatusId());
            orderDoDetailModel.setStatusNm(orderInf.getCurStatusNm());
            orderDoDetailModel.setMsgContent("");
            orderDoDetailModel.setDoDesc("积分支付");
            orderDoDetailModel.setRuleId("");
            orderDoDetailModel.setRuleNm("");
        }
        return orderDoDetailModelList;
    }
}
