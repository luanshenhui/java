package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.trade.vo.CustLevelInfo;
import cn.com.cgbchina.trade.vo.PriceSystem;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.service.ACardCustToelectronbankService;
import cn.com.cgbchina.user.service.ACustToelectronbankService;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class PriceSystemServiceImpl implements PriceSystemService {

	@Resource
	ACustToelectronbankService aCustToelectronbankService;
	@Resource
	ACardCustToelectronbankService aCardCustToelectronbankService;
	@Resource
	LocalCardRelateService localCardRelateService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	ItemService itemService;

	public String getCertNbrByCard(String cardNbr) {
		// 通过卡号获取证件号
		String certNbr = "";
		Response<List<ACardCustToelectronbankModel>> response = aCardCustToelectronbankService
				.findListByCardNbr(cardNbr);
		if (response.isSuccess() && null != response.getResult()) {
			List<ACardCustToelectronbankModel> list = response.getResult();
			if (!list.isEmpty()) {
				certNbr = list.get(0).getCertNbr();
			}
		}
		return certNbr;
	}

	public CustLevelInfo getCustLevelInfo(String certNbr) {
		try {

			CustLevelInfo custLevelInfo = new CustLevelInfo();

			Response<List<ACustToelectronbankModel>> response = aCustToelectronbankService.findUserBirthInfo(certNbr);

			if (response.isSuccess() && null != response.getResult() && !response.getResult().isEmpty()) {
				List<ACustToelectronbankModel> list = response.getResult();
				String cardLevel = list.get(0).getCardLevelCd();// 卡等级代码
				String vipTp = list.get(0).getVipTpCd();// 客户VIP标志
				// 格式化Date类型为yyyyMMdd的字符串
				String birthDay = new SimpleDateFormat("yyyyMMdd").format(list.get(0).getBirthDay());// 设置日期格式
				// 通过客户证件号码,客户级别（数据集市提供的数据）,客户标识计算出客户最优等级（商城的客户级别）
				String memberLevel = calMemberLevel(certNbr, cardLevel, vipTp);

				// 通过客户证件号码，客户卡等级代码，客户标识转换客户发货优先等级
				String sentGoogsLevel = changeCustSentGoogsLevel(certNbr, cardLevel, vipTp);

				custLevelInfo.setVipFlag(isVip(vipTp));
				custLevelInfo.setMemberLevel(memberLevel);
				custLevelInfo.setCertNbr(certNbr);
				custLevelInfo.setCardLevelCd(cardLevel);
				custLevelInfo.setVipTpCd(vipTp);
				custLevelInfo.setBirthDay(birthDay);
				custLevelInfo.setCustType(sentGoogsLevel);
				custLevelInfo.setCustAddr(list.get(0).getCustAddr());
				Response<List<ACardCustToelectronbankModel>> res = aCardCustToelectronbankService
						.findListByCertNbr(certNbr);
				Map<String, String> retFormatMap = new HashMap<String, String>();
				List<String> retFormat = new ArrayList<String>();
				if (res.isSuccess() && null != res.getResult()) {
					List<ACardCustToelectronbankModel> cardInfoList = res.getResult();
					for (int i = 0; i < cardInfoList.size(); i++) {
						ACardCustToelectronbankModel aCardCustToelectronbankModel = cardInfoList.get(i);
						retFormatMap.put(aCardCustToelectronbankModel.getCardNbr(),
								aCardCustToelectronbankModel.getCardFormatNbr());
						retFormat.add(aCardCustToelectronbankModel.getCardFormatNbr());
					}
				}
				custLevelInfo.setCardFormatNbr(retFormatMap);
				custLevelInfo.setCustFomat(retFormat);
				return custLevelInfo;
			} else {
				custLevelInfo.setVipFlag(false);
				custLevelInfo.setMemberLevel(Contants.MEMBER_LEVEL_JP_CODE);
				custLevelInfo.setCertNbr(certNbr);
				custLevelInfo.setCardLevelCd("");
				custLevelInfo.setVipTpCd("P1");
				custLevelInfo.setBirthDay("");
				custLevelInfo.setCustType(Contants.CUST_LEVEL_CODE_A);
				custLevelInfo.setCustAddr("");
				return custLevelInfo;
			}
		}catch(Exception e){
			log.error("查询客户信息有误！" + e.getMessage(),e);
			return null;
		}
	}

	/**
	 *
	 * <p>
	 * Description:客户优先发货等级转换
	 * </p>
	 *
	 * @param certNbr 证件号
	 * @param cardLevel 卡等级代码
	 * @param vipTp vip标志
	 * @return 客户等级
	 */
	private String changeCustSentGoogsLevel(String certNbr, String cardLevel, String vipTp) throws Exception {
		/**
		 * 1：表信息：01-普卡 02-金卡 03-钛金卡 04-白金卡 05 -顶级卡 2：判断证件号码或卡等级代码是否空，若为空，则返回A等级 3：判断cardLevel 4：如果是 01（普卡）/02（金卡） 返回A ;
		 * 5：如果是 04（白金卡）则根据卡板查询是臻淳白金卡 还是 增值白金卡 6: 如果是 03（钛金卡）/臻淳白金卡 返回B 7：如果是 05（顶级卡）/增值白金卡 返回C 8：判断客户vip标志 如果是VIP用户则返回
		 * D 9：若没有证件号码或根据证件号查无客户等级，则统一置为 普.卡/金卡 客户等级A
		 */
		try {
			if (isVip(vipTp)) {
				return Contants.CUST_LEVEL_CODE_D;
			}
			if (certNbr == null || "".equals(certNbr) || cardLevel == null || "".equals(cardLevel)) {
				return Contants.CUST_LEVEL_CODE_A;
			}
			if (Contants.LEVEL_CODE_0.equals(cardLevel) || Contants.LEVEL_CODE_1.equals(cardLevel)) {
				return Contants.CUST_LEVEL_CODE_A;
			}
			// 根据证件号查询客户的客户卡板信息,查询绑定的是臻淳白金卡 还是 增值白金卡 、
			// 如果没有数据，则默认为增值白金卡
			if (Contants.LEVEL_CODE_4.equals(cardLevel)) {// 顶级卡
				return Contants.CUST_LEVEL_CODE_C;
			}
			if (Contants.LEVEL_CODE_2.equals(cardLevel)) {// 钛金卡
				return Contants.CUST_LEVEL_CODE_B;
			}
			if (Contants.LEVEL_CODE_3.equals(cardLevel)) { // 白金卡
				// List cardInfoList=priceSystemDao.getCardInfo(certNbr);
				Response<List<ACardCustToelectronbankModel>> res = aCardCustToelectronbankService
						.findListByCertNbr(certNbr);
				if (res.isSuccess() && null != res.getResult()) {
					List<ACardCustToelectronbankModel> cardInfoList = res.getResult();
					for (int i = 0; i < cardInfoList.size(); i++) {
						// String cardLevelId =
						// priceSystemDao.getCardRelate(cardInfo.getCardFormatNbr());//用卡板代码查白金卡类型关系
						String cardLevelId = "";
						ACardCustToelectronbankModel cardInfo = cardInfoList.get(i);
						Map<String, Object> paramMap = Maps.newHashMap();
						paramMap.put("formatId", cardInfo.getCardFormatNbr());
						Response<List<LocalCardRelateModel>> resp = localCardRelateService
								.findLocalCardByParams(paramMap);
						if (resp.isSuccess() && null != resp.getResult() && resp.getResult().size() > 0) {
							List<LocalCardRelateModel> proCodeList = resp.getResult();
							cardLevelId = proCodeList.get(0).getProCode();
						}
						if (Contants.CUST_LEVEL_TWO_FLAG.equals(cardLevelId)) {
							// 若为增值白金卡板
							return Contants.CUST_LEVEL_CODE_C;
						} else if (Contants.CUST_LEVEL_ONE_FLAG.equals(cardLevelId)) {
							// 臻淳白金卡
							return Contants.CUST_LEVEL_CODE_B;
						}
					}
				}
			}
		}catch(Exception e){
			log.error("取得vip优先发货客户等级异常", e);
			//throw new Exception("取得vip优先发货客户等级异常");
		}
		return Contants.CUST_LEVEL_CODE_A;
	}

	/**
	 * 通过卡号获取客户信息
	 *
	 * @param cardNbr 卡号获
	 * @return
	 */
	public CustLevelInfo getCustLevelInfoByCard(String cardNbr) {
		try {
			String certNbr = getCertNbrByCard(cardNbr);
			if (certNbr != null && !"".equals(certNbr)) {
				return getCustLevelInfo(certNbr);
			} else {
				return null;
			}
		}catch(Exception e){
			log.error("通过卡号查询客户信息有误！"+e.getMessage(),e);
			return null;
		}
	}

	/**
	 * 通过客户最优级别和商品ID获取客户最优的兑换价格
	 *
	 * @param custLevel 客优级别
	 * @param goodsId 单品ID
	 * @return
	 */
	public PriceSystem getPriceSystem(String custLevel, String goodsId) {
		try {
			// 默认等级为金普
			// Map goodsPayWay = priceSystemDao.getGoodsPayWay(goodsId,Contants.MEMBER_LEVEL_JP_CODE);
			Response<List<TblGoodsPaywayModel>> res = null;
			List<TblGoodsPaywayModel> list = null;
			TblGoodsPaywayModel tblGoodsPaywayModel = null;
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("itemCode", goodsId);
			paramMap.put("memberLevel", Contants.MEMBER_LEVEL_JP_CODE);
			res = goodsPayWayService.findByGoodsIdAndMemberLevel(paramMap);
			if (res.isSuccess() && null != res.getResult()) {
				list = res.getResult();
				tblGoodsPaywayModel = list.get(0);
			}
			if (Contants.MEMBER_LEVEL_VIP_CODE.equals(custLevel)) {
				// 客户级别为VIP
				paramMap = Maps.newHashMap();
				paramMap.put("itemCode", goodsId);
				paramMap.put("memberLevel", Contants.MEMBER_LEVEL_VIP_CODE);
				res = goodsPayWayService.findByGoodsIdAndMemberLevel(paramMap);
				if (res.isSuccess() && null != res.getResult()) {
					list = res.getResult();
					tblGoodsPaywayModel = list.get(0);
				}
			} else if (Contants.MEMBER_LEVEL_TJ_CODE.equals(custLevel)) {
				// 客户级别为钛金
				paramMap = Maps.newHashMap();
				paramMap.put("itemCode", goodsId);
				paramMap.put("memberLevel", Contants.MEMBER_LEVEL_TJ_CODE);
				res = goodsPayWayService.findByGoodsIdAndMemberLevel(paramMap);
				if (res.isSuccess() && null != res.getResult()) {
					list = res.getResult();
					tblGoodsPaywayModel = list.get(0);
				}
			} else if (Contants.MEMBER_LEVEL_DJ_CODE.equals(custLevel)) {
				// 若客户级别为顶级卡
				paramMap = Maps.newHashMap();
				paramMap.put("itemCode", goodsId);
				paramMap.put("memberLevel", Contants.MEMBER_LEVEL_DJ_CODE);
				res = goodsPayWayService.findByGoodsIdAndMemberLevel(paramMap);
				if (res.isSuccess() && null != res.getResult()) {
					list = res.getResult();
					tblGoodsPaywayModel = list.get(0);
				} else {
					paramMap = Maps.newHashMap();
					paramMap.put("itemCode", goodsId);
					paramMap.put("memberLevel", Contants.MEMBER_LEVEL_TJ_CODE);
					res = goodsPayWayService.findByGoodsIdAndMemberLevel(paramMap);
					if (res.isSuccess() && null != res.getResult()) {
						list = res.getResult();
						tblGoodsPaywayModel = list.get(0);
					}
				}
			}
			PriceSystem priceSystem = new PriceSystem();

			if (tblGoodsPaywayModel != null) {
				priceSystem.setGoodsPaywayId(StringUtil.dealNull(tblGoodsPaywayModel.getGoodsPaywayId()));
				priceSystem.setGoodsPoint(StringUtil.dealNullObject(tblGoodsPaywayModel.getGoodsPoint()));
				priceSystem.setGoodsPrice(StringUtil.dealNullObject(tblGoodsPaywayModel.getGoodsPrice()));
				priceSystem.setMemberLevel(StringUtil.dealNull(tblGoodsPaywayModel.getMemberLevel()));
			}
			return priceSystem;
		}catch(Exception e){
			log.error("查询客户购买商品优惠价格信息有误！" + e.getMessage(), e);
			return null;
		}
	}

	/**
	 * 通过客户证件号码,卡等级（数据集市提供的数据）,客户标识计算出客户最优等级（商城的客户级别）
	 *
	 * @param certNbr 证件号
	 * @param cardLevel 卡等级
	 * @param vipTp VIP标识
	 * @return 会员等级
	 */
	private String calMemberLevel(String certNbr, String cardLevel, String vipTp) {
		// 格式化客户标识
		if (vipTp != null && vipTp.length() > 2) {
			vipTp = vipTp.substring(0, 2);
		}
		if (Contants.LEVEL_CODE_4.equals(cardLevel)) {
			// 若为顶级卡,返回增值白金/顶级级别
			return Contants.MEMBER_LEVEL_DJ_CODE;
		} else if (Contants.LEVEL_CODE_3.equals(cardLevel)) {
			// 若为白金卡,通过卡板代码判断白金等级
			// List cardInfoList=priceSystemDao.getCardInfo(certNbr);
			List<ACustToelectronbankModel> list = new ArrayList<ACustToelectronbankModel>();
			List<ACardCustToelectronbankModel> cardInfoList = new ArrayList<ACardCustToelectronbankModel>();
			List<LocalCardRelateModel> proCodeList = new ArrayList<LocalCardRelateModel>();
			String cardLevelId;
			Response<List<ACardCustToelectronbankModel>> res = aCardCustToelectronbankService
					.findListByCertNbr(certNbr);
			if (res.isSuccess() && null != res.getResult()) {
				cardInfoList = res.getResult();
				for (int i = 0; i < cardInfoList.size(); i++) {
					// Map cardInfoMap = (Map) cardInfoList.get(i);
					// String cardLevelId = priceSystemDao.getCardRelate((String) cardInfoMap.get("CARD_FORMAT_NBR"));
					cardLevelId = "";
					ACardCustToelectronbankModel cardInfo = cardInfoList.get(i);
					Map<String, Object> paramMap = Maps.newHashMap();
					paramMap.put("formatId", cardInfo.getCardFormatNbr());
					Response<List<LocalCardRelateModel>> resp = localCardRelateService.findLocalCardByParams(paramMap);
					if (resp.isSuccess() && null != resp.getResult() && resp.getResult().size() > 0) {
						proCodeList = resp.getResult();
						cardLevelId = proCodeList.get(0).getProCode();
					}
					if (Contants.INCREMENT_BJ.equals(cardLevelId)) {
						// 若为增值白金卡板,返回顶级卡级别
						return Contants.MEMBER_LEVEL_DJ_CODE;
					}
				}
			}
			// 若为普通白金,判断客户标识
			if ("VV".equals(vipTp) || "P1".equals(vipTp)) {
				// 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
				return Contants.MEMBER_LEVEL_DJ_CODE;
			} else {
				return Contants.MEMBER_LEVEL_TJ_CODE;
			}
		} else if (Contants.LEVEL_CODE_2.equals(cardLevel)) {
			// 若为钛金卡,判断客户标识
			if ("VV".equals(vipTp) || "P1".equals(vipTp)) {
				// 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
				return Contants.MEMBER_LEVEL_DJ_CODE;
			} else {
				return Contants.MEMBER_LEVEL_TJ_CODE;
			}
		} else {
			// 若为金卡或普卡,判断客户标识
			if ("VV".equals(vipTp) || "P1".equals(vipTp)) {
				// 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
				return Contants.MEMBER_LEVEL_DJ_CODE;
			} else if ("P2".equals(vipTp)) {
				// 客户标识为P2,提升客户等级为钛金卡
				return Contants.MEMBER_LEVEL_TJ_CODE;
			} else if (isVip(vipTp)) {
				// 客户标识为V1/V2/V3,提升客户等级为VIP等级
				return Contants.MEMBER_LEVEL_VIP_CODE;
			} else {
				// 返回金普卡等级
				return Contants.MEMBER_LEVEL_JP_CODE;
			}
		}
	}

	private boolean isVip(String vipTp) {
		// 格式化客户标识
		if (vipTp != null && vipTp.length() > 2) {
			vipTp = vipTp.substring(0, 2);
		}
		if ("VV".equals(vipTp) || "V1".equals(vipTp) || "V2".equals(vipTp) || "V3".equals(vipTp)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 校验客户的卡片等级和礼品维护的卡片等级是否一致
	 *
	 * @param goodsId 单品ID
	 * @param certNbr 证件号
	 * @param cardNbr 卡号
	 * @return
	 */
	public boolean checkCardLevel(String goodsId, String certNbr, String cardNbr) {
		Map<String, Object> paramMap = Maps.newHashMap();
		Response<ItemModel> res = itemService.findByItemcode(goodsId);
		if(!res.isSuccess()){
			log.error("Response.error,error code: {}", res.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		ItemModel itemModel = res.getResult();
		if (res.isSuccess() && null != itemModel) {
			String goodsCardLevel = StringUtil.dealNull(itemModel.getCardLevelId());
			// 礼品维护的卡片等级不为00，需要判断判断客户名下的卡片等级与礼品维护的卡片等级是否一致
			if (!StringUtils.isEmpty(goodsCardLevel) && !Contants.GOODS_LEVEL_CODE_0.equals(goodsCardLevel)) {
				String cardLevel = "";
				List<ACardCustToelectronbankModel> cardList = new ArrayList<ACardCustToelectronbankModel>();
				if (!StringUtils.isEmpty(cardNbr)) {// 根据卡号查询
					// cardList = priceSystemDao.queryCardLevelInfoByCardNbr(cardNbr);
					Response<List<ACardCustToelectronbankModel>> response = aCardCustToelectronbankService
							.findListByCardNbr(cardNbr);
					if (response.isSuccess() && null != response.getResult()) {
						cardList = response.getResult();
						// certNbr = list.get(0).getCertNbr();
					}
				} else {// 根据证件号查询
					// cardList = priceSystemDao.queryCardLevelInfoByCertNbr(certNbr);
					Response<List<ACardCustToelectronbankModel>> response = aCardCustToelectronbankService
							.findListByCertNbr(certNbr);
					if (response.isSuccess() && null != response.getResult()) {
						cardList = response.getResult();
						// certNbr = list.get(0).getCertNbr();
					}
				}
				if (cardList != null && cardList.size() > 0) {
					int size = cardList.size();
					for (int i = 0; i < size; i++) {
						cardLevel = changeCardLevel(cardList.get(i));
						if(goodsCardLevel.equals(cardLevel)){
							//logger.info("客户卡片等级cardLevel="+cardLevel);
							return true;
						}
					}
				} else {
					// 如果本地无客户的卡片数据，则默认客户为普卡
					cardLevel = Contants.GOODS_LEVEL_CODE_1;
					if(goodsCardLevel.equals(cardLevel)){
						//logger.info("客户卡片等级cardLevel="+cardLevel);
						return true;
					}
				}
			}else{
				return true;
			}

		} else {
			log.debug("查不到" + goodsId + "礼品信息");
		}
		return false;
	}

	// 转换客户的卡片等级
	private String changeCardLevel(ACardCustToelectronbankModel aCardCustToelectronbankModel) {
		// 礼品卡片等级：01-普卡，02-金卡，03-钛金卡，04-臻享白金，05-增值白金，06-顶级卡
		// 客户卡片等级：01-普卡，02-金卡，03-钛金卡，04-白金卡，05-顶级卡
		String cardLevel = StringUtil.dealNull(aCardCustToelectronbankModel.getCardLevelCd());
		if (Contants.LEVEL_CODE_3.equals(cardLevel)) {// 数据集市提供等级 - 04-白金卡
			// 如果04-白金卡, 则需要用CARD_FORMAT_NBR(三级产品代码)查询CARD_TYPE
			// String cardType =
			// priceSystemDao.getCardRelate(StringUtil.dealNull(aCardCustToelectronbankModel.getCardFormatNbr()));//用三级产品代码查白金卡类型关系
			List<LocalCardRelateModel> proCodeList = new ArrayList<LocalCardRelateModel>();
			ACardCustToelectronbankModel cardInfo = aCardCustToelectronbankModel;
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("formatId", cardInfo.getCardFormatNbr());
			Response<List<LocalCardRelateModel>> resp = localCardRelateService.findLocalCardByParams(paramMap);
			String cardType = "";
			if (resp.isSuccess() && null != resp.getResult() && resp.getResult().size() > 0) {
				proCodeList = resp.getResult();
				cardType = proCodeList.get(0).getProCode();
			}
			if (Contants.CUST_LEVEL_TWO_FLAG.equals(cardType)) {
				cardLevel = Contants.GOODS_LEVEL_CODE_5;// 礼品卡片等级 05-增值白金
			} else {
				cardLevel = Contants.GOODS_LEVEL_CODE_4;// 礼品卡片等级 04-臻享白金
			}
		} else if (Contants.LEVEL_CODE_4.equals(cardLevel)) {// 数据集市提供等级 - 05-顶级卡
			cardLevel = Contants.GOODS_LEVEL_CODE_6;// 礼品卡片等级 06-顶级卡
		}
		return cardLevel;
	}

}
