package cn.com.cgbchina.related.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.service.ACustToelectronbankService;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Service;

import com.spirit.common.model.Response;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.CustLevelInfo;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import cn.com.cgbchina.user.service.ACardCustToelectronbankService;
import cn.com.cgbchina.user.service.CustInfoCommonService;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class RestACardCustToelectronbankServiceImpl implements RestACardCustToelectronbankService {
	@Resource
	ACardCustToelectronbankService aCardCustToelectronbankService;

	@Resource
	ACustToelectronbankService aCustToelectronbankService;

	@Resource
	LocalCardRelateService localCardRelateService;

	@Resource
	CustInfoCommonService custInfoCommonService;

	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

	@Override
	public Response<CustLevelInfo> getCustLevelInfoByCard(String cardNbr) {
		Response<CustLevelInfo> response = new Response<CustLevelInfo>();
		// 根据卡号获取客户信息
		Response<ACardCustToelectronbankModel> responseACard = aCardCustToelectronbankService.findByCardNbr(cardNbr);
		if (responseACard.isSuccess()) {
			ACardCustToelectronbankModel aCardCustToelectronbankModel = responseACard.getResult();
			if (aCardCustToelectronbankModel != null) {
				// 获取身份证号码
				String certNbr = aCardCustToelectronbankModel.getCertNbr();
				Response<CustLevelInfo> custLevelInfoResponse = getCustLevelInfo(certNbr);
				if (custLevelInfoResponse.isSuccess()) {
					response.setResult(custLevelInfoResponse.getResult());
				}
				return response;
			} else {
				log.info("该身份证并没有相关信息:" + cardNbr);
			}
		}else {
			response.setError("no data");
			response.setSuccess(false);
		}
		return response;
	}

	// 获取客户等级
	@Override
	public Response<CustLevelInfo> getCustLevelInfo(String certNbr) {
		Response<CustLevelInfo> response = Response.newResponse();
		try {
			CustLevelInfo custLevelInfo = new CustLevelInfo();
			// 通过证件号码获取客户信息
			Map<String,Object> custParamMap = Maps.newHashMap();
			custParamMap.put("certNbr",certNbr);
			Response<List<ACustToelectronbankModel>> custResponse = aCustToelectronbankService.findCustInfoByParams(custParamMap);
			if(!custResponse.isSuccess()){
				log.error("aCustToelectronbankService.findCustInfoByParams.error certNbr:{}" + certNbr);
				response.setError("aCustToelectronbankService.findCustInfoByParams.error");
				return response;
			}
			ACustToelectronbankModel mp = null;// aCustToelectronbankDao.findByCardNo(certNbr);
			if(custResponse.getResult() != null && custResponse.getResult().size() > 0){
				mp = custResponse.getResult().get(0);
			}
			if (mp != null) {
				String cardLevel = mp.getCardLevelCd();// 卡等级代码
				String VipTp = mp.getVipTpCd();// 客户VIP标志
				String birthDay = null;
				// 格式化Date类型为yyyyMMdd的字符串
				if (mp.getBirthDay()!= null) {
					birthDay = sdf.format(mp.getBirthDay());
				}
				// 通过客户证件号码,客户级别（数据集市提供的数据）,客户标识计算出客户最优等级（商城的客户级别）
				Response<String> levelResponse = custInfoCommonService.calMemberLevel(certNbr, cardLevel, VipTp);
				if(!levelResponse.isSuccess()){
					log.error("custInfoCommonService.calMemberLevel.error certNbr:{}" + certNbr);
					response.setError("custInfoCommonService.calMemberLevel.error");
					return response;
				}
				String memberLevel = levelResponse.getResult();

				// 通过客户证件号码，客户卡等级代码，客户标识转换客户发货优先等级
				String sentGoogsLevel = changeCustSentGoogsLevel(certNbr, cardLevel, VipTp);
				String a = cn.com.cgbchina.common.contants.Contants.ACTION_TYPE_0401;
				custLevelInfo.setVipFlag(isVip(VipTp));
				custLevelInfo.setMemberLevel(memberLevel);
				custLevelInfo.setCertNbr(certNbr);
				custLevelInfo.setCardLevelCd(cardLevel);
				custLevelInfo.setVipTpCd(VipTp);
				custLevelInfo.setBirthDay(birthDay);
				custLevelInfo.setCustType(sentGoogsLevel);
				custLevelInfo.setCustAddr(mp.getCustAddr());
				// 根据证件号查询对应客户所有卡板信息
				Response<List<ACardCustToelectronbankModel>> cardResponse = aCardCustToelectronbankService.findListByCertNbr(certNbr);
				if(!cardResponse.isSuccess()){
					log.error("aCardCustToelectronbankService.findListByCertNbr.error certNbr:{}", certNbr);
					response.setError("aCardCustToelectronbankService.findListByCertNbr.error");
					return response;
				}
				List<ACardCustToelectronbankModel> cardinfoList = cardResponse.getResult();
				Map retFormatMap = new HashMap();
				List retFormat = new ArrayList();
				if (cardinfoList != null && cardinfoList.size() > 0) {
					for (int i = 0; i < cardinfoList.size(); i++) {
						ACardCustToelectronbankModel formatMap = cardinfoList.get(0);
						retFormatMap.put(formatMap.getCardNbr(), formatMap.getCardFormatNbr());
						retFormat.add(formatMap.getCardFormatNbr());
					}
				}
				custLevelInfo.setCardFormatNbr(retFormatMap);
				custLevelInfo.setCustFomat(retFormat);
				log.info("客户等级数据：certNbr=" + certNbr + ", memberLevel=" + memberLevel + ", VipTp=" + VipTp
						+ ", birthDay=" + birthDay + ", cardLevel=" + cardLevel + ",custType=" + sentGoogsLevel);

			} else {
				custLevelInfo.setVipFlag(false);
				custLevelInfo.setMemberLevel(Contants.MEMBER_LEVEL_JP);
				custLevelInfo.setCertNbr(certNbr);
				custLevelInfo.setCardLevelCd("");
				custLevelInfo.setVipTpCd("P1");
				custLevelInfo.setBirthDay("");
				custLevelInfo.setCustType(Contants.CUST_LEVEL_CODE_A);
				custLevelInfo.setCustAddr("");
			}
			response.setResult(custLevelInfo);
		} catch (Exception e) {
			log.error("查询客户信息有误！" + e.getMessage(), e);
			response.setError("getCustLevelInfo.error");
			return response;
		}
		return response;
	}

	private boolean isVip(String VipTp) {
		// 格式化客户标识
		if (VipTp != null && VipTp.length() > 2) {
			VipTp = VipTp.substring(0, 2);
		}
		if ("VV".equals(VipTp) || "V1".equals(VipTp) || "V2".equals(VipTp) || "V3".equals(VipTp)) {
			return true;
		} else {
			return false;
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
	 * @return
	 * @author:panhui
	 * @throws Exception
	 * @update:2013-4-17
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
			if (Contants.LEVEL_CODE_3.equals(cardLevel)) {// 白金卡
				Response<List<ACardCustToelectronbankModel>> cardResponse = aCardCustToelectronbankService.findListByCertNbr(certNbr);
				if(!cardResponse.isSuccess()){
					log.error("aCardCustToelectronbankService.findListByCertNbr.error certNbr:{}", certNbr);
					return Contants.CUST_LEVEL_CODE_A;
				}
				List<ACardCustToelectronbankModel> cardInfoList = cardResponse.getResult();
				if (cardInfoList != null) {
					for (ACardCustToelectronbankModel aCardCustToelectronbankModel : cardInfoList) {
						Response<LocalCardRelateModel> localCardRelateResponse = localCardRelateService
								.findByFormatId(aCardCustToelectronbankModel.getCardFormatNbr());
						if (localCardRelateResponse.isSuccess()) {
							LocalCardRelateModel localCardRelateModel = localCardRelateResponse.getResult();
							if (localCardRelateModel != null) {
								String cardLevelId = localCardRelateModel.getProCode();
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
				}
			}
		} catch (Exception e) {
			log.error("取得vip优先发货客户等级异常", e);
			throw new Exception("取得vip优先发货客户等级异常");
		}

		return Contants.CUST_LEVEL_CODE_A;
	}
}
