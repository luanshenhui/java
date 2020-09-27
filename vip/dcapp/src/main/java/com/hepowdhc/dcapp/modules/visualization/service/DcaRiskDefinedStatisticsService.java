/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskManageDao;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManage;
import com.hepowdhc.dcapp.modules.visualization.entity.RiskDefinedStatistics;
import com.hepowdhc.dcapp.modules.visualization.entity.RiskStatistics;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.DcaTraceUserRoleService;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 风险界定
 * 
 * @author yuduo
 * @version 2016-12-06
 */
@Service
@Transactional(readOnly = true)
public class DcaRiskDefinedStatisticsService extends CrudService<DcaRiskManageDao, DcaRiskManage> {

	@Autowired
	private DcaRiskManageDao dcaRiskManageDao;
	@Autowired
	private DcaTraceUserRoleService dcaTraceUserRoleService;

	/**
	 * 遍历风险数据
	 * 
	 * @author yuduo
	 * @version 2016-12-07
	 */
	public RiskStatistics getRiskStatistics(String selectYear, String idxDataType) {

		String DISR = ""; // 纪检监察室
		List<Dict> dictList = DictUtils.getDictList("discipline_depart");
		if (CollectionUtils.isNotEmpty(dictList)) {
			DISR = dictList.get(0).getValue();
		}
		User curUser = UserUtils.getUser();
		// 当前用户的部门id
		String userOfficeId = curUser.getOffice().getId();
		// 获取用户的岗位id
		String postId = "";
		if (CollectionUtils.isNotEmpty(curUser.getPostList())) {
			postId = curUser.getPostList().get(0).getRoleId();
		}
		List<RiskDefinedStatistics> rsList = Lists.newArrayList();
		// Login User的部门=[纪检监察室]
		if (StringUtils.isNotBlank(DISR) && DISR.equals(userOfficeId)) {
			Map<String, String> param = Maps.newHashMap();
			param.put("selectYear", selectYear);
			param.put("idxDataType", idxDataType);
			rsList = dcaRiskManageDao.getRiskDefinedStatistics(param);
		} else { // 不是[纪检监察室]时
			Map<String, Object> params = Maps.newHashMap();
			params.put("selectYear", selectYear);
			params.put("idxDataType", idxDataType);
			// 判断登录用户的岗位是否有下属人员
			if (!isHavaSub(postId)) {// 如果没有下属，则只查当前用户的信息
				params.put("userId", curUser.getId());
				params.put("officeId", userOfficeId);
				params.put("user", curUser);
			} else {
				params.put("officeId", userOfficeId);
				params.put("user", curUser);
			}
			params.put("postId", postId);
			rsList = dcaRiskManageDao.getRiskDefinedReportByUser(params);
		}

		RiskStatistics risk = new RiskStatistics();
		for (int i = 1; i <= 12; i++) {
			int a = 0, b = 0, c = 0;
			for (RiskDefinedStatistics val : rsList) {
				if (i == val.getMon() && 1 == val.getDefineStatus()) {
					a = val.getNum();
				}
				if (i == val.getMon() && 2 == val.getDefineStatus()) {
					b = val.getNum();
				}
				if (i == val.getMon() && 3 == val.getDefineStatus()) {
					c = val.getNum();
				}
			}
			risk.getIsRisk().add(a);
			risk.getIsNotRisk().add(b);
			risk.getUnattuned().add(c);
			risk.getTotal().add(a + b + c);
		}
		return risk;
	}

	/**
	 * 判断岗位下是否有下属人员
	 * 
	 * @param postId
	 * @return
	 */
	private boolean isHavaSub(String postId) {
		if (StringUtils.isNotBlank(postId)) {
			List<DcaTraceUserRole> list = dcaTraceUserRoleService.findByParentId(postId);
			if (list != null && list.size() > 0) {
				return true;
			}
		}
		return false;
	}
}