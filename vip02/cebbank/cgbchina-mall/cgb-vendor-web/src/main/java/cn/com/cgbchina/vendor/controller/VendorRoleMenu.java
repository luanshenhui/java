package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.user.model.VendorMenuModel;
import cn.com.cgbchina.user.service.VendorMenuService;
import cn.com.cgbchina.user.service.VendorRoleMenuService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/26.
 */
@Controller
@RequestMapping("/api/vendor/roleMenu")
@Slf4j
public class VendorRoleMenu {

	@Resource
	private VendorRoleMenuService vendorRoleMenuService;

	@Resource
	private VendorMenuService vendorMenuService;
	@Resource
	private MessageSources messageSources;

	@RequestMapping(value = "/getAllResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<VendorMenuModel> getAllResource() {
		Response<VendorMenuModel> response = new Response<>();
		Response<List<VendorMenuModel>> result = vendorMenuService.getAllResources();
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find all resource,error code:{}", result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/getRoleResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Long> getCurrentResource(Long roleId) {
		Response<Long> response = new Response<>();
		Response<List<Long>> result = vendorRoleMenuService.getMenuByRoleId(roleId);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find resource,error code:{}", result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
