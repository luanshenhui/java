/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import java.util.Date;

import javax.annotation.Resource;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.BrandAuthorizeDto;
import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import cn.com.cgbchina.item.service.BrandService;
import lombok.extern.slf4j.Slf4j;

import static cn.com.cgbchina.web.utils.SafeHtmlValidator.checkScriptAndEvent;

/**
 * @author zhanglin
 * @version 1.0
 * @Since 2016/6/23.
 */
@Controller
@RequestMapping("/api/admin/pointsAuthorize")
@Slf4j
public class PointsBrandsAuthorize {
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	private BrandService brandService;
	@Resource
	private MessageSources messageSources;

	/**
	 * 修改品牌授权
	 *
	 * @param brandAuthorizeDto
	 * @return
	 */
	@RequestMapping(value = "/audit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean examBrandAuthorize(BrandAuthorizeDto brandAuthorizeDto) {
		// 获取用户信息
		User user = UserUtil.getUser();
		//包含脚本或事件，返回true, 否则返回false
		if(checkScriptAndEvent(brandAuthorizeDto.getApproveMemo())){
			boolean checkResult = false;
			return checkResult;
		}
		// 修改
		Response<Boolean> response = brandService.update(brandAuthorizeDto, user, Contants.BUSINESS_TYPE_JF);
		if (response.isSuccess()){
			return response.getResult();
		}
		log.error("failed to updata brand authorize {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

}
