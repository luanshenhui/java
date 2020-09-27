package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.OrderTieinSaleService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.service.CfgPriceSystemService;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.exception.TradeException;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.service.OrderIOServiceImpl;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.EspCustNewService;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by 11141021040453 on 2016/5/12.
 */
@Component
@Transactional
@Slf4j
public class OrderSubManager {

	@Resource
	OrderSubDao orderSubDao;
	@Resource
	OrderDoDetailDao orderDoDetailDao;
	@Resource
	OrderPartBackDao orderPartBackDao;
	@Resource
	OrderReturnTrackDao orderReturnTrackDao;
	@Resource
	OrderTransDao orderTransDao;
	@Resource
	ItemService itemService;
	@Resource
	TblOrderHistoryDao tblOrderHistoryDao;
	@Resource
	OrderCheckDao orderCheckDao;
	@Resource
	TblOrderExtend1Dao tblOrderExtend1Dao;
	@Resource
	TblOrderExtend2Dao tblOrderExtend2Dao;
	@Resource
	OrderClearDao orderClearDao;
	@Resource
	PaymentService paymentService;
	@Resource
	OrderTieinSaleService orderTieinSaleService;
	@Resource
	private GoodsPayWayService goodsPayWayService;
	@Resource
	OrderReturnTrackDetailDao orderReturnTrackDetailDao;
	@Resource
	OrderCancelDao orderCancelDao;
	@Resource
	MallPromotionService mallPromotionService;
	@Resource
	EspCustNewService espCustNewService;
	@Resource
	private CfgPriceSystemService cfgPriceSystemService;
	@Resource
	private VendorService vendorService;
	@Value("#{app.merchId}")
	private String orderMerchentId;

	/*
	 * 更新订单状态
	 *
	 * @param orderSubModel
	 * 
	 * @return
	 */
	public Boolean update(OrderSubModel orderSubModel) {
		return orderSubDao.update(orderSubModel) == 1;
	}

	public Integer update1(OrderSubModel model){
		return orderSubDao.update(model);
	}

