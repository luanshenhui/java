/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */

package com.hepowdhc.dcapp.biz;

import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportRiskEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportRiskTotalEntity;
import com.hepowdhc.dcapp.modules.visualization.service.DcaReportRiskService;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.DcaTraceUserRoleService;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 风险统计表Controller
 * 
 * @author HuNan
 * @version 2016-11-08
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaReportRiskCount")
public class DcaReportRiskCountController extends BaseController {

	@Autowired
	private DcaReportRiskService dcaReportRiskService;
	@Autowired
	private DcaTraceUserRoleService dcaTraceUserRoleService;
	// 当前查询的业务类型
	private String idxDataType;

	/**
	 * 风险统计表
	 * 
	 * @author gaojianshuo
	 * @date 2016年12月7日
	 */
	@RequestMapping(value = { "forPower", "" })
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
		// 设置查询的业务类型
		idxDataType = (String) request.getSession().getAttribute("tabType");
		return "modules/dca/dcaReportRiskCount";
	}

	/**
	 * 风险统计表
	 * 
	 * @return
	 * @author gaojianshuo
	 * @date 2016-12-07
	 */
	@RequestMapping(value = "findReportRisk")
	@ResponseBody
	public String findReportRisk(DcaReportRiskEntity dcaReportRiskEntity) {

		DcaReportRiskTotalEntity result = new DcaReportRiskTotalEntity();
		String DISR = ""; // 纪检监察室
		List<Dict> dictList = DictUtils.getDictList("discipline_depart");
		if (dictList != null && dictList.get(0) != null) {
			DISR = dictList.get(0).getValue();
		}

		User curUser = UserUtils.getUser();
		// 当前用户的名称
		String operator = curUser.getName();
		// 当前用户的部门id
		String userOfficeId = curUser.getOffice().getId();
		// 取得部门名
		String userOfficeName = curUser.getOffice().getName();

		// 当前用户的岗位ID
		String userTraceID = "";
		if (CollectionUtils.isNotEmpty(curUser.getPostList())) {
			userTraceID = curUser.getPostList().get(0).getRoleId();
		}

		// 查询年份
		List<Integer> yearList = dcaReportRiskService.findRiskYear(dcaReportRiskEntity);
		int nowYear = Integer.parseInt(DateUtils.getYear());
		if (yearList == null || yearList.size() == 0 || (yearList.size() > 0 && yearList.get(0) != nowYear)) {
			// 年份为空||今年无数据
			if (checkSelectNull(dcaReportRiskEntity.getBizOperPerson())
					&& checkSelectNull(dcaReportRiskEntity.getBizOperPost())) {
				// 没有选择 操作人 部门
				yearList.add(0, nowYear);
			}
		}
		result.setYearList(yearList);// 年份列表

		// 设置查询的业务类型
		dcaReportRiskEntity.setIdxDataType(idxDataType);

		// Login User的部门=[纪检监察室]
		if (DISR.equals(userOfficeId)) {

			// 查询风险统计全部数据
			List<DcaReportRiskEntity> totalList = dcaReportRiskService.findReportRisk(dcaReportRiskEntity);
			result.setReportList(totalList);
			result.setOperator(null);
			result.setOfficeName(null);

		} else {
			// 查询风险统计数据 操作人名 TODO
			// 判断当前用户是否有下属用户
			List<DcaTraceUserRole> postList = dcaTraceUserRoleService.findByParentId(userTraceID);

			if (postList != null && postList.size() > 0) {
				result.setOperator(null);
				dcaReportRiskEntity.setBizOperPost(userOfficeId);
			} else {
				result.setOperator(operator);
				result.setOperatorID(curUser.getId());
				dcaReportRiskEntity.setBizOperPerson(curUser.getId());
				dcaReportRiskEntity.setBizOperPost(userOfficeId);
				dcaReportRiskEntity.setPostId(userTraceID);// 岗位id
				dcaReportRiskEntity.setCurrentUser(curUser);// 当前用户对象
			}
			List<DcaReportRiskEntity> totalList = dcaReportRiskService.findReportRisk(dcaReportRiskEntity);

			result.setReportList(totalList);
			// 如果不是纪检监察室,获取部门的名称
			result.setOfficeID(userOfficeId);
			result.setOfficeName(userOfficeName);
		}

		return JsonMapper.nonDefaultMapper().toJson(result);
	}

	/**
	 * 校验 是否选中 有效值
	 * 
	 * @param value
	 * @return
	 * @author panghuidan
	 * @date 2016年12月16日
	 */
	private boolean checkSelectNull(String value) {
		return StringUtils.isEmpty(value) || ("-999").equals(value);
	}
}