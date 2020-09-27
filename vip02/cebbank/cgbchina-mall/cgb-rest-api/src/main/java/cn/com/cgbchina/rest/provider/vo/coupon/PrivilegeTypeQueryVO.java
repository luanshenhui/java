package cn.com.cgbchina.rest.provider.vo.coupon;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL120 商户、类别查询（优惠券）查询对象
 * 
 * @author lizy 2016/4/28.
 */
public class PrivilegeTypeQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = -2467342876783513397L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
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