	/**
	 * 供应商更新订单状态及订单履历 拒签，签收，无人签收
	 *
	 * @param orderSubModel
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateSignVendor(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel)
			throws Exception {
		String curStatusId = orderSubModel.getCurStatusId();
		try {
			String orderId = orderSubModel.getOrderId();
			OrderSubModel orderSubModel1 = orderSubDao.findById(orderId);
			if (orderSubModel1 == null) {
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					log.error("orderId:" + orderId + ",orderSubManager updateSignVendor orderSubModel not exist");
					throw new TradeException("OrderSubModel.non-exist");
				}
				BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
				tblOrderHistoryDao.update(tblOrderHistoryModel);
			} else {
				orderSubDao.update(orderSubModel);
			}
			orderDoDetailDao.insert(orderDoDetailModel);
			// 接口调用时间与数据库插入时间保持一致
			Date dateTime = new Date();
			String dateAndTime = DateHelper.getyyyyMMddHHmmss(dateTime);
			String nowDate = DateHelper.getyyyyMMdd(dateTime);
			String nowTime = DateHelper.getHHmmss(dateTime);
			if (Contants.SUB_ORDER_STATUS_0380.equals(curStatusId)
					|| Contants.SUB_ORDER_STATUS_0381.equals(curStatusId)) {
				// 拒绝签收 无人签收
				// 广发商城分期
				if (Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
					BigDecimal totalMoney = orderSubModel.getTotalMoney();
					// todo 校验
					if (!(BigDecimal.ZERO.compareTo(totalMoney) == 0)) {
						// 调用接口
						BaseResult baseResult = new BaseResult();
						ReturnGoodsInfo returnGoodsInfo = new ReturnGoodsInfo();
						returnGoodsInfo = makeReturnGoodsInfo(orderSubModel);
						returnGoodsInfo.setOperTime(dateAndTime);
						baseResult = paymentService.returnGoods(returnGoodsInfo);
						if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
							log.error("OrderSubManager updateSignVendor ,paymentService call NSCT018APi failed");
							throw new TradeException("call.NSCT018APi.failed");
						}
					}
					// 插入积分优惠券对账文件
					insertOrderCheck(orderSubModel, nowDate, nowTime);
				}
				if (Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())) {
					long time = ((new Date()).getTime() - orderSubModel.getCreateTime().getTime())
							/ (24 * 60 * 60 * 1000);
					// 超过180天
					if (time > 180) {
						log.info("订单下单时间已超过180天,无法退换积分！");
					} else {
						// 订单取消表 默认积分总数大于0
						insertOrderCanncel(orderSubModel);
					}
					// 是否用钱，用钱的情况下调用接口
					if ((BigDecimal.ZERO.compareTo(orderSubModel.getTotalMoney()) == 0)) {
						// donothing
					} else {
						// 交易总金额
						String cal_mon = "0.00";
						// 银联商户号是否存才
						Response<VendorInfoDto> vendorResponse = vendorService.findById(orderSubModel.getVendorId());
						if (!vendorResponse.isSuccess()) {
							log.error(vendorResponse.getError());
							throw new TradeException(vendorResponse.getError());
						}
						// 查询商品支付方式，获取是否生日价格，清算金额
						Response<TblGoodsPaywayModel> goodsResponse = goodsPayWayService
								.findGoodsPayWayInfo(orderSubModel.getGoodsPaywayId());
						if (!goodsResponse.isSuccess()) {
							log.error(goodsResponse.getError());
							throw new TradeException(goodsResponse.getError());
						}
						if (goodsResponse.getResult() != null) {
							// 如果为生日价购买的话，需取得生日折扣比例
							if ("1".equals(goodsResponse.getResult().getIsBirth())) {
								Response<List<CfgPriceSystemModel>> priceResponse = cfgPriceSystemService
										.findByPriceSystemId(Contants.BIRTH_CODE);
								if (!priceResponse.isSuccess()) {
									log.error("order.birth.is.error");
									throw new TradeException("order.birth.is.error");
								}
								// 判断关键数据是否为空
								// 设置交易总金额
								if (priceResponse.getResult() != null && priceResponse.getResult().size() != 0
										&& priceResponse.getResult().get(0).getArgumentOther() != null
										&& goodsResponse.getResult().getCalMoney() != null) {
									cal_mon = new BigDecimal(priceResponse.getResult().get(0).getArgumentOther().toString())
											.multiply(new BigDecimal(goodsResponse.getResult().getCalMoney().toString()))
											.setScale(2, BigDecimal.ROUND_HALF_UP).toString();
								} else {
									cal_mon = goodsResponse.getResult().getCalMoney() == null ? cal_mon
											: goodsResponse.getResult().getCalMoney().toString();
								}
							} else {
								cal_mon = goodsResponse.getResult().getCalMoney() == null ? cal_mon
										: goodsResponse.getResult().getCalMoney().toString();
							}
						}

						// 整理发送外部接口数据
						PointsMallReturnGoodsInfo pointsMallReturnGoodsInfo = new PointsMallReturnGoodsInfo();
						pointsMallReturnGoodsInfo.setOrderId(orderSubModel.getOrderId());// 小订单号
						pointsMallReturnGoodsInfo.setOrderNumber(orderSubModel.getOrdermainId());// 大订单号
						pointsMallReturnGoodsInfo.setChannel("MALL");// 渠道标识
						pointsMallReturnGoodsInfo.setOrderTime(orderSubModel.getCreateTime()); // 订单生成时间
						pointsMallReturnGoodsInfo.setOperTime(new Date());// 请款退货时间
						pointsMallReturnGoodsInfo.setAcrdNo(orderSubModel.getCardno());// 账号
						pointsMallReturnGoodsInfo.setTradeMoney(new BigDecimal(cal_mon));// 交易总金额
						pointsMallReturnGoodsInfo.setCashMoney(orderSubModel.getTotalMoney());// 现金支付金额
						pointsMallReturnGoodsInfo.setIntegralMoney(new BigDecimal("0.00"));// 积分抵扣金额
						pointsMallReturnGoodsInfo.setMerId(orderMerchentId);// 商城商户号
						pointsMallReturnGoodsInfo.setMerno(""); // 小商户号
						pointsMallReturnGoodsInfo.setQsvendorNo(vendorResponse.getResult().getUnionPayNo());// 银联商户号
						pointsMallReturnGoodsInfo.setCategoryNo("");// 计费费率编号
						pointsMallReturnGoodsInfo.setOrderNbr("");// 银行订单号
						pointsMallReturnGoodsInfo.setStagesNum("");// 分期期数
						pointsMallReturnGoodsInfo.setOperId("");// 操作员
						pointsMallReturnGoodsInfo.setPayee("");// 01行方 不送或空值代表客户

						// 012接口发送
						handleReturnGoodsInt(orderSubModel, pointsMallReturnGoodsInfo);
					}
				}

			}
		} catch (TradeException e) {
			throw e;
		}
		return Boolean.TRUE;
	}

	/**
	 * 供应商更新订单状态及订单履历及退货
	 * 
	 * @param orderSubModel
	 * @param orderDoDetailModel
	 * @param orderReturnTrackDetailModel
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateReturnVendor(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
			OrderReturnTrackDetailModel orderReturnTrackDetailModel) throws Exception {
		String orderId = orderSubModel.getOrderId();
		String ordertypeId = orderSubModel.getOrdertypeId();
		String sinStatusId = orderSubModel.getSinStatusId();

		try {
			orderSubDao.update(orderSubModel);
			orderDoDetailDao.insert(orderDoDetailModel);
			orderReturnTrackDetailDao.insert(orderReturnTrackDetailModel);
			// 判断支付金额是否为零
			// 请款中
			OrderClearModel orderClearModel = orderClearDao.findByOrderId(orderId);
			// 正在请款跑批 无法退货
			if (orderClearModel != null && "2".equals(orderClearModel.getClearflag())) {
				log.error("order.be.requesting.money.can.not.returnGoods");
				throw new TradeException("order.be.requesting.money.can.not.returnGoods");
			}
			// 接口调用时间与数据库插入时间保持一致
			Date dateTime = new Date();
			String dateAndTime = DateHelper.getyyyyMMddHHmmss(dateTime);
			String nowDate = DateHelper.getyyyyMMdd(dateTime);
			String nowTime = DateHelper.getHHmmss(dateTime);
			// 供应商操作直接退货
			// 广发商城
			if (!Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
				if (Contants.BUSINESS_TYPE_FQ.equals(ordertypeId)) {
					if ((BigDecimal.ZERO.compareTo(orderSubModel.getTotalMoney()) == 0)
							&& (Contants.SUB_SIN_STATUS_0300.equals(sinStatusId)
									|| Contants.SUB_SIN_STATUS_0332.equals(sinStatusId)
									|| StringUtils.isBlank(sinStatusId))) {
						// donothing
					} else {
						ReturnGoodsInfo returnGoodsInfo = makeReturnGoodsInfo(orderSubModel);
						returnGoodsInfo.setOperTime(dateAndTime);
						BaseResult baseResult = paymentService.returnGoods(returnGoodsInfo);
						if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
							log.error("OrderSubManager updateReturnVendor,paymentService call.NSCT018APi.failed");
							throw new TradeException("call.NSCT018APi.failed");
						}
					}
					if (orderClearModel != null
							&& Contants.SUB_SIN_STATUS_0350.equals(orderSubModel.getSinStatusId())) {
						// 如果该订单请款状态为“同意请款”，则需要定时任务的请款订单剔除任务。
						orderClearModel.setClearflag("1");
						orderClearModel.setExtend1("剔除任务");
						orderClearDao.update(orderClearModel);
					}
					// 插入积分优惠券对账文件
					insertOrderCheck(orderSubModel, nowDate, nowTime);
				}
			} else {
				// 积分商城
				// 交易总金额
				String cal_mon = "0.00";
				// 银联商户号是否存才
				Response<VendorInfoDto> vendorResponse = vendorService.findById(orderSubModel.getVendorId());
				if (!vendorResponse.isSuccess()) {
					log.error(vendorResponse.getError());
					throw new TradeException(vendorResponse.getError());
				}
				// 查询商品支付方式，获取是否生日价格，清算金额
				Response<TblGoodsPaywayModel> goodsResponse = goodsPayWayService
						.findGoodsPayWayInfo(orderSubModel.getGoodsPaywayId());
				if (!goodsResponse.isSuccess()) {
					log.error(goodsResponse.getError());
					throw new TradeException(goodsResponse.getError());
				}
				if (goodsResponse.getResult() != null) {
					// 如果为生日价购买的话，需取得生日折扣比例
					if ("1".equals(goodsResponse.getResult().getIsBirth())) {
						Response<List<CfgPriceSystemModel>> priceResponse = cfgPriceSystemService
								.findByPriceSystemId(Contants.BIRTH_CODE);
						if (!priceResponse.isSuccess()) {
							log.error("order.birth.is.error");
							throw new TradeException("order.birth.is.error");
						}
						// 判断关键数据是否为空
						// 设置交易总金额
						if (priceResponse.getResult() != null && priceResponse.getResult().size() != 0
								&& priceResponse.getResult().get(0).getArgumentOther() != null
								&& goodsResponse.getResult().getCalMoney() != null) {
							cal_mon = new BigDecimal(priceResponse.getResult().get(0).getArgumentOther().toString())
									.multiply(new BigDecimal(goodsResponse.getResult().getCalMoney().toString()))
									.setScale(2, BigDecimal.ROUND_HALF_UP).toString();
						} else {
							cal_mon = goodsResponse.getResult().getCalMoney() == null ? cal_mon
									: goodsResponse.getResult().getCalMoney().toString();
						}
					} else {
						cal_mon = goodsResponse.getResult().getCalMoney() == null ? cal_mon
								: goodsResponse.getResult().getCalMoney().toString();
					}
				}

				// 整理发送外部接口数据
				PointsMallReturnGoodsInfo pointsMallReturnGoodsInfo = new PointsMallReturnGoodsInfo();
				pointsMallReturnGoodsInfo.setOrderId(orderSubModel.getOrderId());// 小订单号
				pointsMallReturnGoodsInfo.setOrderNumber(orderSubModel.getOrdermainId());// 大订单号
				pointsMallReturnGoodsInfo.setChannel("MALL");// 渠道标识
				pointsMallReturnGoodsInfo.setOrderTime(orderSubModel.getCreateTime()); // 订单生成时间
				pointsMallReturnGoodsInfo.setOperTime(new Date());// 请款退货时间
				pointsMallReturnGoodsInfo.setAcrdNo(orderSubModel.getCardno());// 账号
				pointsMallReturnGoodsInfo.setTradeMoney(new BigDecimal(cal_mon));// 交易总金额
				pointsMallReturnGoodsInfo.setCashMoney(orderSubModel.getTotalMoney());// 现金支付金额
				pointsMallReturnGoodsInfo.setIntegralMoney(new BigDecimal("0.00"));// 积分抵扣金额
				pointsMallReturnGoodsInfo.setMerId(orderMerchentId);// 商城商户号
				pointsMallReturnGoodsInfo.setMerno(""); // 小商户号
				pointsMallReturnGoodsInfo.setQsvendorNo(vendorResponse.getResult().getUnionPayNo());// 银联商户号
				pointsMallReturnGoodsInfo.setCategoryNo("");// 计费费率编号
				pointsMallReturnGoodsInfo.setOrderNbr("");// 银行订单号
				pointsMallReturnGoodsInfo.setStagesNum("");// 分期期数
				pointsMallReturnGoodsInfo.setOperId("");// 操作员
				pointsMallReturnGoodsInfo.setPayee("");// 01行方 不送或空值代表客户

				// 退货接口发送
				handleReturnGoodsInt(orderSubModel, pointsMallReturnGoodsInfo);
				// 积分商城操作 取消表插入
				insertOrderCanncel(orderSubModel);
			}

		} catch (TradeException e) {
			log.error("trade 退货 cause by{}", Throwables.getStackTraceAsString(e));
			throw e;
		}

		return Boolean.TRUE;
	}

	/**
	 * 处理退货发送到电子支付的入口类 实现以下方案： 1）如果该订单请款状态为“请款成功”，则需要调支付的接口将退货流水给到电子支付；
	 * 2）如果该订单请款状态为“同意请款”，则需要定时任务的请款订单剔除任务，后续不发送给电子支付（如果是积分+现金的订单，仍需要推送给电子支付进行客户退款）；
	 * 3）如果该订单请款状态为“未请款”、“请款申请”、“拒绝请款申请”，则不需要调用电子支付的退货接口（如果是积分+现金的订单，仍需要推送给电子支付进行客户退款）。
	 * 5）当退货流水中，银联商户号字段为空时，该笔流水不发送给电子支付进行退货清算，直接修改为退货成功，现金部分的退货需要业务手动线下处理。
	 *
	 * @param orderSubModel
	 * @param pointsMallReturnGoodsInfo
	 */
	private void handleReturnGoodsInt(OrderSubModel orderSubModel,
			PointsMallReturnGoodsInfo pointsMallReturnGoodsInfo) {
		BaseResult baseResult = null;
		// 请款成功
		if (Contants.SUB_SIN_STATUS_0311.equals(orderSubModel.getSinStatusId())) {
			baseResult = paymentService.pointsMallReturnGoods(pointsMallReturnGoodsInfo);
		} else if ((Strings.isNullOrEmpty(orderSubModel.getSinStatusId())
				|| "0000".equals(orderSubModel.getSinStatusId())
				|| Contants.SUB_SIN_STATUS_0332.equals(orderSubModel.getSinStatusId())
				|| Contants.SUB_SIN_STATUS_0333.equals(orderSubModel.getSinStatusId()))
				&& new BigDecimal(orderSubModel.getTotalMoney().toString()).compareTo(new BigDecimal(0)) > 0
				&& new BigDecimal(orderSubModel.getBonusTotalvalue().toString()).compareTo(new BigDecimal(0)) > 0) {
			// 未请款 = [space or 0000] or 0332 请款申请 or 0333 拒绝请款
			baseResult = paymentService.pointsMallReturnGoods(pointsMallReturnGoodsInfo);
		} else if (Contants.SUB_SIN_STATUS_0350.equals(orderSubModel.getSinStatusId())) {
			// 自动任务的前置状态是否在执行
			OrderClearModel orderClear = orderClearDao.findByOrderId(orderSubModel.getOrderId());
			if (orderClear != null) {
				// 剔除任务
				orderClear.setClearflag(Contants.CLEAR_TASK_FLAG_1);
				orderClear.setExtend1("剔除任务");
				orderClearDao.update(orderClear);
			}
			if (new BigDecimal(orderSubModel.getTotalMoney().toString()).compareTo(new BigDecimal(0)) > 0
					&& new BigDecimal(orderSubModel.getBonusTotalvalue().toString()).compareTo(new BigDecimal(0)) > 0) {
				baseResult = paymentService.pointsMallReturnGoods(pointsMallReturnGoodsInfo);
			}
		}
		if (baseResult != null && !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
			throw new TradeException("call.NSCT012APi.failed");
		}

	}

