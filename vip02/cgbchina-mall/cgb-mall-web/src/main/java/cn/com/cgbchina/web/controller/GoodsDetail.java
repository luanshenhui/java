package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import cn.com.cgbchina.item.dto.BirthdayTipDto;
import cn.com.cgbchina.item.dto.CardScaleDto;
import cn.com.cgbchina.item.dto.GoodsItemDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.PromotionItemResultDto;
import cn.com.cgbchina.item.dto.MallPromotionSaleInfoDto;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.GoodsDetailService;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.trade.dto.CartAddDto;
import cn.com.cgbchina.trade.dto.VoucherInfoDto;
import cn.com.cgbchina.trade.service.CartService;
import cn.com.cgbchina.trade.service.RedisService;
import cn.com.cgbchina.user.service.UserBrowseHistoryService;
import cn.com.cgbchina.user.service.UserFavoriteService;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * Created by Cong on 2016/5/27.
 */
@Controller
@RequestMapping("/api/goodsDetail")
@Slf4j
public class GoodsDetail {

	@Autowired
	private GoodsDetailService goodsDetailService;
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private UserBrowseHistoryService userBrowseHistoryService;
	@Autowired
	private UserFavoriteService userFavoriteService;
	@Resource
	private MallPromotionService mallPromotionService;
	@Resource
	private CartService cartService;
	@Resource
	private CouponService couponService;
	@Resource
	private PointsPoolService pointsPoolService;
	@Resource
	private PromotionPayWayService promotionPayWayService;
	@Autowired
	private MessageSources messageSources;
	@Resource
	private GoodsPayWayService goodsPayWayService;
	@Resource
	private RedisService redisService;

