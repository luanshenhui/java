package cn.rkylin.apollo.notice.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.rkylin.apollo.notice.service.INoticeConfigureService;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.controller.AbstractController;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName: BacklogNoticeContorller.java
 * 
 * @Description: OA用户待办事项通知
 * @author zhangXinyuan
 * @Date 2016-8-24 上午 11:48
 * @version 1.00
 */
@Controller
@RequestMapping("/backlogNotice")
public class BacklogNoticeController extends AbstractController {
	private static final Log log = LogFactory.getLog(BacklogNoticeController.class);
	
	@Autowired
	private INoticeConfigureService noticeConfigureService;
	
	@RequestMapping("/findNotice")
	public void findNotice(){
		ApolloMap<String, Object> params = new ApolloMap<String, Object>();
		try {
			noticeConfigureService.findByWhere(params);
		} catch (Exception e) {
			log.error("查询异常",e);
		}
	}
	

}
