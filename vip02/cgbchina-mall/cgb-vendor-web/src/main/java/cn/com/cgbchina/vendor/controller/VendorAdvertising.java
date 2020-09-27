/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.vendor.controller;

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
@RequestMapping("/api/vendor/advertising")
@Slf4j
public class VendorAdvertising {

	@Autowired
	AdvertisingManageService advertisingManageService;

	@Autowired
	MessageSources messageSources;

	/**
	 * 广告管理添加 (广发商城)niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */
	@RequestMapping(value = "/advertisingCreate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> advertisingCreate(AdvertisingManageModel advertisingManageModel) {
		Response<Boolean> result = new Response<Boolean>();
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException("user.not.login");
		}
		//获取供应商id
		String vendorId = user.getVendorId();
		advertisingManageModel.setVendorId(vendorId);
		String userType = user.getUserType();
		// 校验
		try {
			// 校验

			// 添加
			result = advertisingManageService.create(advertisingManageModel,userType);
			if(!result.isSuccess()){
				log.error("create.advertising.error，error:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.advertising.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.advertising.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.advertising.error"));
		}
	}

	/**
	 * 广告管理编辑 （广发商城）niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */
	@RequestMapping(value = "/advertisingUpdate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> advertisingUpdate(AdvertisingManageModel advertisingManageModel) {
		Response<Boolean> result = new Response<Boolean>();
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException("user.not.login");
		}
		//获取供应商id
		String vendorId = user.getVendorId();
		advertisingManageModel.setModifyOper(vendorId);//修改人
		// 校验
		try {
			// 编辑
			result = advertisingManageService.update(advertisingManageModel);
			if(!result.isSuccess()){
				log.error("update.advertising.error，error:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("update.advertising.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.advertising.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("update.advertising.error"));
		}
	}
}
