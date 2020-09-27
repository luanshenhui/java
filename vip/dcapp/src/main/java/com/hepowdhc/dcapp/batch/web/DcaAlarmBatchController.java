/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.batch.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hepowdhc.dcapp.batch.service.DcaAlarmBatchService;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 告警管理批处理Controller
 * @author dhc
 * @version 2016-11-17
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaAlarmBatch")
public class DcaAlarmBatchController extends BaseController {

	@Autowired
	private DcaAlarmBatchService dcaAlarmBatchService;
	
	/**
	 * 告警上报管理计时器功能
	 * @param dcaAlarmUpGrade
	 * @return
	 */
	@RequestMapping(value = "alarmBatchTimer")
	public void alarmBatchTimer() throws Exception {
		dcaAlarmBatchService.alarmBatchTimer();
	}
	
}