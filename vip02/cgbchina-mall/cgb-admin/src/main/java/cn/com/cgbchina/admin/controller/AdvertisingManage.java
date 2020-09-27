/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import static cn.com.cgbchina.common.utils.DateHelper.getCurrentTime;
import static cn.com.cgbchina.web.utils.SafeHtmlValidator.checkScriptAndEvent;
import static org.elasticsearch.common.base.Preconditions.checkArgument;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.UserNotLoginException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.AdvertisingManageModel;
import cn.com.cgbchina.related.service.AdvertisingManageService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/06/22
 */
@Controller
@RequestMapping("/api/admin/advertising")
@Slf4j
public class AdvertisingManage {

	@Autowired
	AdvertisingManageService advertisingManageService;

	@Autowired
	MessageSources messageSources;

	/**
	 * 广告管理审核 niufw
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/advertisingCheck", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> advertisingCheck(Long id) {
		Response<Boolean> result = Response.newResponse();
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException("user.not.login");
		}
		String auditOper = user.getName();//审核人
		// 校验
		try {
			// 审核
			AdvertisingManageModel advertisingManageModel = new AdvertisingManageModel();
			advertisingManageModel.setId(id);
			advertisingManageModel.setAuditOper(auditOper);
			result = advertisingManageService.advertisingCheck(advertisingManageModel);
			if(!result.isSuccess()){
				log.error("check.advertising.error，error:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("check.advertising.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("check.advertising.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.advertising.error"));
		}
	}

	/**
	 * 广告管理拒绝
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/advertisingRefuse", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> advertisingRefuse(Long id,String refuseDetail) {
		Response<Boolean> result = new Response<Boolean>();
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException("user.not.login");
		}
		String auditOper = user.getName();//审核人
		//对textarea进行SafeHtmlValidator类校验
		//包含脚本或事件，返回true, 否则返回false
		if(checkScriptAndEvent(refuseDetail)){
			boolean checkResult = false;
			result.setResult(checkResult);
			return result;
		}

		try {
			// 校验

			// 拒绝
			AdvertisingManageModel advertisingManageModel = new AdvertisingManageModel();
			advertisingManageModel.setAuditOper(auditOper);
			advertisingManageModel.setId(id);
			//生成审核履历
			String date = getCurrentTime();
			String auditLog = date + "未通过初审，审核意见【" + refuseDetail + "】，" + "【审核人："
					+ auditOper + "】";
			advertisingManageModel.setAuditLog(auditLog);
			result = advertisingManageService.advertisingRefuse(advertisingManageModel);
			if(!result.isSuccess()){
				log.error("refuse.advertising.error,error:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("refuse.advertising.error,error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("refuse.advertising.error,error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("refuse.advertising.error"));
		}
	}

	/**
	 * 广告管理删除 niufw
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/advertisingDelete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(Long id) {
		Response<Boolean> result = Response.newResponse();
		// 校验
		try {
			// 校验
			checkArgument(id!=null,"argument is null");
			// 删除
			result = advertisingManageService.delete(id);
			if(!result.isSuccess()){
				log.error("delete.advertising.error,error:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("delete.advertising.error,error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("delete.advertising.error,error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("delete.advertising.error"));
		}
	}
}
