package cn.com.cgbchina.rest.visit.vo.point;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PointTypeInfoVO implements Serializable {
	@NotNull
	@XMLNodeName("jg_id")
	private String jgId;
	@NotNull
	@XMLNodeName("jg_type")
	private String jgType;
	@NotNull
	@XMLNodeName("is_adjective")
	private Byte isAdjective;

	public String getJgId() {
		return jgId;
	}

	public void setJgId(String jgId) {
		this.jgId = jgId;
	}

	public String getJgType() {
		return jgType;
	}

	public void setJgType(String jgType) {
		this.jgType = jgType;
	}

	public Byte getIsAdjective() {
		return isAdjective;
	}

	public void setIsAdjective(Byte isAdjective) {
		this.isAdjective = isAdjective;
	}

}
