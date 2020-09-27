package cn.com.cgbchina.restful.provider.service.user;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.CustLevelInfo;
import cn.com.cgbchina.related.service.RestACardCustToelectronbankService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.user.CustInfoItem;
import cn.com.cgbchina.rest.provider.vo.user.CustInfoQueryCardItem;
import cn.com.cgbchina.rest.provider.vo.user.CustInfoQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustInfoVO;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.ACardLevelToelectronbankModel;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.service.ACardCustToelectronbankService;
import cn.com.cgbchina.user.service.ACardLevelToelectronbankService;
import cn.com.cgbchina.user.service.EspCustNewService;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

import org.elasticsearch.common.base.Strings;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * MAL323 客户信息查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL323")
@Slf4j
public class CustInfoQueryProvideServiceImpl implements SoapProvideService<CustInfoVO, CustInfoQueryReturnVO> {

	@Resource
	ACardCustToelectronbankService aCardCustToelectronbankService;// 电子商城卡客户明细Service

	@Resource
	ACardLevelToelectronbankService aCardLevelToelectronbankService;// 供电子商城卡等级Service

	@Resource
	LocalCardRelateService localCardRelateService;

	@Resource
	EspCustNewService espCustNewService;// 用户生日信息Service

	@Resource
	RestACardCustToelectronbankService restACardCustToelectronbankService;

	@Value("#{app.birthdayLimit}")
	private String birthdayLimit;

