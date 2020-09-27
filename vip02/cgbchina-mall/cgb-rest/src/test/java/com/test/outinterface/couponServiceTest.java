package com.test.outinterface;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponProjectResutl;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProjectPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfoResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponProjectResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import com.spirit.util.JsonMapper;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
public class couponServiceTest {

	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Resource
	CouponService couponServiceImpl;

	@Test
	public void test_QueryCouponInfo_01() {//MA4000 已调通
		QueryCouponInfo info = new QueryCouponInfo();
//		QueryCouponInfo info =  BeanUtils.randomClass(QueryCouponInfo.class);

		// 【商城提供部分】
		info.setChannel("BC");// 交易渠道
		info.setQryType("01");// 查询类型
		info.setRowsPage("10");// 每页行数
		info.setCurrentPage("0");// 当前页数，0表示第一页
		info.setUseState(Byte.valueOf("0"));// 使用状态:0全部,1已使用，2未使用
		info.setPastDueState(Byte.valueOf("0"));// 过期状态:0全部，1未过期，2已过期

		// 【外部接口提供部分】
		info.setContIdCard("362330199010269776");// 证件号码
		info.setContIdType("0");// 证件类型
		QueryCouponInfoResult result = couponServiceImpl.queryCouponInfo(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void test_activateCoupon_01() {//MA1000 已调通
		ActivateCouponInfo info = BeanUtils.randomClass(ActivateCouponInfo.class);
		// 【商城提供部分】
		info.setChannel("BC");// 交易渠道

		// 【外部接口提供部分】
		info.setContIdCard("362330199010269776");// 证件号码
		info.setContIdType("0");
		info.setActivation("abcde12345771492564");// 优惠券激活码
		ActivateCouponProjectResutl result = couponServiceImpl.activateCoupon(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void test_provideCoupon_01() {//MA1001已调通
		ProvideCouponPage info = new ProvideCouponPage();
//		ProvideCouponPage info = BeanUtils.randomClass(ProvideCouponPage.class);
		// 【商城提供部分】
		info.setChannel("BC");// 交易渠道
		info.setProjectNO("110301");// 优惠劵项目编号 ,此数据需要从MA4001中的结果集中取得，此处为假值
//		Byte b = '3';
		info.setGrantType("1");// 发放种类
		info.setNum(1);// 数量

		// 【外部接口提供部分】
		info.setContIdCard("362330199010269776");// 证件号码
		info.setContIdType("0");
		ProvideCouponResult result = couponServiceImpl.provideCoupon(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void MA4001CouponServiceImpl() {//已调通
		CouponProjectPage info = BeanUtils.randomClass(CouponProjectPage.class);
		// 【固定参数】
		info.setCurrentPage("0");// 请求页数,0表示第一页
		info.setRowsPage("10");// 10条数据
		// 【商城提供】
		info.setChannel(Contants.CHANNEL_BC);// 商城

		QueryCouponProjectResult result = couponServiceImpl.queryCouponProject(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败", result);
	}
}
