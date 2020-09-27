/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */

package com.hepowdhc.dcapp.modules.gzw.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.gzw.service.DcaImpWorkflowService;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaHomePageEntity;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 国资委首页第二屏Controller
 * 
 * @author panghuidan
 * @version 2017-1-5
 */
@Controller
@RequestMapping(value = "${adminPath}/gzw")
public class GzwHomeSeccondPageController extends BaseController {

	@Autowired
	private DcaImpWorkflowService dcaImpWorkflowService;

	/**
	 * 告警风险
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2017年1月5日
	 */
	@RequestMapping(value = "getSecondData")
	@ResponseBody
	public DcaHomePageEntity getSecondData(String powerId) {
		DcaHomePageEntity result = new DcaHomePageEntity();
		// 获取告警和风险列表
		DcaAlarmDetail dcaAlarmDetail = new DcaAlarmDetail();
		dcaAlarmDetail.setPowerId(powerId);

		List<DcaAlarmDetail> alarmAndRiskList = dcaImpWorkflowService.getAlarmAndRisk(dcaAlarmDetail);
		result.setAlarmAndRiskList(alarmAndRiskList);

		return result;
	}

}