package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsDetailService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.points.PointsGiftService;
import cn.com.cgbchina.trade.dto.CartAddDto;
import cn.com.cgbchina.trade.service.CartService;
import cn.com.cgbchina.trade.service.PriceSystemService;
import cn.com.cgbchina.trade.service.PriorJudgeService;
import cn.com.cgbchina.user.service.ACustToelectronbankService;
import cn.com.cgbchina.user.service.EspCustNewService;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by zhanglin on 2016/8/12.
 */
@Controller
@RequestMapping("/api/pointsGift")
@Slf4j
public class PointsGift {
	@Autowired
	private GoodsDetailService goodsDetailService;
	@Autowired
	private MessageSources messageSources;
	@Resource
	private PointsGiftService pointsGiftService;
	@Resource
	private ACustToelectronbankService aCustToelectronbankService;
	@Resource
	private CartService cartService;
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private PriceSystemService priceSystemService;
	@Resource
	private EspCustNewService espCustNewService;
	@Resource
	private PriorJudgeService priorJudgeService;

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	/**
	 * 第三类卡校验以及用户基本信息（需登录后调用）
	 * 
	 * @param goodsCode
	 * @return
	 */
	@RequestMapping(value = "/getUserData", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, String> getUserData(String goodsCode) {
		Map<String, String> reMap = Maps.newHashMap();
		User user = UserUtil.getUser();
		reMap.put("userName", user.getName());
		Response<Boolean> result = goodsDetailService.checkThreeCard(goodsCode, user);
		if (result.isSuccess()) {
			if (result.getResult()) {
				reMap.put("formatCard", "true");
			} else {
				reMap.put("formatCard", "false");
			}
		} else {
			reMap.put("formatCard", "第三类卡编码校验失败！");
		}
		return reMap;
	}

	/**
	 * 是否生日价获取（调用此方法时，积分商品有商城价，此方法仅用于判断用户是否可用生日价）
	 */
	@RequestMapping(value = "/checkBirthPrice", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> checkBirthPrice(@Param("itemCode") String itemCode) {
		User user = UserUtil.getUser();
		Map<String, Object> map = Maps.newHashMap();
		Boolean birthFlag = false;
		String birthDay = "";
		if (user != null) {
			List<UserAccount> userCartDtoList = user.getAccountList();
			final List<String> cardNos = Lists.transform(userCartDtoList, new Function<UserAccount, String>() {
				@Override
				public String apply(@NotNull UserAccount input) {
					return input.getCardNo();
				}
			});
			birthDay = aCustToelectronbankService.getUserBirth(user.getCertNo(),Lists.newArrayList(cardNos));
			if (!Strings.isNullOrEmpty(birthDay)) {
				Date birthDate = DateHelper.string2Date(birthDay, DateHelper.YYYY_MM_DD);
				map.put("birthDay", DateHelper.date2string(birthDate, DateHelper.DD));
				boolean isBrith = DateHelper.isBrithDay(DateHelper.date2string(birthDate, DateHelper.YYYYMMDD));
				if (isBrith) {
					Response<Integer> reEspCust = espCustNewService.findBirthAvailableCount(user.getCustId(),
							Contants.MAX_BRITH_GOODS_NUM);
					if (reEspCust.isSuccess()) {
						if (reEspCust.getResult() > 0) {
							TblGoodsPaywayModel birthFirstPayway = pointsGiftService.checkBirthIsBest(itemCode, user);
							if (birthFirstPayway != null) {
								birthFlag = true;
							}
						}
					}
				}
			}
		}
		map.put("birth", birthFlag);
		return map;
	}

	/**
	 * 提交至购物车前校验
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addToGiftCart", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean checkCanToCartJF(@Param("payType") String payType, @Param("isBirth") String isBirth,
			@Param("jfAddCart") String jfAddCart) {
		try{
			ItemModel itemModel;
			GoodsModel goodsmodel;
			User user = UserUtil.getUser();
			CartAddDto cartAddDto = jsonMapper.fromJson(jfAddCart, CartAddDto.class);
			Long buyNums = Long.parseLong(cartAddDto.getGoodsNum());
			if (Strings.isNullOrEmpty(cartAddDto.getItemId())) {
				log.info("pointsGift.checkCanToCartJF.check.item.id.error");
				throw new ResponseException(500, messageSources.get("pointsGift.check.itemid.error"));
			} else {
				itemModel = itemService.findById(cartAddDto.getItemId());// 单品信息
				if (itemModel == null) {
					log.info("pointsGift.checkCanToCartJF.check.item.model.is.null");
					throw new ResponseException(500, messageSources.get("pointsGift.check.itemid.error"));
				}
				goodsmodel = goodsService.findById(itemModel.getGoodsCode()).getResult();// 商品信息
				if (goodsmodel == null) {
					log.info("pointsGift.checkCanToCartJF.check.goods.model.is.null");
					throw new ResponseException(500, messageSources.get("pointsGift.check.itemid.error"));
				}
			}
			if (!Contants.CHANNEL_POINTS_02.equals(goodsmodel.getChannelPoints())) {
				log.info("pointsGift.checkCanToCartJF.check.goodUndercarriage");
				throw new ResponseException(500, messageSources.get("goodsDetail.check.goodUndercarriage"));
			}
			// 库存校验
			if (itemModel.getStock() != 9999l && buyNums.compareTo(itemModel.getStock()) > 0) {
				log.info("pointsGift.checkCanToCartJF.check.goodsStock");
				throw new ResponseException(500, messageSources.get("goodsDetail.check.goodsStock"));
			}
			// 卡等级
			boolean checkCardLecel = priceSystemService.checkCardLevel(itemModel.getCode(), user.getCertNo(), "");
			if (!checkCardLecel) {
				log.info("pointsGift.checkCanToCartJF.check.card.level.error,itemcode{},cartNo{}",itemModel.getCode(),user.getCertNo());
				throw new ResponseException(500, messageSources.get("pointsGift.check.useCardType.error"));
			}
			// 第三类卡校验
			Response<Boolean> result = goodsDetailService.checkThreeCard(itemModel.getGoodsCode(), UserUtil.getUser());
			if (result.isSuccess()) {
				if (!result.getResult()) {
					log.info("pointsGift.checkCanToCartJF.check.three.card.error,itemcode{}",itemModel.getCode());
					throw new ResponseException(500, messageSources.get("goodsDetail.check.useThreeCard"));
				}
			} else {
				log.info("pointsGift.checkCanToCartJF.check.three.card.has.error,cause{}",result.getError());
				throw new ResponseException(500, messageSources.get("goodsDetail.check.useThreeCard.error"));
			}
			Boolean isBirthB = false;
			Boolean integralCashB = false;
			if ("true".equals(isBirth)) {
				isBirthB = true;
			}
			if ("2".equals(payType)) {
				integralCashB = true;
			}
			// 支付商品选择
			Response<TblGoodsPaywayModel> rePaywayModel = pointsGiftService.getPaywayIdbyItem(isBirthB, itemModel.getCode(),
					user, integralCashB);
			TblGoodsPaywayModel paywayModel;
			if (rePaywayModel.isSuccess()) {
				paywayModel = rePaywayModel.getResult();
			} else {
				log.info("pointsGift.checkCanToCartJF.re.payway.model.has.error,cause{}",rePaywayModel.getError());
				throw new ResponseException(500, messageSources.get(rePaywayModel.getError()));
			}
			// 是否拥有商品所需积分
			if (Strings.isNullOrEmpty(goodsmodel.getPointsType())) {
				log.info("pointsGift.checkCanToCartJF.check.pay.way.goods.point.error,cause{}",goodsmodel.getPointsType());
				throw new ResponseException(500, messageSources.get("pointsGift.check.goodspoint.error"));
			} else {
				Response<BigDecimal> retemp = cartService.checkHavePointType(user, goodsmodel.getPointsType().trim());
				if (retemp.isSuccess()) {
					BigDecimal pointNum = retemp.getResult();
					if (pointNum == null || BigDecimal.ZERO.equals(pointNum)) {
						log.info("pointsGift.checkCanToCartJF.check.use.three.Card.re.temp.error");
						throw new ResponseException(500, messageSources.get("pointsGift.check.noJfType"));
					}else{
						long goodsPointL = paywayModel.getGoodsPoint();
						BigDecimal goodspoint = BigDecimal.valueOf(goodsPointL);
						if ((BigDecimal.valueOf(buyNums).multiply(goodspoint)).compareTo(pointNum) > 0) {
							log.info("pointsGift.checkCanToCartJF.userId:{},userPoint:{},havePoint:{}",user.getId(),pointNum,BigDecimal.valueOf(buyNums).multiply(goodspoint));
							throw new ResponseException(500, messageSources.get("goodsDetail.check.useOriBonus.low"));
						}
					}
				} else {
					log.info("pointsGift.checkCanToCartJF.check.use.point.error,cause{}",goodsmodel.getPointsType());
					throw new ResponseException(500, messageSources.get(retemp.getError()));
				}
			}
			//限购商品购买
			if (itemModel.getVirtualLimit()!=null && itemModel.getVirtualLimit() > 0){
				if (buyNums > 1){
					throw new ResponseException(500, messageSources.get("pointsGift.check.limit.error"));
				}else{
					Map<String, Object> custInfoJFParam = new HashMap<String, Object>();
					custInfoJFParam.put("custId", user.getCustId());
					custInfoJFParam.put("ordertypeId", "JF");
					Response<Boolean> booleanResponse = cartService.checkOnlyLimitInCart(custInfoJFParam, itemModel.getCode());
					if(booleanResponse.isSuccess()){
						if(!booleanResponse.getResult()){
							throw new ResponseException(500, messageSources.get("pointsGift.check.limit.error"));
						}
					}else{
						throw new ResponseException(500, messageSources.get(booleanResponse.getError()));
					}
				}
			}
			String custmerNm = null;
			switch (paywayModel.getMemberLevel()) {
				case Contants.MEMBER_LEVEL_BIRTH_CODE:
					custmerNm = Contants.MEMBER_LEVEL_BIRTH_NM;
					break;
				case Contants.MEMBER_LEVEL_INTEGRAL_CASH_CODE:
					custmerNm = Contants.MEMBER_LEVEL_INTEGRAL_CASH_NM;
					break;
			}
			if (custmerNm == null){
				String level = pointsGiftService.getUserLevel(user);
				switch (level){
					case Contants.MEMBER_LEVEL_JP_CODE:
						custmerNm = Contants.MEMBER_LEVEL_JP_NM;
						break;
					case Contants.MEMBER_LEVEL_TJ_CODE:
						custmerNm = Contants.MEMBER_LEVEL_TJ_NM;
						break;
					case Contants.MEMBER_LEVEL_DJ_CODE:
						custmerNm = Contants.MEMBER_LEVEL_DJ_NM;
						break;
					case Contants.MEMBER_LEVEL_VIP_CODE:
						custmerNm = Contants.MEMBER_LEVEL_VIP_NM;
				}
			}
			addTOJFCart(user, goodsmodel, itemModel, paywayModel.getGoodsPaywayId(), paywayModel.getGoodsPoint(),
					cartAddDto,custmerNm);
			return true;
		}catch (ResponseException e){
			throw e;
		}catch (Exception e){
			log.error("addToGiftCart.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500,messageSources.get("goodsDetail.addCart.error"));
		}

	}

	/**
	 * 将通过验证的数据加入购物车
	 */
	private void addTOJFCart(User user, GoodsModel goodsmodel, ItemModel itemModel, String goodsPaywayId,
			Long goodsPoint, CartAddDto jfAddCart,String custmerNm) {
		// 加入购物车
		// 特殊虚拟商品校验
		CartAddDto cartAddDto = new CartAddDto();
		cartAddDto.setCustmerNm(custmerNm);
		cartAddDto.setOrigin(Contants.CHANNEL_MALL_CODE); // 网上商城（包括广发，积分商城）
		cartAddDto.setCustId(user.getCustId());// 客户id
		cartAddDto.setItemId(itemModel.getCode());// 单品id
		cartAddDto.setGoodsPaywayId(goodsPaywayId);// 付款方式id
		cartAddDto.setGoodsNum(jfAddCart.getGoodsNum());// 商品数量
		cartAddDto.setMallType("02");// 商城类型 商城类型标识 "01":广发商城 ;"02":积分商城
		cartAddDto.setPayFlag("0");
		cartAddDto.setFixBonusValue(goodsPoint);// 将积分放入固定积分字段
		// 付款方式(保留)
		cartAddDto.setOrdertypeId("JF");// 订单类型id:分期订单:FQ 一次性订单:YG 积分订单：JF
		String xnlpbh = itemModel.getXid();// 虚拟礼品编号

		if (!Strings.isNullOrEmpty(goodsmodel.getGoodsType())
				&& Contants.SUB_ORDER_TYPE_01.equals(goodsmodel.getGoodsType())
				&& !Strings.isNullOrEmpty(xnlpbh)) {// 如果是虚拟礼品的话需要判断用户的必输项是否为空
			// 校验商品积分上限值
			Response<Boolean> cartResponse = cartService.checkUsedBonus(itemModel, new BigDecimal(goodsPoint),
					new BigDecimal(cartAddDto.getGoodsNum()), user);
			if (cartResponse.isSuccess()) {
				if (!cartResponse.getResult()) {
					throw new ResponseException(500, messageSources.get("cartservice.checkGiftPoint.excess"));
				}
			} else {
				throw new ResponseException(500, messageSources.get(cartResponse.getError()));
			}
			if (priorJudgeService.isClkxf(xnlpbh) || priorJudgeService.isSouthern(xnlpbh)) {// ALL常旅客消费
				if (Strings.isNullOrEmpty(jfAddCart.getVirtualAviationType())
						|| Strings.isNullOrEmpty(jfAddCart.getVirtualMemberId())
						|| Strings.isNullOrEmpty(jfAddCart.getVirtualMemberNm())) {
					throw new ResponseException(500, messageSources.get("pointsGift.check.userInput.error"));
				} else {
					cartAddDto.setVirtualAviationType(jfAddCart.getVirtualAviationType());// 航空类型(保留)
					cartAddDto.setVirtualMemberId(jfAddCart.getVirtualMemberId());// 会员号(保留)
					cartAddDto.setVirtualMemberNm(jfAddCart.getVirtualMemberNm());// 会员姓名(保留)
				}
			}

			if (priorJudgeService.isBjfsk(xnlpbh)) {// 白金卡附属卡年费产品
				if (Strings.isNullOrEmpty(jfAddCart.getEntryCard())) {
					throw new ResponseException(500, messageSources.get("pointsGift.check.userInput.error"));
				} else {
					String tempnum = jfAddCart.getEntryCard().substring(0,7);
					if (tempnum.equals("6225582") || tempnum.equals("5289312") || tempnum.equals("4870132")){
						cartAddDto.setEntryCard(jfAddCart.getEntryCard());// 附属卡号(保留)
					} else {
						throw new ResponseException(500, messageSources.get("pointsGift.check.userInput.fushuerror"));
					}
				}
			}
			if (priorJudgeService.isLxsyx(xnlpbh)) {// 留学生卡附属卡金卡旅行意外险 或 留学生附属卡普卡旅行意外险
				if (Strings.isNullOrEmpty(jfAddCart.getAttachIdentityCard())
						|| Strings.isNullOrEmpty(jfAddCart.getAttachName())) {
					throw new ResponseException(500, messageSources.get("pointsGift.check.userInput.error"));
				} else {
					Response<Boolean> result = goodsDetailService.checkStudentAbroadCard(goodsmodel.getCards(),user);
					if (result.isSuccess()){
						if(!result.getResult()){
							throw new ResponseException(500, messageSources.get("pointsGift.check.checkStudentAbroadCard"));
						}
					} else {
						log.info("pointsGift.checkCanToCartJF.check.three.card.has.error,cause{}",result.getError());
						throw new ResponseException(500, messageSources.get("goodsDetail.check.useThreeCard.error"));
					}
					cartAddDto.setAttachIdentityCard(jfAddCart.getAttachIdentityCard());// 留学生意外险附属卡证件号码(保留)
					cartAddDto.setAttachName(jfAddCart.getAttachName());// 留学生意外险附属卡姓名(保留)
				}
			}
			if (priorJudgeService.isQtlmk(xnlpbh)) {// 七天联名卡住宿券
				if (Strings.isNullOrEmpty(jfAddCart.getVirtualMemberId())) {
					throw new ResponseException(500, messageSources.get("pointsGift.check.userInput.error"));
				} else {
					cartAddDto.setVirtualMemberId(jfAddCart.getVirtualMemberId());// 会员号(保留)
				}
			}
			if (priorJudgeService.isPrepaid(xnlpbh)) {
				cartAddDto.setPrepaidMob(user.getMobile());// 充值电话号码(保留)
			}
			if (priorJudgeService.isYueTong(xnlpbh)) {// 广发粤通卡
				if (Strings.isNullOrEmpty(jfAddCart.getSerialno())) {
					throw new ResponseException(500, messageSources.get("pointsGift.check.userInput.error"));
				} else {
					cartAddDto.setSerialno(jfAddCart.getSerialno());// 客户所输入的保单号(保留)
				}
			}
		}
		log.info("pointgift.createCartInfo.ordertypeid={}", cartAddDto.getOrdertypeId());
		Response<Integer> response = cartService.createCartInfo(cartAddDto);
		if (!response.isSuccess()) {
			throw new ResponseException(500, response.getError());
		}
	}

	/**
	 * 弹窗需要用户名
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getUserName", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map getUserName() {
		Map<String, Object> userMap = Maps.newHashMap();
		User user = UserUtil.getUser();
		userMap.put("name", user.getName());
		return userMap;
	}

	/**
	 * 获取用户等级
	 */
	@RequestMapping(value = "/getUserLevel", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String getUserLevel(){
		User user = UserUtil.getUser();
		if (user == null){
			return "99";
		}else {
			String level = pointsGiftService.getUserLevel(user);
			return level;
		}
	}
}
