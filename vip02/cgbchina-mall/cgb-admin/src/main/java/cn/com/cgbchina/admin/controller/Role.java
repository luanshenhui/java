package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.user.dto.AdminRoleDto;
import cn.com.cgbchina.user.dto.RoleCreateDto;
import cn.com.cgbchina.user.dto.RoleEditDto;
import cn.com.cgbchina.user.model.MenuMagModel;
import cn.com.cgbchina.user.service.AdminRoleService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/23.
 */
@RequestMapping("/api/admin/role")
@Controller
@Slf4j
public class Role {
	@Resource
	private AdminRoleService adminRoleService;
	@Resource
	private MessageSources messageSources;

	@RequestMapping(value = "add",method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(@RequestBody @Valid RoleCreateDto roleCreateDto, BindingResult bindingResult) {
		Response<MenuMagModel> response = new Response<>();
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}
		Response<Boolean> result = adminRoleService.createRoleRoot(roleCreateDto, UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to create role {},error code:{}", roleCreateDto, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "edit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean edit(@RequestBody @Valid RoleEditDto roleEditDto, BindingResult bindingResult) {
		Response<MenuMagModel> response = new Response<>();
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}
		Response<Boolean> result = adminRoleService.updateRoleRoot(roleEditDto, UserUtil.getUserId());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to update role {},error code:{}", roleEditDto, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/allEnabledRoleDtos", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<AdminRoleDto> allEnabledRoleDtos() {
		Response<List<AdminRoleDto>> response = new Response<>();
		Response<List<AdminRoleDto>> result = adminRoleService.allEnabledRoleDtos();
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find role ,error code:{}", result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "delete/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean delete(@PathVariable Long id) {
		Response<MenuMagModel> response = new Response<>();
		Response<Boolean> result = adminRoleService.deleteRole(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to delete role {},error code:{}", id, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
