/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.google.common.collect.Lists;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.related.dao.TblParametersDao;
import cn.com.cgbchina.related.manager.BusinessManager;
import cn.com.cgbchina.related.model.TblParametersModel;
import lombok.extern.slf4j.Slf4j;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-7.
 */
@Slf4j
@Service
public class BusinessServiceImpl implements BusinessService {
	@Resource
	private TblParametersDao tblParametersDao;// 业务启停表
	@Resource
	private BusinessManager businessManager;

	/**
	 * 查找全部启停控制信息
	 *
	 * @param pageNo
	 * @param size
	 * @param parametersType
	 * @param ordertypeId
	 * @return
	 */
	@Override
	public Response<Pager<TblParametersModel>> findBusinessControlAll(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("parametersType") String parametersType,
			@Param("ordertypeId") String ordertypeId) {
		Response<Pager<TblParametersModel>> response = new Response<Pager<TblParametersModel>>();
		try {
			Map<String, Object> paramMap = Maps.newHashMap();
			PageInfo pageInfo = new PageInfo(pageNo, size);
			paramMap.put("offset", pageInfo.getOffset());
			paramMap.put("limit", pageInfo.getLimit());
			if (StringUtils.isNotEmpty(parametersType)) {
				paramMap.put("parametersType", parametersType);
			}
			if (StringUtils.isNotEmpty(ordertypeId)) {
				paramMap.put("ordertypeId", ordertypeId);
			}
			// 查询
			Pager<TblParametersModel> pager = tblParametersDao.findByPageQuery(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("business.query.error", Throwables.getStackTraceAsString(e));
			response.setError("business.query.error");
			return response;
		}
	}

	/**
	 * 修改启动暂停
	 *
	 * @param tblParametersModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(TblParametersModel tblParametersModel, User user) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			TblParametersModel TblParameters = new TblParametersModel();
			TblParameters.setOpenCloseFlag(tblParametersModel.getOpenCloseFlag());
			TblParameters.setParametersId(tblParametersModel.getParametersId());
			Boolean result = businessManager.update(TblParameters);
			if (result) {
				response.setResult(result);
				return response;
			} else {
				response.setError("update.business.error");
				return response;
			}

		} catch (Exception e) {
			log.error("business.update.error", Throwables.getStackTraceAsString(e));
			response.setError("business.update.error");
			return response;
		}
	}

	/**
	 * 修改业务话术
	 *
	 * @param tblParametersModel
	 * @return
	 */
	@Override
	public Response<Boolean> updatePrompt(TblParametersModel tblParametersModel, User user) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			TblParametersModel TblParameters = new TblParametersModel();
			TblParameters.setPrompt(tblParametersModel.getPrompt());
			TblParameters.setParametersId(tblParametersModel.getParametersId());
			Boolean result = businessManager.updatePrompt(TblParameters);
			if (result) {

				return response;
			} else {
				response.setError("update.business.error");
				return response;
			}

		} catch (Exception e) {
			log.error("business.update.error", Throwables.getStackTraceAsString(e));
			response.setError("business.update.error");
			return response;
		}
	}

	/**
	 * 获取web渠道的登录信息
	 *
	 * @return
	 */
	@Override
	public Response<List<TblParametersModel>> findByWebLogin() {
		Response<List<TblParametersModel>> response = new Response<List<TblParametersModel>>();
		try {
			List<TblParametersModel> list = tblParametersDao.findByWebLogin();
			if (list == null || list.size() != 2) {
				log.error("business.find.web.login.lose");
				response.setError("business.find.web.login.lose");
				return response;
			}
			response.setResult(list);
			return response;
		} catch (Exception e) {
			log.error("business.find.web.login.error", Throwables.getStackTraceAsString(e));
			response.setError("business.find.web.login.error");
			return response;
		}
	}

	/**
	 * MAL501 和 MAL104 接口
	 *
	 * @param ordertypeId
	 * @param sourceId
	 * @return
	 */
	@Override
	public  Response<List<TblParametersModel>> findJudgeQT(String ordertypeId, String sourceId) {
		Response<List<TblParametersModel>> response = Response.newResponse();
		try {
			List<TblParametersModel> parametersModellList = Lists.newArrayList();
			parametersModellList = tblParametersDao.findJudgeQT(ordertypeId, sourceId);
			response.setResult(parametersModellList);
			return response;
		} catch (Exception e) {
			log.error("TblParametersServiceImpl.query.error", Throwables.getStackTraceAsString(e));
			response.setError("TblParametersServiceImpl.query.error");
			return response;
		}
	}

	@Override
	public Response<List<TblParametersModel>> findParameters(Integer parametersType, String ordertypeId, String sourceId) {
		Response<List<TblParametersModel>> response = Response.newResponse();
		try {
			List<TblParametersModel> parametersModellList = Lists.newArrayList();
			parametersModellList = tblParametersDao.findParameters(parametersType, ordertypeId, sourceId);
			response.setResult(parametersModellList);
			return response;
		} catch (Exception e) {
			log.error("TblParametersServiceImpl.query.error", Throwables.getStackTraceAsString(e));
			response.setError("TblParametersServiceImpl.query.error");
			return response;
		}
	}
}