	private void insertOrderCheck(OrderSubModel orderSubModel, String nowDate, String nowTime) throws Exception {
		long time = ((new Date()).getTime() - orderSubModel.getCreateTime().getTime()) / (24 * 60 * 60 * 1000);
		// 判断是否超过180且使用优惠券
		// 超过180天
		if (time > 180) {
			log.info("订单下单时间已超过180天,不出具优惠券积分对账文件！");
		} else {
			// 没超过180天
			// 判断是否使用优惠券或积分
			if ((orderSubModel.getBonusTotalvalue() != null && orderSubModel.getBonusTotalvalue() > 0)
					|| StringUtils.isNotBlank(orderSubModel.getVoucherId())) {
				// 构建对账信息
				OrderCheckModel orderCheckModel = new OrderCheckModel();
				orderCheckModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
				orderCheckModel.setCreateOper(orderSubModel.getModifyOper());
				orderCheckModel.setCurStatusId(orderSubModel.getCurStatusId());
				orderCheckModel.setCurStatusNm(orderSubModel.getCurStatusNm());
				orderCheckModel.setDoDate(nowDate);
				orderCheckModel.setDoTime(nowTime);
				if (orderSubModel.getVoucherNo() != null && !"".equals(orderSubModel.getVoucherNo().trim())) {
					orderCheckModel.setIscheck(Contants.ORDER_ISCHECK_YES);
				}
				if (orderSubModel.getBonusTotalvalue() != null && orderSubModel.getBonusTotalvalue() > 0) {
					orderCheckModel.setIspoint(Contants.ORDER_ISPOINT_YES);
				}
				orderCheckModel.setModifyOper(orderSubModel.getModifyOper());
				orderCheckModel.setOrderId(orderSubModel.getOrderId());
				orderCheckDao.insert(orderCheckModel);
			}
		}
	}

