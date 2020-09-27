package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.related.model.AnnounceInfo;
import cn.com.cgbchina.related.service.AnnouncementService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by 11141021040453 on 16-4-13.
 */
@Controller
@RequestMapping("api/admin/announcements")
@Slf4j
public class Announcements {

	@Autowired
	private AnnouncementService announcementService;
	@Autowired
	private MessageSources messageSources;

	/**
	 * 创建公告
	 *
	 * @param announceInfo
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(AnnounceInfo announceInfo) {
		Response<Boolean> result = announcementService.create(announceInfo);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to create {},error code:{}", announceInfo, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
