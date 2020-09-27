package cn.com.cgbchina.item.service.points;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.ItemRedisDao;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import cn.com.cgbchina.user.service.CustInfoCommonService;
import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Map;

/**
 * Created by zhanglin on 2016/8/10.
 */
@Service
@Slf4j
public class PointsGiftServiceImpl implements PointsGiftService {
	@Resource
	private GoodsPayWayService goodsPayWayService;
	@Resource
	private CustInfoCommonService custInfoCommonService;

	@Resource
	private ItemRedisDao itemRedisDao;


	/**
	 *
	 * 积分商城获得最优的价格的支付方式id(积分支付场合)
	 * 
	 * @param isBirth 是否使用生日价
	 * @param itemCode 单品id
	 * @param user 用户信息
	 * @param integralCash 是否使用积分+现金
	 * @return
	 */
	public Response<TblGoodsPaywayModel> getPaywayIdbyItem(Boolean isBirth, String itemCode, User user,
			Boolean integralCash) {
		Response<TblGoodsPaywayModel> response = Response.newResponse();
		try {
			Response<List<TblGoodsPaywayModel>> responseGoodsPaywayModelList = goodsPayWayService
					.findInfoByItemCode(itemCode);
			List<TblGoodsPaywayModel> goodsPaywayModelList = null;
			if (responseGoodsPaywayModelList.isSuccess()) {
				goodsPaywayModelList = responseGoodsPaywayModelList.getResult();
			} else {
				response.setError("pointsGift.check.goodspayway.error");
				return response;
			}
			TblGoodsPaywayModel userFirstPayway;
			// 通过等级获得最优的支付价格start
			Map<String, TblGoodsPaywayModel> paywayMap = Maps.newHashMap();
			for (TblGoodsPaywayModel goodsPaywayModel : goodsPaywayModelList) {
				paywayMap.put(goodsPaywayModel.getMemberLevel(), goodsPaywayModel);
			}
			if (integralCash) {
				userFirstPayway = paywayMap.get(Contants.MEMBER_LEVEL_INTEGRAL_CASH_CODE);
			} else {
				userFirstPayway = getUserFirstCardLevel(user, paywayMap);
				// 选择生日特权的场合并且生日比例是最优惠比例的场合
				if (isBirth) {
					if (paywayMap.get(Contants.MEMBER_LEVEL_BIRTH_CODE) != null) {
						if (userFirstPayway != null) {
							if (paywayMap.get(Contants.MEMBER_LEVEL_BIRTH_CODE).getGoodsPoint() < userFirstPayway
									.getGoodsPoint()) {
								userFirstPayway = paywayMap.get(Contants.MEMBER_LEVEL_BIRTH_CODE);
							}
						}
					}
				}
			}
			if (userFirstPayway == null) {
				response.setError("pointsGift.check.goodspayway.error");
				return response;
			}
			response.setResult(userFirstPayway);
		}catch (Exception e){
			response.setError("pointsGift.check.goodspayway.error");
		}
		return response;
	}

	/**
	 * 生日价是否为最优价格选项
	 */
	public TblGoodsPaywayModel checkBirthIsBest(String itemCode, User user) {
		Response<List<TblGoodsPaywayModel>> responseGoodsPaywayModelList = goodsPayWayService
				.findInfoByItemCode(itemCode);
		List<TblGoodsPaywayModel> goodsPaywayModelList = null;
		if (responseGoodsPaywayModelList.isSuccess()) {
			goodsPaywayModelList = responseGoodsPaywayModelList.getResult();
		}
		TblGoodsPaywayModel birthFirstPayway = null;
		// 通过等级获得最优的支付价格start
		Map<String, TblGoodsPaywayModel> paywayMap = Maps.newHashMap();
		if (goodsPaywayModelList != null) {
			for (TblGoodsPaywayModel goodsPaywayModel : goodsPaywayModelList) {
				paywayMap.put(goodsPaywayModel.getMemberLevel(), goodsPaywayModel);
			}
		}
		TblGoodsPaywayModel userFirstPayway = getUserFirstCardLevel(user, paywayMap);
		// 选择生日特权的场合并且生日比例是最优惠比例的场合
		if (paywayMap.get(Contants.MEMBER_LEVEL_BIRTH_CODE) != null) {
			if (userFirstPayway != null) {
				if (paywayMap.get(Contants.MEMBER_LEVEL_BIRTH_CODE).getGoodsPoint() < userFirstPayway.getGoodsPoint()) {
					birthFirstPayway = paywayMap.get(Contants.MEMBER_LEVEL_BIRTH_CODE);
				}
			}
		}
		return birthFirstPayway;
	}

