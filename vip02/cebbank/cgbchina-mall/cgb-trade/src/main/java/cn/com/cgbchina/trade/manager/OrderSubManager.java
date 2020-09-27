package cn.com.cgbchina.trade.manager;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.spirit.common.model.Response;
import com.spirit.util.BeanMapper;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.OrderTieinSaleService;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.ReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.model.*;

/**
 * Created by 11141021040453 on 2016/5/12.
 */
@Component
@Transactional
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
	OrderClearDao orderClearDao;
	@Resource
	PaymentService paymentService;
	@Resource
	OrderTieinSaleService orderTieinSaleService;
	@Resource
	OrderReturnTrackDetailDao orderReturnTrackDetailDao;

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

	public Boolean updateStatues(OrderSubModel orderSubModel) {
		return orderSubDao.updateStatues(orderSubModel) == 1;
	}

	/**
	 * 供应商更新订单状态及订单履历 拒签，签收，无人签收
	 *
	 * @param orderSubModel
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateSignVendor(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel) throws Exception {
		String curStatusId = orderSubModel.getCurStatusId();
		try {
			if (Contants.SUB_ORDER_STATUS_0380.equals(curStatusId)
					|| Contants.SUB_ORDER_STATUS_0381.equals(curStatusId)) {
				// 拒绝签收 无人签收
				// 广发商城一期
				if (Contants.BUSINESS_TYPE_YG.equals(orderSubModel.getOrdertypeId())
						|| Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
					String orderId = orderSubModel.getOrderId();
					OrderSubModel orderSubModel1 = orderSubDao.findById(orderId);
					if (orderSubModel1 == null) {
						TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
						if (tblOrderHistoryModel == null) {
							throw new Exception("OrderSubModel.non-exist");
						}
						BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
						Integer tblOrderHistoryInt = tblOrderHistoryDao.update(tblOrderHistoryModel);
					} else {
						Integer orderSubInt = orderSubDao.update(orderSubModel);
					}
					Integer orderDoDetailInt2 = orderDoDetailDao.insert(orderDoDetailModel);
				}
				// 广发商城分期
				//todo 7.11对应
//				if (Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
//					BigDecimal totalMoney = orderSubModel.getTotalMoney();
//					// todo 校验
//					if (!BigDecimal.ZERO.equals(totalMoney)) {
//						// 调用接口
//						BaseResult baseResult = new BaseResult();
//						baseResult = callNSCT018(orderSubModel);
//						if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
//							throw new Exception("call.NSCT018APi.failed");
//						}
//					}
//					// 插入积分优惠券对账文件
//					insertOrderCheck(orderSubModel);
//				}
				// 积分商城 分期
				// todo
			} else {
				String orderId = orderSubModel.getOrderId();
				OrderSubModel orderSubModel1 = orderSubDao.findById(orderId);
				if (orderSubModel1 == null) {
					TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
					BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
					Integer tblOrderHistoryInt = tblOrderHistoryDao.update(tblOrderHistoryModel);
				} else {
					Integer orderSubInt = orderSubDao.update(orderSubModel);
				}
				Integer orderDoDetailInt = orderDoDetailDao.insert(orderDoDetailModel);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;

		}
		return Boolean.TRUE;
	}

	/**
	 * 供应商更新订单状态及订单履历及退货
	 *
	 * @param orderDoDetailModel
	 * @param orderSubModel
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateReturnVendor(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
			OrderReturnTrackDetailModel orderReturnTrackDetailModel) throws Exception {
		String orderId = orderSubModel.getOrderId();
		String ordertypeId = orderSubModel.getOrdertypeId();
		String sinStatusId = orderSubModel.getSinStatusId();
		OrderSubModel orderSubModel1 = orderSubDao.findById(orderId);
		if (orderSubModel1 == null) {
			TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
			if (tblOrderHistoryModel == null) {
				throw new Exception("OrderSubModel.non-exist");
			}
			BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
			tblOrderHistoryDao.update(tblOrderHistoryModel);
		} else {
			orderSubDao.update(orderSubModel);
		}
		orderDoDetailDao.insert(orderDoDetailModel);
		orderReturnTrackDetailDao.insert(orderReturnTrackDetailModel);
		try {
			// 供应商操作直接退货
			// 广发商城（一期以及分期）
			if (Contants.BUSINESS_TYPE_FQ.equals(ordertypeId)) {
				BaseResult baseResult = new BaseResult();
				// 判断支付金额是否为零
				// 请款中
				OrderClearModel orderClearModel = orderClearDao.findByOrderId(orderId);
				// 正在请款跑批 无法退货
				if (orderClearModel != null && "2".equals(orderClearModel.getClearflag())) {
					throw new Exception("order.be.requesting.money.can.not.returnGoods");
				}
				if (BigDecimal.ZERO.equals(orderSubModel.getTotalMoney())
						&& (Contants.SUB_SIN_STATUS_0300.equals(sinStatusId)
								|| Contants.SUB_SIN_STATUS_0332.equals(sinStatusId)
								|| StringUtils.isBlank(sinStatusId))) {
					// donothing
				} else {
					baseResult = callNSCT018(orderSubModel);
					if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
						throw new Exception("call.NSCT018APi.failed");
					}
				}
				if (orderClearModel != null && Contants.SUB_SIN_STATUS_0350.equals(orderSubModel.getSinStatusId())) {
                    //如果该订单请款状态为“同意请款”，则需要定时任务的请款订单剔除任务。
					orderClearModel.setClearflag("1");
					orderClearModel.setExtend1("剔除任务");
					orderClearDao.update(orderClearModel);
				}
				// 插入积分优惠券对账文件
				insertOrderCheck(orderSubModel);
				// todo 短信
			} else {
				// TODo 积分商城
			}

		} catch (Exception e) {
			throw e;
		}

		return Boolean.TRUE;
	}

	private void insertOrderCheck(OrderSubModel orderSubModel) {
		long time = ((new Date()).getTime() - orderSubModel.getCreateTime().getTime()) / (24 * 60 * 60 * 1000);
		// 判断是否超过180且使用优惠券
		// 超过180天
		if (time > 180) {
			// todo log文件平台打印
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
				orderCheckModel.setDoDate(DateHelper.getyyyyMMdd());
				orderCheckModel.setDoTime(DateHelper.getHHmmss());
				if (orderSubModel.getBonusTotalvalue() != null && orderSubModel.getBonusTotalvalue() > 0) {
					orderCheckModel.setIscheck(Contants.ORDER_ISCHECK_YES);
				} else {
					orderCheckModel.setIscheck(Contants.ORDER_ISCHECK_NO);
				}
				if (StringUtils.isNotBlank(orderSubModel.getVoucherId())) {
					orderCheckModel.setIspoint(Contants.ORDER_ISPOINT_YES);
				} else {
					orderCheckModel.setIspoint(Contants.ORDER_ISPOINT_NO);
				}
				orderCheckModel.setModifyOper(orderSubModel.getModifyOper());
				orderCheckModel.setOrderId(orderSubModel.getOrderId());
				orderCheckDao.insert(orderCheckModel);
			}
		}
	}

	private BaseResult callNSCT018(OrderSubModel orderSubModel) throws Exception {
		ReturnGoodsInfo returnGoodsInfo = new ReturnGoodsInfo();
		returnGoodsInfo.setTradeCode(Contants.GATEWAY_ENVELOPE_TRADECODE_NETBANK_RETURN_NEW);
		returnGoodsInfo.setAcrdNo(orderSubModel.getCardno());
		returnGoodsInfo.setOrderId(orderSubModel.getOrderId());
		String goodsPaywayId = orderSubModel.getGoodsPaywayId();
		if (StringUtils.isBlank(goodsPaywayId)) {
			throw new Exception("goodsPaywayId.be.null");
		}
		Response<TblGoodsPaywayModel> response = new Response<>();
		response = orderTieinSaleService.findGoodsPrice(goodsPaywayId);
		if (!response.isSuccess()) {
			throw new Exception("TblGoodsPaywayModel.be.null");
		}
		TblGoodsPaywayModel tblGoodsPaywayModel = response.getResult();
		if (tblGoodsPaywayModel == null) {
			throw new Exception("TblGoodsPaywayModel.be.null");
		}
		BigDecimal goodsPrice = BigDecimal.ZERO.setScale(2);
		goodsPrice = tblGoodsPaywayModel.getGoodsPrice();
		returnGoodsInfo.setTradeMoney(goodsPrice);
		returnGoodsInfo
				.setStagesNum(orderSubModel.getStagesNum() != null ? orderSubModel.getStagesNum().toString() : null);
		returnGoodsInfo.setCashMoney(orderSubModel.getTotalMoney());
		returnGoodsInfo.setCategoryNo(orderSubModel.getSpecShopno());
		returnGoodsInfo.setChannel("mall");
		returnGoodsInfo.setDiscountMoney(goodsPrice.subtract(orderSubModel.getTotalMoney()));
		returnGoodsInfo.setIntegralMoney(orderSubModel.getUitdrtamt());
		returnGoodsInfo.setMerId(orderSubModel.getMerId());
		returnGoodsInfo.setOperId(orderSubModel.getModifyOper());
		TblOrderExtend1Model tblOrderExtend1Model = tblOrderExtend1Dao.findByOrderId(orderSubModel.getOrderId());
		if (tblOrderExtend1Model == null || StringUtils.isBlank(tblOrderExtend1Model.getOrdernbr())) {
			throw new Exception("Ordernbr.be.null");
		}
		returnGoodsInfo.setOrderNbr(tblOrderExtend1Model.getOrdernbr());
		returnGoodsInfo.setOperTime(DateHelper.getCurrentTime());
		returnGoodsInfo.setOrderTime(DateHelper.date2string(orderSubModel.getCreateTime(), "yyyy-MM-dd HH:mm:ss"));
		returnGoodsInfo.setQsvendorNo(orderSubModel.getReserved1());
		// todo returnGoodsInfo.setPayee("");
		// TODO returnGoodsInfo.setRefundType();
		BaseResult baseResult = paymentService.returnGoods(returnGoodsInfo);
		return baseResult;
	}

	/**
	 * 发货更新订单状态及订单履历及物流表
	 *
	 * @param orderDoDetailModel
	 * @param orderSubModel
	 * @param orderTransModel
	 * @return
	 */
	public Boolean update(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
			OrderTransModel orderTransModel) {
		Integer orderSubInt = orderSubDao.update(orderSubModel);
		Integer orderDoDetailInt = orderDoDetailDao.insert(orderDoDetailModel);
		Integer orderPartBackInt = orderTransDao.insert(orderTransModel);
		return Boolean.TRUE;
	}

	/**
	 * 批量更新订单状态及订单履历
	 *
	 * @param orderSubModelList
	 * @param orderDoDetailModelList
	 * @return
	 */
	public Boolean updateBatch(List<OrderSubModel> orderSubModelList, List<OrderDoDetailModel> orderDoDetailModelList) {
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
	public Boolean updateReturnForMall(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
			OrderReturnTrackDetailModel orderRrturnTrackDetailModel) throws Exception {
		try {
			orderDoDetailDao.insert(orderDoDetailModel);
			orderReturnTrackDetailDao.insert(orderRrturnTrackDetailModel);
			String orderId = orderSubModel.getOrderId();
			if (orderSubDao.findById(orderId) == null) {
				TblOrderHistoryModel tblOrderHistoryModel = new TblOrderHistoryModel();
				if (tblOrderHistoryDao.findById(orderId) == null) {
					throw new Exception("wrong");
				}
				BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
				tblOrderHistoryDao.update(tblOrderHistoryModel);
			}
			orderSubDao.update(orderSubModel);
		} catch (Exception e) {
			throw e;
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
	public Boolean updateRevokeForMall(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
			OrderReturnTrackDetailModel orderRrturnTrackDetailModel) throws Exception {
		try {
			orderDoDetailDao.insert(orderDoDetailModel);
			orderReturnTrackDetailDao.insert(orderRrturnTrackDetailModel);
			String orderId = orderSubModel.getOrderId();
			if (orderSubDao.findById(orderId) == null) {
				TblOrderHistoryModel tblOrderHistoryModel = new TblOrderHistoryModel();
				if (tblOrderHistoryDao.findById(orderId) == null) {
					throw new Exception("wrong");
				}
				BeanMapper.copy(orderSubModel, tblOrderHistoryModel);
				tblOrderHistoryDao.update(tblOrderHistoryModel);
			}
			orderSubDao.update(orderSubModel);
			// 更新库存
			String itemcode = orderSubModel.getGoodsId();
			ItemModel itemModel = itemService.findItemDetailByCode(itemcode);
			if (itemModel == null) {
				throw new Exception("update.findItemDetailByCode.error");
			}
			Long stock = itemModel.getStock();
			stock += 1;
			itemModel.setModifyOper(orderSubModel.getModifyOper());
			itemModel.setStock(stock);
			Response<Boolean> result = itemService.update(itemModel);
			if (!result.getResult()) {
				throw new Exception("update.item.error");
			}
			// 广发商城（一期以及分期）
			//todo 7.11
//			if (Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
//				BaseResult baseResult = new BaseResult();
//				// 判断支付金额是否为零
//				if (!BigDecimal.ZERO.equals(orderSubModel.getTotalMoney())) {
//					baseResult = callNSCT018(orderSubModel);
//					if (baseResult == null || !(Contants.SUCCESS_CODE.equals(baseResult.getRetCode()))) {
//						throw new Exception("call.NSCT018APi.failed");
//					}
//				}
//				// 插入积分优惠券对账文件
//				insertOrderCheck(orderSubModel);
//			}

		} catch (Exception e) {
			throw e;
		}
		return Boolean.TRUE;
	}

}
