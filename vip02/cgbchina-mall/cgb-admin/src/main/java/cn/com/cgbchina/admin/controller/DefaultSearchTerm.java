package cn.com.cgbchina.admin.controller;

import static com.google.common.base.Preconditions.checkArgument;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.DefaultSearchModel;
import cn.com.cgbchina.related.service.DefaultSearchTermService;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/api/admin/defaultSearchTerm")
@Slf4j
public class DefaultSearchTerm {
	@Autowired
	DefaultSearchTermService defaultSearchTermService;
	@Autowired
	MessageSources messageSources;

	/**
	 * 默认搜索词新增
	 *
	 * @param defaultSearchModel
	 * @return
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(DefaultSearchModel defaultSearchModel) {
		// 校验搜索词名称非空
		checkArgument(StringUtils.isNotBlank(defaultSearchModel.getName()), "rule.not.empty");
		// 获取登录人
		User user = UserUtil.getUser();
		String createName = user.getName();
		defaultSearchModel.setCreateOper(createName);
		Response<Boolean> booleanResponse = defaultSearchTermService.create(defaultSearchModel);
		if (booleanResponse.isSuccess()) {
			return booleanResponse.getResult();
		}
		log.error("insert.error，erro:{}", booleanResponse.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(booleanResponse.getError()));
	}

	/**
	 * 默认搜索词更新
	 *
	 * @param id
	 * @param defaultSearchModel
	 * @return
	 */
	@RequestMapping(value = "edit/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(@PathVariable String id, DefaultSearchModel defaultSearchModel) {
		// 校验搜索词名称非空
		checkArgument(StringUtils.isNotBlank(defaultSearchModel.getName()), "rule.not.empty");
		User user = UserUtil.getUser();
		String createName = user.getName();
		defaultSearchModel.setModifyOper(createName);
		// 如果status为null时赋值1
		if (defaultSearchModel.getStatus() == null) {
			defaultSearchModel.setStatus(Contants.DEFAULT_SEAR_1);
		} else {
			// 否则赋值0
			defaultSearchModel.setStatus(Contants.DEFAULT_SEAR_0);
		}
		Response<Boolean> result = defaultSearchTermService.update(id, defaultSearchModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("update.error，erro:{}", result.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	}

	/**
	 * 默认搜索词删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delete/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(@PathVariable Long id) {
		Response<Boolean> result = Response.newResponse();
		try {
			DefaultSearchModel defaultSearchModel = new DefaultSearchModel();
			defaultSearchModel.setId(id);
			User user = UserUtil.getUser();
			String createName = user.getName();
			defaultSearchModel.setModifyOper(createName);
			// defaultSearchModel.setDelFlag("1");
			result = defaultSearchTermService.delete(defaultSearchModel);
		} catch (IllegalArgumentException e) {
			log.error("update.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
		return result;

	}

	/**
	 * 搜索词名称重复校验
	 *
	 * @param name
	 * @return
	 * @author :tanliang
	 */
	@RequestMapping(value = "checkDefaultSearchTerm", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean checkDefaultSearchTerm(@RequestParam(value = "name", required = true) String name, Long id) {
		try {
			Response<Boolean> result = defaultSearchTermService.findNameByName(id, name);
			if(!result.isSuccess()){
				log.error("Response.error,error code: {}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result.getResult();
		} catch (Exception e) {
			log.error("check.productCheckName.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("check.error"));
		}
	}

}
