package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.user.dto.VendorRoleCreateDto;
import cn.com.cgbchina.user.dto.VendorRoleDto;
import cn.com.cgbchina.user.dto.VendorRoleEditDto;
import cn.com.cgbchina.user.model.MenuMagModel;
import cn.com.cgbchina.user.service.VendorRoleService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/26.
 */
@Controller
@RequestMapping("/api/vendor/role")
@Slf4j
public class VendorRole {
	@Resource
	private VendorRoleService vendorRoleService;
	@Resource
	private MessageSources messageSources;

	@RequestMapping(value = "/create", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(@RequestBody @Valid VendorRoleCreateDto vendorRoleCreateDto, BindingResult bindingResult) {
		Response<Boolean> response = new Response<>();
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}
		Response<Boolean> result = vendorRoleService.createRoleRoot(vendorRoleCreateDto, UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find all resource,error code:{}", result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "edit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean edit(@RequestBody @Valid VendorRoleEditDto roleEditDto, BindingResult bindingResult) {
		Response<MenuMagModel> response = new Response<>();
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}
		Response<Boolean> result = vendorRoleService.updateRoleRoot(roleEditDto, UserUtil.getUserId());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to update role {},error code:{}", roleEditDto, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean delete(@PathVariable Long id) {
		Response<MenuMagModel> response = new Response<>();
		Response<Boolean> result = vendorRoleService.delete(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to delete role {},error code:{}", id, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/allEnabledRoleDtos", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<VendorRoleDto> allEnabledRoleDtos() {
		Response<List<VendorRoleDto>> response = new Response<>();
		Response<List<VendorRoleDto>> result = vendorRoleService.allEnabledRoleDtos(UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find role ,error code:{}", result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
