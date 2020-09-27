package cn.com.cgbchina.rest.provider.model.coupon;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL120
 * 
 * @author lizy 2016/4/28.
 */
public class PrivilegeTypeQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = -2467342876783513397L;
	private String origin;
	private String mallType;
	private String projectNO;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getMallType() {
		return mallType;
	}

	public void setMallType(String mallType) {
		this.mallType = mallType;
	}

	public String getProjectNO() {
		return projectNO;
	}

	public void setProjectNO(String projectNO) {
		this.projectNO = projectNO;
	}
}
