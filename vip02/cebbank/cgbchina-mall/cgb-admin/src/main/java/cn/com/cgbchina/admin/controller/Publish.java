package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.user.dto.EspPublishInfDto;
import cn.com.cgbchina.user.service.EspPublishInfService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by Tanliang 公告管理
 *
 * @time:2016-6-8
 */
@Controller
@RequestMapping("/api/admin/publish") // 请求映射
@Slf4j // 日志
public class Publish {
	@Autowired
	private EspPublishInfService espPublishInfService;
	@Autowired
	private MessageSources messageSources;

	/**
	 * 公告发布 保存功能
	 *
	 * @param publishDate
	 * @param expireDate
	 * @param publishTitle
	 * @param publishType
	 * @param linkHref
	 * @param publishContent
	 * @return
	 */
	@RequestMapping(value = "/savePublish", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String savePublish(@RequestParam(value = "publishDate", required = true) String publishDate,
			@RequestParam(value = "expireDate", required = true) String expireDate,
			@RequestParam(value = "publishTitle", required = true) String publishTitle,
			@RequestParam(value = "publishType", required = true) String publishType,
			@RequestParam(value = "linkHref", required = false) String linkHref,
			@RequestParam(value = "publishContent", required = false) String publishContent) {

		try {
			EspPublishInfDto espPublishInfDto = new EspPublishInfDto();
			// 发布时间 将String时间转换为Date类型
			SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd");
			Date startTime = time.parse(publishDate);
			espPublishInfDto.setPublishDate(startTime);
			// 到期时间
			Date endTime = time.parse(expireDate);
			espPublishInfDto.setExpireDate(endTime);
			// 公告类型
			espPublishInfDto.setPublishType(publishType);
			// 公告标题
			espPublishInfDto.setPublishTitle(publishTitle);
			// 链接地址
			if (StringUtils.isNotEmpty(linkHref)) {
				espPublishInfDto.setLinkHref(linkHref.trim());
			}
			// 公告内容
			if (StringUtils.isNotEmpty(publishContent)) {
				espPublishInfDto.setPublishContent(publishContent.trim());
			}
			// 新增
			Response<Boolean> result = espPublishInfService.createPublish(espPublishInfDto);
			if (result.isSuccess()) {
				return "ok";
			} else {
				log.error("savePublish.error,error code:{}", espPublishInfDto, result.getError());
				throw new ResponseException(500, messageSources.get(result.getError()));
			}
		} catch (Exception e) {
			log.error("savePublish.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("save.error"));
		}
	}
}
