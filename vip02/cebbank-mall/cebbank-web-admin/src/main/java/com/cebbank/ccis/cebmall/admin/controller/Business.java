package com.cebbank.ccis.cebmall.admin.controller;

import com.cebbank.ccis.cebmall.user.model.TblParametersModel;
import com.cebbank.ccis.cebmall.user.service.BusinessService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-7.
 */
@Controller
@RequestMapping("/api/admin/business")
@Slf4j
public class Business {
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private BusinessService businessService;

	/**
	 * 修改启动暂停
	 *
	 * @param tblParametersModel
	 * @return
	 */
	@RequestMapping(value = "/startStop",method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(TblParametersModel tblParametersModel) {
		try {
			// 获取用户信息
			User user = UserUtil.getUser();
			// 修改
			Response<Boolean> result = businessService.update(tblParametersModel, user);
			if(!result.isSuccess()){
				log.error("Response.error,error code: {}", result.getError());
				throw new ResponseException(500, messageSources.get(result.getError()));
			}
			return result.getResult();
		} catch (IllegalArgumentException e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("create.error"));
		}
	}

	/**
	 * 修改业务话术
	 *
	 * @param tblParametersModel
	 * @return
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updatePrompt(TblParametersModel tblParametersModel) {
		try {
			// 获取用户信息
			User user = UserUtil.getUser();
			// 修改
			Response<Boolean> result = businessService.updatePrompt(tblParametersModel, user);
			return result.getResult();
		} catch (IllegalArgumentException e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("create.error"));
		}
	}
}
