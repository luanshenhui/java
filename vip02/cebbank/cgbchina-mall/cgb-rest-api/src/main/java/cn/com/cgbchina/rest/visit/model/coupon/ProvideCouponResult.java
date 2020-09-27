package cn.com.cgbchina.rest.visit.model.coupon;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ProvideCouponResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = -678900685581646347L;
	@NotNull
	private String totalPages;
	@NotNull
	private String totalCount;
	private List<ProvideCouponResultInfo> provideCouponResultInfos;
	private String returnCode;
	private String returnDes;

	public String getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}

	public String getReturnDes() {
		return returnDes;
	}

	public void setReturnDes(String returnDes) {
		this.returnDes = returnDes;
	}

	public String getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(String totalPages) {
		this.totalPages = totalPages;
	}

	public String getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(String totalCount) {
		this.totalCount = totalCount;
	}

	public List<ProvideCouponResultInfo> getProvideCouponResultInfos() {
		return provideCouponResultInfos;
	}

	public void setProvideCouponResultInfos(List<ProvideCouponResultInfo> provideCouponResultInfos) {
		this.provideCouponResultInfos = provideCouponResultInfos;
	}
}