	private ReturnGoodsInfo makeReturnGoodsInfo(OrderSubModel orderSubModel) throws Exception {
		ReturnGoodsInfo returnGoodsInfo = new ReturnGoodsInfo();
		returnGoodsInfo.setTradChannel("EBS");
		returnGoodsInfo.setTradSource("#SC");
		returnGoodsInfo.setBizSight("00");
		// 交易码
		String actType = orderSubModel.getActType();
		if (!StringUtils.isBlank(actType)) {
			switch (actType) {
			case "10":
				returnGoodsInfo.setTradeCode("12");// 12折扣
				break;
			case "20":
				returnGoodsInfo.setTradeCode("11");// 11减满
				break;
			case "30":
				returnGoodsInfo.setTradeCode("13");// 13秒杀
				break;
			case "40":
				returnGoodsInfo.setTradeCode("14");// 14团购
				break;
			case "50":
				returnGoodsInfo.setTradeCode("08");// 08荷兰式拍卖业务
				break;
			default:
				break;
			}
		}
		// 支付账号
		returnGoodsInfo.setAcrdNo(orderSubModel.getCardno());
		// 小订单号
		returnGoodsInfo.setOrderId(orderSubModel.getOrderId());
		// 优惠差额
		returnGoodsInfo.setDiscountMoney(orderSubModel.getFenefit());
		BigDecimal goodsPrice = BigDecimal.ZERO.setScale(2);
//		BigDecimal totalMoney = orderSubModel.getTotalMoney();
//		BigDecimal uitdrtamt = orderSubModel.getUitdrtamt();
//		BigDecimal voucherPrice = orderSubModel.getVoucherPrice();
//		if (totalMoney != null) {
//			goodsPrice = goodsPrice.add(totalMoney);
//		}
//		if (uitdrtamt != null) {
//			goodsPrice = goodsPrice.add(uitdrtamt);
//		}
//		if (voucherPrice != null) {
//			goodsPrice = goodsPrice.add(voucherPrice);
//		}
//		//begin商城退款 代码修改 要求退款金额 tradeMoney 应为  payway 表商品原价
		String paywayId=orderSubModel.getGoodsPaywayId();
		Response<TblGoodsPaywayModel> rs=goodsPayWayService.findGoodsPayWayInfoById(paywayId);
		if(rs.isSuccess()){
			goodsPrice=goodsPrice.add(rs.getResult().getGoodsPrice());
		}else{
			log.error("OrderSubManager makeReturnGoodsInfo,orderId:" + orderSubModel.getOrderId()
					+ "paywayId find payway error");
			throw new TradeException("Ordernbr.be.null");
		}
//		//end
		// 交易总金额
		returnGoodsInfo.setTradeMoney(goodsPrice);
		// 分期期数
		returnGoodsInfo
				.setStagesNum(orderSubModel.getStagesNum() != null ? orderSubModel.getStagesNum().toString() : null);
		// 计费费率编号
		returnGoodsInfo.setCategoryNo(orderSubModel.getSpecShopno());
		// 渠道标识
		returnGoodsInfo.setChannel("mall");
		// 积分抵扣金额
		returnGoodsInfo.setIntegralMoney(orderSubModel.getUitdrtamt());
		// 商城商户号
		returnGoodsInfo.setMerId(orderSubModel.getMerId());
		// 操作员
		returnGoodsInfo.setOperId(orderSubModel.getModifyOper());
		List<TblOrderExtend1Model> tblOrderExtend1ModelLists = Lists.newArrayList();
		tblOrderExtend1ModelLists = tblOrderExtend1Dao.findListByOrderId(orderSubModel.getOrderId());
		if (tblOrderExtend1ModelLists == null || tblOrderExtend1ModelLists.isEmpty()) {
			log.error("OrderSubManager makeReturnGoodsInfo,orderId:" + orderSubModel.getOrderId()
					+ "tblOrderExtend1Dao findListByOrderId failed");
			throw new TradeException("Ordernbr.be.null");
		}
		TblOrderExtend1Model tblOrderExtend1Model = tblOrderExtend1ModelLists.get(0);
		if (tblOrderExtend1Model == null || StringUtils.isBlank(tblOrderExtend1Model.getOrdernbr())) {
			log.error("OrderSubManager makeReturnGoodsInfo,orderId:" + orderSubModel.getOrderId()
					+ "tblOrderExtend1Model orderNbr be empty");
			throw new TradeException("Ordernbr.be.null");
		}
		// 银行订单号
		returnGoodsInfo.setOrderNbr(tblOrderExtend1Model.getOrdernbr());
		// 请款退货时间
		returnGoodsInfo.setOperTime(DateHelper.getyyyyMMddHHmmss(new Date()));
		// 订单生成时间
		returnGoodsInfo.setOrderTime(DateHelper.date2string(orderSubModel.getCreateTime(), DateHelper.YYYYMMDDHHMMSS));
		// 银联商户号
		returnGoodsInfo.setQsvendorNo(orderSubModel.getReserved1());
		// 现金支付金额
		returnGoodsInfo.setCashMoney(orderSubModel.getTotalMoney());
		// 退款接受方
		//if ( 0 == orderSubModel.getCostBy()){
		//	returnGoodsInfo.setPayee("01");
		//}else{
			returnGoodsInfo.setPayee("02");
		//}

		return returnGoodsInfo;
	}