	/**
	 * 获取商品咨询信息
	 *
	 * @param goodsCode
	 * @param pageNo
	 * @param size
	 * @return
	 */
	@RequestMapping(value = "/getGoodsConsult", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Pager<GoodsConsultModel>> getGoodsConsultPager(String goodsCode, Integer pageNo, Integer size) {
		Response<Pager<GoodsConsultModel>> result = new Response<Pager<GoodsConsultModel>>();
		try {
			Pager<GoodsConsultModel> goodsConsultModelPager = goodsDetailService.getGoodsConsultList(goodsCode, pageNo,
					size);
			result.setResult(goodsConsultModelPager);
			return result;
		} catch (Exception e) {
			log.error("GoodsDetailService.findGoodsDescribe.fail,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("GoodsDetailService.findGoodsDescribe.fail");
			return result;
		}
	}

	/**
	 * 获取库存信息
	 *
	 * @param itemCode
	 * @return
	 */
	@RequestMapping(value = "/getItemStock", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<String> getItemStock(String itemCode) {
		Response<String> result = new Response<String>();
		if (itemCode == null) {
			result.setError("itemCode.can.not.be.empty");
			return result;
		}
		try {
			Response<String> results = goodsDetailService.getItemStock(itemCode);
			if(!results.isSuccess()){
				log.error("Response.error,error code: {}", results.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(results.getError()));
			}
			String stock = results.getResult();
			result.setResult(stock);
			return result;
		} catch (Exception e) {
			result.setError("goodsDetail.getItemStock.fail");
			return result;
		}
	}
	/**
	 * 获取用户是否是信用卡用户
	 */

	@RequestMapping(value = "/getUserCreditCard", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> getUserCreditCard(){
		Map<String, Object> returned = Maps.newHashMap();
		User user = UserUtil.getUser();
		Boolean creditCard = true;
		if (user != null) {
			creditCard = false;
			List<UserAccount> userCartDtoList = user.getAccountList();
			if (userCartDtoList != null) {
				// 有一张卡符合第三级卡要求则允许用户购买
				for (UserAccount userAccount : userCartDtoList) {
					if (UserAccount.CardType.CREDIT_CARD.equals(userAccount.getCardType())) {
						creditCard = true;
						break;
					}
				}
			}
			returned.put("creditCard",creditCard);
			return returned;
		}else{
			returned.put("creditCard",creditCard);
			return returned;
		}
	}
	/**
	 * 获取用户积分
	 */
	@RequestMapping(value = "/getUserScore", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> getUserScore(){
		Map<String, Object> returned = Maps.newHashMap();
		User user = UserUtil.getUser();
		String userScore;
		if (user != null){
			try {
				Response<Map<String,BigDecimal>> response = redisService.getScores(user);
				if (response.isSuccess()) {
					userScore = response.getResult().get(Contants.JGID_COMMON)==null?"":response.getResult().get(Contants.JGID_COMMON).toString();
				}
				else {
					userScore = "";
				}
				returned.put("userScore",userScore);
				return returned;
			}catch (Exception e){
				log.error("GoodsDetail.userScore.error{}",Throwables.getStackTraceAsString(e));
				userScore = "error";
				returned.put("userScore",userScore);
				return returned;
			}
		}else {
			userScore = "nologin";
			returned.put("userScore",userScore);
			return returned;
		}
	}

	/**
	 * 获取用户生日折扣信息
	 *
	 * @return
	 */
	@RequestMapping(value = "/getUserBirth", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<BirthdayTipDto> getUserBirth(HttpServletRequest request, HttpServletResponse response) {
		Response<BirthdayTipDto> result = new Response<BirthdayTipDto>();
		try {
			User user = UserUtil.getUser();
			List<UserAccount> userCartDtoList = user.getAccountList();
			final List<String> cardNos = Lists.transform(userCartDtoList, new Function<UserAccount, String>() {
				@Override
				public String apply(@NotNull UserAccount input) {
					return input.getCardNo();
				}
			});
			Response<BirthdayTipDto> results = goodsDetailService.getUserBirth(user.getCertNo(),Lists.newArrayList(cardNos));
			if(!results.isSuccess()){
				log.error("Response.error,error code: {}", results.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(results.getError()));
			}
			BirthdayTipDto dto = results.getResult();
			result.setResult(dto);
			return result;
		} catch (Exception e) {
			result.setError("goodsDetailService.getUserBirth.fail");
			return result;
		}
	}

	@RequestMapping(value = "/cardScale", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<CardScaleDto>> findCardScale() {
		Response<List<CardScaleDto>> result = new Response<List<CardScaleDto>>();
		User user = UserUtil.getUser();
		Response<List<CardScaleDto>> response = goodsDetailService.findCardScaleByUserId(user);
		if (response.isSuccess()) {
			return response;
		}
		result.setResult(Collections.<CardScaleDto> emptyList());
		return result;
	}

	// 检查该商品是否被收藏（未登录返回未收藏）
	@RequestMapping(value = "/checkFavorite", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<String> checkFavorite( String itemCode) {
		User user = UserUtil.getUser();
		Response<String> response = new Response<>();
		if (user != null) {
			response = userFavoriteService.checkFavorite(itemCode, user.getCustId());
			if (response.isSuccess()) {
				return response;
			}
		}
		response.setResult("0");
		return response;
	}

	// 存储用户足迹信息
	@RequestMapping(value = "/creatUserBrowse", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public boolean creatUserBrowse(@RequestParam("itemCode") String itemCode) {
		User user = UserUtil.getUser();
		if (user != null) {
			ItemModel itemModel = itemService.findById(itemCode);
			if (itemModel != null) {
				if (Strings.isNullOrEmpty(itemModel.getInstallmentNumber())){//礼品没有分期,没有售价
					Response<List<TblGoodsPaywayModel>>tblGoodsPaywayModelResponse=goodsPayWayService.findInfoByItemCode(itemCode);

					if (!tblGoodsPaywayModelResponse.isSuccess()||tblGoodsPaywayModelResponse.getResult()==null||tblGoodsPaywayModelResponse.getResult().isEmpty()){
						return true;
					}
					//默认第一条，第一条为金普价
					TblGoodsPaywayModel tblGoodsPaywayModel=tblGoodsPaywayModelResponse.getResult().get(0);
					Long goodsPoints=tblGoodsPaywayModel.getGoodsPoint();
					userBrowseHistoryService.loinBrowseHistory(itemModel.getGoodsCode(), itemModel.getCode(),
							BigDecimal.ZERO, user.getCustId(), 0,goodsPoints);
				}else{

					//调用共通方法，查找单品最高期数
					Integer maxInstallmentNumber = GoodsCheckUtil.getMaxInstallmentNumber(itemModel.getInstallmentNumber());

					// 插入用户浏览历史
					userBrowseHistoryService.loinBrowseHistory(itemModel.getGoodsCode(), itemModel.getCode(),
							itemModel.getPrice(), user.getCustId(), maxInstallmentNumber,null);
				}
			}
		}
		return true;
	}

	// 查询商品是否参加活动
	@RequestMapping(value = "/itemPromotion", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public MallPromotionResultDto itemPromotion(@RequestParam("itemCode") String itemCode) {
		MallPromotionResultDto mallPromotionResultDto = new MallPromotionResultDto();
		// 调用活动接口获得该商品的活动信息
		Response<MallPromotionResultDto> mallPromotion = mallPromotionService.findPromByItemCodes("0", itemCode,
				Contants.PROMOTION_SOURCE_ID_00);
		if (mallPromotion.isSuccess()) {
			if(mallPromotion.getResult() == null){
				return mallPromotionResultDto;
			}
			mallPromotionResultDto = mallPromotion.getResult();
			if ("0".equals(mallPromotionResultDto.getPromStatus())){
				Response<List<PromotionPayWayModel>> findInfoByItemCode = promotionPayWayService
						.findPromotionByItemCode(itemCode, mallPromotionResultDto.getId());
				if (!findInfoByItemCode.isSuccess()) {
					return mallPromotionResultDto;
				}
				mallPromotionResultDto.setTblGoodsPaywayModelList(findInfoByItemCode.getResult());
				List<PromotionItemResultDto> promItemResultList = mallPromotionResultDto.getPromItemResultList();// 活动范围（选品列表）
				mallPromotionResultDto.setSaleAmountAll(promItemResultList.get(0).getBuyCount() != null
						? promItemResultList.get(0).getBuyCount().toString() : "0");
				// 查询活动商品是否还有库存
				if (mallPromotionResultDto.getId() == null){
					log.error("mallPromotionResultDto.id.isnull");
					return mallPromotionResultDto;
				}
				Response<MallPromotionSaleInfoDto> salePromtion =  mallPromotionService.findPromSaleInfoByPromId(mallPromotionResultDto.getId().toString(), mallPromotionResultDto.getPeriodId(), itemCode);
//			Response<Boolean> mallBoolean = mallPromotionService.checkPromItemStock(
//					mallPromotionResultDto.getId().toString(), mallPromotionResultDto.getPeriodId(), itemCode, "1");
				if (salePromtion.isSuccess()) {
					MallPromotionSaleInfoDto mallPromotionSaleInfoDto =  salePromtion.getResult();
					Long remainStock = mallPromotionSaleInfoDto.getRemainStock();
					mallPromotionResultDto.setRemainStock(remainStock);
					if(remainStock != null && remainStock.compareTo(0l) > 0 ){
						mallPromotionResultDto.setHavaStock(true);
					}else {
						mallPromotionResultDto.setHavaStock(false);
					}
				} else {
					mallPromotionResultDto.setHavaStock(true);// 防止影响后续流程校验库存失败认为可以购买
				}
			}
		}
		return mallPromotionResultDto;
	}

	/**
	 * 提交至购物车前校验
	 *
	 * @param itemCode 单品id
	 * @param goodsNum 购买数量
	 * @param payType 支付方式(1信用卡支付,2借记卡支付,3全积分支付,4零元秒杀)
	 * @param oriBonusValue 抵扣积分（打折前）
	 * @param goodsPaywayId 支付方式id（具体价格分期信息）
	 * @return
	 */
	@RequestMapping(value = "/addToGoodsCart", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean checkCanToCart(String itemCode, String goodsNum,
			String payType,  String oriBonusValue,
			 String goodsPaywayId) {
		try {
			User user = UserUtil.getUser();
			ItemModel itemModel = itemService.findById(itemCode);// 单品信息
			if (itemModel == null){
				throw new ResponseException(500, messageSources.get("pointsGift.check.itemid.error"));
			}
			GoodsModel goodsmodel = goodsService.findById(itemModel.getGoodsCode()).getResult();// 商品信息
			if (goodsmodel == null){
				throw new ResponseException(500, messageSources.get("pointsGift.check.itemid.error"));
			}
			if (!Contants.CHANNEL_MALL_02.equals(goodsmodel.getChannelMall())) {
				throw new ResponseException(500, messageSources.get("goodsDetail.check.goodUndercarriage"));
			}

			BigDecimal stock = new BigDecimal(goodsNum);// 购买数量
			BigDecimal oriBonusLong = new BigDecimal(Strings.isNullOrEmpty(oriBonusValue) ? "0" : oriBonusValue);// 抵扣积分（未折扣）
			String mallPromotionId = null;// 活动ID
			String periodId = null;// 场次ID
			Integer promType = null;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
			BigDecimal cardScale = new BigDecimal(1);// 最优兑换比例(如果是借记卡流程该数据未获取)
			String cardName = "借记卡";
			Long singlePoint = null;// 单位积分
			BigDecimal price = new BigDecimal(0);//商品价格

			// 调用活动接口获得该商品的活动信息
			Response<MallPromotionResultDto> mallPromotion = mallPromotionService.findPromByItemCodes("1", itemCode,
					Contants.PROMOTION_SOURCE_ID_00);
			if (mallPromotion.isSuccess()&&mallPromotion.getResult()!=null) {
				MallPromotionResultDto mallPromotionResultDto = mallPromotion.getResult();
				if (mallPromotionResultDto != null && mallPromotionResultDto.getId() != null) {
					mallPromotionId = String.valueOf(mallPromotion.getResult().getId());
					periodId = mallPromotion.getResult().getPeriodId();
					promType = mallPromotion.getResult().getPromType();
				}
				//2.如果是荷兰拍抛出异常那之前就不用算价钱了啊？(荷兰拍不在这里加入购物车需要到荷兰拍页面购买，详情页不提供荷兰拍入口)
				if (promType != null && 50 == promType) {
					throw new ResponseException(500, messageSources.get("goodsDetail.check.ishelanpai"));
				}
				if (promType !=null && (promType.equals(20)||promType.equals(50))){//满减和荷兰拍支付方式
					Response<TblGoodsPaywayModel> responseGoodsPayWay = goodsPayWayService.findGoodsPayWayInfo(goodsPaywayId);
					isGoodsPaywaySuccess(responseGoodsPayWay);//校验支付方式结果
					TblGoodsPaywayModel goodsPaywayModel = responseGoodsPayWay.getResult();
					//数据篡改检查
					if(!goodsPaywayModel.getGoodsId().equals(itemCode)) {
						throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("goodsDetail.check.goodspayway.warning"));
					}
					price = goodsPaywayModel.getGoodsPrice();
				}else{
					Response<List<PromotionPayWayModel>> findInfoByItemCode = promotionPayWayService
							.findPromotionByItemCode(itemCode, mallPromotionResultDto.getId());
					isGoodsPaywaySuccess(findInfoByItemCode);//校验支付方式结果
					if(!findInfoByItemCode.getResult().get(0).getGoodsId().equals(itemCode)){
						throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("goodsDetail.check.goodspayway.warning"));
					}
					price = findInfoByItemCode.getResult().get(0).getGoodsPrice();
				}
			}else{
				Response<TblGoodsPaywayModel> responseGoodsPayWay = goodsPayWayService.findGoodsPayWayInfo(goodsPaywayId);
				isGoodsPaywaySuccess(responseGoodsPayWay);//校验支付方式结果
				TblGoodsPaywayModel goodsPaywayModel = responseGoodsPayWay.getResult();
				//数据篡改检查
				if(!goodsPaywayModel.getGoodsId().equals(itemCode)){
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("goodsDetail.check.goodspayway.warning"));
				}
				price = goodsPaywayModel.getGoodsPrice();
			}
			Response<PointPoolModel> pointsPoolResponse = pointsPoolService.getCurOrLastInfo();
			if (pointsPoolResponse.isSuccess()) {
				singlePoint = pointsPoolResponse.getResult().getSinglePoint();
			} else {
				throw new ResponseException(500, messageSources.get("goodsDetail.check.getsinglePoint.error"));
			}
			if (mallPromotionId != null) {
				Response<Integer> resCartNumber = cartService.findCustCartNumByUserItem(user,itemCode);
				int buyNum = Integer.parseInt(goodsNum);
				if(resCartNumber.isSuccess()){
					Integer cartNumber = resCartNumber.getResult();
					if(cartNumber!=null){
						buyNum = buyNum + cartNumber.intValue();
					}
				}
				// 校验库存(活动商品)
				// 根据活动ID、场次ID、单品CODE、购买数量 检验是否超过库存
				Response<Boolean> mallBoolean = mallPromotionService.checkPromItemStock(mallPromotionId, periodId, itemCode,
						String.valueOf(buyNum));
				//3.这段代码什么意思？（曾经的一个bug。商品页面购买两件，活动还剩一件，要求提示‘请减少购买数量’的提示。）
				if (mallBoolean.isSuccess()) {
					if (!mallBoolean.getResult()) {
						Response<Boolean> mallBoolean2 = mallPromotionService.checkPromItemStock(mallPromotionId, periodId, itemCode,
								"1");
						if(mallBoolean2.getResult()){
							throw new ResponseException(500, messageSources.get("goodsDetail.check.goodsStock"));
						}else {
							throw new ResponseException(500, messageSources.get("goodsDetail.check.promotionShowdown"));
						}
					}
				} else {
					throw new ResponseException(500, messageSources.get("goodsDetail.check.promotionStock.error"));
				}
				// 根据活动ID、场次ID、购买数量 检验用户是否达到限购
				Response<Boolean> bugBoolean = mallPromotionService.checkPromBuyCount(mallPromotionId, periodId, String.valueOf(buyNum),
						user,itemCode);
				if (bugBoolean.isSuccess()) {
					if (!bugBoolean.getResult()) {
						if(30 == promType){
							throw new ResponseException(500, "特惠商品，每次限购"+mallPromotion.getResult().getRuleLimitBuyCount()+"个");
						}
						throw new ResponseException(500, messageSources.get("goodsDetail.check.promotionRestrictions"));
					}
				} else {
					throw new ResponseException(500, messageSources.get("goodsDetail.check.promotionRestrictions.error"));
				}
			} else {
				//库存
				BigDecimal itemStock = new BigDecimal(itemModel.getStock());
				// 校验库存(普通商品)
				if (stock.compareTo(itemStock) > 0) {
					throw new ResponseException(500, messageSources.get("goodsDetail.check.goodsStock"));
				}
			}
			// 支付方式  1信用卡支付,2借记卡支付,3全积分支付,4零元秒杀
			// 第三类卡
			if ("1".equals(payType)) {
				Response<Boolean> result = goodsDetailService.checkThreeCard(itemModel.getGoodsCode(), UserUtil.getUser());
				if (result.isSuccess()) {
					if (!result.getResult()) {
						throw new ResponseException(500, messageSources.get("goodsDetail.check.useThreeCard"));
					}
				} else {
					throw new ResponseException(500, messageSources.get("goodsDetail.check.useThreeCard.error"));
				}
			}
			BigDecimal commonAmount = new BigDecimal(0);
			Response<Map<String,BigDecimal>> userAccountResponse = redisService.getScores(user);
			if (userAccountResponse.isSuccess()) {
				commonAmount= userAccountResponse.getResult().get(Contants.JGID_COMMON);
			}
			if (commonAmount == null){
				commonAmount = BigDecimal.ZERO;
			}
			//抵扣最佳倍率
			BigDecimal itembestRate = itemModel.getBestRate()==null?BigDecimal.ZERO:itemModel.getBestRate();
			//全积分兑换比例
			BigDecimal single_point = price.multiply(new BigDecimal(singlePoint)).multiply(itembestRate);
			//最佳抵扣积分
			BigDecimal split_point =
					(price.multiply(itembestRate).setScale(0,BigDecimal.ROUND_DOWN)).multiply(new BigDecimal(singlePoint));
			if ("1".equals(payType) || "3".equals(payType)) { // 信用卡或全积分流程
				//根据用户取得最优的兑换比例
				Response<List<CardScaleDto>> cardScales = goodsDetailService.findCardScaleByUserId(user);

				//最优兑换比例(如果是借记卡流程该数据未获取)
				if (cardScales.isSuccess()) {
					List<CardScaleDto> cardScaleDtoList = cardScales.getResult();
					CardScaleDto cardScaleDto = cardScaleDtoList.get(0);
					cardScale = cardScaleDto.getScal();
					cardName = cardScaleDto.getCardName();
				}
				// 非法抵现积分
				if (oriBonusLong.compareTo(single_point.multiply(stock)) > 0) {
					throw new ResponseException(500, messageSources.get("goodsDetail.check.useOriBonus"));
				}
				// 全积分流程start
				BigDecimal goodsNums = new BigDecimal(goodsNum);
				if ("3".equals(payType)) {
					oriBonusLong = single_point.multiply(goodsNums);
				}
				// 全积分流程end
				//抵扣积分验证
				if (oriBonusLong.longValue() % singlePoint > 0 && !"3".equals(payType)) {
					throw new ResponseException(500, messageSources.get("goodsDetail.check.useOriBonus.integer"));
				}
				log.info("用户积分" + commonAmount);
				log.info("抵扣几分" + oriBonusLong);
				log.info("cardScale" + cardScale);
				// 积分抵扣（页面已控制）
				if(commonAmount.compareTo(BigDecimal.ZERO)<0){
					commonAmount = BigDecimal.ZERO;
				}
				if ((cardScale.multiply(oriBonusLong)).compareTo(commonAmount) > 0) {
					throw new ResponseException(500, messageSources.get("goodsDetail.check.useOriBonus.low"));
				}

				if (oriBonusLong.compareTo(BigDecimal.ZERO) > 0) {
					if (pointsPoolResponse.isSuccess()) {
						PointPoolModel pointPoolModel = pointsPoolResponse.getResult();
						// 积分池余额
						Long surplusPoint = pointPoolModel.getMaxPoint() - pointPoolModel.getUsedPoint();
						BigDecimal surplusPoints = new BigDecimal(surplusPoint);
						if (cardScale.multiply(oriBonusLong).compareTo(surplusPoints) > 0) {
							throw new ResponseException(500, messageSources.get("goodsDetail.check.usePoints.end"));
						}
					} else {
						throw new ResponseException(500, messageSources.get("goodsDetail.check.usePoints.end"));
					}
				}
				// 固定积分（页面已控制）
				if (itemModel.getFixPoint() != null && ((stock.multiply(cardScale.multiply(new BigDecimal(itemModel.getFixPoint())))).compareTo(commonAmount) > 0)) {
					throw new ResponseException(500, messageSources.get("goodsDetail.check.useOriBonus.low"));
				}
			}
			// 零元秒杀不加入购物车
			if ("4".equals(payType)) {
				return true;
			}
			//加入购物车需要存在支付方式
			if (Strings.isNullOrEmpty(goodsPaywayId)){
				throw new ResponseException(500, messageSources.get("goodsDetail.check.goodspayway.null"));
			}
			// 加入购物车
			addTOCart(itemModel, user, goodsPaywayId, payType, oriBonusLong.longValue(), goodsNum, cardScale, singlePoint, single_point.longValue(),split_point.longValue(),cardName);
			// 积分拆分结束
			return true;
		}catch (ResponseException e){
			throw e;
		}catch (Exception e){
			log.error("addToGoodsCart.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500,messageSources.get("goodsDetail.addCart.error"));
		}
	}
	  private void isGoodsPaywaySuccess(Response<?> response){
		  if(!response.isSuccess()){
			  log.error("Response.error,error code: {}", response.getError());
			  throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
		  }
		  if(response.getResult()==null){
			  log.error("goodspayway not exist paramter={}",response);
			  throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("goodsDetail.goods.payway.not.exist"));
		  }
  }


	/**
	 *
	 * 将通过验证的数据加入购物车
	 *
	 * @param itemModel 单品信息
	 * @param user 用户
	 * @param goodsPaywayId 支付方式id
	 * @param payType 支付方式
	 * @param oriBonusLong  抵扣积分（未折扣）
	 * @param goodsNum 购买数量
	 * @param cardScale 最优兑换比例
	 * @param singlePoint 单位积分
     * @param single_point 单品最多可用积分数
	 * @param split_point 拆单积分数（单位积分的整数倍）
     */
	private void addTOCart(ItemModel itemModel, User user, String goodsPaywayId, String payType, Long oriBonusLong,
			String goodsNum, BigDecimal cardScale, Long singlePoint, Long single_point, Long split_point, String cardName) {
		// 加入购物车
		CartAddDto cartAddDto = new CartAddDto();
		cartAddDto.setOrigin(Contants.CHANNEL_MALL_CODE); // 网上商城（包括广发，积分商城）
		cartAddDto.setCustId(user.getCustId());
		cartAddDto.setItemId(itemModel.getCode());
		cartAddDto.setGoodsPaywayId(goodsPaywayId);
		cartAddDto.setMallType("01");// 商城类型标识 "01":广发商城 ;"02":积分商城
		cartAddDto.setCustmerNm(cardName);
		Response<PointPoolModel> pointsPoolResponse = pointsPoolService.getCurMonthInfo();
		if (pointsPoolResponse.isSuccess()) {
			cartAddDto.setSinglePoint(singlePoint);// 单位积分
		}
		if ("1".equals(payType)) { // 信用卡
			cartAddDto.setFixBonusValue(itemModel.getFixPoint());// 固定积分
			// 积分拆分开始
			if (itemModel.getFixPoint() == null || itemModel.getFixPoint() == 0) { // 未设置固定积分场合
				if(single_point==null || single_point.equals(0l) || split_point.equals(0l)){//最佳抵扣积分为0时
					cartAddDto.setGoodsNum(goodsNum);
					cartAddDto.setBonusValue(0l);// 积分抵扣数
					cartAddDto.setOriBonusValue(0l);// 抵扣积分
					cartAddDto.setOrdertypeId("FQ");// 分期订单:FQ 一次性订单:YG 积分订单：JF
					cartAddDto.setCardType("1");// 卡类型 1：信用卡；2借记卡
					Response<Integer> response = cartService.createCartInfo(cartAddDto);
					if (!response.isSuccess()) {
						throw new ResponseException(500, response.getError());
					}
				}else {
					long allPointGoods = oriBonusLong / split_point;// 可用于最大积分抵现的商品或全积分抵现的商品数量
					long portionGoods = 0;// 部分抵现商品的数量
					long portionPoint = oriBonusLong - allPointGoods * split_point;// 剩余积分抵现的商品的积分数
					if (portionPoint > 0) {
						portionGoods = 1;
					}
					long zeroPoint = Long.parseLong(goodsNum) - portionGoods - allPointGoods;
					cartAddDto.setOrdertypeId("FQ");// 分期订单:FQ 一次性订单:YG 积分订单：JF
					cartAddDto.setCardType("1");// 卡类型 1：信用卡；2借记卡
					if (allPointGoods > 0) {
						cartAddDto.setGoodsNum(String.valueOf(allPointGoods));
						cartAddDto.setBonusValue(cardScale.multiply(new BigDecimal(split_point)).longValue());// 积分抵扣数
						cartAddDto.setOriBonusValue(split_point);// 抵扣积分
						Response<Integer> response = cartService.createCartInfo(cartAddDto);
						if (!response.isSuccess()) {
							throw new ResponseException(500, response.getError());
						}
					}
					if (portionGoods > 0) {
						cartAddDto.setGoodsNum(String.valueOf(portionGoods));
						cartAddDto.setBonusValue(cardScale.multiply(new BigDecimal(portionPoint)).longValue());// 积分抵扣数
						cartAddDto.setOriBonusValue(portionPoint);// 抵扣积分
						Response<Integer> response = cartService.createCartInfo(cartAddDto);
						if (!response.isSuccess()) {
							throw new ResponseException(500, response.getError());
						}
					}
					if (zeroPoint > 0) {
						cartAddDto.setGoodsNum(String.valueOf(zeroPoint));
						cartAddDto.setBonusValue(0l);// 积分抵扣数
						cartAddDto.setOriBonusValue(0l);// 抵扣积分
						Response<Integer> response = cartService.createCartInfo(cartAddDto);
						if (!response.isSuccess()) {
							throw new ResponseException(500, response.getError());
						}
					}
				}
			}  else {// 设置固定积分场合
				cartAddDto.setGoodsNum(goodsNum);
				cartAddDto.setOrdertypeId("FQ");// 分期订单:FQ 一次性订单:YG 积分订单：JF
				cartAddDto.setCardType("1");// 卡类型 1：信用卡；2借记卡
				cartAddDto.setBonusValue(0l);// 积分抵扣数
				cartAddDto.setOriBonusValue(0l);// 抵扣积分
				Response<Integer> response = cartService.createCartInfo(cartAddDto);
				if (!response.isSuccess()) {
					throw new ResponseException(500, response.getError());
				}
			}
		} else if("3".equals(payType)) { //全积分流程
			cartAddDto.setOrdertypeId("FQ");// 分期订单:FQ 一次性订单:YG 积分订单：JF
			cartAddDto.setCardType("1");// 卡类型 1：信用卡；2借记卡
			cartAddDto.setGoodsNum(goodsNum);
			cartAddDto.setBonusValue(cardScale.multiply(new BigDecimal(single_point)).longValue());// 积分抵扣数
			cartAddDto.setOriBonusValue(single_point);// 抵扣积分
			Response<Integer> response = cartService.createCartInfo(cartAddDto);
			if (!response.isSuccess()) {
				throw new ResponseException(500, response.getError());
			}
		} else {
			// 借记卡流程
			cartAddDto.setGoodsNum(goodsNum);
			cartAddDto.setOrdertypeId("YG");// 分期订单:FQ 一次性订单:YG 积分订单：JF
			cartAddDto.setFixBonusValue(0l);// 固定积分
			cartAddDto.setCardType("2");// 卡类型 1：信用卡；2借记卡
			cartAddDto.setBonusValue(0l);// 积分抵扣数
			cartAddDto.setOriBonusValue(0l);// 抵扣积分
			Response<Integer> response = cartService.createCartInfo(cartAddDto);
			if (!response.isSuccess()) {
				throw new ResponseException(500, response.getError());
			}
		}
	}

	/**
	 * 获得商品可领的优惠券信息
	 */
	@RequestMapping(value = "/findDrawCoupon", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<VoucherInfoDto> findDrawCoupon(@RequestParam("goodsCode") String goodsCode) {
		User user = UserUtil.getUser();
		List<VoucherInfoDto> voucherInfoDtoList = null;

		// 获取商品信息
		Response<GoodsModel> goodsResponse = goodsService.findById(goodsCode);
		if (!goodsResponse.isSuccess()) {
			log.error("find.goods.error");
			throw new ResponseException(500, messageSources.get("find.goods.error"));
		}
		GoodsModel goodsModel = goodsResponse.getResult();
		if (user != null) {
			Response<List<CouponInfo>> couponInfoResponse = redisService.getCoupons(user.getId(),
					user.getCertType(), user.getCertNo());
			if (couponInfoResponse.isSuccess()) {
				List<CouponInfo> couponInfoList = couponInfoResponse.getResult();
				Response<Map<String, List<VoucherInfoDto>>> response = cartService.getCouponInfo(couponInfoList, goodsModel, 0);
				if (response.isSuccess()) {
					voucherInfoDtoList = response.getResult().get("CouponsForGet");
				}
				else {
					log.error("failed to getCouponInfos of db,error code:{}", response.getError());
					throw new ResponseException(500, messageSources.get(response.getError()));
				}
			}
			else {
				log.error("failed to getCouponInfos of outer,error code:{}", couponInfoResponse.getError());
			}
		}else{ // 未登录显示所有优惠券
			List<CouponInfo> couponInfoList = Lists.newArrayList();
			Response<Map<String, List<VoucherInfoDto>>> response = cartService.getCouponInfo(couponInfoList, goodsModel, 0);
			if (response.isSuccess()) {
				voucherInfoDtoList = response.getResult().get("CouponsForGet");
			}
			else {
				log.error("failed to getCouponInfos of db,error code:{}", response.getError());
				throw new ResponseException(500, messageSources.get(response.getError()));
			}
		}
		return voucherInfoDtoList;
	}

	/**
	 * 领取优惠券
	 */
	@RequestMapping(value = "/drawCoupon", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean drawCoupon(String couponId, String goodsCode) {
		User user = UserUtil.getUser();
		//领取优惠券之前校验是否已经领取过
		Boolean received = false;
		List<VoucherInfoDto> voucherInfoDtoList = findDrawCoupon(goodsCode);
		if(voucherInfoDtoList != null && !voucherInfoDtoList.isEmpty()){
			for(VoucherInfoDto voucherInfoDto : voucherInfoDtoList){
				if(couponId.equals(voucherInfoDto.getVoucherId()) && 0==(voucherInfoDto.getIsReceived()).intValue()){
					received = true;
				}
			}
		}
		if(received){
			log.error("GoodsDetail.drawCoupon.error.casuse.by.has.received,couponId{}",couponId);
			throw new ResponseException(500, messageSources.get("the.coupon.has.been.received"));
		}else{
			ProvideCouponPage provideCouponPage = new ProvideCouponPage();
			provideCouponPage.setChannel("BC");// 交易渠道
			provideCouponPage.setContIdCard(user.getCertNo());// 证件号码
			provideCouponPage.setProjectNO(couponId);// 优惠劵项目编号
			String b = "3";
			provideCouponPage.setGrantType(b);// 发放种类
			provideCouponPage.setNum(1);// 数量
			log.info("GoodsDetail.findDrawCoupon.provideCoupon,contIdCard:{},projectNO:{},grantType:{}",
					provideCouponPage.getContIdCard(), provideCouponPage.getProjectNO(), provideCouponPage.getGrantType());
			// 请求增值服务接口
			ProvideCouponResult provideCouponResult = couponService.provideCoupon(provideCouponPage);
			log.info("GoodsDetail.findDrawCoupon.provideCouponResult,returnCode:{},returnDes:{}，totalCount:{}",
					provideCouponResult.getReturnCode(), provideCouponResult.getReturnDes(),
					provideCouponResult.getTotalCount());
			if ("000000".equals(provideCouponResult.getReturnCode())) {
				Response<Boolean> response =  redisService.deleteCoupons(user.getId());
				if (response.isSuccess()) {
					redisService.getCoupons(user.getId(), user.getCertType(), user.getCertNo());
					return true;
				}
				return false;

			} else {
				return false;
			}
		}
	}

	/**
	 * 获得单品信息
	 */
	@RequestMapping(value = "/findItemDetail", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public GoodsItemDto findItemDetail(@RequestParam("itemCode") String itemCode) {
		Response<GoodsItemDto> response = goodsDetailService.findItemDetail(itemCode);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("获取荷兰拍单品详情失败{},itemCode={}",response.getError(),itemCode);
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 用户积分详细结果
	 */
	@RequestMapping(value = "/findUserPoints", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, BigDecimal> findUserPoints() {
		User user = UserUtil.getUser();
		Map<String, BigDecimal> userPoints = null;
		try{
			Response<Map<String,BigDecimal>> response = redisService.getScores(user);
			Map<String,BigDecimal> pointsMap = null;
			if (response.isSuccess()) {
				pointsMap =  response.getResult();
			}
			if (pointsMap != null && !pointsMap.isEmpty()){
				userPoints = goodsDetailService.findUserPoints(pointsMap);
			}
		}catch (Exception e){
		}
		return userPoints;
	}
}
