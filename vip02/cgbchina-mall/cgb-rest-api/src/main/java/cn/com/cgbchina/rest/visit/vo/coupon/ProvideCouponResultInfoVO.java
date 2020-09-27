package cn.com.cgbchina.rest.visit.vo.coupon;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ProvideCouponResultInfoVO implements Serializable {
	@NotNull
	private String privilegeId;
	@NotNull
	private String privilegeName;
	@NotNull
	private String beginDate;
	@NotNull
	private String endDate;

	public String getPrivilegeId() {
		return privilegeId;
	}

	public void setPrivilegeId(String privilegeId) {
		this.privilegeId = privilegeId;
	}

	public String getPrivilegeName() {
		return privilegeName;
	}

	public void setPrivilegeName(String privilegeName) {
		this.privilegeName = privilegeName;
	}

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

}
