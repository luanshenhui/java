/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import javax.annotation.Resource;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.user.dao.ACardLevelToelectronbankDao;
import cn.com.cgbchina.user.model.ACardLevelToelectronbankModel;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/14.
 */
@Slf4j
@Service("aCardLevelToelectronbankServiceImpl")
public class ACardLevelToelectronbankServiceImpl implements ACardLevelToelectronbankService {

	@Resource
	private ACardLevelToelectronbankDao aCardLevelToelectronbankDao;

	/**
	 * 查询卡等级
	 * 
	 * @return
	 */
	@Override
	public Response<List<ACardLevelToelectronbankModel>> findCard() {
		Response<List<ACardLevelToelectronbankModel>> acardList = new Response<List<ACardLevelToelectronbankModel>>();
		try {
			List<ACardLevelToelectronbankModel> resultList = aCardLevelToelectronbankDao.findAll();
			acardList.setResult(resultList);
		} catch (Exception e) {
			log.error("ACardLevelToelectronbankServiceImpl.findCardLevelByIdList.error{}",
					Throwables.getStackTraceAsString(e));
			acardList.setError("ACardLevelToelectronbankServiceImpl.findCardLevelByIdList.error");
			return acardList;
		}
		return acardList;


	}

	/**
	 * 查询 卡等级
	 * @param cardLevelNbr
	 * @return
     */
	@Override
	public Response<ACardLevelToelectronbankModel> findCardByCardLevelNbr(String cardLevelNbr) {
		Response<ACardLevelToelectronbankModel> response = Response.newResponse();
		try {
			ACardLevelToelectronbankModel model = aCardLevelToelectronbankDao.findByCardLevelNbr(cardLevelNbr);
			response.setResult(model);
		} catch (Exception e) {
			log.error("ACardLevelToelectronbankServiceImpl.findCardByCardLevelNbr.error,bad code:{}",
					Throwables.getStackTraceAsString(e));
			response.setError("ACardLevelToelectronbankServiceImpl.findCardByCardLevelNbr.error");
			return response;
		}
		return response;
	}

	/**
	 * 根据卡等级代码列表查询详细信息
	 * @param idList 卡等级代码列表
	 * @return 查询结果
	 *
	 * geshuo 20160721
	 */
	public Response<List<ACardLevelToelectronbankModel>> findCardLevelByIdList(List<String> idList){
		Response<List<ACardLevelToelectronbankModel>> response = new Response<List<ACardLevelToelectronbankModel>>();
		try{
			List<ACardLevelToelectronbankModel> resultList = aCardLevelToelectronbankDao.findCardLevelByIdList(idList);
			response.setResult(resultList);
		}catch (Exception e){
			log.error("ACardLevelToelectronbankServiceImpl.findCardLevelByIdList.error{}", Throwables.getStackTraceAsString(e));
			response.setError("ACardLevelToelectronbankServiceImpl.findCardLevelByIdList.error");
			return response;
		}
		return response;
	}
}
