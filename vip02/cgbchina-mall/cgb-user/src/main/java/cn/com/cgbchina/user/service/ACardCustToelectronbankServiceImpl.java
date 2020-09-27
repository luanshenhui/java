/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.ACardCustToelectronbankDao;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

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
	public  Response<ACardCustToelectronbankModel> findByCardNbr(String cardNbr) {
		Response<ACardCustToelectronbankModel> response = new Response<>();
		try {
			ACardCustToelectronbankModel aCardCustToelectronbankModel = aCardCustToelectronbankDao.findByCardNbr(cardNbr);
			if (aCardCustToelectronbankModel != null) {
				response.setResult(aCardCustToelectronbankModel);
				response.setSuccess(true);
			}else {
				response.setSuccess(false);
				response.setError("query no data");
			}
		} catch (Exception e) {
			response.setSuccess(false);
			response.setError("ACardCustToelectronbankServiceImpl.findListByCardNbr.error");
			log.error("ACardCustToelectronbankServiceImpl.findListByCardNbr.error{}",e);
		}
		return response;
	}

	/**
	 * 根据证件号码查询商城卡客户明细
	 * @param certNbr 证件号码
	 * @return 查询结果
	 *
	 * geshuo 20160721
	 */
	public Response<List<ACardCustToelectronbankModel>> findListByCertNbr(String certNbr){
		Response<List<ACardCustToelectronbankModel>> response = new Response<>();
		try{
			List<ACardCustToelectronbankModel> dataList = aCardCustToelectronbankDao.findListByCertNbr(certNbr);
			response.setResult(dataList);
		}catch (Exception e){
			log.error("ACardCustToelectronbankServiceImpl.findListByCertNbr.error{}", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("ACardCustToelectronbankServiceImpl.findListByCertNbr.error");
		}
		return response;
	}

	@Override
	public Response<List<ACardCustToelectronbankModel>> findListByCardNbr(String cardNbr) {
		Response<List<ACardCustToelectronbankModel>> response = new Response<>();
		try{
			List<ACardCustToelectronbankModel> dataList = aCardCustToelectronbankDao.findListByCardNbr(cardNbr);
			response.setResult(dataList);
		}catch (Exception e){
			log.error("ACardCustToelectronbankServiceImpl.findListByCardNbr.error{}", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("ACardCustToelectronbankServiceImpl.findListByCardNbr.error");
		}
		return response;
	}
}
