package cn.com.cgbchina.rest.visit.vo.coupon;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ProvideCouponResultVO extends BaseResultVo implements Serializable {
	@NotNull
	private String totalPages;
	@NotNull
	private String totalCount;
	private List<ProvideCouponResultInfoVO> provideCouponResultInfos;

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

	public List<ProvideCouponResultInfoVO> getProvideCouponResultInfos() {
		return provideCouponResultInfos;
	}

	public void setProvideCouponResultInfos(List<ProvideCouponResultInfoVO> provideCouponResultInfos) {
		this.provideCouponResultInfos = provideCouponResultInfos;
	}
}