	/**
	 * 获得用户最优的支付方式（不含生日）
	 */
	private TblGoodsPaywayModel getUserFirstCardLevel(User user, Map<String, TblGoodsPaywayModel> paywayMap) {
		// 类型
		String scaleType = scaleType(user);
		// 最佳价格等级
		if (paywayMap.get(scaleType) != null) {
			return paywayMap.get(scaleType);
		}
		// 如果最佳不存在则找最优的
		if (scaleType.equals(Contants.MEMBER_LEVEL_JP_CODE)) {
			return paywayMap.get(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (scaleType.equals(Contants.MEMBER_LEVEL_TJ_CODE)) {
			return paywayMap.get(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (scaleType.equals(Contants.MEMBER_LEVEL_DJ_CODE)) {
			if (paywayMap.get(Contants.MEMBER_LEVEL_TJ_CODE) != null) {
				return paywayMap.get(Contants.MEMBER_LEVEL_TJ_CODE);
			} else {
				return paywayMap.get(Contants.MEMBER_LEVEL_JP_CODE);
			}
		} else if (scaleType.equals(Contants.MEMBER_LEVEL_VIP_CODE)) {
			if (paywayMap.get(Contants.MEMBER_LEVEL_DJ_CODE) != null) {
				return paywayMap.get(Contants.MEMBER_LEVEL_DJ_CODE);
			} else if (paywayMap.get(Contants.MEMBER_LEVEL_TJ_CODE) != null) {
				return paywayMap.get(Contants.MEMBER_LEVEL_TJ_CODE);
			} else {
				return paywayMap.get(Contants.MEMBER_LEVEL_JP_CODE);
			}
		} else {
			return null;
		}
	}
	//获得用户等级
	public String getUserLevel(User user){
		String level = itemRedisDao.get(user.getId());
		if (level != null){
			return level;
		}else {
			String scaleType = scaleType(user);
			itemRedisDao.insert(user.getId(), scaleType);
			return scaleType;
		}
	}
	// 通过最高卡等级取得客户最优等级
	private String scaleType (User user){
		String scaleType = Contants.MEMBER_LEVEL_JP_CODE;
		String certNo = user.getCertNo();
		List<UserAccount> userCartDtoList = user.getAccountList();
		final List<String> cardNos = Lists.transform(userCartDtoList, new Function<UserAccount, String>() {
			@Override
			public String apply(@NotNull UserAccount input) {
				return input.getCardNo();
			}
		});
		// 通过客户证件号码取得客户最高卡等级对应的信息
		Response<ACustToelectronbankModel> resultCustInfo = custInfoCommonService
				.getMaxCardLevelCustInfoByCertNbr(certNo, Lists.newArrayList(cardNos));
		if (!resultCustInfo.isSuccess()) {
			log.error("Response.error,error code: {}", resultCustInfo.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		ACustToelectronbankModel aCustToelectronbankModel = resultCustInfo.getResult();
		if (aCustToelectronbankModel != null) {
			// 通过最高卡等级取得客户最优等级
			Response<String> resultCustInfoCommon = custInfoCommonService.calMemberLevel(certNo, aCustToelectronbankModel.getCardLevelCd(),
					aCustToelectronbankModel.getVipTpCd());
			if (!resultCustInfoCommon.isSuccess()) {
				log.error("Response.error,error code: {}", resultCustInfoCommon.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
			}
			String memberLevel = resultCustInfoCommon.getResult();
			switch (memberLevel) {
				// 普卡/金卡
				case Contants.MEMBER_LEVEL_JP:
					scaleType = Contants.MEMBER_LEVEL_JP_CODE;
					break;
				// 钛金卡/臻享白金卡
				case Contants.MEMBER_LEVEL_TJ:
					scaleType = Contants.MEMBER_LEVEL_TJ_CODE;
					break;
				// 顶级/增值白金卡
				case Contants.MEMBER_LEVEL_DJ:
					scaleType = Contants.MEMBER_LEVEL_DJ_CODE;
					break;
				// vip
				case Contants.MEMBER_LEVEL_VIP:
					scaleType = Contants.MEMBER_LEVEL_VIP_CODE;
					break;
				default:
					break;
			}
		}
		return scaleType;
	}
}
