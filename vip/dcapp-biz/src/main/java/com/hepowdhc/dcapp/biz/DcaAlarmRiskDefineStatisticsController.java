/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.biz;

import com.hepowdhc.dcapp.modules.riskmanage.service.DcaRiskManageDefineService;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmRiskDefineEntity;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.OfficeService;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * 告警风险统计(部门)
 * 
 * @author panghuidan
 * @date 2016年12月6日
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaAlarmRiskDefineStatistics")
public class DcaAlarmRiskDefineStatisticsController extends BaseController {

	@Autowired
	private DcaRiskManageDefineService dcaRiskManageDefineService;
	@Autowired
	private OfficeService officeService;
	// 当前查询的业务类型
	private String idxDataType;

	/**
	 * 告警风险统计(部门)
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @author panghuidan
	 * @date 2016年12月6日
	 */
	@RequestMapping(value = { "office", "" })
	public String list(HttpServletRequest request, HttpServletResponse response, Model model,
			DcaAlarmRiskDefineEntity dcaAlarmRiskDefineEntity) {

		idxDataType = (String) request.getSession().getAttribute("tabType");

		String officeId = ""; // 当前用户部门ID
		User currentUser = UserUtils.getUser();
		if (currentUser != null) {
			// 当前登录用户的部门ID
			officeId = currentUser.getOffice().getId();
		}
		// 当前部门的名称
		String offficeName = currentUser.getOffice().getName();
		Boolean flag = true;// 标识
		// 非纪检监察室
		if (!checkifPost(officeId)) {
			// 没有下属部门
			if (!checkifexits(officeId)) {
				model.addAttribute("name", offficeName);
				model.addAttribute("id", officeId);
				model.addAttribute("flag", flag);
			} else {
				flag = false;
				model.addAttribute("flag", flag);
			}
		}

		return "modules/dca/dcaReportOffice";
	}

	/**
	 * 告警风险统计(部门):风险界定状态
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月6日
	 */
	@RequestMapping(value = "findRiskDefineData")
	@ResponseBody
	public String findRiskDefineData(Model model, DcaAlarmRiskDefineEntity dcaAlarmRiskDefineEntity) {

		List<DcaAlarmRiskDefineEntity> riskList = new ArrayList<DcaAlarmRiskDefineEntity>();

		User currentUser = UserUtils.getUser();
		// 当前用户部门ID
		String officeId = currentUser.getOffice().getId();

		String curOfficeId = dcaAlarmRiskDefineEntity.getOfficeId();

		if (StringUtils.isNotEmpty(curOfficeId)) {
			if (!officeId.equals(curOfficeId)) {
				officeId = curOfficeId;
			}
		}

		// 设置查询的业务类型
		dcaAlarmRiskDefineEntity.setIdxDataType(idxDataType);

		if (checkifPost(officeId)) {
			// 纪检监察室可以看到所有数据

			riskList = dcaRiskManageDefineService.findRiskDefineData(dcaAlarmRiskDefineEntity);
		} else {
			// 非纪检监察室的正职副职领导可以看到部门数据

			if (checkifexits(officeId)) {

				List<Office> officeList = dcaRiskManageDefineService.findParent(officeId);

				if (CollectionUtils.isNotEmpty(officeList)) {
					dcaAlarmRiskDefineEntity.setParentList(officeList);
				}
				riskList = dcaRiskManageDefineService.findRiskDefineData(dcaAlarmRiskDefineEntity);
			}

		}

		model.addAttribute("riskList", riskList);

		return JsonMapper.nonDefaultMapper().toJson(riskList);
	}

