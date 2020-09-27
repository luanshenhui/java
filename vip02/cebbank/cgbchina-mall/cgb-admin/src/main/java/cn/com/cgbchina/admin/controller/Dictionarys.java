package cn.com.cgbchina.admin.controller;

import com.spirit.common.model.Response;
import com.spirit.core.model.Dictionary;
import com.spirit.core.service.DicService;
import com.spirit.exception.ResponseException;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;

/**
 * Created by 11140721050130 on 2016/4/29.
 */
@Controller
@RequestMapping("/api/admin/dictionary")
@Slf4j
public class Dictionarys {

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Resource
	private DicService dicService;

	@Resource
	private MessageSources messageSources;

	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Long create(@RequestParam("dic") @NotNull String json) {
		Dictionary dictionary = jsonMapper.fromJson(json, Dictionary.class);
		Response<Long> result = dicService.create(dictionary);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to create {},error exception:{}", dictionary, result.getError());
		throw new ResponseException(500, messageSources.get("dictionary.create.error"));
	}
}