	/**
	 * 发货更新订单状态及订单履历及物流表
	 *
	 * @param orderDoDetailModel
	 * @param orderSubModel
	 * @param orderTransModel
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean update(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
			OrderTransModel orderTransModel) {
		orderSubDao.update(orderSubModel);
		orderDoDetailDao.insert(orderDoDetailModel);
		orderTransDao.insert(orderTransModel);
		return Boolean.TRUE;
	}

	/**
	 * 批量更新订单状态及订单履历
	 *
	 * @param orderSubModelList
	 * @param orderDoDetailModelList
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateBatch(List<OrderSubModel> orderSubModelList, List<OrderDoDetailModel> orderDoDetailModelList)
			throws Exception {
		// 循环子订单插入数据
		for (int i = 0; i < orderSubModelList.size(); i++) {
			OrderSubModel orderSubModel = orderSubModelList.get(i);
			OrderDoDetailModel orderDoDetailModel = orderDoDetailModelList.get(i);
			orderDoDetailModel.setOrderId(orderSubModel.getOrderId());

			Integer orderSubInt = orderSubDao.update(orderSubModel);
			Integer orderDoDetailInt = orderDoDetailDao.insert(orderDoDetailModel);
		}
		return Boolean.TRUE;
	}

	/**
	 * 批量 更新订单状态 、订单履历、订单物流
	 *
	 * @param orderSubModelList 子订单表更新
	 * @param orderDoDetailModelList 订单详细表 插入
	 * @param orderTransModelList 订单物流表 插入 Add by zhoupeng
	 *
	 * @return Boolean
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateBatch(List<OrderSubModel> orderSubModelList, List<OrderDoDetailModel> orderDoDetailModelList,
			List<OrderTransModel> orderTransModelList,String orderType) throws Exception {
//		Boolean flag = Boolean.FALSE;
		// 循环子订单插入数据
		for (int i = 0; i < orderSubModelList.size(); i++) {
			OrderSubModel orderSubModel = orderSubModelList.get(i);
			OrderDoDetailModel orderDoDetailModel = orderDoDetailModelList.get(i);
			OrderTransModel orderTransModel = orderTransModelList.get(i);

			Integer orderSubInt = orderSubDao.update(orderSubModel);
			Integer orderDoDetailInt = orderDoDetailDao.insert(orderDoDetailModel);
			Integer orderTransInt;
			if (OrderIOServiceImpl.YGimportOrdersign.equals(orderType) || OrderIOServiceImpl.JFimportOrdersign.equals(orderType)) {
				orderTransInt = orderTransDao.updateDoDesc(orderTransModel);
			}else{
				orderTransInt = orderTransDao.insert(orderTransModel);
			}

			if (orderSubInt != 1 || orderDoDetailInt != 1 || orderTransInt != 1) {
				throw new RuntimeException("数据库更新失败");
			}
		}
		return Boolean.TRUE;
	}

	/**
	 * 批量更新撤单
	 *
	 * @param
	 * @return
	 */
	public Integer updateAllRevocation(Map<String, Object> paramMap) {
		return orderSubDao.updateAllRevocation(paramMap);
	}

