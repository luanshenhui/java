/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;


import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/14.
 */
public interface ACardCustToelectronbankService {

	/**
	 * 根据卡号查找卡客户明细
	 * 
	 * @param cardNbr
	 * @return
	 */
	public Response<ACardCustToelectronbankModel> findByCardNbr(String cardNbr);

	/**
	 * 根据证件号码查询商城卡客户明细
	 * @param certNbr 证件号码
	 * @return 查询结果
	 *
	 * geshuo 20160721
	 */
	public Response<List<ACardCustToelectronbankModel>> findListByCertNbr(String certNbr);

	/**
	 * Description : 根据卡号查询商城卡客户信息
	 * @param cardNbr 卡号
	 * @return
	 */
	public Response<List<ACardCustToelectronbankModel>> findListByCardNbr(String cardNbr);
}
