package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.BpsReturnCode;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.related.model.TblCfgProCodeModel;
import cn.com.cgbchina.related.service.CfgProCodeService;
import cn.com.cgbchina.rest.common.utils.GatewayEnvelopeUtil;
import cn.com.cgbchina.rest.provider.vo.order.NoAs400GWEnvelopeVo;
import cn.com.cgbchina.rest.provider.vo.order.PayReturnOrderVo;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.manager.OrderMainManager;
import cn.com.cgbchina.trade.manager.OrderTradeManager;
import cn.com.cgbchina.trade.manager.PayManager;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.vo.GateWayEnvolopeVo;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.EspCustNewService;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.dom4j.Document;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

/**
 * Created by 11141021040453 on 16-4-25.
 */
@Service
@Slf4j
public class PayServiceImpl implements PayService {

	@Resource
	OrderMainDao orderMainDao;
    @Resource
    OrderMainManager orderMainManager;
	@Resource
	OrderSubDao orderSubDao;
	@Resource
	TblEspCustCartDao tblEspCustCartDao;
	@Resource
	OrderDoDetailDao orderDoDetailDao;
	@Resource
	ItemService itemService;
	@Resource
	GoodsService goodsService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	EspCustNewService espCustNewService;
	@Resource
	CfgProCodeService cfgProCodeService;
	@Resource
	LocalCardRelateService localCardRelateService;
	@Resource
	PointsPoolService pointsPoolService;
	@Resource
	TblOrderExtend1Dao tblOrderExtend1Dao;
	@Resource
	OrderCheckDao orderCheckDao;
	@Resource
	IdGenarator idGenarator;
	@Resource
	PaymentService paymentService;

	@Resource
	PayManager payManager;
	@Resource
	OrderTradeManager orderTradeManager;

	/**
	 * 大机试运行标识 1：试运行 0：试运行结束
	 */
	private static String runFlag;
	/**
	 * 大机试运行卡号8,9位
	 */
	private static String cardNoSubStr;
	/**
	 * 获取序列
	 */
	private static long gwSeq = 1000;

	@Override
	public Response<Map<String,String>> dealJFOrderWithTX(String ordermain_id, String payAccountNo, String cardType,
			List<PayReturnOrderVo> checkList, List<OrderSubModel> orderList, String custType) {
		try{
			return payManager.dealJFOrderWithTX(ordermain_id, payAccountNo, cardType, checkList, orderList, custType);
		}catch(Exception e){
			final String msg = "更新支付结果失败";
			log.error(msg,e);
			throw new RuntimeException(msg,e);
		}
	}

	@Override
	public Response<String> getCustTypeFromJF(String cardNo, String cardType) {

		Response<String> result = Response.newResponse();
		String custType = Contants.CUST_LEVEL_CODE_A;
		// 调用积分系统
		log.info("南航白金卡数据来源中无法查询出客户信息，需要到积分系统查询该卡的信息，取得客户等级");
		// 积分系统返回的客户等级
		List bonusCustLevelList = new ArrayList();
		// 积分系统的卡号，顺序与bonusCustLevelList对应
		List cardList = new ArrayList();
		// 积分系统的卡板，顺序与bonusCustLevelList对应
		List cardCodeList = new ArrayList();

		// 由于积分系统返回的报文包含翻页信息，有可能需要查询多个页面
		int bonusCurPage = 1;
		int bonusTotalPage = 1;
		Document bonusQueryDocument = null;
		Document bonusReturnDocument = null;
		try {
			// 进行翻页查询
			while (bonusCurPage <= bonusTotalPage) {
				String bonusCurPageStr;
				if (bonusCurPage < 10) {
					bonusCurPageStr = "000" + bonusCurPage;
				} else if (bonusCurPage < 100) {
					bonusCurPageStr = "00" + bonusCurPage;
				} else if (bonusCurPage < 1000) {
					bonusCurPageStr = "0" + bonusCurPage;
				} else {
					bonusCurPageStr = bonusCurPage + "";
				}
				bonusQueryDocument = assBonusQueryEnvelope(bonusCurPageStr, cardNo);
				log.info("【MAL101】流水：向积分系统发送请求报文，当前页数：" + bonusCurPageStr);
				// 等积分系统正常后读取报文
				bonusReturnDocument = GatewayEnvelopeUtil.sendEnvelope(bonusQueryDocument);
				log.info("【MAL101】流水：收到积分系统返回报文");

				String[] custLevelArray = GatewayEnvelopeUtil.getNoAS400BodyFieldArray(bonusReturnDocument,
						"level_code", "soapenv", "gateway");
				log.info("【MAL101】流水：从积分系统返回报文中得到用户同一分行下的用户等级有：" + custLevelArray.toString());
				bonusCustLevelList = assArrayInList(custLevelArray, bonusCustLevelList);

				String[] cardNumArray = GatewayEnvelopeUtil.getNoAS400BodyFieldArray(bonusReturnDocument, "card_no",
						"soapenv", "gateway");
				log.info("【MAL101】流水：从积分系统返回报文中得到用户同一分行下的卡号有：" + cardNumArray.toString());
				cardList = assArrayInList(cardNumArray, cardList);

				// 大机改造 是否走新流程
				boolean isPractiseRun = isPractiseRun(cardNo);
				String kaban = "";
				if (isPractiseRun) {
					kaban = "product_code";// 第三产品编码
				} else {
					kaban = "cfpr_code";// 卡板
				}
				String[] cfprCodeArray = GatewayEnvelopeUtil.getNoAS400BodyFieldArray(bonusReturnDocument, kaban,
						"soapenv", "gateway");
				log.info("【MAL101】流水：从积分系统返回报文中得到用户同一分行下的卡板有：" + cfprCodeArray.toString());
				cardCodeList = assArrayInList(cfprCodeArray, cardCodeList);// 卡板list

				bonusCurPage++;

				String totalPage = GatewayEnvelopeUtil.getNoAS400BodyField(bonusReturnDocument, "totalPage", "soapenv",
						"gateway");
				try {
					bonusTotalPage = Integer.parseInt(totalPage.trim());
				} catch (Exception e) {
					result.setSuccess(false);
					log.error("【MAL101】流水：转换总页数时出现异常，积分返回总页数：" + bonusTotalPage);
					log.error(e.getMessage(), e);
					throw new Exception(e.getMessage());
				}
			}
			String isVip = GatewayEnvelopeUtil.getNoAS400BodyField(bonusReturnDocument, "is_vip", "soapenv", "gateway");
			log.info("【MAL101】流水：从积分系统返回报文中得到VIP字段：isVip =" + isVip);
			// 等积分系统正常后读取报文,取得对应卡号的卡等级
			// 先判断是否vip客户
			if ("0".equals(isVip)) {
				custType = Contants.CUST_LEVEL_CODE_D;
			} else {
				custType = getCustLevel(bonusCustLevelList, cardCodeList);
				log.info("积分系统返回的客户优先发货级别为：" + custType);
			}
		} catch (Exception e) {
			result.setSuccess(false);
			log.error("查询积分系统异常");
		}
		result.setSuccess(true);
		result.setResult(custType);
		return result;
	}

