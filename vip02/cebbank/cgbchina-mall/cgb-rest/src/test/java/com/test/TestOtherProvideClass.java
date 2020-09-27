package com.test;

import javax.annotation.Resource;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponProjectResutl;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProjectPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfoResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponProjectResult;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPay;
import cn.com.cgbchina.rest.visit.model.payment.ChannelPayInfo;
import cn.com.cgbchina.rest.visit.model.payment.ChannelPayResult;
import cn.com.cgbchina.rest.visit.model.payment.Orderluck;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResult;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQuery;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQueryResult;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQuery;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQueryResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.recharge.MobileRechargeInfo;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.user.ChannelPwdInfo;
import cn.com.cgbchina.rest.visit.model.user.CheckChannelPwdResult;
import cn.com.cgbchina.rest.visit.model.user.LoginInfo;
import cn.com.cgbchina.rest.visit.model.user.LoginResult;
import cn.com.cgbchina.rest.visit.model.user.MobileValidCode;
import cn.com.cgbchina.rest.visit.model.user.MobileValidCodeResult;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.RegisterInfo;
import cn.com.cgbchina.rest.visit.model.user.RegisterResult;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.rest.visit.service.recharge.RechargeService;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;
import cn.com.cgbchina.rest.visit.service.user.UserService;

import com.spirit.util.JsonMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
public class TestOtherProvideClass {

	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Test
	public void demo() {
		QueryCouponInfo info = BeanUtils.randomClass(QueryCouponInfo.class);
		QueryCouponInfoResult result = couponServiceImpl.queryCouponInfo(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void BP0005StagingRequestServiceImpl() {
		StagingRequest info = BeanUtils.randomClass(StagingRequest.class);
		StagingRequestResult result = stagingRequestServiceImpl
				.getStagingRequest(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(stagingRequestServiceImpl.getClass().getName()
				+ "对比失败", result);
	}

	@Test
	public void BP1001StagingRequestServiceImpl() {
		WorkOrderQuery info = BeanUtils.randomClass(WorkOrderQuery.class);
		WorkOrderQueryResult result = stagingRequestServiceImpl
				.workOrderQuery(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(stagingRequestServiceImpl.getClass().getName()
				+ "对比失败", result);
	}

	@Test
	public void NSCT002PaymentServiceImpl() {
		PaymentRequeryInfo info = BeanUtils
				.randomClass(PaymentRequeryInfo.class);
		PaymentRequeryResult result = paymentServiceImpl.paymentRequery(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void NSCT004PaymentServiceImpl() {
		Orderluck info = BeanUtils.randomClass(Orderluck.class);
		BaseResult result = paymentServiceImpl.luckPackReturn(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void NSCT016PaymentServiceImpl() {
		CCPointsPay info = BeanUtils.randomClass(CCPointsPay.class);
		BaseResult result = paymentServiceImpl.ccPointsPay(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void NSCT007PaymentServiceImpl() {
		ReqMoneyInfo info = BeanUtils.randomClass(ReqMoneyInfo.class);
		BaseResult result = paymentServiceImpl.reqMoney(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void NSCT018PaymentServiceImpl() {
		ReturnGoodsInfo info = BeanUtils.randomClass(ReturnGoodsInfo.class);
		BaseResult result = paymentServiceImpl.returnGoods(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void NSCT009PaymentServiceImpl() {
		ReturnPointsInfo info = BeanUtils.randomClass(ReturnPointsInfo.class);
		BaseResult result = paymentServiceImpl.returnPoint(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void NSCT010PaymentServiceImpl() {
		PointsMallReqMoneyInfo info = BeanUtils
				.randomClass(PointsMallReqMoneyInfo.class);
		BaseResult result = paymentServiceImpl.pointsMallReqMoney(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void NSCT012PaymentServiceImpl() {
		PointsMallReturnGoodsInfo info = BeanUtils
				.randomClass(PointsMallReturnGoodsInfo.class);
		BaseResult result = paymentServiceImpl.pointsMallReturnGoods(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void MMP011PaymentServiceImpl() {
		ChannelPayInfo info = BeanUtils.randomClass(ChannelPayInfo.class);
		ChannelPayResult result = paymentServiceImpl.channelPay(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void bms007PointServiceImpl() {
		PointTypeQuery info = BeanUtils.randomClass(PointTypeQuery.class);
		PointTypeQueryResult result = pointServiceImpl.queryPointType(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(pointServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void bms011PointServiceImpl() {
		QueryPointsInfo info = BeanUtils.randomClass(QueryPointsInfo.class);
		QueryPointResult result = pointServiceImpl.queryPoint(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(pointServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void SMS093SMSServiceImpl() {
		BatchSendSMSNotify info = BeanUtils
				.randomClass(BatchSendSMSNotify.class);
		BaseResult result = sMSServiceImpl.batchSMSNotify(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(sMSServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void EBOT01UserServiceImpl() {
		LoginInfo info = BeanUtils.randomClass(LoginInfo.class);
		LoginResult result = userServiceImpl.login(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void EBOT02UserServiceImpl() {
		RegisterInfo info = BeanUtils.randomClass(RegisterInfo.class);
		RegisterResult result = userServiceImpl.register(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void EBOT03UserServiceImpl() {
		MobileValidCode info = BeanUtils.randomClass(MobileValidCode.class);
		MobileValidCodeResult result = userServiceImpl.getMobileValidCode(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void EBOT04UserServiceImpl() {
		QueryUserInfo info = BeanUtils.randomClass(QueryUserInfo.class);
		UserInfo result = userServiceImpl.getCousrtomInfo(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void EBOT12UserServiceImpl() {
		ChannelPwdInfo info = BeanUtils.randomClass(ChannelPwdInfo.class);
		CheckChannelPwdResult result = userServiceImpl.checkChannelPwd(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void MA4000CouponServiceImpl() {
		QueryCouponInfo info = BeanUtils.randomClass(QueryCouponInfo.class);
		QueryCouponInfoResult result = couponServiceImpl.queryCouponInfo(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void MA4001CouponServiceImpl() {
		CouponProjectPage info = BeanUtils.randomClass(CouponProjectPage.class);
		QueryCouponProjectResult result = couponServiceImpl
				.queryCouponProject(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void MA1000CouponServiceImpl() {
		ActivateCouponInfo info = BeanUtils
				.randomClass(ActivateCouponInfo.class);
		ActivateCouponProjectResutl result = couponServiceImpl
				.activateCoupon(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void MA1001CouponServiceImpl() {
		ProvideCouponPage info = BeanUtils.randomClass(ProvideCouponPage.class);
		ProvideCouponResult result = couponServiceImpl.provideCoupon(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Test
	public void A_QUANDDEPRechargeServiceImpl() {
		MobileRechargeInfo info = BeanUtils
				.randomClass(MobileRechargeInfo.class);
		BaseResult result = rechargeServiceImpl.rechargeCMCC(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(rechargeServiceImpl.getClass().getName() + "对比失败",
				result);
	}

	@Resource
	StagingRequestService stagingRequestServiceImpl;
	@Resource
	PaymentService paymentServiceImpl;
	@Resource
	PointService pointServiceImpl;
	@Resource
	SMSService sMSServiceImpl;
	@Resource
	UserService userServiceImpl;
	@Resource
	CouponService couponServiceImpl;
	@Resource
	RechargeService rechargeServiceImpl;

}