	/**
	 * 商城退货申请
	 *
	 * @param orderSubModel
	 * @param orderDoDetailModel
	 * @param orderRrturnTrackDetailModel
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateReturnForMall(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
		OrderReturnTrackDetailModel orderRrturnTrackDetailModel) throws Exception {
		orderDoDetailDao.insert(orderDoDetailModel);
		orderReturnTrackDetailDao.insert(orderRrturnTrackDetailModel);
		String orderId = orderSubModel.getOrderId();
		if (orderSubDao.findById(orderId) == null) {
			TblOrderHistoryModel tblOrderHistoryModel = new TblOrderHistoryModel();
			if (tblOrderHistoryDao.findById(orderId) == null) {
				log.error("OrderSunManager updateReturnForMall,orderId:" + orderId + "orderSubModel be empty");
				throw new TradeException("tblOrderHistoryModel.be.null");
			}
			BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
			tblOrderHistoryDao.update(tblOrderHistoryModel);
		} else {
			orderSubDao.update(orderSubModel);
		}
		return Boolean.TRUE;
	}

	/**
	 * 商城撤单
	 *
	 * @param orderSubModel
	 * @param orderDoDetailModel
	 * @param orderRrturnTrackDetailModel
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateRevokeForMall(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
			OrderReturnTrackDetailModel orderRrturnTrackDetailModel, User user) throws Exception {
		orderDoDetailDao.insert(orderDoDetailModel);
		orderReturnTrackDetailDao.insert(orderRrturnTrackDetailModel);
		String orderId = orderSubModel.getOrderId();
		if (orderSubDao.findById(orderId) == null) {
			TblOrderHistoryModel tblOrderHistoryModel = new TblOrderHistoryModel();
			if (tblOrderHistoryDao.findById(orderId) == null) {
				log.error("OrderSubManager updateRevokeForMall,orderId:" + orderId + "orderSubModel be empty");
				throw new TradeException("tblOrderHistoryModel.be.null");
			}
			BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
			tblOrderHistoryDao.update(tblOrderHistoryModel);
		} else {
			orderSubDao.update(orderSubModel);
		}
		// 接口调用时间与数据库插入时间保持一致
		Date dateTime = new Date();
		String dateAndTime = DateHelper.getyyyyMMddHHmmss(dateTime);
		String nowDate = DateHelper.getyyyyMMdd(dateTime);
		String nowTime = DateHelper.getHHmmss(dateTime);
		// 荷兰拍回滚redis库存
		if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderSubModel.getActType())
				||Contants.PROMOTION_PROM_TYPE_STRING_40.equals(orderSubModel.getActType())
				|| Contants.PROMOTION_PROM_TYPE_STRING_30.equals(orderSubModel.getActType())
				|| Contants.PROMOTION_PROM_TYPE_STRING_20.equals(orderSubModel.getActType())
				|| Contants.PROMOTION_PROM_TYPE_STRING_10.equals(orderSubModel.getActType())) {
			List<Map<String, Object>> paramList=Lists.newArrayList();
			Map<String, Object> proMap = Maps.newHashMap();
			proMap.put("promId", orderSubModel.getActId());
			proMap.put("periodId", orderSubModel.getPeriodId() == null ? null : orderSubModel.getPeriodId().toString());
			proMap.put("itemCode", orderSubModel.getGoodsId());
			// 接口需要“-”代表回滚
			proMap.put("itemCount", orderSubModel.getGoodsNum());
			proMap.put("orderId", orderSubModel.getOrderId());
			proMap.put("actType", orderSubModel.getActType());
			paramList.add(proMap);
			// 更新数据库(活动选品表)库存
			Response<Boolean> result = mallPromotionService.updateRollbackPromotionStock(paramList);
			if (!result.isSuccess() || !result.getResult()) {
				throw new TradeException("您所选中的商品库存回滚失败");
			}
			if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderSubModel.getActType())){
				String promId = orderSubModel.getActId();
				String periodId = orderSubModel.getPeriodId().toString();
				String itemCode = orderSubModel.getGoodsId();
				String itemCount = "-" + orderSubModel.getGoodsNum();
				Response<Boolean> mallPromotionResult = mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode,
						itemCount, user);
				if (!mallPromotionResult.isSuccess() || !mallPromotionResult.getResult()) {
					log.error("OrderSubManager updateRevokeForMall,mallPromotionService updatePromSaleInfo failed");
					throw new TradeException("OrderSubManager.mallPromotionService.updatePromSaleInfo.failed");
				}
			}
		} else{
			// 普通单品更新db库存
			String itemCode = orderSubModel.getGoodsId();
			Map<String, Integer> itemStockmap = Maps.newHashMap();
			itemStockmap.put(itemCode,orderSubModel.getGoodsNum());
			Response<Boolean> booleanResponse = itemService.updateBatchStock(itemStockmap, user);
			if (!booleanResponse.isSuccess()) {
				log.error("orderMainManager updateCancelOrder,itemService updateBatchStock returnResult be wrong");
				throw new TradeException("itemService.updateBatchStock.be.wrong");
			}
		}
		// 广发商城（分期）
		if (Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
			// 判断支付金额是否为零
			if (!(BigDecimal.ZERO.compareTo(orderSubModel.getTotalMoney()) == 0)) {
				ReturnGoodsInfo returnGoodsInfo = makeReturnGoodsInfo(orderSubModel);
				returnGoodsInfo.setOperTime(dateAndTime);
				BaseResult baseResult = paymentService.returnGoods(returnGoodsInfo);
				if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
					log.error("OrderSubManager updateRevokeForMall,paymentService call NSCT018APi failed");
					throw new TradeException("call.NSCT018APi.failed");
				}
			}
			// 插入积分优惠券对账文件
			insertOrderCheck(orderSubModel, nowDate, nowTime);
		}
		return Boolean.TRUE;
	}

	/**
	 * 供应商 o2o已过期
	 * 
	 * @param orderSubModel
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateO2OExpiredVendor(OrderSubModel orderSubModel) throws Exception {
		String orderId = orderSubModel.getOrderId();
		if (orderSubDao.findById(orderId) == null) {
			TblOrderHistoryModel tblOrderHistoryModel = new TblOrderHistoryModel();
			if (tblOrderHistoryDao.findById(orderId) == null) {
				log.error("OrderSubManger updateO2OExpiredVendor,orderID:" + orderId + "orderSubModel be empty");
				throw new TradeException("tblOrderHistoryModel.be.null");
			}
			BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
			tblOrderHistoryDao.update(tblOrderHistoryModel);
		} else {
			orderSubDao.update(orderSubModel);
		}
		if (Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())) {
			// 查询商品支付方式，获取是否生日价格，清算金额
			Response<TblGoodsPaywayModel> goodsResponse = goodsPayWayService
					.findGoodsPayWayInfo(orderSubModel.getGoodsPaywayId());
			if (!goodsResponse.isSuccess() || goodsResponse.getResult() == null
					|| StringUtils.isBlank(goodsResponse.getResult().getIsBirth())) {
				log.error("OrderSubManager updateO2OExpiredVendor,goodsPayWayService findGoodsPayWayInfo failed");
				throw new TradeException("goodsPayWayService.findGoodsPayWayInfo.failed");
			}
			String isBirth = goodsResponse.getResult().getIsBirth();
			// 如果为生日价购买的话，需取得生日折扣比例
			String cal_mon = "0.00";
			if ("1".equals(isBirth)) {
				Response<List<CfgPriceSystemModel>> priceResponse = cfgPriceSystemService
						.findByPriceSystemId(Contants.BIRTH_CODE);
				if (!priceResponse.isSuccess()) {
					log.error(
							"OrderSubManager updateO2OExpiredVendor,cfgPriceSystemService findByPriceSystemId failed");
					throw new TradeException("cfgPriceSystemService.findByPriceSystemId.failed");
				}
				// 判断关键数据是否为空
				// 设置交易总金额
				if (priceResponse.getResult() != null && priceResponse.getResult().size() != 0
						&& priceResponse.getResult().get(0).getArgumentOther() != null
						&& goodsResponse.getResult().getCalMoney() != null) {
					cal_mon = new BigDecimal(priceResponse.getResult().get(0).getArgumentOther().toString())
							.multiply(new BigDecimal(goodsResponse.getResult().getCalMoney().toString()))
							.setScale(2, BigDecimal.ROUND_HALF_UP).toString();
				} else {
					cal_mon = goodsResponse.getResult().getCalMoney() == null ? cal_mon
							: goodsResponse.getResult().getCalMoney().toString();
				}
			} else {
				cal_mon = goodsResponse.getResult().getCalMoney() == null ? cal_mon
						: goodsResponse.getResult().getCalMoney().toString();
			}
			// 银联商户号是否存才
			Response<VendorInfoDto> vendorResponse = vendorService.findById(orderSubModel.getVendorId());
			if (!vendorResponse.isSuccess() || vendorResponse.getResult() == null
					|| StringUtils.isBlank(vendorResponse.getResult().getUnionPayNo())) {
				log.error("OrderSubManager updateO2OExpiredVendor,vendorService findById failed");
				throw new TradeException("vendorService.findById.failed");
			}
			String unionPayNo = vendorResponse.getResult().getUnionPayNo();
			// 整理发送外部接口数据
			PointsMallReturnGoodsInfo pointsMallReturnGoodsInfo = new PointsMallReturnGoodsInfo();
			pointsMallReturnGoodsInfo.setOrderId(orderSubModel.getOrderId());// 小订单号
			pointsMallReturnGoodsInfo.setOrderNumber(orderSubModel.getOrdermainId());// 大订单号
			pointsMallReturnGoodsInfo.setChannel("MALL");// 渠道标识
			pointsMallReturnGoodsInfo.setOrderTime(orderSubModel.getCreateTime()); // 订单生成时间
			pointsMallReturnGoodsInfo.setOperTime(new Date());// 请款退货时间
			pointsMallReturnGoodsInfo.setAcrdNo(orderSubModel.getCardno());// 账号
			pointsMallReturnGoodsInfo.setTradeMoney(new BigDecimal(cal_mon).setScale(2));// 交易总金额
			pointsMallReturnGoodsInfo.setCashMoney(orderSubModel.getTotalMoney());// 现金支付金额
			pointsMallReturnGoodsInfo.setIntegralMoney(BigDecimal.ZERO.setScale(2));// 积分抵扣金额
			pointsMallReturnGoodsInfo.setMerId(orderMerchentId);// 商城商户号
			pointsMallReturnGoodsInfo.setMerno(""); // 小商户号
			pointsMallReturnGoodsInfo.setQsvendorNo(unionPayNo);// 银联商户号
			pointsMallReturnGoodsInfo.setCategoryNo("");// 计费费率编号
			pointsMallReturnGoodsInfo.setOrderNbr("");// 银行订单号
			pointsMallReturnGoodsInfo.setStagesNum("");// 分期期数
			pointsMallReturnGoodsInfo.setOperId(orderSubModel.getModifyOper());// 操作员
			pointsMallReturnGoodsInfo.setPayee("01");// 01行方 不送或空值代表客户
			// 退货接口发送
			BaseResult baseResult = paymentService.pointsMallReturnGoods(pointsMallReturnGoodsInfo);
			if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
				log.error("OrderSubManger updateO2OExpiredVendor,paymentService call NSCT012APi failed");
				throw new TradeException("call.NSCT012APi.failed");
			}
		} else {
			ReturnGoodsInfo returnGoodsInfo = makeReturnGoodsInfo(orderSubModel);
			// 返款给行方-01 空-个人
			returnGoodsInfo.setPayee("01");
			BaseResult baseResult = paymentService.returnGoods(returnGoodsInfo);
			if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
				log.error("OrderSubManger updateO2OExpiredVendor,paymentService call NSCT018APi failed");
				throw new TradeException("call.NSCT018APi.failed");
			}
		}
		return Boolean.TRUE;
	}

	/**
	 * 供应商撤单
	 * 
	 * @param orderSubModel 订单信息
	 * @param orderReturnTrackDetailModel 退货撤单履历表
	 * @param orderDoDetailModel 订单处理历史明细表
	 * @param user 用户
	 * @param pointReturnGoodsInfo 积分撤单接口信息
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean revokeOrder(OrderSubModel orderSubModel, OrderReturnTrackDetailModel orderReturnTrackDetailModel,
			OrderDoDetailModel orderDoDetailModel, User user, PointsMallReturnGoodsInfo pointReturnGoodsInfo,String updateFlag)
			throws Exception {
		// 更新订单表
//		orderSubDao.updateStatues(orderSubModel);
//		订单应该更新的表，orderSub tbl_order ,history history表
		if ("orderSub".equals(updateFlag)){
			orderSubDao.updateStatues(orderSubModel);
		}
		if ("history".equals(updateFlag)){
			TblOrderHistoryModel tblOrderHistoryModel = new TblOrderHistoryModel();
			BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
			tblOrderHistoryDao.updateStatues(tblOrderHistoryModel);
		}
		// 插入订单操作履历表
		orderDoDetailDao.insert(orderDoDetailModel);
		// 插入撤单退货表
		orderReturnTrackDetailDao.insert(orderReturnTrackDetailModel);
		String ordertypeId = orderSubModel.getOrdertypeId();
		//构建撤单回滚库存参数
		Map<String, Integer> itemStockmap = Maps.newHashMap();
		itemStockmap.put(orderSubModel.getGoodsId(), orderSubModel.getGoodsNum());
		// 接口调用时间与数据库插入时间保持一致
		Date dateTime = new Date();
		String dateAndTime = DateHelper.getyyyyMMddHHmmss(dateTime);
		String nowDate = DateHelper.getyyyyMMdd(dateTime);
		String nowTime = DateHelper.getHHmmss(dateTime);
		// 广发商城（一期以及分期）
		if (!Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
			// 荷兰拍回滚redis库存
			if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderSubModel.getActType())
					||Contants.PROMOTION_PROM_TYPE_STRING_40.equals(orderSubModel.getActType())
					|| Contants.PROMOTION_PROM_TYPE_STRING_30.equals(orderSubModel.getActType())
					|| Contants.PROMOTION_PROM_TYPE_STRING_20.equals(orderSubModel.getActType())
					|| Contants.PROMOTION_PROM_TYPE_STRING_10.equals(orderSubModel.getActType())) {
				if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderSubModel.getActType())) {
					String promId = orderSubModel.getActId();
					String periodId = orderSubModel.getPeriodId().toString();
					String itemCode = orderSubModel.getGoodsId();
					String itemCount = "-" + orderSubModel.getGoodsNum();
					Response<Boolean> result = mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode,
							itemCount, user);
					if (!result.isSuccess() || !result.getResult()) {
						throw new TradeException("OrderMainManager.mallPromotionService.updatePromSaleInfo.failed");
					}
				}
				List<Map<String, Object>> paramList=Lists.newArrayList();
				Map<String, Object> proMap = Maps.newHashMap();
				proMap.put("promId", orderSubModel.getActId());
				proMap.put("itemCode", orderSubModel.getGoodsId());
				proMap.put("itemCount", orderSubModel.getGoodsNum());
				paramList.add(proMap);
				// 更新数据库(活动选品表)库存
				Response<Boolean> result = mallPromotionService.updateRollbackPromotionStock(paramList);
				if (!result.isSuccess() || !result.getResult()) {
					throw new TradeException("您所选中的商品库存回滚失败");
				}
			} else{
				// 普通单品更新db库存
				Response<Boolean> booleanResponse = itemService.updateBatchStock(itemStockmap, user);
				if (!booleanResponse.isSuccess()) {
					log.error("orderMainManager updateCancelOrder,itemService updateBatchStock returnResult be wrong");
					throw new TradeException("itemService.updateBatchStock.be.wrong");
				}
			}
			// 一期订单线下退款 线上更新订单状态和插入履历 二期全部线上处理
			if (Contants.BUSINESS_TYPE_FQ.equals(ordertypeId)) {
				// 是否用钱，用钱的情况下调用接口
				if ((BigDecimal.ZERO.compareTo(orderSubModel.getTotalMoney()) == 0)) {
					// donothing
				} else {
					ReturnGoodsInfo returnGoodsInfo = makeReturnGoodsInfo(orderSubModel);
					returnGoodsInfo.setOperTime(dateAndTime);
					BaseResult baseResult = paymentService.returnGoods(returnGoodsInfo);
					if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
						throw new TradeException("call.NSCT018APi.failed");
					}
				}
				// 插入积分优惠券对账文件
				insertOrderCheck(orderSubModel, nowDate, nowTime);
			}
		} else {
			//回滚库存
			Response<Boolean> booleanResponse = itemService.updateRollBackStockForJF(itemStockmap, user);
			if (!booleanResponse.isSuccess()) {
				log.error("orderMainManager updateCancelOrder,itemService updateRollBackStockForJF returnResult be wrong");
				throw new TradeException("itemService.updateRollBackStockForJF.be.wrong");
			}
			// 积分商城操作 取消表插入
			insertOrderCanncel(orderSubModel);
			// 是否用钱，用钱的情况下调用接口
			if ((BigDecimal.ZERO.compareTo(orderSubModel.getTotalMoney()) == 0)) {
				// donothing
			} else {
				// 连接NSCT012 积分加现金退款（积分商城）（大订单号支付，小订单号退款） 外部接口
				BaseResult baseResult = paymentService.pointsMallReturnGoods(pointReturnGoodsInfo);
				if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
					throw new TradeException("call.NSCT012APi.failed");
				}
			}
		}
		return true;
	}

	/**
	 *
	 * @param orderSubModel
	 */
	private void insertOrderCanncel(OrderSubModel orderSubModel) {
		// 积分商城操作 取消表插入
		List<OrderCancelModel> orderCancelList = orderCancelDao.findByOrderId(orderSubModel.getOrderId());
		if (orderCancelList == null || orderCancelList.size() == 0) {
			OrderCancelModel orderCancelModel = new OrderCancelModel();
			orderCancelModel.setOrderId(orderSubModel.getOrderId());
			orderCancelModel.setCancelCheckStatus("0");
			orderCancelModel.setCurStatusId(orderSubModel.getCurStatusId());
			orderCancelDao.insert(orderCancelModel);
		}
	}

