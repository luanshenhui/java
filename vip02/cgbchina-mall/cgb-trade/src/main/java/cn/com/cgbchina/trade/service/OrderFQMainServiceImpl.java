package cn.com.cgbchina.trade.service;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Strings.nullToEmpty;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.*;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.trade.dto.*;
import com.google.common.base.*;
import com.google.common.collect.Collections2;
import com.spirit.exception.ResponseException;
import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.SignAndVerify;
import cn.com.cgbchina.item.dto.CardScaleDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.user.model.MemberAddressModel;
import cn.com.cgbchina.user.service.MemberAddressService;
import cn.com.cgbchina.user.service.VendorService;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserAccount;

@Service
@Slf4j
public class OrderFQMainServiceImpl extends DefaultOrderMainServiceImpl implements OrderFQMainService {
	@Resource
	MemberAddressService memberAddressService;
	@Resource
	MallPromotionService mallPromotionService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	ItemService itemService;
	@Resource
	GoodsDetailService goodsDetailService;
	@Resource
	CouponService couponService;
	@Resource
	GoodsService goodsService;
	@Resource
	CartService cartService;
	@Resource
	PointsPoolService pointsPoolService;
	@Resource
	VendorService vendorService;
	@Resource
	CouponScaleService couponScaleService;
	@Resource
	PriorJudgeService priorJudgeService;
	@Resource
	PromotionPayWayService promotionPayWayService;
	@Resource
	RedisService redisService;
	@Value("#{app.merchId}") String merchId;
	@Value("#{app.returl}") String returl;
	@Value("#{app.mainPrivateKey}") String mainPrivateKey;
	@Value("#{app.payAddress}") String payAddress;
	@Value("#{app.timeStart}")
	private String timeStart;
	@Value("#{app.timeEnd}")
	private String timeEnd;

