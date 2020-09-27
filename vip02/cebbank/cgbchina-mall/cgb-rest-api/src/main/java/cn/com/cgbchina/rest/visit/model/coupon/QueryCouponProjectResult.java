package cn.com.cgbchina.rest.visit.model.coupon;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class QueryCouponProjectResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = 4471880886941609796L;
	@NotNull
	private String totalPages;
	@NotNull
	private String totalCount;
	private List<CouponProject> couponProjects = new ArrayList<CouponProject>();

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

	public List<CouponProject> getCouponProjects() {
		return couponProjects;
	}

	public void setCouponProjects(List<CouponProject> couponProjects) {
		this.couponProjects = couponProjects;
	}

}
