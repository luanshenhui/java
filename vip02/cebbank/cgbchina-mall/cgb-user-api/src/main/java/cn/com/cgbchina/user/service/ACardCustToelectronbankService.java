/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;


import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;

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
	public ACardCustToelectronbankModel findByCardNbr(String cardNbr);
}
