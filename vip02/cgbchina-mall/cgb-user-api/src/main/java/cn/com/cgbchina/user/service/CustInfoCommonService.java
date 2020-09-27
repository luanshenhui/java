/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;


import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/14.
 */
public interface CustInfoCommonService {
	/**
	 * 通过客户证件号码取得客户最高卡等级对应的信息
	 *
	 * @param certNbr
	 * @return
	 */
	public Response<ACustToelectronbankModel> getMaxCardLevelCustInfoByCertNbr(String certNbr,List<String> cardNbrs);

	/**
	 * 通过客户证件号码,客户级别（数据集市提供的数据）,客户标识计算出客户最优等级（商城的客户级别）
	 *
	 * @param certNbr
	 * @param cardLevel
	 * @param vipTp
	 * @return
	 */
	public Response<String> calMemberLevel(String certNbr, String cardLevel, String vipTp);
}