	/**
	 * MAL115 CC广发下单
	 * 
	 * @param tblOrderMain
	 * @param tblOrders
	 * @param orderDodetails
	 * @param goodsNumList
	 * @param actNumList
	 * @param tblOrderExtend1List
	 * @return
	 */
	@Override
	public Response<Boolean> paywithTX(OrderMainModel tblOrderMain, List<OrderSubModel> tblOrders,
			List<OrderDoDetailModel> orderDodetails, List<Map<String, Object>> goodsNumList,
			List<Map<String, Object>> actNumList, List<TblOrderExtend1Model> tblOrderExtend1List) {
		Response<Boolean> response = Response.newResponse();

		try {
			orderMainManager.createOrder_mal115(tblOrderMain, tblOrders, orderDodetails,
					goodsNumList, actNumList, tblOrderExtend1List);
			response.setResult(Boolean.TRUE);
			return response;
		} catch (Exception e) {
			log.error("PayService.paywithTX.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("PayService.paywithTX.error");
			return response;
		}
	}

	/**
	 * 支付返回状态未明，小单状态置为“状态未明”
	 */
	@Override
	@Transactional
	public Response<Boolean> dealNoSureOrderswithTX115(List<Map<String, Object>> failueList, String cardNo,
			String cardType, String errCode, String doDesc) {
		Response<Boolean> response = Response.newResponse();
		try {
			for (Map<String, Object> map : failueList) {
				String orderId = String.valueOf(map.get("orderId"));
				log.info(orderId + "分期订单支付状态未明");
				// 更新子订单表
				OrderSubModel model = new OrderSubModel();
				model.setOrderId(orderId);
				model.setCardno(cardNo);
				model.setCardtype(cardType);
				model.setCurStatusId("0316");
				model.setCurStatusNm("状态未明");
				model.setErrorCode(errCode);
				orderSubDao.updateOrder(model);
				// 插入历史记录
				OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
				orderDoDetailModel.setOrderId(orderId);
				orderDoDetailModel.setDoTime(new Date());
				orderDoDetailModel.setDoUserid("System");
				orderDoDetailModel.setUserType("0");
				orderDoDetailModel.setStatusId("0316");
				orderDoDetailModel.setStatusNm("状态未明");
				orderDoDetailModel.setDoDesc(doDesc);
				orderDoDetailModel.setCreateOper("System");
				orderDoDetailModel.setCreateTime(new Date());
				orderDoDetailModel.setDelFlag(0);
				orderDoDetailDao.insert(orderDoDetailModel);
			}
			response.setResult(Boolean.TRUE);
			return response;
		} catch (Exception e) {
			log.error("PayService.dealNoSureOrderswithTX.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("PayService.dealNoSureOrderswithTX.error");
			return response;
		}
	}

	/**
	 * 401短信
	 * 
	 * @param failueList
	 * @param orderMainId
	 * @param cardNo
	 * @param doDesc
	 * @return
	 */
	@Override
	public void dealFailOrderswithTx(List<Map<String, Object>> failueList, String orderMainId, String cardNo,
			String doDesc) {
		orderTradeManager.dealWXFailOrderswithTX(failueList, orderMainId, cardNo, doDesc);
	}

	@Override
	@Transactional
	public Response<Boolean> dealFailOrderswithTX(List<Map<String, Object>> failueList, String orderMainid) {
		Response<Boolean> response = Response.newResponse();
		String nowDate = DateHelper.getyyyyMMdd();
		String nowTime = DateHelper.getHHmmss();
		try {
			for (Map<String, Object> map : failueList) {
				String orderId = String.valueOf(map.get("orderId"));
				String goodsId = String.valueOf(map.get("goodsId"));
				OrderSubModel tblOrder = orderSubDao.findById(orderId);
				log.info(orderId + "分期订单支付失败");
				if (tblOrder.getErrorCode() == null || "".equals(tblOrder.getErrorCode())) {// 未返回支付结果的情况下回滚
					// 回滚商品数量（库存+1）
					itemService.rollbackBacklogByNum(goodsId, 1);
					// 回滚积分池
					if (tblOrder.getBonusTotalvalue() != null && tblOrder.getBonusTotalvalue().longValue() != 0) {
						Map<String, Object> params = Maps.newHashMap();
						params.put("cur_month", DateHelper.getyyyyMM());
						params.put("used_point", tblOrder.getBonusTotalvalue());
						pointsPoolService.dealPointPool(params);
					}
				}
				// 更新子订单表
				OrderSubModel subModel = new OrderSubModel();
				subModel.setOrderId(orderId);
				subModel.setCurStatusId("0307");
				subModel.setCurStatusNm("支付失败");
				orderSubDao.updateOrder(subModel);
				/**** 支付失败时插入对账文件表begin ****/
				if (tblOrder.getVoucherNo() != null && !"".equals(tblOrder.getVoucherNo())) {
					OrderCheckModel orderCheck = getObject(tblOrder.getOrderId(), "0307", "支付失败", "0", "", nowDate, nowTime);
					orderCheckDao.insert(orderCheck);
				}
				/**** 支付失败时插入对账文件表end ****/
				OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
				orderDoDetailModel.setOrderId(orderId);
				orderDoDetailModel.setDoTime(new Date());
				orderDoDetailModel.setDoUserid("System");
				orderDoDetailModel.setUserType("0");
				orderDoDetailModel.setStatusId("0307");
				orderDoDetailModel.setStatusNm("支付失败");
				orderDoDetailModel.setDoDesc("CC广发分期支付");
				orderDoDetailModel.setCreateOper("System");
				orderDoDetailModel.setCreateTime(new Date());
				orderDoDetailModel.setDelFlag(0);
				orderDoDetailDao.insert(orderDoDetailModel);
			}
			response.setResult(Boolean.TRUE);
			return response;
		} catch (Exception e) {
			log.error("PayService.dealFailOrderswithTX.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("PayService.dealFailOrderswithTX.error");
			return response;
		}
	}

    /**
     * 处理bps分期支付信息
     * @param tblOrderMain
     * @param ordersTemp
     * @return
     */
    @Override
	@Transactional
    public Response<Boolean> dealFQorderBpswithTX(OrderMainModel tblOrderMain, List<Map<String, Object>> ordersTemp) {
        Response<Boolean> response = Response.newResponse();
		String nowDate = DateHelper.getyyyyMMdd();
		String nowTime = DateHelper.getHHmmss();
        try{
            boolean orderMainFlag = true;
            for (int i = 0; i < ordersTemp.size(); i++) {
                Map<String, Object> map = (Map) ordersTemp.get(i);
                OrderSubModel tblOrder = (OrderSubModel) map.get("tblOrder");
                VendorInfoModel tblVendorInf = (VendorInfoModel) map.get("tblVendorInf");
                GoodsModel tblGoodsInf = (GoodsModel) map.get("tblGoodsInf");
                TblGoodsPaywayModel tblGoodsPayway = (TblGoodsPaywayModel) map.get("tblGoodsPayway");
                StagingRequestResult returnGateWayEnvolopeVo = (StagingRequestResult) map.get("returnGateWayEnvolopeVo");
                String errorCode = null;
                String approveResult= null;
                String followdir= null;
                String caseid = null;
                String specialcust = null;
                String releasetype = null;
                String rejectcode = null;
                String aprtcode = null;
                String ordernbr = null;
                if(null!=returnGateWayEnvolopeVo){//空判断
                    errorCode = returnGateWayEnvolopeVo.getErrorCode();
                    approveResult=returnGateWayEnvolopeVo.getApproveResult();
                    followdir=returnGateWayEnvolopeVo.getFollowDir();
                    caseid=returnGateWayEnvolopeVo.getCaseId();
                    specialcust=returnGateWayEnvolopeVo.getSpecialCust();
                    releasetype=returnGateWayEnvolopeVo.getReleaseType();
                    rejectcode=returnGateWayEnvolopeVo.getRejectcode();
                    aprtcode=returnGateWayEnvolopeVo.getAprtcode();
                    ordernbr=returnGateWayEnvolopeVo.getOrdernbr();
                }
                //分期订单电子支付是否已经验证标识 Null或’’:电子支付平台未验证 1:电子支付平台已验证
                OrderSubModel subModel = new OrderSubModel();
                subModel.setOrderId(tblOrder.getOrderId());
                subModel.setCashAuthType("1");
                orderSubDao.updateOrder(subModel);
                tblOrder.setCashAuthType("1");
                /*** 支付成功 插入积分正交易start **/
                String ischeck = "";
                String ispont = "";
                if(tblOrder.getVoucherNo()!=null&&!"".equals(tblOrder.getVoucherNo())){
                    ischeck = "0";
                }
                if(tblOrder.getBonusTotalvalue()!=null&&tblOrder.getBonusTotalvalue().longValue()!=0){
                    ispont = "0";
                }
                if(!"".equals(ispont)){//支付成功，插入积分正交易
                    OrderCheckModel orderCheck = getObject(tblOrder.getOrderId(), "0308", "支付成功","",ispont, nowDate, nowTime);
                    orderCheck.setDoDate(DateHelper.getyyyyMMdd(tblOrder.getCreateTime()));
                    orderCheck.setDoTime(DateHelper.getHHmmss(tblOrder.getCreateTime()));
                    orderCheckDao.insert(orderCheck);
                }
                /*** 支付成功 插入积分正交易 end **/
                if(returnGateWayEnvolopeVo!=null&&errorCode!=null){//如果能正确获取到bps的返回对象
                    if (BpsReturnCode.isBp0005Sucess(errorCode, approveResult)) {// 如果支付成
                        log.info(tblOrder.getOrderId()+"分期订单支付成功");
                        // 更新子订单表
                        OrderSubModel orderSubModel = new OrderSubModel();
                        orderSubModel.setOrderId(tblOrder.getOrderId());
                        orderSubModel.setCurStatusId("0308");
                        orderSubModel.setCurStatusNm("支付成功");
                        orderSubDao.updateOrder(orderSubModel);
                        tblOrder.setCurStatusId("0308");
                        tblOrder.setCurStatusNm("支付成功");
                        if(!"".equals(ischeck)){//插入优惠券正交易
                            OrderCheckModel orderCheck = getObject(tblOrder.getOrderId(), "0308", "支付成功",ischeck,"",nowDate,nowTime);
                            orderCheck.setDoDate(DateHelper.getyyyyMMdd(tblOrder.getCreateTime()));
                            orderCheck.setDoTime(DateHelper.getHHmmss(tblOrder.getCreateTime()));
                            orderCheckDao.insert(orderCheck);
                        }
                        /****支付失败时插入对账文件表end****/
                    }else if(BpsReturnCode.isBp0005Dealing(errorCode, approveResult)){// 如果处理中
                        log.info(tblOrder.getOrderId()+"分期订单处理中");
                        // 更新子订单表
                        OrderSubModel orderSubModel = new OrderSubModel();
                        orderSubModel.setOrderId(tblOrder.getOrderId());
                        orderSubModel.setCurStatusId("0305");
                        orderSubModel.setCurStatusNm("处理中");
                        orderSubDao.updateOrder(orderSubModel);
                        tblOrder.setCurStatusId("0305");
                        tblOrder.setCurStatusNm("处理中");
                    }else if(BpsReturnCode.isBp0005NoSure(errorCode, approveResult)){//如果状态未明
                        log.info(tblOrder.getOrderId()+"分期订单状态未明");
                        // 更新子订单表
                        OrderSubModel orderSubModel = new OrderSubModel();
                        orderSubModel.setOrderId(tblOrder.getOrderId());
                        orderSubModel.setCurStatusId("0316");
                        orderSubModel.setCurStatusNm("状态未明");
                        orderSubDao.updateOrder(orderSubModel);
                        tblOrder.setCurStatusId("0316");
                        tblOrder.setCurStatusNm("状态未明");
                    }else{
                        log.info(tblOrder.getOrderId()+"分期订单支付失败");
                        // 回滚商品数量（库存+1）
                        itemService.rollbackBacklogByNum(tblOrder.getGoodsId(),1);
                        //回滚积分池
                        if(tblOrder.getBonusTotalvalue()!=null&&tblOrder.getBonusTotalvalue().longValue()!=0){
                            Map<String,Object> params = Maps.newHashMap();
                            params.put("cur_month",DateHelper.getyyyyMM());
                            params.put("used_point",tblOrder.getBonusTotalvalue());
                            pointsPoolService.dealPointPool(params);
                        }
                        // 更新子订单表
                        OrderSubModel orderSubModel = new OrderSubModel();
                        orderSubModel.setOrderId(tblOrder.getOrderId());
                        orderSubModel.setCurStatusId("0307");
                        orderSubModel.setCurStatusNm("支付失败");
                        orderSubDao.updateOrder(orderSubModel);
                        tblOrder.setCurStatusId("0307");
                        tblOrder.setCurStatusNm("支付失败");
                        orderMainFlag = false;
                        /** 支付成功，bps失败 插入积分负交易 start**/
                        if(!"".equals(ischeck)||!"".equals(ispont)){
                            OrderCheckModel orderCheck = getObject(tblOrder.getOrderId(), "0307", "支付失败",ischeck,ispont,nowDate,nowTime);
                            String jfRefundSerialno="";
                            if(!"".equals(ispont)){
                                jfRefundSerialno = idGenarator.jfRefundSerialNo();
                            }
                            orderCheck.setJfRefundSerialno(jfRefundSerialno);
                            orderCheckDao.insert(orderCheck);
                            if(!"".equals(ispont)){
                                //如果BPS经过系统审核立即返回“支付失败”时，商城需要向积分系统发起积分撤销，调用积分系统接口
                                //存在积分需要发起撤销积分
                                if(tblOrder.getBonusTotalvalue()!=null && tblOrder.getBonusTotalvalue().longValue()!=0){
                                    try{
                                        //积分撤销时间用当前时间，发送时候与ordercheck一致，对账bms202取ordercheck时间
                                        sendNSCT009(tblOrder,orderCheck.getDoDate(),orderCheck.getDoTime(),jfRefundSerialno);
                                    }catch(Exception se){
                                        log.error("手机分期订单，支付成功，bps失败，主动退积分:"+se.getMessage());
                                    }
                                }
                            }
                        }
                        /** 支付成功，bps失败 插入积分负交易 end  */
                    }
                    // 插入历史记录
                    OrderSubModel orderSubModel = orderSubDao.findById(tblOrder.getOrderId());
                    OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
                    orderDoDetailModel.setOrderId(tblOrder.getOrderId());
                    orderDoDetailModel.setDoTime(new Date());
                    orderDoDetailModel.setDoUserid("System");
                    orderDoDetailModel.setUserType("0");
                    orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
                    orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
                    orderDoDetailModel.setDoDesc("广发分期支付");
                    orderDoDetailModel.setCreateOper("System");
                    orderDoDetailModel.setCreateTime(new Date());
                    orderDoDetailModel.setDelFlag(0);
                    orderDoDetailDao.insert(orderDoDetailModel);
                    TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
                    tblOrderExtend1.setErrorcode(errorCode);
                    tblOrderExtend1.setApproveresult(approveResult);
                    tblOrderExtend1.setFollowdir(followdir);
                    tblOrderExtend1.setCaseid(caseid);
                    tblOrderExtend1.setSpecialcust(specialcust);
                    tblOrderExtend1.setReleasetype(releasetype);
                    tblOrderExtend1.setRejectcode(rejectcode);
                    tblOrderExtend1.setAprtcode(aprtcode);
                    tblOrderExtend1.setOrdernbr(ordernbr);
                    tblOrderExtend1.setOrderId(tblOrder.getOrderId());
                    tblOrderExtend1Dao.updateByOrderId(tblOrderExtend1);
                }else{//如果returnGateWayEnvolopeVo==null,返回状态未明
                    log.info(tblOrder.getOrderId()+"分期订单状态未明");
                    // 更新子订单表
                    OrderSubModel orderSubModel = new OrderSubModel();
                    orderSubModel.setOrderId(tblOrder.getOrderId());
                    orderSubModel.setCurStatusId("0316");
                    orderSubModel.setCurStatusNm("状态未明");
                    orderSubDao.updateOrder(orderSubModel);
                    tblOrder.setCurStatusId("0316");
                    tblOrder.setCurStatusNm("状态未明");
                    //增加操作记录
                    OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
                    orderDoDetailModel.setOrderId(tblOrder.getOrderId());
                    orderDoDetailModel.setDoTime(new Date());
                    orderDoDetailModel.setDoUserid("System");
                    orderDoDetailModel.setUserType("0");
                    orderDoDetailModel.setStatusId("0316");
                    orderDoDetailModel.setStatusNm("状态未明");
                    orderDoDetailModel.setDoDesc("广发分期支付");
                    orderDoDetailModel.setCreateOper("System");
                    orderDoDetailModel.setCreateTime(new Date());
                    orderDoDetailModel.setDelFlag(0);
                    orderDoDetailDao.insert(orderDoDetailModel);
                }
            }
            if (orderMainFlag && ordersTemp.size()>0) {// 大订单成功
                OrderMainModel orderMainModel = new OrderMainModel();
                orderMainModel.setCurStatusId("0308");
                orderMainModel.setCurStatusNm("支付成功");
                orderMainModel.setOrdermainId(tblOrderMain.getOrdermainId());
                orderMainDao.updateOrderMainStatus(orderMainModel);
            } else {// 大订单异常
                OrderMainModel orderMainModel = new OrderMainModel();
                orderMainModel.setCurStatusId("0307");
                orderMainModel.setCurStatusNm("支付失败");
                orderMainModel.setOrdermainId(tblOrderMain.getOrdermainId());
                orderMainDao.updateOrderMainStatus(orderMainModel);
            }
            response.setResult(Boolean.TRUE);
            return response;
        }catch (Exception e){
            log.error("PayService.dealFQorderBpswithTX.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("PayService.dealFQorderBpswithTX.error");
            return response;
        }
    }

	/**
	 * 获取优惠券对账文件表对象
	 * 
	 * @param order_id
	 * @param cur_status_id
	 * @param cur_status_nm
	 * @param ischeck 1代表优惠券需要出对账文件，2代表积分需要出对账文件
	 * @return
	 */
	public OrderCheckModel getObject(String order_id, String cur_status_id, String cur_status_nm, String ischeck,
			String ispoint, String nowDate, String nowTime) {
		OrderCheckModel orderCheck = new OrderCheckModel();
		orderCheck.setOrderId(order_id);
		orderCheck.setCurStatusId(cur_status_id);
		orderCheck.setCurStatusNm(cur_status_nm);
		orderCheck.setDoDate(nowDate);
		orderCheck.setDoTime(nowTime);
		orderCheck.setIscheck(ischeck);
		orderCheck.setIspoint(ispoint);
		orderCheck.setDelFlag(0);
		return orderCheck;
	}

	/**
	 * <p>
	 * Description:组装积分报文
	 * </p>
	 *
	 * @param pageNo
	 * @param cardNo
	 * @return
	 */
	private Document assBonusQueryEnvelope(String pageNo, String cardNo) {
		// 获取信用卡大机改造试运行阶段的参数
		String receiverId = getReceiverId(cardNo);// 旧流程-BPMS 新流程-
		String bmsTraceCode = getBmsTraceCode(cardNo);
		NoAs400GWEnvelopeVo bonusQueryEnvelopeVo = new NoAs400GWEnvelopeVo();
		bonusQueryEnvelopeVo.setCommType("0");// hwh 20150714 改为同步
		// bonusQueryEnvelopeVo.setReceiverId("BPMS");
		bonusQueryEnvelopeVo.setReceiverId(receiverId);
		bonusQueryEnvelopeVo.setSenderId("MALL");
		bonusQueryEnvelopeVo.setSenderSN(getGateWaySeq());
		bonusQueryEnvelopeVo.setSenderDate(DateHelper.getyyyyMMdd());
		bonusQueryEnvelopeVo.setSenderTime(DateHelper.getHHmmss());
		bonusQueryEnvelopeVo.setTradeCode(bmsTraceCode);
		// 组装报文体
		List bodyList = new ArrayList();

		bodyList.add(new String[] { "channelID", "MALL" });
		bodyList.add(new String[] { "midID", "" });
		bodyList.add(new String[] { "midTime", "" });
		bodyList.add(new String[] { "midSN", "" });
		bodyList.add(new String[] { "midTag", "" });

		bodyList.add(new String[] { "currentPage", pageNo });
		bodyList.add(new String[] { "card_no", cardNo });
		bodyList.add(new String[] { "mtype", "" });
		bodyList.add(new String[] { "MOBILE", "" });
		bonusQueryEnvelopeVo.setEnvelopeBody(bodyList);
		return GatewayEnvelopeUtil.genGatewayEnvelope(bonusQueryEnvelopeVo);
	}

	/**
	 * 获取信用卡大机改造试运行阶段的参数
	 *
	 * @param cardNo
	 * @return
	 */
	public String getReceiverId(String cardNo) {
		if (isPractiseRun(cardNo)) {// 试运行ing 试运行结束
			return "JFDJ";
		} else {// 非试运行
			return "BPMS";
		}
	}

	/**
	 * 获取信用卡大机改造试运行阶段查询积分接口交易码的参数
	 *
	 * @param cardNo
	 * @return
	 */
	public String getBmsTraceCode(String cardNo) {
		if (isPractiseRun(cardNo)) {// 试运行ing 试运行结束
			return "bms011";
		} else {// 非试运行
			return "bms002";
		}
	}

    /**
     * 是否使用新方法
     * 试运行标识是0(试运行结束，使用新方法);试运行标识是1(试运行中,如果卡号8、9为是44,则使用新方法)
     *
     * @param cardNo
     * @return
     */
    public boolean isPractiseRun(String cardNo) {
        if (needToUpdateRunFlag()) {//判断是否需要更新runFlag
            // 大机试运行
            Response<List<TblCfgProCodeModel>> response = cfgProCodeService.findProCodeInfo();
            if(!response.isSuccess()){
                log.error("Response.error,error code: {}", response.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
            }
            List<TblCfgProCodeModel> list = response.getResult();
            log.info("大机试运行标识 list:" + list);
            if (null == list || 0 == list.size()) {
                log.info("没有维护大机参数 默认为大机试运行结束");
                runFlag = "0";
            } else {
                TblCfgProCodeModel codeModel = list.get(0);
                //如果试运行标识为空，则给默认值1（试运行结束）
                String pro_pri = String.valueOf(codeModel.getProPri());
                log.info("大机试运行标识 pro_pri:" + pro_pri);
                cardNoSubStr = String.valueOf(codeModel.getProDesc());
                log.info("大机试运行卡号8,9位:" + cardNoSubStr);
                if (0 == pro_pri.length()) {
                    runFlag = "0";
                } else {
                    runFlag = pro_pri;//更新runFlag
                }
                runFlag = pro_pri;//更新runFlag
                list.clear();
            }
        }
        log.info("试运行标识 0试运行结束,1试运行:" + runFlag);
        if ("0".equals(runFlag)) {//0 试运行结束，使用新方法
            return true;
        } else if ("1".equals(runFlag)) {//1试运行中，如果卡号8、9位是44的，就走新流程。
            //卡号为空或者卡长度不够9位
            if (null == cardNo || cardNo.length() < 9) {
                return false;
            } else {
                //卡号第8、9为是44，走新流程
                if (cardNoSubStr != null && cardNoSubStr.length() == 2) {
                    if (cardNoSubStr.charAt(0) == cardNo.charAt(7) && cardNoSubStr.charAt(1) == cardNo.charAt(8)) {
                        return true;
                    }
                }
            }
            return false;
        }
        log.error("大机试运行标识异常:" + runFlag);
        return true; //默认试运行结束
    }

	/**
	 * 检查runFlag是否需求更新
	 * 如果runFlag为空
	 */
	private static boolean needToUpdateRunFlag() {
		//初始化时候 标识位空时候，查询数据库
		if (null == runFlag || 0 == runFlag.length()) {
			log.info("runFlag:" + runFlag);
			return true;
		}
		return false;
	}

	private static String getGateWaySeq() {

		Random ran = new Random();
		int ranInt = ran.nextInt(9999);
		if (ranInt < 10) {
			ranInt = ranInt * 1000;
		} else if (ranInt < 100) {
			ranInt = ranInt * 100;
		} else if (ranInt < 1000) {
			ranInt = ranInt * 10;
		}
		String gatewaySeq = DateHelper.getyyyyMMdd() + DateHelper.getHHmmss() + genSeq() + ranInt;
		return gatewaySeq;
	}

	private static long genSeq() {
		if (gwSeq >= 9999) {
			gwSeq = 1000;
		}
		gwSeq++;
		return gwSeq;
	}

	/**
	 * <p>
	 * Description:返回客户优先发货等级
	 * </p>
	 *
	 * @param cardLevelList 积分系统返回得到的卡号list
	 * @param cardCodeList cc下单得到的卡号
	 * @return
	 */
	private String getCustLevel(List cardLevelList, List cardCodeList) {
		log.info("getCustLevel遍历卡等级，取得最优客户等级 ，返回客户优先发货等级");
		// 遍历卡数组，取得最优客户等级
		// 如果还是没有取到相应的数据，则默认返回等级A,金普卡
		String cust_type = Contants.CUST_LEVEL_CODE_A;
		String custLevel = null;
		String custType = Contants.CUST_LEVEL_CODE_A;
		for (int i = 0; i < cardLevelList.size(); i++) {
			String formatId = (String) cardCodeList.get(i);// 卡对应的卡板数据
			custLevel = (String) cardLevelList.get(i);
			if (Contants.LEVEL_CODE_44.equals(custLevel)) {// 顶级卡
				custType = Contants.CUST_LEVEL_CODE_C;
			} else if (Contants.LEVEL_CODE_33.equals(custLevel)) {// 白金卡
				Response<LocalCardRelateModel> localCardRelateResponse = localCardRelateService
						.findByFormatId(formatId);// 先查询卡板信息
				if (localCardRelateResponse.isSuccess()) {
					LocalCardRelateModel localCardRelate = localCardRelateResponse.getResult();
					if (localCardRelate != null && "2".equals(localCardRelate.getProCode())) {
						custType = Contants.CUST_LEVEL_CODE_C;// 增值白金
					} else {
						custType = Contants.CUST_LEVEL_CODE_B;// 尊越/臻享白金+钛金卡
					}
				} else {
					custType = Contants.CUST_LEVEL_CODE_B;// 尊越/臻享白金+钛金卡
				}
			} else if (Contants.LEVEL_CODE_22.equals(custLevel)) {// 钛金卡
				custType = Contants.CUST_LEVEL_CODE_B;// 尊越/臻享白金+钛金卡
			}
			cust_type = cust_type.compareTo(custType) > 0 ? cust_type : custType;// 最终获得客户卡的最优客户级别
		}
		log.info("getCustLevel查询南航白金卡取得最优客户等级为:" + cust_type);
		return cust_type;

	}

	/**
	 * <p>
	 * Description:组装list
	 * </p>
	 *
	 * @param array
	 * @param list
	 * @return
	 * @author:panhui
	 * @update:2013-5-31
	 */
	private List assArrayInList(String[] array, List list) {
		for (int index = 0; index < array.length; index++) {
			list.add(array[index].trim());
		}
		return list;
	}

	/**
	 * 支付返回状态未明，小单状态置为“状态未明”
	 *
	 * @param list
	 * @param cardNo
	 * @param cardType
	 * @param errCode
	 * @param doDesc
	 */
	@Override
	public void dealNoSureOrderswithTX(List list, String cardNo, String cardType, String errCode, String doDesc) {
		orderTradeManager.dealNoSureOrderswithTX(list, cardNo, cardType, errCode, doDesc);
	}

	/**
	 * 处理支付失败订单信息(微信渠道)
	 *
	 * @param list
	 * @param ordermainId
	 * @param cardNo
	 */
	@Override
	public void dealWXFailOrderswithTX(List list, String ordermainId, String cardNo) {
		orderTradeManager.dealWXFailOrderswithTX(list, ordermainId, cardNo);
	}

	/**
	 * 处理bps分期支付信息(微信渠道)
	 * 
	 */
	@Override
	public void dealWXFQorderBpswithTX(List<OrderCheckModel> orderCheckList2, List<OrderCheckModel> orderCheckList, List<String> goodsIdList, List<OrderSubModel> dealPointPoolList, List<TblOrderExtend1Model> tblOrderExtend1ModelIns,
            List<TblOrderExtend1Model> tblOrderExtend1Modelupd, OrderMainModel orderMainModel, List<OrderSubModel> orderSubList, List<OrderDoDetailModel> orderDoDetailModelList) throws Exception {
		// 事物处理
		orderTradeManager.processInstallmentWX(orderCheckList2, orderCheckList, goodsIdList, dealPointPoolList,
				tblOrderExtend1ModelIns, tblOrderExtend1Modelupd, orderMainModel, orderSubList, orderDoDetailModelList);
	}

	/**
	 * 其他渠道在微信继续支付，修改订单渠道和创建时间
	 *
	 * @param ordermainId
	 * @param orderId
	 * @param sourceId
	 * @param sourceName
	 */
	@Override
	public void updateWXOrderSourcewithTX(String ordermainId, String orderId, String sourceId, String sourceName,
			Date date) {
		orderTradeManager.updateWXOrderSourcewithTX(ordermainId, orderId, sourceId, sourceName, date);
	}

	/**
	 * 发起撤销积分申请
	 *
	 * @param order
	 * @param curDate 撤销日期
	 * @param curTime 撤销时间
	 * @param jfRefundSerialno 撤销流水 jfRefundSerialno退积分流水
	 */
	private void sendNSCT009(OrderSubModel order, String curDate, String curTime, String jfRefundSerialno)
			throws Exception {
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
		gateWayEnvolopeVo.setSendDate(DateHelper.date2string(order.getOrder_succ_time(), "yyyyMMdd")); // 原发起方日期
		gateWayEnvolopeVo.setSendTime(DateHelper.date2string(order.getOrder_succ_time(), "HHmmss")); // 原发起方时间
		gateWayEnvolopeVo.setSerialNo(order.getOrderIdHost()); // 原发起方流水号
		gateWayEnvolopeVo.setCardNo(order.getCardno()); // 卡号
		gateWayEnvolopeVo.setExpiryDate("0000"); // 卡片有效期
		gateWayEnvolopeVo.setPayMomey(new BigDecimal(0)); // 现金支付金额(默认送0)
		gateWayEnvolopeVo.setJgId(Contants.JGID_COMMON); // 积分类型
		gateWayEnvolopeVo.setDecrementAmt(order.getBonusTotalvalue()); // 扣减积分额
		gateWayEnvolopeVo.setTerminalNo("01"); // 终端号("01"广发商城，"02"积分商城)
		BaseResult baseResult = paymentService.returnPoint(gateWayEnvolopeVo);
	}

	/**
	 * <p>
	 * Description:上送积分系统渠道标志转换
	 * </p>
	 *
	 * @param sourceId
	 * @return
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
		if (Contants.SOURCE_ID_APP.equals(sourceId)){
			return Contants.SOURCE_ID_APP_TYPY;
		}
		return Contants.SOURCE_ID_MALL_TYPY;
	}

	/**
	 * 微信0元秒杀下单
	 * 
	 * @param orderMainModel 主订单
	 * @param orderSubModel 子订单
	 * @param orderDoDetailModel 订单操作历史
	 * @param orderOutSystemModel 订单推送
	 * @param user 用户
	 * @param paramMap 其他参数
	 *
	 *            geshuo 20160818
	 */
	@Override
	public Response<Boolean> paywithTX(OrderMainModel orderMainModel, OrderSubModel orderSubModel,
			OrderDoDetailModel orderDoDetailModel, OrderOutSystemModel orderOutSystemModel, User user,
			Map<String, String> paramMap) {

		Response<Boolean> response = Response.newResponse();
		try {
			// 调用Manager，下单不成功可以进行回滚
			payManager.paywithTX(orderMainModel, orderSubModel, orderDoDetailModel, orderOutSystemModel, user,
					paramMap);
			response.setResult(Boolean.TRUE);
		} catch (ResponseException re) {
			response.setError(re.getMessage());
		} catch (Exception e) {
			log.error("PayServiceImpl.paywithTX.error Exception:{}", Throwables.getStackTraceAsString(e));
			response.setError("PayServiceImpl.paywithTX.error");
		}
		return response;
	}

    public Map<String,String> saveFQOrdersWithTX(OrderMainModel orderMain,Map orderMap,String businessType,List goodsList) throws Exception{
        Map<String,String> returnMap = new HashMap<>();
        if(orderMap!=null&&orderMain!=null){
            orderMainDao.insert(orderMain);
            //保存小订单
            List order = (List)orderMap.get("tblOrder");
            if(order!=null&&order.size()>0){
                for (int i = 0; i < order.size(); i++) {
                    OrderSubModel tblOrder = (OrderSubModel)order.get(i);
                    tblOrder.setOrder_succ_time(orderMain.getCreateTime());
                    orderSubDao.insert(tblOrder);
                    //如果是生日价购买需要扣减生日使用次数
                    if(Contants.PAYWAY_MENBER_LEVEL_BIRTHDAY.equals(tblOrder.getMemberLevel())){
                        int row = 0;
                        Map<String,Object> paramMap = new HashMap<>();
                        paramMap.put("custId",tblOrder.getCreateOper());
                        paramMap.put("goodsCount",tblOrder.getGoodsNum().intValue());
                        paramMap.put("birthLimitCount", "1");
                        Response<Integer> rowResponse = espCustNewService.updateCustNewByParams(paramMap);
                        if(rowResponse.isSuccess()){
                            row = rowResponse.getResult();
                        }
                        if(row<=0){
                            returnMap.put("returnCode","000102");
                            returnMap.put("returnDesc","生日当月已兑换过生日礼品，本次兑换不成功");
                            return returnMap;
                        }
                    }
                }
            }

            //保存订单历史表
            List detail = (List)orderMap.get("tblOrderDodetail");
            List<OrderDoDetailModel> orderDoDetailModelList = new ArrayList<OrderDoDetailModel>();
            if(detail!=null&&detail.size()>0){
                for (int j = 0; j < detail.size(); j++) {
                    OrderDoDetailModel orderDodetail = (OrderDoDetailModel)detail.get(j);
                    orderDodetail.setDelFlag(0);
                    orderDodetail.setCreateOper(orderMain.getCreateOper());
                    orderDodetail.setCreateTime(new Date());
                    orderDoDetailModelList.add(orderDodetail);
                }
                //订单处理明细
                log.info("保存订单处理明细");
                if (orderDoDetailModelList != null && orderDoDetailModelList.size() != 0) {
                    orderDoDetailDao.insertBatch(orderDoDetailModelList);
                }
            }

			for (int k = 0; k < goodsList.size(); k++) {
				Map map = (Map) goodsList.get(k);
				String goodsId = (String) map.get("goodsId");
				String goodsNum = (String) map.get("goodsNum");
				// 扣减商品数量
				Response<Integer> countResponse = itemService.subtractStock(goodsId, Long.valueOf(goodsNum));// 减库存
				int goodsRow = 0;
				if (countResponse.isSuccess()) {
					goodsRow = countResponse.getResult();
				}
				if (goodsRow == 0) {
					returnMap.put("returnCode", "000074");
					returnMap.put("returnDesc", "商品数量不足");
					return returnMap;
				}
				// 扣减积分
				String bonusVal = (String) map.get("bonusVal");
				if (bonusVal != null && !"".equals(bonusVal) && Long.valueOf(bonusVal) > 0) {
					Map<String, Object> params = Maps.newHashMap();
					params.put("cur_month", DateHelper.getyyyyMM());
					params.put("used_point", bonusVal);
					pointsPoolService.subtractPointPool(params);
				}

                String actType =  (String) map.get("actType");
                // 广发下单团购时增加活动人数
//                if("00".equals(businessType) && Contants.TBL_ORDER_ACT_TYPE_TG.equals(actType)){
//                    tblEspGoodsActBySqlDao.addActionByGoodsIdAndNum(goodsId, Integer.parseInt(goodsNum), Contants.TBL_ESP_GOODS_ACT_ACTION_TYPE_TG);
//                }
            }
        }
        return null;
    }

	/**
	 * 处理bps分期支付信息
	 * 
	 * @param orderMainModel
	 * @param orderSubModelList
	 * @param orderCheckList
	 * @param goodsIdList
	 * @param dealPointPoolList
	 * @param tblOrderExtend1Modelupd
	 * @param orderDoDetailModelList
	 * @param orderExtend1ModelIns
	 * @throws Exception
	 */
	public void dealFQorderBpswithTX(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList,
			List<OrderCheckModel> orderCheckList, List<String> goodsIdList, List<OrderSubModel> dealPointPoolList,
			List<TblOrderExtend1Model> tblOrderExtend1Modelupd, List<TblOrderExtend1Model> orderExtend1ModelIns,
			List<OrderDoDetailModel> orderDoDetailModelList) throws Exception {
		// 事物处理
		orderTradeManager.dealFQorderBpswithTX(orderMainModel, orderSubModelList, orderCheckList, goodsIdList,
				dealPointPoolList, tblOrderExtend1Modelupd, orderExtend1ModelIns, orderDoDetailModelList);

	}

	/**
	 *
	 * @param tblOrder
	 * @param itemModel
	 * @param orderDetail
	 * @param tblOrderExtend1
	 * @param orderCheck
     * @param orderHistory
	 * for StageMallOrderUpdateStateProvideServiceImpl
     */
	@Override
	public void orderChangeWithTX(OrderSubModel tblOrder, ItemModel itemModel, OrderDoDetailModel orderDetail,
								  TblOrderExtend1Model tblOrderExtend1, OrderCheckModel orderCheck,
								  TblOrderHistoryModel orderHistory) throws Exception  {
		orderTradeManager.orderChangeWithTX(tblOrder,itemModel,orderDetail,tblOrderExtend1,orderCheck,
				orderHistory);
	}

	/**
	 *
	 * @param tblOrder
	 * @param orderDetail
	 * @param runTime
	 * @param tblOrderExtend1
	 * @param orderCheck
     * @param orderHistory
	 * for StageMallOrderUpdateStateProvideServiceImpl
     */
	@Override
	public void orderChangeSuccessWithTX(OrderSubModel tblOrder, OrderDoDetailModel orderDetail, Map<String, String> runTime,
										 TblOrderExtend1Model tblOrderExtend1, OrderCheckModel orderCheck,
										 TblOrderHistoryModel orderHistory)  throws Exception {
		orderTradeManager.orderChangeSuccessWithTX(tblOrder, orderDetail, runTime, tblOrderExtend1, orderCheck, orderHistory);
	}
}
