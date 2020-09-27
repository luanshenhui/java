package cn.com.cgbchina.rest.visit.model.coupon;

import cn.com.cgbchina.rest.visit.model.BaseResult;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

/**
 * Comment:
 * Created by 11150321050126 on 2016/4/30.
 */
public class QueryCouponInfoResult extends BaseResult implements Serializable {
    private static final long serialVersionUID = 8833609196691242350L;
    @NotNull
    private String totalPages;
	@NotNull
    private String totalCount;
    private List<CouponInfo> couponInfos=new ArrayList<CouponInfo>();

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

    public List<CouponInfo> getCouponInfos() {
        return couponInfos;
    }

    public void setCouponInfos(List<CouponInfo> couponInfos) {
        this.couponInfos = couponInfos;
    }
}
