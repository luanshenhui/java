/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.entity;

import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 页面设置Entity（用于与前台交互）
 * 
 * @author zhengwei.cui
 * @version 2016-12-26
 */
public class DcaPageConfigDetail extends DataEntity<DcaPageConfigDetail> {

	private static final long serialVersionUID = 1L;
	private List<OverallData> overallDataList; // 总体数据
	private List<TimeDimension> timeDimensionList; // 时间维度
	private List<InvolveDept> involveDeptList; // 涉及部门
	private List<EfficacyAnalysis> efficacyAnalysisList; // 效能分析

	public List<OverallData> getOverallDataList() {
		return overallDataList;
	}

	public void setOverallDataList(List<OverallData> overallDataList) {
		this.overallDataList = overallDataList;
	}

	public List<TimeDimension> getTimeDimensionList() {
		return timeDimensionList;
	}

	public void setTimeDimensionList(List<TimeDimension> timeDimensionList) {
		this.timeDimensionList = timeDimensionList;
	}

	public List<InvolveDept> getInvolveDeptList() {
		return involveDeptList;
	}

	public void setInvolveDeptList(List<InvolveDept> involveDeptList) {
		this.involveDeptList = involveDeptList;
	}

	public List<EfficacyAnalysis> getEfficacyAnalysisList() {
		return efficacyAnalysisList;
	}

	public void setEfficacyAnalysisList(List<EfficacyAnalysis> efficacyAnalysisList) {
		this.efficacyAnalysisList = efficacyAnalysisList;
	}
}