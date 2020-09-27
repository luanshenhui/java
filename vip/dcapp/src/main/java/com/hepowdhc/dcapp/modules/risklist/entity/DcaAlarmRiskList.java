/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.common.utils.excel.annotation.ExcelField;

/**
 * 风险清单管理Entity
 * 
 * @author shiqiang.zhang
 * @version 2016-11-08
 */
public class DcaAlarmRiskList extends DataEntity<DcaAlarmRiskList> {

	private static final long serialVersionUID = 1L;
	private String riskId; // 风险清单id
	private String riskName; // 风险名称
	private String powerId; // 权力
	private String riskTask; // 风险环节
	private String riskContent; // 风险内容
	private String riskLevel; // 风险等级
	private String measure; // 防范措施
	private String createPerson; // 创建人
	private String updatePerson; // 更新者

	private String riskType; // 风险类型

	public String getRiskType() {
		return riskType;
	}

	public void setRiskType(String riskType) {
		this.riskType = riskType;
	}

	public DcaAlarmRiskList() {
		super();
	}

	public DcaAlarmRiskList(String id) {
		super(id);
	}

	@ExcelField(title = "序号", align = 2, sort = 5)
	@Length(min = 1, max = 50, message = "风险清单id长度必须介于 1 和 50 之间")
	public String getRiskId() {
		return riskId;
	}

	public void setRiskId(String riskId) {
		this.riskId = riskId;
	}

	@ExcelField(title = "权力", align = 2, sort = 8)
	@Length(min = 1, max = 5, message = "权力长度必须介于 1 和 5 之间")
	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	@ExcelField(title = "风险名称", align = 2, sort = 10)
	@Length(min = 1, max = 30, message = "风险名称长度必须介于 1 和30之间")
	public String getRiskName() {
		return riskName;
	}

	public void setRiskName(String riskName) {
		this.riskName = riskName;
	}

	@ExcelField(title = "风险环节", align = 2, sort = 15)
	@Length(min = 1, max = 16, message = "风险环节长度必须介于 1 和 16之间")
	public String getRiskTask() {
		return riskTask;
	}

	public void setRiskTask(String riskTask) {
		this.riskTask = riskTask;
	}

	@ExcelField(title = "风险内容", align = 2, sort = 20)
	@Length(min = 1, max = 300, message = "风险内容长度必须介于 1 和 300 之间")
	public String getRiskContent() {
		return riskContent;
	}

	public void setRiskContent(String riskContent) {
		this.riskContent = riskContent;
	}

	@ExcelField(title = "风险等级", align = 2, sort = 25)
	@Length(min = 1, max = 5, message = "风险等级长度必须介于 1 和 5 之间")
	public String getRiskLevel() {
		return riskLevel;
	}

	public void setRiskLevel(String riskLevel) {
		this.riskLevel = riskLevel;
	}

	@ExcelField(title = "防范措施", align = 2, sort = 30)
	@Length(min = 1, max = 300, message = "防范措施长度必须介于 1 和 300 之间")
	public String getMeasure() {
		return measure;
	}

	public void setMeasure(String measure) {
		this.measure = measure;
	}

	@Length(min = 0, max = 64, message = "创建人长度必须介于 0 和 64 之间")
	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	@Length(min = 0, max = 64, message = "更新者长度必须介于 0 和 64 之间")
	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

	/**
	 * 是否关联了工作流标记
	 */
	private String workFlowFlag;

	public String getWorkFlowFlag() {
		return workFlowFlag;
	}

	public void setWorkFlowFlag(String workFlowFlag) {
		this.workFlowFlag = workFlowFlag;
	}

	/**
	 * 修改时判断风险名称是否改变
	 */
	private String oldRiskName;

	public String getOldRiskName() {
		return oldRiskName;
	}

	public void setOldRiskName(String oldRiskName) {
		this.oldRiskName = oldRiskName;
	}

}