	/**
	 * MAL502更新子订单状态 niufw
	 * 
	 * @param orderSubModel
	 * @return
	 */
	public Integer updateForMAL502(OrderSubModel orderSubModel) {
		Integer result = orderSubDao.updateForMAL502(orderSubModel);
		return result;
	}

	/**
	 * MAL502 订单扩展表2 插入扣款记录
	 * 
	 * @param tblOrderExtend2Model
	 * @return
	 */
	public Integer insertForMAL502(TblOrderExtend2Model tblOrderExtend2Model) {
		Integer result = tblOrderExtend2Dao.insert(tblOrderExtend2Model);
		return result;
	}

	/**
	 * MAL502 插入订单取消记录
	 * 
	 * @param orderCancelModel
	 * @return
	 */
	public Integer saveTblOrderCancel(OrderCancelModel orderCancelModel) {
		Integer result = orderCancelDao.insert(orderCancelModel);
		return result;
	}

	/**
	 * MAL502 插入订单处理历史明细
	 * 
	 * @param orderDoDetailModel
	 * @return
	 */
	public Integer saveOrderDodetail(OrderDoDetailModel orderDoDetailModel) {
		Integer result = orderDoDetailDao.insert(orderDoDetailModel);
		return result;
	}

	/**
	 * 更新广发商城小订单流水号
	 * 
	 * @param orderSubModel
	 * @return
	 */
	public Integer updateOrderSerialNo(OrderSubModel orderSubModel) {
		Integer result = orderSubDao.updateOrderSerialNo(orderSubModel);
		return result;
	}

