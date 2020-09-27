package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.dto.MessageSettingDto;
import cn.com.cgbchina.related.service.MessageSettingService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * 开关设置 Created by yuxinxin on 16-4-24
 */
@Controller
@RequestMapping("/api/admin/messageSetting")
@Slf4j
public class MessageSetting {
	@Autowired
	MessageSettingService messageSettingService;
	@Autowired
	MessageSources messageSources;

	/**
	 * 开关设置
	 *
	 * @param messageSettingDto
	 * @return
	 */
	@RequestMapping(method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response updateMessage(MessageSettingDto messageSettingDto) {
		try {
			// 更新开关操作
			Response<Boolean> result = messageSettingService.updateMessage(messageSettingDto);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("update.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			// 更新失败
			log.error("update.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("update.error"));
		}
	}

}