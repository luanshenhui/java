package cn.com.cgbchina.vendor.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.validation.Valid;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.service.UserRoleService;
import cn.com.cgbchina.user.service.VendorRoleService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 郝文佳 on 2016/5/25.
 */
@Controller
@Slf4j
@RequestMapping("/api/vendor/userInfo")
public class VendorUserRole {
	@Resource
	private UserRoleService userRoleService;
	@Resource
	private MessageSources messageSources;
    @Resource
    private VendorRoleService vendorRoleService;

	@RequestMapping(value = "/assignRole", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean assignRole(@RequestBody @Valid UserRoleDto userRoleDto, BindingResult bindingResult) {
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}
		Response<Boolean> response = new Response<>();
		Response<Boolean> result = vendorRoleService.assignRole(userRoleDto);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to assign role {},error code:{}", userRoleDto, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