	/**
	 * 保存订单扩展表
	 * 
	 * @param orderSubModel
	 * @return
	 */
	public Integer insertOrderExtend(TblOrderExtend1Model orderSubModel) {
		Integer result = tblOrderExtend1Dao.insert(orderSubModel);
		return result;
	}

	/**
	 * 根据主订单号更新订单状态
	 *
	 * @param orderSubModel
	 *
	 * @return
	 */
	public Boolean updateByOrderMainId(OrderSubModel orderSubModel) {
		return orderSubDao.updateByOrderMainId(orderSubModel) == 1;
	}

	/**
	 * 更新状态
	 *
	 * @param orderSubModel
	 * @return
	 */
	public Integer updateStatues(OrderSubModel orderSubModel) {
		return orderSubDao.updateStatues(orderSubModel);
	}

	/**
	 * 更新 。。。
	 *
	 * @param ordermainId 主订单id
	 * @param payAccountNo 。。。
     * @return Integer
     */
	public Integer updateOrderCardNoForSub(String ordermainId, String payAccountNo) {
		return orderSubDao.updateOrderCardNoForSub(ordermainId, payAccountNo);
	}

	/**
	 * 新增
	 *
	 * @param orderSubModel 更新对象
	 * @return Integer
	 */
	public Integer insert(OrderSubModel orderSubModel) {
		return orderSubDao.insert(orderSubModel);
	}

	/**
	 * MAL501
	 *
	 * @param orderSubModel 更新对象
	 * @return Integer
	 */
	public Integer updateTblOrderSub(OrderSubModel orderSubModel) {
		return orderSubDao.updateTblOrderSub(orderSubModel);
	}
}
