/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.BrandAuthorizeDto;
import cn.com.cgbchina.item.service.BrandService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

import static cn.com.cgbchina.web.utils.SafeHtmlValidator.checkScriptAndEvent;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/13.
 */
@Controller
@RequestMapping("/api/admin/authorize")
@Slf4j
public class BrandsAuthorize {
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
		//对textarea进行SafeHtmlValidator类校验
		//包含脚本或事件，返回true, 否则返回false
		if(checkScriptAndEvent(brandAuthorizeDto.getApproveMemo())){
			return false;
		}
		//审核
		Response<Boolean> response = brandService.update(brandAuthorizeDto, user, Contants.BUSINESS_TYPE_YG);
		if (response.isSuccess()){
			return response.getResult();
		}
		log.error("failed to updata brand authorize {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

}