	/**
	 * 广发商城判断参数库存支付方式等是否正确并取得商品供应商等信息
	 *
	 * @param orderCommitSubmitDto
	 * @param selectedCardInfo
	 * @param user
	 * @return retRsp
	 */
	@Override
	public Response<OrderMainDto> checkCreateOrderArgumentAndGetInfos_new(OrderCommitSubmitDto orderCommitSubmitDto, UserAccount selectedCardInfo, User user) {
		Response<OrderMainDto> retRsp = Response.newResponse();
		try {
			checkArgument(orderCommitSubmitDto != null, "订单信息不能为空");
			// 选择的支付卡卡号
			String cardNo = orderCommitSubmitDto.getCardNo();
			checkArgument(!cardNo.isEmpty(), "卡号不能为空");
			// 卡号对应的卡片类型是信用卡还是借记卡
			String cardType = Contants.CARD_TYPE_Y;// 借记卡
			if (UserAccount.CardType.CREDIT_CARD.equals(selectedCardInfo.getCardType())) {
				cardType = Contants.CARD_TYPE_C;
			}
			//1：信用卡；2借记卡
			String payType = orderCommitSubmitDto.getPayType();
			checkArgument(!payType.isEmpty(), "支付方式不能为空");
			// 判断支付方式和所选卡号是否相符
			if (Contants.CART_PAY_TYPE_2.equals(payType)) {
				checkArgument(Contants.CARD_TYPE_Y.equals(cardType), "所选卡号和支付方式不符");
			} else if (Contants.CART_PAY_TYPE_1.equals(payType)) {
				checkArgument(Contants.CARD_TYPE_C.equals(cardType), "所选卡号和支付方式不符");
			} else {
				checkArgument(false, "支付方式不正确");
			}
			Response<OrderMainDto> orderMainDtoResponse =  execOrderSubmit(orderCommitSubmitDto, user, cardType);
			if (!orderMainDtoResponse.isSuccess()) {
				return orderMainDtoResponse;
			}
			OrderMainDto orderMainDto = orderMainDtoResponse.getResult();

			// 活动购买数量校验
			if (orderMainDto.getPromotionLimitMap() != null) {
				for (String idandpid : orderMainDto.getPromotionLimitMap().keySet()) {
					List<String> ids = Splitter.on(',').trimResults().splitToList(idandpid);
					String pid = ids.get(0);
					String periodid = ids.get(1);
					String itemcd = ids.get(2);
					Response<Boolean> checkPromBuyCountResponse = mallPromotionService.checkPromBuyCount(pid,
							periodid, orderMainDto.getPromotionLimitMap().get(idandpid).toString(), user, itemcd);
					if(!checkPromBuyCountResponse.isSuccess()){
						log.error("Response.error,error code: {}", checkPromBuyCountResponse.getError());
						throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
					}
					checkArgument(checkPromBuyCountResponse.getResult(), "您所购买的活动商品数量已达到上限，无法继续参加活动");
				}
			}
			// 商品数量库存检证
			promCheck(orderCommitSubmitDto, orderCommitSubmitDto.getOrderCommitInfoList(), orderMainDto);
			// 商品积分检证
			log.info("jfTotalNum：商品的积分总数为：" + orderMainDto.getJfTotalNum());
			if (orderMainDto.getJfTotalNum() != 0L) {
				scoreCheck(orderMainDto, user);
			}
			// 供应商检证
			vendorCheck(orderMainDto);
			orderMainDto.setMiaoshaFlag(orderCommitSubmitDto.getMiaoFlag());
			retRsp.setResult(orderMainDto);
		} catch (IllegalArgumentException e) {
			log.error("OrderFQMainService checkCreateOrderArgumentAndGetInfos error,error code: {}", Throwables.getStackTraceAsString(e));
			retRsp.setError(e.getMessage());
			return retRsp;
		} catch (Exception e) {
			log.error("OrderFQMainService createOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			retRsp.setError("OrderFQMainService.checkCreateOrderArgumentAndGetInfos.error");
			return retRsp;
		}
		return retRsp;
	}

	/**
	 * 商品积分检证
	 *
	 * @param orderMainDto
	 * @param user
	 * @return
	 */
	private void scoreCheck(OrderMainDto orderMainDto, User user) {
		Response<Map<String,BigDecimal>> userAccountResponse = cartService.getUserScore(user);// 积分系统返回客户的最高积分
		checkArgument(userAccountResponse.isSuccess(), "查询不到客户积分");
		BigDecimal bunusum = userAccountResponse.getResult().get(Contants.JGID_COMMON);
		checkArgument(bunusum != null, "您当前的剩余积分不足");
		checkArgument(bunusum.compareTo(new BigDecimal(orderMainDto.getJfTotalNum())) >= 0, "您当前的剩余积分不足");
		// 固定积分不占用积分池
		Response<PointPoolModel> pointResult = pointsPoolService.getCurMonthInfo();
		checkArgument(pointResult.isSuccess() && pointResult.getResult() != null, "取得积分池失败");
		PointPoolModel pointPoolModel = pointResult.getResult();
		Long maxPoint = pointPoolModel.getMaxPoint();
		Long usedPoint = pointPoolModel.getUsedPoint();
		checkArgument(orderMainDto.getJfTotalNumNoFix() <= maxPoint - usedPoint, "本月广发商城积分抵现活动已结束，下月1日起可继续参与。");
		pointPoolModel.setUsedPoint(orderMainDto.getJfTotalNumNoFix());
		pointPoolModel.setModifyOper(user.getId());
		orderMainDto.setPointPoolModel(pointPoolModel);
	}
	/**
	 * 商品数量库存检证
	 * @param orderCommitInfoDtoList
	 * @param orderMainDto
	 */
	private void promCheck(OrderCommitSubmitDto orderCommitSubmitDto, List<OrderCommitInfoDto> orderCommitInfoDtoList, OrderMainDto orderMainDto) {
		List<String> goodsCodes = Lists.newArrayList();
		List<String> itemCodeList = Lists.newArrayList();
		// 判断活动单品库存数
		for (ItemModel itemModel : orderMainDto.getItemModels()) {
			String itemCode = itemModel.getCode();
			itemCodeList.add(itemModel.getCode());
			goodsCodes.add(itemModel.getGoodsCode());
			// 判断单品库存数
			Long itemCount = 0L;
			Long promItemCount = 0L;
			OrderCommitInfoDto dto = new OrderCommitInfoDto();
			for (OrderCommitInfoDto orderCommitInfoDto : orderMainDto.getOrderCommitInfoDtoListMultimap().get(itemCode)) {
				if (orderCommitInfoDto.getPromotion() != null && orderCommitInfoDto.getPromotion().getId() == null) {
					itemCount = itemCount + orderCommitInfoDto.getItemCount();
				} else if (orderCommitInfoDto.getPromotion() != null &&
						orderCommitInfoDto.getPromotion().getId() != null) {
					promItemCount = promItemCount + orderCommitInfoDto.getItemCount();
					dto = orderCommitInfoDto;
				}
			}

			if (dto.getPromotion() != null && dto.getPromotion().getId() != null) {
				Map<String, String> map = Maps.newHashMap();
				map.put("promId", String.valueOf(dto.getPromotion().getId()));
				map.put("periodId", dto.getPromotion().getPeriodId());
				map.put("itemCode", itemModel.getCode());
				map.put("itemCount", String.valueOf(promItemCount));
				map.put("promotionType", String.valueOf(orderMainDto.getPromotionTypeMap().get(itemCode)));
				orderMainDto.addProItemMap(map);
			} else {
				checkArgument(itemModel.getStock() >= itemCount, "库存不够");
				orderMainDto.putStock(itemModel.getCode(), itemCount);
			}
		}
		boolean changed = true;
		for (OrderCommitInfoDto dto : orderCommitInfoDtoList) {
			if (!itemCodeList.contains(dto.getCode())) {
				changed = false;
				break;
			}
		}
		checkArgument(changed, "购买的商品发生了变化，请重新购买");
		Response<List<GoodsModel>> goodsModels = goodsService.findByCodes(goodsCodes);
		if(!goodsModels.isSuccess()){
			log.error("Response.error,error code: {}", goodsModels.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		checkArgument(goodsModels.getResult().size() > 0, "购买的商品发生了变化，请重新购买");
		boolean flg = true;
		// 判断商品是否在售
		for (GoodsModel goodsModel : goodsModels.getResult()) {
			// 商城的场合
			checkArgument(Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall()), "购买的商品已经下架");
			orderMainDto.putGoodsInfo(goodsModel.getCode(), goodsModel);
			orderMainDto.addVendorCode(goodsModel.getVendorId());
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType()) && flg) {
				checkArgument(orderCommitSubmitDto.getAddressId() != null, "请选择送货地址");
				Response<MemberAddressModel> memberAddressResult = memberAddressService.findById(orderCommitSubmitDto.getAddressId());
				checkArgument(memberAddressResult.isSuccess(), "收货地址发生变化请重新选择");
				orderMainDto.setMemberAddressModel(memberAddressResult.getResult());
				// 商品类型
				orderMainDto.setGoodsType(goodsModel.getGoodsType());
				flg = false;
			}
			// 实物，O2O商品结算数量最大为99件
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType()) ||
					Contants.SUB_ORDER_TYPE_02.equals(goodsModel.getGoodsType())) {
				checkArgument(orderMainDto.getTotalNum() <= 99, "购买总数量不能大于99");
			}
		}
	}

	/**
	 * 商品list
	 * @param orderCommitInfoDto
	 * @param user
	 * @return
	 */
	protected OrderMainSingleCheckDto singleCommitCheck(OrderCommitInfoDto orderCommitInfoDto,
								   User user) {
		OrderMainSingleCheckDto retSinle = new OrderMainSingleCheckDto();
		// 单品编码
		checkArgument(!orderCommitInfoDto.getCode().isEmpty(), "没找到商品");
		// 购买数量
		Integer num = orderCommitInfoDto.getItemCount();
		checkArgument(num > 0, "购买数量不能小于1");
		// 借记卡不支持优惠券和积分
		if (Contants.CARD_TYPE_Y.equals(orderCommitInfoDto.getCardType())) {
			checkArgument(orderCommitInfoDto.getJfCount() == null || orderCommitInfoDto.getJfCount().intValue() == 0, "借记卡不支持优惠券和积分");
			checkArgument(StringUtils.isBlank(orderCommitInfoDto.getVoucherId()), "借记卡不支持优惠券和积分");
		}

		Response<ItemModel> itemModelResponse = itemService.findByItemcode(orderCommitInfoDto.getCode());
		checkArgument(itemModelResponse.isSuccess(), "单品不存在");
		ItemModel itemModel = itemModelResponse.getResult();
		retSinle.setItemModel(itemModel);

		BigDecimal goodsPrice = new BigDecimal("0");
		if (orderCommitInfoDto.getJfCount() == null) {
			orderCommitInfoDto.setJfCount(0l);
		}
		if (orderCommitInfoDto.getAfterDiscountJf() == null) {
			orderCommitInfoDto.setAfterDiscountJf(0l);
		}
		if (orderCommitInfoDto.getSinglePrice() == null) {
			orderCommitInfoDto.setSinglePrice(0l);
		}
		retSinle.setItemCode(orderCommitInfoDto.getCode());
		retSinle.setOrderCommitInfoDto(orderCommitInfoDto);
		/** 商品价格校验 */

		// 活动价格校验
		if (orderCommitInfoDto.getPromotion() != null && orderCommitInfoDto.getPromotion().getId() != null) {
			goodsPrice = promotionPriceCheck(orderCommitInfoDto, user, retSinle);
		} else {
			Response<TblGoodsPaywayModel> tblGoodsPaywayResult = goodsPayWayService.findGoodsPayWayInfo(orderCommitInfoDto.getPayWayId());
			checkArgument(tblGoodsPaywayResult.isSuccess(), "商品支付方式发生变化请重新提交");
			checkArgument(orderCommitInfoDto.getCode().equals(tblGoodsPaywayResult.getResult().getGoodsId()), "商品支付方式发生变化请重新提交");
			retSinle.setPayWayId(orderCommitInfoDto.getPayWayId());
			retSinle.setTblGoodsPaywayModel(tblGoodsPaywayResult.getResult());
			goodsPrice = tblGoodsPaywayResult.getResult().getGoodsPrice();
		}
		// 总价格
		// 满减时 减去满减价格
		if (orderCommitInfoDto.getMjDisPrice() != null) {
			retSinle.setTotalPrice(goodsPrice.multiply(new BigDecimal(orderCommitInfoDto.getItemCount().toString())).subtract(orderCommitInfoDto.getMjDisPrice()));
		} else {
			retSinle.setTotalPrice(goodsPrice.multiply(new BigDecimal(orderCommitInfoDto.getItemCount().toString())));
		}

		Long afterDiscountJf = orderCommitInfoDto.getAfterDiscountJf() == null ? 0L : Long.parseLong(orderCommitInfoDto.getAfterDiscountJf().toString());
		retSinle.setJfTotalNum(afterDiscountJf);
		retSinle.setJfTotalNumNoFix(afterDiscountJf);
		// 固定积分检证
		if (!orderCommitInfoDto.isFixFlag()) {
			fixPointCheck(orderCommitInfoDto, user, itemModel, retSinle);
		}
		// 优惠券总额
		retSinle.setVoucherPriceTotal(orderCommitInfoDto.getVoucherPrice() == null ? new BigDecimal(0) : orderCommitInfoDto.getVoucherPrice());
		retSinle.setTotalNum(num);
		if (StringUtils.isNotEmpty(orderCommitInfoDto.getVoucherId()) &&
				StringUtils.isNotEmpty(orderCommitInfoDto.getVoucherNo())) {
			Response<List<CouponInfo>> getCoupons = redisService.getCoupons(user.getId(),
					user.getCertType(), user.getCertNo());
			List<CouponInfo> couponInfoList = Lists.newArrayList();
			if (getCoupons.isSuccess()){
				couponInfoList = getCoupons.getResult();
			}
			// 筛选用户未使用的优惠券     1：已使用 2：已激活未使用 3: 未激活
			Collection<CouponInfo> user_small_coupon_tempCollection = Collections2.filter(couponInfoList,
					new Predicate<CouponInfo>() {
						@Override
						public boolean apply(@NotNull CouponInfo input) {
							return "2".equals(input.getUseActivatiState());
						}
					});
			Boolean couponIsTrue = false;
			final BigDecimal price = orderCommitInfoDto.getPrice();
			Collection<CouponInfo> finalListForUseCol = Collections2.filter(user_small_coupon_tempCollection, new Predicate<CouponInfo>() {
				@Override
				public boolean apply(@NotNull CouponInfo input) {
					Boolean single = true;
					if (input.getLimitMoney()!=null){
						single = price.compareTo(input.getLimitMoney())>=0;
					}
					return single;
				}
			});
			for(CouponInfo couponInfo:finalListForUseCol){
				if(couponInfo.getPrivilegeId().equals(orderCommitInfoDto.getVoucherNo())){
					couponIsTrue = true;
				}
			}
			if(!couponIsTrue){
				throw new IllegalArgumentException(String.valueOf("优惠券不可用"));
			}
		}
		return retSinle;
	}

	/**
	 * 固定积分检证
	 * @param orderCommitInfoDto
	 * @param user
	 * @param itemModel
	 * @param retSinle
	 */
	private void fixPointCheck(OrderCommitInfoDto orderCommitInfoDto, User user, ItemModel itemModel, OrderMainSingleCheckDto retSinle) {
		//抵扣最佳倍率
//		if (itemModel.getMaxPoint() != null) {
//			BigDecimal max = new BigDecimal(itemModel.getMaxPoint());
//			BigDecimal jf = new BigDecimal(orderCommitInfoDto.getJfCount());
//			BigDecimal itemCnt = new BigDecimal(orderCommitInfoDto.getItemCount());
//			checkArgument(max.compareTo(jf.divide(itemCnt, 0, BigDecimal.ROUND_DOWN)) >= 0, "所用积分不能大于商品最大抵扣积分");
//		}
		Response<List<CardScaleDto>> CardScaleResponse = goodsDetailService.findCardScaleByUserId(user);
		if(!CardScaleResponse.isSuccess()){
			log.error("Response.error,error code: {}", CardScaleResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		CardScaleDto CardScale = CardScaleResponse.getResult().get(0);
		// 优惠比例
		BigDecimal scale = CardScale.getScal();
		if (orderCommitInfoDto.getJfCount() != 0l) {
			// 积分折扣校验
			checkArgument(new BigDecimal(orderCommitInfoDto.getJfCount())
					.multiply(scale).setScale(0, BigDecimal.ROUND_HALF_UP).
							compareTo(new BigDecimal(orderCommitInfoDto.getAfterDiscountJf())) == 0, "积分折扣发生变化");
			retSinle.setDeduction(new BigDecimal(orderCommitInfoDto.getJfCount()).divide(
					new BigDecimal(orderCommitInfoDto.getSinglePrice()), 2, BigDecimal.ROUND_HALF_UP));
		}
	}

	/**
	 *  活动价格校验
	 * @param orderCommitInfoDto
	 * @param user
	 * @param singleCheckDto
	 * @return
	 */
	private BigDecimal promotionPriceCheck(OrderCommitInfoDto orderCommitInfoDto,
										   User user,
										   OrderMainSingleCheckDto singleCheckDto) {
		BigDecimal goodsPrice = new BigDecimal("0");
		Response<MallPromotionResultDto> rsp = mallPromotionService.findPromByItemCodes("1", orderCommitInfoDto.getCode(), null);
		MallPromotionResultDto mallPromotionResultDto = null;
		if (rsp.isSuccess() && rsp.getResult() != null) {
			mallPromotionResultDto = rsp.getResult();
			singleCheckDto.setPromotionType(mallPromotionResultDto.getPromType());
			switch (mallPromotionResultDto.getPromType()) {
				// 折扣
				case 10 :
					goodsPrice = mallPromotionResultDto.getPromItemResultList().get(0).getPrice() == null ? new BigDecimal(0) :
							mallPromotionResultDto.getPromItemResultList().get(0).getPrice().multiply(mallPromotionResultDto.getRuleDiscountRate())
									.setScale(2, BigDecimal.ROUND_DOWN);
					break;
				// 满减
				case 20 :
					goodsPrice = orderCommitInfoDto.getPrice();
					break;
				case 50 :
					goodsPrice = orderCommitInfoDto.getPrice();
					break;
				// 团购
				case 40 :
					goodsPrice = mallPromotionResultDto.getPromItemResultList().get(0).getLevelPrice() == null ? new BigDecimal(0) :
							mallPromotionResultDto.getPromItemResultList().get(0).getLevelPrice();
					break;
				default:
					goodsPrice = mallPromotionResultDto.getPromItemResultList().get(0).getPrice() == null ? new BigDecimal(0) :
							mallPromotionResultDto.getPromItemResultList().get(0).getPrice();
					break;
			}
		}
		// 0元秒杀检证
		if (orderCommitInfoDto.getMiaoFlag().equals("1")) {
			goodsPrice = new BigDecimal("0");
			checkArgument(orderCommitInfoDto.getPrice().compareTo(goodsPrice) == 0, "0元秒杀商品价格必须为0");
		}
		// 满减 荷兰拍以外活动
		if (orderCommitInfoDto.getPromotion().getPromType() != null &&
				orderCommitInfoDto.getPromotion().getPromType() != 50 &&
				orderCommitInfoDto.getPromotion().getPromType() != 20) {
			checkArgument(goodsPrice.compareTo(orderCommitInfoDto.getPrice()) == 0, "购买商品的价格发生变化");
		}

		Integer num = orderCommitInfoDto.getItemCount();
		if (orderCommitInfoDto.getMiaoFlag().equals("1")) {
			checkArgument(num == 1, "只能秒杀一件商品");
		}

		// 活动时间有效性校验
		Response<Boolean> promValidResponse = mallPromotionService.findPromValidByPromId(orderCommitInfoDto.getPromotion().getId().toString(),
				orderCommitInfoDto.getPromotion().getPeriodId());
		if(!promValidResponse.isSuccess()){
			log.error("Response.error,error code: {}", promValidResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		checkArgument(promValidResponse.getResult(), "未在活动时间范围内或活动已结束");

		if (mallPromotionResultDto != null) {
			// 荷兰拍 满减
			if (mallPromotionResultDto.getPromType().intValue() != 50) {
				// 活动购买数量校验promotionLimitMap
				Response<Boolean> checkPromBuyCountResponse = mallPromotionService.checkPromBuyCount(orderCommitInfoDto.getPromotion().getId().toString(),
						orderCommitInfoDto.getPromotion().getPeriodId(),
						orderCommitInfoDto.getItemCount().toString(), user, orderCommitInfoDto.getCode());
				if(!checkPromBuyCountResponse.isSuccess()){
					log.error("Response.error,error code: {}", checkPromBuyCountResponse.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
				}
				checkArgument(checkPromBuyCountResponse.getResult(), "您所购买的活动商品数量已达到上限，无法继续参加活动");
			}
		}
		
		// 活动商品数量校验
		Response<Boolean> checkPromItemStockResponse = mallPromotionService.checkPromItemStock(orderCommitInfoDto.getPromotion().getId().toString(),
				orderCommitInfoDto.getPromotion().getPeriodId(), orderCommitInfoDto.getCode(),
				orderCommitInfoDto.getItemCount().toString());
		if(!checkPromItemStockResponse.isSuccess()){
			log.error("Response.error,error code: {}", checkPromItemStockResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		checkArgument(checkPromItemStockResponse.getResult(), "您所选中的活动商品库存数量不足，无法继续参加活动");
		// 是否可使用优惠卷校验
		Response<MallPromotionResultDto> findPromByItemCodesResponse = mallPromotionService.findPromByItemCodes("1", orderCommitInfoDto.getCode(), null);
		if(!findPromByItemCodesResponse.isSuccess()){
			log.error("Response.error,error code: {}", findPromByItemCodesResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		MallPromotionResultDto result = findPromByItemCodesResponse.getResult();
		if (result != null && result.getPromItemResultList() != null &&
				result.getPromItemResultList().get(0) != null &&
				result.getPromItemResultList().get(0).getCouponEnable() != null) {
			Boolean check = true;
			if (result.getPromItemResultList().get(0).getCouponEnable().compareTo(new Integer(0)) == 0 &&
					orderCommitInfoDto.getVoucherPrice().compareTo(new BigDecimal(0)) != 0) {
				check = false;
			}
			checkArgument(check, "您所选购的活动商品不可使用优惠卷");
		}
		if (mallPromotionResultDto != null) {
			// 荷兰拍 满减
			if (mallPromotionResultDto.getPromType() == 20 || mallPromotionResultDto.getPromType() == 50) {
				Response<TblGoodsPaywayModel> tblGoodsPaywayResult = goodsPayWayService.findGoodsPayWayInfo(orderCommitInfoDto.getPayWayId());
				checkArgument(tblGoodsPaywayResult.isSuccess(), "活动支付方式发生变化请重新提交");
				checkArgument(orderCommitInfoDto.getCode().equals(tblGoodsPaywayResult.getResult().getGoodsId()), "商品支付方式发生变化请重新提交");
				singleCheckDto.setPayWayId(orderCommitInfoDto.getPayWayId());
				singleCheckDto.setTblGoodsPaywayModel(tblGoodsPaywayResult.getResult());
			} else {
				Map<String, Object> param = Maps.newHashMap();
				param.put("goodsPaywayId", orderCommitInfoDto.getPayWayId());
				param.put("promId", rsp.getResult().getId());
				Response<PromotionPayWayModel> payWayModelResponse = promotionPayWayService.findPomotionPayWayInfoByParam(param);
				if (!payWayModelResponse.isSuccess() || payWayModelResponse.getResult() == null) {
					checkArgument(false, "活动支付方式发生变化请重新提交");
				}
				checkArgument(orderCommitInfoDto.getCode().equals(payWayModelResponse.getResult().getGoodsId()), "活动支付方式发生变化请重新提交");
				singleCheckDto.setPayWayId(orderCommitInfoDto.getPayWayId());
				singleCheckDto.setPromotionPayWayModel(payWayModelResponse.getResult());
			}
		}
		return goodsPrice;
	}

	/**
	 * 广发获取返回的报文
	 *
	 * @param orderMain
	 * @param orderSubModelList
	 * @return response
	 */
	public Response<PagePaymentReqDto> getReturnObjForPay_new(OrderMainModel orderMain, List<OrderSubModel> orderSubModelList) {
		Response<PagePaymentReqDto> response = Response.newResponse();
		PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
		try {
			String orderid = orderMain.getOrdermainId();// 大订单号
			String amount = orderMain.getTotalPrice().toString();// 总金额
			String payType = "";// 支付类型
			String pointType = "";// 积分类型
			String pointSum = "0";// 总积分值
			String isMerge = orderMain.getIsmerge();// 是否合并支付
			String payAccountNo = orderMain.getCardno();// 支付账号
			String serialNo = "";// 交易流水号
			String tradeDate = DateHelper.getyyyyMMdd(orderMain.getCreateTime());// 订单日期
			String tradeTime = DateHelper.getHHmmss(orderMain.getCreateTime());// 订单时间
			String certType = orderMain.getContIdType();// 证件类型
			String certNo = orderMain.getContIdcard();// 证件号
			String otherOrdersInf = "";// 优惠券、积分信息串
			pagePaymentReqDto.setSerialNo("");// 商城生成的流水号 为空
			pagePaymentReqDto.setTradeDate(tradeDate);// 交易日期 为空
			pagePaymentReqDto.setTradeTime(tradeTime);// 交易时间 为空
			pagePaymentReqDto.setOrderid(orderid);// 大订单号
			pagePaymentReqDto.setAmount(amount);// 总金额
			pagePaymentReqDto.setMerchId(merchId);// 大商户号
			pagePaymentReqDto.setReturl(returl);// 回调地址
			pagePaymentReqDto.setPointType(pointType);// 积分类型 为空
			pagePaymentReqDto.setPointSum(pointSum);// 总积分值 为空
			pagePaymentReqDto.setIsMerge(isMerge);// 是否合并支付 为空
			pagePaymentReqDto.setPayAccountNo(payAccountNo);// 支付账号 为空
			//0-商城分期(广发商城)（17-商城分期）
			//1-商城信用卡支付(广发商城)（01-B2C支付，若payType空也归此类）
			if (Contants.BUSINESS_TYPE_YG.equals(orderMain.getOrdertypeId())) {// 如果是一次性
				payType = "1";
			} else {
				payType = "0";
			}
			pagePaymentReqDto.setPayType(payType);// 支付类型
			String orders = "";
			boolean flag = false;
			for (int i = 0; i < orderSubModelList.size(); i++) {
				OrderSubModel orderSubModel = (OrderSubModel) orderSubModelList.get(i);
				if (i == 0) {// 如果是第一个子订单
					orders = Joiner.on("|").join(nullToEmpty(orderSubModel.getMerId()), nullToEmpty(orderSubModel.getOrderId()), orderSubModel.getTotalMoney(),
							orderSubModel.getStagesNum(), orderSubModel.getInstallmentPrice());
					if ((orderSubModel != null && !"".equals(orderSubModel.getVoucherNo())) || orderSubModel.getBonusTotalvalue().longValue() != 0) {
						// 存在使用积分、优惠券
						flag = true;
					}
					otherOrdersInf = Joiner.on("|").join(nullToEmpty(orderSubModel.getOrderIdHost()), nullToEmpty(orderSubModel.getMerId()),
							orderSubModel.getOrderId(), nullToEmpty(orderSubModel.getVoucherNo()), nullToEmpty(orderSubModel.getIntegraltypeId()),
							orderSubModel.getBonusTotalvalue() == null ? "0" : orderSubModel.getBonusTotalvalue().toString(), orderSubModel.getUitdrtamt() == null ? "0" : orderSubModel.getUitdrtamt().toString());
				} else {
					orders = Joiner.on("|").join(nullToEmpty(orders), orderSubModel.getMerId(), orderSubModel.getOrderId(), orderSubModel.getTotalMoney(), orderSubModel.getStagesNum(), orderSubModel.getInstallmentPrice());
					if (!Strings.isNullOrEmpty(orderSubModel.getVoucherNo()) || orderSubModel.getBonusTotalvalue().longValue() != 0) {
						// 存在使用积分、优惠券
						flag = true;
					}
					otherOrdersInf = Joiner.on("|").join(nullToEmpty(otherOrdersInf), nullToEmpty(orderSubModel.getOrderIdHost()), nullToEmpty(orderSubModel.getMerId()),
							nullToEmpty(orderSubModel.getOrderId()), nullToEmpty(orderSubModel.getVoucherNo()), nullToEmpty(orderSubModel.getIntegraltypeId()),
							orderSubModel.getBonusTotalvalue() == null ? "0" : orderSubModel.getBonusTotalvalue().toString(), orderSubModel.getUitdrtamt() == null ? "0" : orderSubModel.getUitdrtamt().toString());
				}
			}
			log.info("密钥：" + mainPrivateKey);
			if (!flag) {// 如果没使用优惠券、积分
				certType = "";
				certNo = "";
				otherOrdersInf = "";
			} else {// 打印出优惠券积分串
				log.debug("积分、优惠券串otherOrdersInf:" + otherOrdersInf);
			}
			pagePaymentReqDto.setOrders(orders);// 订单信息串
			pagePaymentReqDto.setOtherOrdersInf(otherOrdersInf);// 优惠券信息串
			pagePaymentReqDto.setCertType(certType);
			pagePaymentReqDto.setCertNo(certNo);
			String singGene = Joiner.on("|").join(merchId, nullToEmpty(orderid), amount, pointType, pointSum, isMerge, payType, nullToEmpty(orders), nullToEmpty(payAccountNo), nullToEmpty(serialNo), tradeDate, nullToEmpty(tradeTime), nullToEmpty(otherOrdersInf), nullToEmpty(certType), nullToEmpty(certNo)).trim();
			log.debug("订单信息串singGene:" + singGene);
			// 改用旧系统加密方式
			String sign = SignAndVerify.sign_md(singGene, mainPrivateKey);// 签名
			pagePaymentReqDto.setSign(sign);// 签名
			pagePaymentReqDto.setPayAddress(payAddress);// 支付网关地址
			pagePaymentReqDto.setIsPractiseRun("0");
			pagePaymentReqDto.setTradeChannel(Contants.TRADECHANNEL);
			pagePaymentReqDto.setTradeSource(Contants.TRADESOURCE);
			pagePaymentReqDto.setBizSight(Contants.BIZSIGHT);
			pagePaymentReqDto.setSorceSenderNo(orderid); //// 源发起方流水:大订单号
			pagePaymentReqDto.setOperatorId("");
			if (log.isDebugEnabled()) {
				log.debug("\n************ e-payment request info start ************\n"
								+ pagePaymentReqDto.toString().replaceAll(",", "\n")
								+ "\n************ e-payment request info end ************"
				);
			}
			response.setResult(pagePaymentReqDto);
			return response;
		} catch (Exception e) {
			log.error("OrderFQMainService getReturnObjForPay error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderFQMainService.getReturnObjForPay.error");
			return response;
		}
	}
}
