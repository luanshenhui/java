package cn.com.cgbchina.rest.provider.model.coupon;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL120 商户、类别查询（优惠券）返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class PrivilegeTypeQueryReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = -6345689147519711885L;
	private String projectNO;
	private String projectNM;
	private String typeIds;
	private String typePids;
	private String typeNms;
	private String vendorIds;
	private String vendorNms;

	public String getProjectNO() {
		return projectNO;
	}

	public void setProjectNO(String projectNO) {
		this.projectNO = projectNO;
	}

	public String getProjectNM() {
		return projectNM;
	}

	public void setProjectNM(String projectNM) {
		this.projectNM = projectNM;
	}

	public String getTypeIds() {
		return typeIds;
	}

	public void setTypeIds(String typeIds) {
		this.typeIds = typeIds;
	}

	public String getTypePids() {
		return typePids;
	}

	public void setTypePids(String typePids) {
		this.typePids = typePids;
	}

	public String getTypeNms() {
		return typeNms;
	}

	public void setTypeNms(String typeNms) {
		this.typeNms = typeNms;
	}

	public String getVendorIds() {
		return vendorIds;
	}

	public void setVendorIds(String vendorIds) {
		this.vendorIds = vendorIds;
	}

	public String getVendorNms() {
		return vendorNms;
	}

	public void setVendorNms(String vendorNms) {
		this.vendorNms = vendorNms;
	}
}
