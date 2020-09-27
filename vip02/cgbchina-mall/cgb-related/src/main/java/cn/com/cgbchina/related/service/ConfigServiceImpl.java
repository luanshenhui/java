/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;

import cn.com.cgbchina.related.dao.TblConfigDao;
import cn.com.cgbchina.related.model.TblConfigModel;
import lombok.extern.slf4j.Slf4j;

/**
 *
 */
@Slf4j
@Service
public class ConfigServiceImpl implements ConfigService {

	@Resource
	private TblConfigDao tblConfigDao;

	@Override
	public Response<TblConfigModel> findByCfgType(String cfgType) {
		Response<TblConfigModel> response = new Response<TblConfigModel>();
		try {
			TblConfigModel tblConfigModel = tblConfigDao.findByCfgType(cfgType);
			response.setResult(tblConfigModel);
		} catch (Exception e) {
			log.error("config.find.error", Throwables.getStackTraceAsString(e));
			response.setError("config.find.error");
			return response;
		}
		return response;
	}
}
