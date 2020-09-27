package cn.com.cgbchina.rest.visit.service.coupon;

import cn.com.cgbchina.rest.visit.model.coupon.*;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public interface CouponService {
	QueryCouponInfoResult queryCouponInfo(QueryCouponInfo info);

	QueryCouponProjectResult queryCouponProject(CouponProjectPage page);

	ActivateCouponProjectResutl activateCoupon(ActivateCouponInfo info);

	ProvideCouponResult provideCoupon(ProvideCouponPage page);
}
