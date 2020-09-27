package cn.com.cgbchina.rest.visit.model.point;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PointTypeInfo implements Serializable {
	private static final long serialVersionUID = -217166980844504695L;
	private String jgId;
	private String jgType;
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
