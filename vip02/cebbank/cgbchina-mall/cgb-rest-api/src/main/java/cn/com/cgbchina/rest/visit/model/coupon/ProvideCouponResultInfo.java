package cn.com.cgbchina.rest.visit.model.coupon;

import java.io.Serializable;
import java.util.Date;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ProvideCouponResultInfo implements Serializable {
	private static final long serialVersionUID = 4514354607052071156L;
	private String privilegeId;
	private String privilegeName;
	private String beginDate;
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
