/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 页面设置Entity
 * 
 * @author zhengwei.cui
 * @version 2016-12-26
 */
public class DcaPageConfig extends DataEntity<DcaPageConfig> {

	private static final long serialVersionUID = 1L;
	private String cfgId; // 页面配置ID
	private String cfgType; // 字典代码
	private Integer cfgCode; // 详细编码
	private String cfgName; // 名称
	private String cfgValue1; // 值1
	private String cfgValue2; // 值2
	private String cfgValue3; // 值3
	private String cfgValue4; // 值4
	private String cfgValue5; // 值5
	private String cfgValue6; // 值6
	private String createPerson; // 创建人
	private String updatePerson; // 更新人

	public DcaPageConfig() {
		super();
	}

	public DcaPageConfig(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "页面配置ID长度必须介于 1 和 50 之间")
	public String getCfgId() {
		return cfgId;
	}

	public void setCfgId(String cfgId) {
		this.cfgId = cfgId;
	}

	@Length(min = 1, max = 50, message = "字典代码长度必须介于 1 和 50 之间")
	public String getCfgType() {
		return cfgType;
	}

	public void setCfgType(String cfgType) {
		this.cfgType = cfgType;
	}

	public Integer getCfgCode() {
		return cfgCode;
	}

	public void setCfgCode(Integer cfgCode) {
		this.cfgCode = cfgCode;
	}

	@Length(min = 0, max = 100, message = "名称长度必须介于 0 和 100 之间")
	public String getCfgName() {
		return cfgName;
	}

	public void setCfgName(String cfgName) {
		this.cfgName = cfgName;
	}

	@Length(min = 0, max = 100, message = "值1长度必须介于 0 和 100 之间")
	public String getCfgValue1() {
		return cfgValue1;
	}

	public void setCfgValue1(String cfgValue1) {
		this.cfgValue1 = cfgValue1;
	}

	@Length(min = 0, max = 100, message = "值2长度必须介于 0 和 100 之间")
	public String getCfgValue2() {
		return cfgValue2;
	}

	public void setCfgValue2(String cfgValue2) {
		this.cfgValue2 = cfgValue2;
	}

	@Length(min = 0, max = 100, message = "值3长度必须介于 0 和 100 之间")
	public String getCfgValue3() {
		return cfgValue3;
	}

	public void setCfgValue3(String cfgValue3) {
		this.cfgValue3 = cfgValue3;
	}

	@Length(min = 0, max = 100, message = "值4长度必须介于 0 和 100 之间")
	public String getCfgValue4() {
		return cfgValue4;
	}

	public void setCfgValue4(String cfgValue4) {
		this.cfgValue4 = cfgValue4;
	}

	@Length(min = 0, max = 100, message = "值5长度必须介于 0 和 100 之间")
	public String getCfgValue5() {
		return cfgValue5;
	}

	public void setCfgValue5(String cfgValue5) {
		this.cfgValue5 = cfgValue5;
	}

	@Length(min = 0, max = 100, message = "值6长度必须介于 0 和 100 之间")
	public String getCfgValue6() {
		return cfgValue6;
	}

	public void setCfgValue6(String cfgValue6) {
		this.cfgValue6 = cfgValue6;
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

}