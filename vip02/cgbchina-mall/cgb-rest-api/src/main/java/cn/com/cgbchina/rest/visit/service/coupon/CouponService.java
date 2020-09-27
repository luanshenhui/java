package cn.com.cgbchina.rest.visit.service.coupon;

import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponProjectResutl;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProjectPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfoResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponProjectResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public interface CouponService {
	QueryCouponInfoResult queryCouponInfo(QueryCouponInfo info);

	QueryCouponProjectResult queryCouponProject(CouponProjectPage page);

	ActivateCouponProjectResutl activateCoupon(ActivateCouponInfo info);

	ProvideCouponResult provideCoupon(ProvideCouponPage page);
}
