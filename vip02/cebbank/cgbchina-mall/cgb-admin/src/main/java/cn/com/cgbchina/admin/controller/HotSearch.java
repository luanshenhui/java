package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.HotSearchTermModel;
import cn.com.cgbchina.related.service.HotSearchService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by 11150721040343 on 16-4-8.
 */
@Controller
@RequestMapping("/api/admin/hotSearchTerms")
@Slf4j
public class HotSearch {
	@Resource
	private HotSearchService hotSearchService;
	@Resource
	MessageSources messageSources;

	/**
	 * 新增热搜词
	 *
	 * @param hotSearchTermModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer create(HotSearchTermModel hotSearchTermModel) {
		hotSearchTermModel.setDelFlag(Contants.DEL_FLAG_0);
		// 获取登录人
		User user = UserUtil.getUser();
		String createName = user.getName();
		hotSearchTermModel.setCreatOper(createName);
		if (hotSearchTermModel.getStatus() == null) {
			hotSearchTermModel.setStatus(Contants.USEING_COMMON_STATUS_1);
		}
		Response<Integer> result = hotSearchService.create(hotSearchTermModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("create.error,error code:{}", result.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	}

	/**
	 * 删除热搜词
	 *
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer delete(String name) {
		try {
			// 校验热搜词名字是否为空
			checkArgument(StringUtils.isNotBlank(name), "name is null");
			Response<HotSearchTermModel> result1 = hotSearchService.findByName(name);
			Response<Integer> result = hotSearchService.delete(result1.getResult());
			if (result.isSuccess()) {
				return result.getResult();
			} else {
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
		} catch (IllegalArgumentException e) {
			log.error("delete.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("delete.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("term.delete.error"));
		}
	}

	/**
	 * 编辑热搜词
	 *
	 * @param id
	 * @param hotSearchTermModel
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer update(@PathVariable Long id, HotSearchTermModel hotSearchTermModel) {
		// 校验id值是否为空
		checkArgument(!("".equals(id + "")), "id is null");
		// 校验热搜词名称是否为空
		checkArgument(StringUtils.isNotBlank(hotSearchTermModel.getName()), "name is null");
		// 校验热搜词顺序是否为空
		checkArgument(!("".equals(hotSearchTermModel.getSort() + "")), "sort is null");
		Map<String, Object> dataMap = Maps.newHashMap();
		hotSearchTermModel.setDelFlag(Contants.DEL_FLAG_0);
		// 获取登录人
		User user = UserUtil.getUser();
		String createName = user.getName();
		hotSearchTermModel.setCreatOper(createName);
		if (hotSearchTermModel.getStatus() == null) {
			hotSearchTermModel.setStatus(Contants.USEING_COMMON_STATUS_1);
		}
		dataMap.put("id", id);
		dataMap.put("hotSearchTermModel", hotSearchTermModel);
		Response<Integer> result = hotSearchService.update(dataMap);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("update.error,error code:{}", result.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	}
}
