/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.MailStagesDao;
import cn.com.cgbchina.user.model.MailStagesModel;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/7.
 */
@Service
@Slf4j
public class MailStatesServiceImpl implements MailStatesService {
	@Resource
	private MailStagesDao mailStagesDao;

	@Override
	public Response<List<MailStagesModel>> findMailStagesListByVendorId(String vendorId) {
		Response<List<MailStagesModel>> result = new Response<>();
		try {
			List<MailStagesModel> mailStagesModelList = mailStagesDao.findMailStagesListByVendorId(vendorId);
			result.setResult(mailStagesModelList);
		} catch (Exception e) {
			log.error("find.mailstageslist.error", Throwables.getStackTraceAsString(e));
			result.setError("find.mailstageslist.error");
		}
		return result;
	}

	@Override
	public Response<List<MailStagesModel>> findAll() {
		Response<List<MailStagesModel>> response = new Response<>();
		try {
			List<MailStagesModel> mailStagesModelList = mailStagesDao.findAll();
			response.setResult(mailStagesModelList);
		} catch (Exception e) {
			log.error("find.mailstageslist.error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.mailstageslist.error");
		}
		return response;
	}
	@Override
	public Response<MailStagesModel> findByCodeAndVendorId(String code,String vendorId){
		Response<MailStagesModel> response = new Response<>();
		Map<String,Object> params = Maps.newHashMap();
		if(!Strings.isNullOrEmpty(code)){
			params.put("code",code);
		}
		if(!Strings.isNullOrEmpty(vendorId)){
			params.put("vendorId",vendorId);
		}
		try {
			MailStagesModel mailStagesModel = mailStagesDao.findMailStageByCode(params);
			response.setResult(mailStagesModel);
		}catch (Exception e){
			log.error("find.mail.stages.by.code.error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.mail.stages.by.code.error");
		}
		return response;
	}
}
