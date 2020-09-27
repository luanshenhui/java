/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.SpecialPointScaleModel;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-13.
 */
@Controller
@RequestMapping("/api/admin/localCardRelate")
@Slf4j
public class LocalCardRelate {
	@Autowired
	LocalCardRelateService localCardRelateService;
	@Autowired
	MessageSources messageSources;

	/**
	 * 白金卡绑定关系新增
	 * 
	 * @param array
	 * @param proCode
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(@RequestParam(value = "array[]") String[] array, String proCode) {
		Response<Boolean> booleanResponse = localCardRelateService.create(array, proCode);
		if (booleanResponse.isSuccess()) {
			return booleanResponse.getResult();
		}
		log.error("insert.error，erro:{}", booleanResponse.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(booleanResponse.getError()));
	}

	/**
	 * 白金卡绑定关系解绑
	 *
	 * @param proCode
	 * @return
	 */
	@RequestMapping(value = "/unBind", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(@RequestParam("proCode") String proCode,
			@RequestParam("formatId") String formatId) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			LocalCardRelateModel localCardRelateModel = new LocalCardRelateModel();
			localCardRelateModel.setProCode(String.valueOf(proCode));
			localCardRelateModel.setFormatId(String.valueOf(formatId));
			result = localCardRelateService.delete(localCardRelateModel);
		} catch (IllegalArgumentException e) {
			log.error("detele.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("detele.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
		return result;

	}

}