	/**
	 * 告警风险统计(部门):告警风险统计年度 个数
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月7日
	 */
	@RequestMapping(value = "findRiskCount")
	@ResponseBody
	public String findRiskCount(Model model, DcaAlarmRiskDefineEntity dcaAlarmRiskDefineEntity) {
		List<DcaAlarmRiskDefineEntity> riskYear = new ArrayList<DcaAlarmRiskDefineEntity>();
		User currentUser = UserUtils.getUser();
		// 当前用户部门ID
		String officeId = currentUser.getOffice().getId();

		String curofficeId = dcaAlarmRiskDefineEntity.getOfficeId();

		if (StringUtils.isNotEmpty(curofficeId)) {
			if (!officeId.equals(curofficeId)) {
				officeId = curofficeId;
			}
		}
		// 设置查询的业务类型
		dcaAlarmRiskDefineEntity.setIdxDataType(idxDataType);

		if (checkifPost(officeId)) {
			// 纪检监察室看到所有数据

			riskYear = dcaRiskManageDefineService.findRiskCount(dcaAlarmRiskDefineEntity);
		} else {
			// 非纪检监察室的正职副职领导可以看到部门数据
			if (checkifexits(officeId)) {

				List<Office> officeList = dcaRiskManageDefineService.findParent(officeId);

				if (CollectionUtils.isNotEmpty(officeList)) {
					dcaAlarmRiskDefineEntity.setParentList(officeList);
				}

				riskYear = dcaRiskManageDefineService.findRiskCount(dcaAlarmRiskDefineEntity);
			}

		}

		model.addAttribute("riskYear", riskYear);
		return JsonMapper.nonDefaultMapper().toJson(riskYear);
	}

	/**
	 * 告警风险统计(部门):告警风险统计月份个数
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月7日
	 */
	@RequestMapping(value = "findRiskMonthCount")
	@ResponseBody
	public String findRiskMonthCount(Model model, DcaAlarmRiskDefineEntity dcaAlarmRiskDefineEntity) {

		DcaAlarmRiskDefineEntity riskMonth = new DcaAlarmRiskDefineEntity();

		User currentUser = UserUtils.getUser();
		// 当前用户部门ID
		String officeId = currentUser.getOffice().getId();

		String curofficeId = dcaAlarmRiskDefineEntity.getOfficeId();

		if (StringUtils.isNotEmpty(curofficeId)) {
			if (!officeId.equals(curofficeId)) {
				officeId = curofficeId;
			}
		}

		// 设置查询的业务类型
		dcaAlarmRiskDefineEntity.setIdxDataType(idxDataType);

		if (checkifPost(officeId)) {
			// 纪检监察室看到所有数据

			riskMonth = dcaRiskManageDefineService.findRiskMonthCount(dcaAlarmRiskDefineEntity);
		} else {
			// 非纪检监察室的正职副职领导可以看到部门数据
			if (checkifexits(officeId)) {

				List<Office> officeList = dcaRiskManageDefineService.findParent(officeId);

				if (CollectionUtils.isNotEmpty(officeList)) {
					dcaAlarmRiskDefineEntity.setParentList(officeList);
				}
				riskMonth = dcaRiskManageDefineService.findRiskMonthCount(dcaAlarmRiskDefineEntity);
			} else {

				Integer[] riskArray = new Integer[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
				Integer[] alarmArray = new Integer[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
				riskMonth.setRiskArray(riskArray);
				riskMonth.setAlarmArray(alarmArray);
			}

		}
		model.addAttribute("riskMonth", riskMonth);

		return JsonMapper.nonDefaultMapper().toJson(riskMonth);
	}

	/**
	 * 判断当前用户是否是部门领导
	 *
	 */
	private boolean checkifexits(String officeId) {
		User currentUser = UserUtils.getUser();// 获取当前用户
		String primaryPerson = "";// 正职领导
		String deputyPerson = "";// 副职领导
		Office office = officeService.get(officeId);
		if (office.getPrimaryPerson() != null) {
			primaryPerson = office.getPrimaryPerson().getId();
		}
		if (office.getDeputyPerson() != null) {
			deputyPerson = office.getDeputyPerson().getId();
		}
		if (currentUser.getId().equals(primaryPerson) || currentUser.getId().equals(deputyPerson)) {

			return true;

		}
		return false;
	}

	/**
	 * 判断当前用户是否是纪检监察室
	 */
	private boolean checkifPost(String officeId) {
		String DISR = ""; // 纪检监察室
		List<Dict> dictList = DictUtils.getDictList("discipline_depart");
		if (dictList != null && dictList.get(0) != null) {
			DISR = dictList.get(0).getValue();
		}
		if (DISR.equals(officeId)) {
			return true;
		}

		return false;
	}

}