	/**
	 * 客户信息查询接口
	 * 
	 * @param model
	 * @param content
	 *            查询参数
	 * @return 查询结果
	 *         <p/>
	 *         geshuo 20160728
	 */
	@Override
	public CustInfoQueryReturnVO process(SoapModel<CustInfoVO> model, CustInfoVO content) {
		CustInfoQueryReturnVO result = new CustInfoQueryReturnVO();

		String certNo = content.getCertNo();// 证件号
		String custId = content.getCustId();// 客户号
		String birthDay = content.getBirthDay();// 生日
		String isVip = content.getIsVip();// vip标志 0:是vip

		try {
			if (StringUtils.isEmpty(certNo)) {
				result.setReturnCode("000008");
				result.setReturnDes("报文参数错误:证件号必须填写");
				return result;
			}
			if (StringUtils.isEmpty(custId)) {
				result.setReturnCode("000008");
				result.setReturnDes("报文参数错误:客户号必须填写");
				return result;
			}

			Response<CustLevelInfo> custLevelInfoResponse = restACardCustToelectronbankService.getCustLevelInfo(certNo);
			if (!custLevelInfoResponse.isSuccess()) {
				throw new RuntimeException(custLevelInfoResponse.getError());
			}
			String custLevel = Contants.MEMBER_LEVEL_JP_CODE;// 客户最优级别
			if (custLevelInfoResponse.isSuccess() && custLevelInfoResponse.getResult() != null) {// ods部分数据存在
				CustLevelInfo custInfo = custLevelInfoResponse.getResult();
				birthDay = custInfo.getBirthDay();
				custLevel = convertLevelCode(custInfo.getMemberLevel());
				// if (custInfo.isVipFlag()) {//ods中有vip标志
				// isVip = Contants.IS_VIP;
				// }
				// 根据证件号码查询卡明细
				Response<List<ACardCustToelectronbankModel>> cardResponse = aCardCustToelectronbankService
						.findListByCertNbr(certNo);
				if (!cardResponse.isSuccess()) {
					log.error(
							"CustInfoQueryProvideServiceImpl.query-->aCardCustToelectronbankService.findListByCertNbr.error certNo{}",
							certNo);
					result.setReturnCode("000009");
					result.setReturnDes("客户信息查询失败");
					return result;
				}

				List<ACardCustToelectronbankModel> cardModelList = cardResponse.getResult();
				List<CustInfoQueryCardItem> cardList = Lists.newArrayList();
				if (cardModelList != null && cardModelList.size() > 0) {
					// 卡等级代码
					List<String> cardLevelCdList = Lists.newArrayList();
					for (ACardCustToelectronbankModel cardModel : cardModelList) {
						cardLevelCdList.add(cardModel.getCardLevelCd());
					}

					// 根据卡等级代码列表查询卡等级描述
					Response<List<ACardLevelToelectronbankModel>> cardLevelResponse = aCardLevelToelectronbankService
							.findCardLevelByIdList(cardLevelCdList);
					if (!cardLevelResponse.isSuccess()) {
						log.error(
								"CustInfoQueryProvideServiceImpl.query-->aCardLevelToelectronbankService.findCardLevelByIdList.error cardLevelCdList{}",
								cardLevelCdList);
						result.setReturnCode("000009");
						result.setReturnDes("客户信息查询失败");
						return result;
					}

					List<ACardLevelToelectronbankModel> levelList = cardLevelResponse.getResult();
					Map<String, String> levelDescMap = Maps.newHashMap();// 卡等级描述Map
					for (ACardLevelToelectronbankModel cardLevelItem : levelList) {
						levelDescMap.put(cardLevelItem.getCardLevelNbr(), cardLevelItem.getCardLevelDesc());// 放入等级描述
					}

					for (ACardCustToelectronbankModel cardModel : cardModelList) {
						CustInfoQueryCardItem cardItem = new CustInfoQueryCardItem();
						cardItem.setBankNo(cardModel.getBankNbr());// 分行号
						cardItem.setCardNo(cardModel.getCardNbr());// 卡号
						cardItem.setCardFormatNo(cardModel.getCardFormatNbr());// 卡板代码

						String cardLevelCd = cardModel.getCardLevelCd();// 卡等级代码
						cardItem.setCardLevel(cardLevelCd);// 卡等级

						String levelDesc = levelDescMap.get(cardLevelCd);// 获取卡等级描述
						if (StringUtils.isNotEmpty(levelDesc)) {
							cardItem.setCardLevelDesc(levelDesc);// 卡等级描述
						}
						cardItem.setCardTypeNo(cardModel.getCardTpCd());// 卡类代码
						cardList.add(cardItem);
					}
				}
				result.setCardList(cardList);
			} else {// 使用积分系统的数据（报文中传输的）
				try {
					List<CustInfoItem> itemList = content.getCardList();
					if (null != itemList && itemList.size() > 0) {
						custLevel = getMemberLevel(content.getCardList(), isVip);// 使用积分系统数据计算出最优客户等级
					}
				} catch (Exception e) {
					log.error("CustInfoQueryProvideServiceImpl.query-->getMemberLevel Exception:{}",
							Throwables.getStackTraceAsString(e));
					result.setReturnCode("000009");
					result.setReturnDes("客户信息查询失败");
					return result;
				}

			}
			// 查询可用生日次数
			Response<Integer> countResponse = espCustNewService.findBirthAvailableCount(custId, new Integer(
					birthdayLimit));
			if (!countResponse.isSuccess()) {
				log.error(
						"CustInfoQueryProvideServiceImpl.query-->espCustNewService.findBirthAvailableCount.error custId:{}",
						custId);
				result.setReturnCode("000009");
				result.setReturnDes("客户信息查询失败");
				return result;
			}

			// 可用次数
			Integer availCount = countResponse.getResult() == null ? Integer.valueOf(0) : countResponse.getResult();

			result.setBrthTimes(String.valueOf(availCount));// 生日价购买次数
			result.setCustLevel(custLevel);// 客户最优等级
			result.setBrthDate(birthDay);// 客户生日日期

			result.setReturnCode("000000");
			result.setReturnDes("客户信息查询成功");
		} catch (Exception e) {
			log.error("CustInfoQueryProvideServiceImpl.query.error custId:{}", custId);
			result.setReturnCode("000009");
			result.setReturnDes("客户信息查询失败");
		}
		return result;
	}

	/**
	 * 转换为外部接口客户等级代码
	 * @param memberLevel
	 * @return
	 */
	private String convertLevelCode(String memberLevel) {
		if (Strings.isNullOrEmpty(memberLevel)) {
			return "";
		}
		switch (memberLevel) {
		case "0":
			memberLevel = Contants.MEMBER_LEVEL_JP_CODE;
			break;
		case "1":
			memberLevel = Contants.MEMBER_LEVEL_TJ_CODE;
			break;
		case "2":
			memberLevel = Contants.MEMBER_LEVEL_DJ_CODE;
			break;
		case "3":
			memberLevel = Contants.MEMBER_LEVEL_VIP_CODE;
			break;
		case "4":
			memberLevel = Contants.MEMBER_LEVEL_BIRTH_CODE;
			break;
		default:
			break;
		}
		return memberLevel;
	}

