/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.CouponScaleDto;
import cn.com.cgbchina.item.service.CouponScaleService;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import cn.com.cgbchina.user.service.ACardCustToelectronbankService;
import cn.com.cgbchina.user.service.CustInfoCommonService;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/16.
 */
@Service
@Slf4j
public class PointRelatedServiceImpl implements PointRelatedService {
	@Resource
	ACardCustToelectronbankService aCardCustToelectronbankService;
	@Resource
	CustInfoCommonService custInfoCommonService;
	@Resource
	CouponScaleService couponScaleService;

	/**
	 * 信用卡结算的场合取得最优的积分兑换比例,兑换比例小于1时有对应的值返回，不小于1时结果中各属性不存在
	 *
	 * @Param isUseBirthDiscount 是否使用生日优惠（广发商城默认是使用：true）
	 * @Param user 用户
	 * @Return
	 */
	public Map<String, Object> getBestPointScale(boolean isUseBirthDiscount, User user) {
		Map<String, Object> result = Maps.newHashMap();
		// 类型
		String scaleType = Contants.MEMBER_LEVEL_JP;
		// 类型名称
		String scaleName = Contants.MEMBER_LEVEL_JP_NM;
		// 兑换等级比例
		BigDecimal scale = new BigDecimal(1);
		// 通过session取得证件号码
		String certNo = user.getCertNo();
		// 检索优惠折扣比例表
		Response<CouponScaleDto> couponScaleDtoResponse = couponScaleService.findAll();
		if (couponScaleDtoResponse.isSuccess()) {
			BigDecimal birthday = couponScaleDtoResponse.getResult().getBirthday();
			BigDecimal vip = couponScaleDtoResponse.getResult().getVIP();
			BigDecimal topCard = couponScaleDtoResponse.getResult().getTopCard();
			BigDecimal platinumCard = couponScaleDtoResponse.getResult().getPlatinumCard();
			BigDecimal commonCard = couponScaleDtoResponse.getResult().getCommonCard();
			// 通过客户证件号码取得客户最高卡等级对应的信息
			ACustToelectronbankModel aCustToelectronbankModel = custInfoCommonService
					.getMaxCardLevelCustInfoByCertNbr(certNo);
			if (aCustToelectronbankModel != null) {
				// 通过最高卡等级取得客户最优等级
				String memberLevel = custInfoCommonService.calMemberLevel(certNo,
						aCustToelectronbankModel.getCardLevelCd(), aCustToelectronbankModel.getVipTpCd());
				switch (memberLevel) {
				// 普卡/金卡
				case Contants.MEMBER_LEVEL_JP:
					scale = commonCard;
					scaleType = Contants.MEMBER_LEVEL_JP;
					scaleName = Contants.MEMBER_LEVEL_JP_NM;
					break;
				// 钛金卡/臻享白金卡
				case Contants.MEMBER_LEVEL_TJ:
					scale = platinumCard;
					scaleType = Contants.MEMBER_LEVEL_TJ;
					scaleName = Contants.MEMBER_LEVEL_TJ_NM;
					break;
				// 顶级/增值白金卡
				case Contants.MEMBER_LEVEL_DJ:
					scale = topCard;
					scaleType = Contants.MEMBER_LEVEL_DJ;
					scaleName = Contants.MEMBER_LEVEL_DJ_NM;
					break;
				// vip
				case Contants.MEMBER_LEVEL_VIP:
					scale = vip;
					scaleType = Contants.MEMBER_LEVEL_VIP;
					scaleName = Contants.MEMBER_LEVEL_VIP_NM;
					break;
				default:
					break;
				}
				// 选择生日特权的场合并且生日比例是最优惠比例的场合
				if (birthday.compareTo(scale) < 0 && isUseBirthDiscount) {
					// 判断是否过期和取得生日特权对应的兑换比例
					SimpleDateFormat myFmt1 = new SimpleDateFormat(DateHelper.MM);
					if (myFmt1.format(aCustToelectronbankModel.getBirthDay()).equals(myFmt1.format(new Date()))) {
						scale = birthday;
						scaleType = Contants.MEMBER_LEVEL_BIRTH;
						scaleName = Contants.MEMBER_LEVEL_BIRTH_NM;
					}
				}
				// 设置返回值积分兑换折扣以及对应的折扣名称,兑换比例小于1时才设置值
				if (scale.compareTo(new BigDecimal(1)) < 0) {
					result.put("scale", scale);
					result.put("scaleType", scaleType);
					result.put("scaleName", scaleName);
				}
			}
		}
		return result;
	}
}
