/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import javax.annotation.Resource;

import cn.com.cgbchina.user.dao.ACardCustToelectronbankDao;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/14.
 */
@Slf4j
@Service("aCardCustToelectronbankServiceImpl")
public class ACardCustToelectronbankServiceImpl implements ACardCustToelectronbankService {

	@Resource
	private ACardCustToelectronbankDao aCardCustToelectronbankDao;

	/**
	 * 根据卡号查找卡客户明细
	 * 
	 * @param cardNbr
	 * @return
	 */
	public ACardCustToelectronbankModel findByCardNbr(String cardNbr) {
		return aCardCustToelectronbankDao.findByCardNbr(cardNbr);
	}
}