	/**
	 * 根据卡板 卡等级获取最优客户等级
	 * 
	 * @param cardList
	 *            卡片列表
	 * @param isVip
	 *            是否vip
	 * @return 客户等级
	 * @throws Exception
	 *             geshuo 20160721
	 */
	public String getMemberLevel(List<CustInfoItem> cardList, String isVip) throws Exception {
		String custLevel;
		List<String> levelList = Lists.newArrayList();
		for (CustInfoItem cardItem : cardList) {
			String levelCode = cardItem.getCardLevel();// 卡等级
			String formatId = cardItem.getFormatId();// 卡板代码
			custLevel = getMemberLevelByLevelCode(levelCode, formatId);
			levelList.add(custLevel);
		}
		custLevel = getMemberLevelByList(levelList, isVip);
		return custLevel;
	}

	/**
	 * 根据卡等级以及卡板代码获取对应的客户等级
	 * 
	 * @param levelCode
	 *            卡等级代码
	 * @param cardFormat
	 *            卡板代码
	 * @return geshuo 20160721
	 */
	public String getMemberLevelByLevelCode(String levelCode, String cardFormat) throws Exception {
		String memberLevel = Contants.MEMBER_LEVEL_JP_CODE;// 金普卡
		if (Contants.LEVEL_CODE_44.equals(levelCode)) {// 积分系统返回类型 - 顶级卡
														// 旧代码使用LEVEL_CODE_44 =
														// "4";
			memberLevel = Contants.MEMBER_LEVEL_DJ_CODE;
		} else if (Contants.LEVEL_CODE_22.equals(levelCode)) {// 钛金卡
			memberLevel = Contants.MEMBER_LEVEL_TJ_CODE;
		} else if (Contants.LEVEL_CODE_33.equals(levelCode)) {// 白金卡(需要判断)
			String cardType = "";
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("formatId", cardFormat);
			Response<List<LocalCardRelateModel>> cardResponse = localCardRelateService.findLocalCardByParams(paramMap);
			if (!cardResponse.isSuccess()) {
				return memberLevel;
			}
			List<LocalCardRelateModel> cardList = cardResponse.getResult();
			LocalCardRelateModel cardR = null;
			if (cardList != null && cardList.size() > 0) {
				cardR = cardList.get(0);
			}
			if (cardR != null) {
				cardType = cardR.getProCode();// 卡类id
			}
			// 通过卡板获取到对应的卡是顶级卡还是钛金卡
			if (cardType != null && !"".equals(cardType)) {
				log.info("通过卡板查到的卡类型cardType:{}", cardType);
				memberLevel = cardType.equals(Contants.INCREMENT_BJ) ? Contants.MEMBER_LEVEL_DJ_CODE
						: Contants.MEMBER_LEVEL_TJ_CODE;
			} else {
				memberLevel = Contants.MEMBER_LEVEL_TJ_CODE;
			}

		}
		return memberLevel;
	}

	/**
	 * @param list
	 *            客户等级list
	 * @param vipFlag
	 *            vip标志
	 * @return 等级
	 */
	public String getMemberLevelByList(List<String> list, String vipFlag) throws Exception {
		String custLevel = Contants.MEMBER_LEVEL_JP_CODE;
		for (String memberLevel : list) {
			if (Contants.MEMBER_LEVEL_DJ_CODE.equals(memberLevel)) {
				// 若用户名下有顶级卡,返回顶级卡等级
				return memberLevel;
			} else if (Contants.MEMBER_LEVEL_TJ_CODE.equals(memberLevel)) {
				custLevel = memberLevel;
			} else if (Contants.IS_VIP.equals(vipFlag) && !Contants.MEMBER_LEVEL_TJ_CODE.equals(custLevel)) {
				custLevel = Contants.MEMBER_LEVEL_VIP_CODE;
			}
		}
		return custLevel;
	}

}
