package cn.com.cgbchina.rest.visit.test.coupon;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.TestClass;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponProjectResutl;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProjectPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfoResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponProjectResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Service
public class CouponServiceImpl implements CouponService {
	@Override
	public QueryCouponInfoResult queryCouponInfo(QueryCouponInfo info) {
		return TestClass.debugMethod(QueryCouponInfoResult.class);
//		return null;
	}

	@Override
	public QueryCouponProjectResult queryCouponProject(CouponProjectPage page) {
		return TestClass.debugMethod(QueryCouponProjectResult.class);
	}

	@Override
	public ActivateCouponProjectResutl activateCoupon(ActivateCouponInfo info) {
		return TestClass.debugMethod(ActivateCouponProjectResutl.class);
	}

	@Override
	public ProvideCouponResult provideCoupon(ProvideCouponPage page) {
		return TestClass.debugMethod(ProvideCouponResult.class);
	}
}
