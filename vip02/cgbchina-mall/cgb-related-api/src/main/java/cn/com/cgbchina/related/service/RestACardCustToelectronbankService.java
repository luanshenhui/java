/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.CustLevelInfo;

import com.spirit.common.model.Response;

 
/**
 *	日期		:	2016-7-17<br>
 *	作者		:	lizeyuan<br>
 *	项目		:	cgb-related-api<br>
 *	功能		:	<br>
 */
public interface RestACardCustToelectronbankService {
	
	/**
	 * Description : 通过身份证获取卡信息
	 * @param cardNbr 身份证号码
	 * @return
	 */
	Response<CustLevelInfo> getCustLevelInfoByCard(String cardNbr);

	/**
	 * 通过证件号码获取客户信息
	 *
	 * @param certNbr 证件号码
	 * @return 客户信息
	 *
	 * geshuo 20160810
	 */
	Response<CustLevelInfo> getCustLevelInfo(String certNbr);
}
