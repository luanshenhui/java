package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.ServicePromiseCheckDto;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import cn.com.cgbchina.item.service.ServicePromiseService;
import com.google.common.base.Throwables;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import com.spirit.common.model.Response;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by yuxinxin on 16-6-7.
 */
@Controller
@RequestMapping("/api/admin/servicePromise")
@Slf4j
public class ServicePromise {
	@Autowired
	private ServicePromiseService servicePromiseService;
	@Autowired
	MessageSources messageSources;

	/**
	 * 服务承诺新增
	 *
	 * @param servicePromiseModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(ServicePromiseModel servicePromiseModel) {
		// 校验搜索词名称非空
		checkArgument(StringUtils.isNotBlank(servicePromiseModel.getName()), "rule.not.empty");
		// 获取登录人
		User user = UserUtil.getUser();
		String createName = user.getName();
		servicePromiseModel.setCreateOper(createName);
		servicePromiseModel.setIsEnable("0");
		Response<Boolean> booleanResponse = servicePromiseService.create(servicePromiseModel);
		if (booleanResponse.isSuccess()) {
			return booleanResponse.getResult();
		}
		log.error("insert.error，erro:{}", booleanResponse.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(booleanResponse.getError()));
	}

	/**
	 * 服务承诺更新
	 *
	 * @param code
	 * @param servicePromiseModel
	 * @return
	 */
	@RequestMapping(value = "/{code}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(@PathVariable String code, ServicePromiseModel servicePromiseModel) {
		Response<Boolean> result = new Response<Boolean>();
		// 校验搜索词名称非空
		checkArgument(StringUtils.isNotBlank(servicePromiseModel.getName()), "rule.not.empty");
		User user = UserUtil.getUser();
		String createName = user.getName();
		servicePromiseModel.setModifyOper(createName);
		servicePromiseModel.setIsEnable("0");
		result = servicePromiseService.update(code, servicePromiseModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("update.error，erro:{}", result.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	}

	/**
	 * 服务承诺删除
	 *
	 * @param code
	 * @return
	 */
	@RequestMapping(value = "/{code}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(@PathVariable Integer code) {
		Response<Boolean> result = new Response<Boolean>();
		try {

			ServicePromiseModel servicePromiseModel = new ServicePromiseModel();
			servicePromiseModel.setCode(Integer.valueOf(code));
			servicePromiseModel.setModifyOper("admin");// TODO
			// defaultSearchModel.setDelFlag("1");
			result = servicePromiseService.delete(servicePromiseModel);
		} catch (IllegalArgumentException e) {
			log.error("detele.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("detele.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
		return result;

	}

	/**
	 * 服务承诺重复校验
	 *
	 * @param name
	 * @return
	 * @author :tanliang
	 */
	@RequestMapping(value = "checkServicePromise", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ServicePromiseCheckDto checkServicePromise(@RequestParam(value = "name", required = true) String name,
			Long code, Integer sort) {
		try {
			Response<ServicePromiseCheckDto> result = servicePromiseService.findNameByName(code, name, sort);
			return result.getResult();
		} catch (Exception e) {
			log.error("check.productCheckName.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("check.error"));
		}
	}
}
