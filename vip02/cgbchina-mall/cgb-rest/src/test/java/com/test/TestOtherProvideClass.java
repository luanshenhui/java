package com.test;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.coupon.*;
import cn.com.cgbchina.rest.visit.model.payment.*;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQuery;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQueryResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSInfo;
import cn.com.cgbchina.rest.visit.model.user.*;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import java.math.BigDecimal;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context-real.xml")
@ActiveProfiles("dev")
@Slf4j
public class TestOtherProvideClass {

	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Test
	public void demo() {
		QueryCouponInfo info = BeanUtils.randomClass(QueryCouponInfo.class);
		QueryCouponInfoResult result = couponServiceImpl.queryCouponInfo(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void BP0005StagingRequestServiceImpl() {
		StagingRequest info = BeanUtils.randomClass(StagingRequest.class);
		StagingRequestResult result = stagingRequestServiceImpl.getStagingRequest(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(stagingRequestServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void BP1001StagingRequestServiceImpl() {
		WorkOrderQuery info = BeanUtils.randomClass(WorkOrderQuery.class);
		WorkOrderQueryResult result = stagingRequestServiceImpl.workOrderQuery(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(stagingRequestServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void NSCT002PaymentServiceImpl() {
		PaymentRequeryInfo info = BeanUtils.randomClass(PaymentRequeryInfo.class);
		PaymentRequeryResult result = paymentServiceImpl.paymentRequery(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void NSCT004PaymentServiceImpl() {
		Orderluck info = BeanUtils.randomClass(Orderluck.class);
		BaseResult result = paymentServiceImpl.luckPackReturn(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void NSCT016PaymentServiceImpl() {
		CCPointsPay info = BeanUtils.randomClass(CCPointsPay.class);
		BaseResult result = paymentServiceImpl.ccPointsPay(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void NSCT007PaymentServiceImpl() {
		ReqMoneyInfo info = BeanUtils.randomClass(ReqMoneyInfo.class);
		BaseResult result = paymentServiceImpl.reqMoney(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	/**
	 * 撤单测试类
	 */
	@Test
	public void NSCT018PaymentServiceImpl() {
		/***
		 *  积分 优惠券 无活动 实物
		 */
		ReturnGoodsInfo info = BeanUtils.randomClass(ReturnGoodsInfo.class);
		// 【商城提供部分】
		BigDecimal totalMoney = BigDecimal.ZERO.setScale(2);
		BigDecimal cashMoney = BigDecimal.valueOf(700).setScale(2);
		BigDecimal uitdrtamt = BigDecimal.valueOf(200).setScale(2);
		BigDecimal voucherPrice = BigDecimal.valueOf(100).setScale(2);
		totalMoney = cashMoney.add(uitdrtamt).add(voucherPrice);
		info.setTradeCode("");//活动类型
		info.setOrderId("201607180000045408");//子订单号
		info.setTradeMoney(totalMoney);//交易总金额
		info.setStagesNum("1");//分期期数
		info.setCategoryNo("1YT");//计费费率编号
		info.setChannel("mall");//渠道标识
		info.setIntegralMoney(uitdrtamt);//积分抵扣金额
		info.setOperId("huaxin");//操作员
		info.setOperTime("2016-08-03 20:21:56");//请款退货时间
		info.setOrderTime("2016-08-03 20:21:56");//订单生成时间
		info.setDiscountMoney(voucherPrice);//优惠金额
		info.setCashMoney(cashMoney);//现金支付金额
		info.setRefundType("01");//退款类型，01部分退款，不送或空值代表全额退款（积分场景）
		info.setPayee("");//退款接收方标识（o2o）
		info.setTradChannel("EBS");//交易渠道 EBS
		info.setTradSource("#SC");//交易来源 #SC
		info.setBizSight("00");//业务场景 00
		info.setOperatorId("");//非金融必填：若为业务操作，填写业务员ID，若为系统自动发起，填SYSTEM
		// 【外部接口提供部分】
		info.setMerId("");//商城商户号
		info.setOrderNbr("");//银行订单号
		info.setSorceSenderNo("");//源发起方流水
		info.setAcrdNo("");//支付账号
		info.setQsvendorNo("");//银联商户号
		BaseResult result = paymentServiceImpl.returnGoods(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void NSCT009PaymentServiceImpl() {
		ReturnPointsInfo info = BeanUtils.randomClass(ReturnPointsInfo.class);
		BaseResult result = paymentServiceImpl.returnPoint(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void NSCT010PaymentServiceImpl() {
		PointsMallReqMoneyInfo info = BeanUtils.randomClass(PointsMallReqMoneyInfo.class);
		BaseResult result = paymentServiceImpl.pointsMallReqMoney(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void NSCT012PaymentServiceImpl() {
		PointsMallReturnGoodsInfo info = BeanUtils.randomClass(PointsMallReturnGoodsInfo.class);
		BaseResult result = paymentServiceImpl.pointsMallReturnGoods(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void MMP011PaymentServiceImpl() {
		ChannelPayInfo info = BeanUtils.randomClass(ChannelPayInfo.class);
		ChannelPayResult result = paymentServiceImpl.channelPay(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void bms007PointServiceImpl() {
		PointTypeQuery info = BeanUtils.randomClass(PointTypeQuery.class);
		PointTypeQueryResult result = pointServiceImpl.queryPointType(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(pointServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void bms011PointServiceImpl() {
		QueryPointsInfo info = BeanUtils.randomClass(QueryPointsInfo.class);
		QueryPointResult result = pointServiceImpl.queryPoint(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(pointServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void SMS093SMSServiceImpl() {
		BatchSendSMSNotify info = BeanUtils.randomClass(BatchSendSMSNotify.class);
		BaseResult result = sMSServiceImpl.batchSMSNotify(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(sMSServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void SMS072FH00001ServiceImpl(){
		SendSMSInfo info = BeanUtils.randomClass(SendSMSInfo.class);
		info.setTemplateId("072FH00001");
		info.setSerial("20160803183735");
		info.setChannelCode("072");
		info.setSendBranch("010000");
		info.setMobile("mobilePhone");
		info.setTop("100");
		info.setTos("100");
		BaseResult result = sMSServiceImpl.sendSMS(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(sMSServiceImpl.getClass().getName() + "对比失败",result);
	}

	@Test
	public void SMS072FH00002ServiceImpl(){
		SendSMSInfo info = BeanUtils.randomClass(SendSMSInfo.class);
		info.setSmsId("FH");
		info.setTemplateId("072FH00002");
		info.setSerial("20160803183735");
		info.setChannelCode("072");
		info.setSendBranch("010000");
		info.setMobile("mobilePhone");
		info.setTop("100");
		info.setTos("100");
		BaseResult result = sMSServiceImpl.sendSMS(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(sMSServiceImpl.getClass().getName() + "对比失败",result);
	}

	@Test
	public void SMS072FH00003ServiceImpl(){
		SendSMSInfo info = BeanUtils.randomClass(SendSMSInfo.class);
		info.setSmsId("FH");
		info.setTemplateId("072FH00003");
		info.setSerial("20160803183735");
		info.setChannelCode("072");
		info.setSendBranch("010000");
		info.setMobile("mobilePhone");
		info.setAmountAll(99);
		info.setAmountsuc(99);
		BaseResult result = sMSServiceImpl.sendSMS(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(sMSServiceImpl.getClass().getName() + "对比失败",result);
	}

	@Test
	public void SMS072FH00013ServiceImpl(){
		SendSMSInfo info = BeanUtils.randomClass(SendSMSInfo.class);
		info.setSmsId("FH");
		info.setTemplateId("072FH00013");
		info.setSerial("20160803183735");
		info.setChannelCode("072");
		info.setSendBranch("010000");
		info.setMobile("mobilePhone");
		info.setProduct("100");
		info.setAmount("100");
		info.setReaccount("100");
		BaseResult result = sMSServiceImpl.sendSMS(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(sMSServiceImpl.getClass().getName() + "对比失败",result);
	}

	@Test
	public void EBOT01UserServiceImpl() {
		LoginInfo info = BeanUtils.randomClass(LoginInfo.class);
		LoginResult result = userServiceImpl.login(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void EBOT02UserServiceImpl() {
		RegisterInfo info = BeanUtils.randomClass(RegisterInfo.class);
		RegisterResult result = userServiceImpl.register(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void EBOT03UserServiceImpl() {
		MobileValidCode info = BeanUtils.randomClass(MobileValidCode.class);
		MobileValidCodeResult result = userServiceImpl.getMobileValidCode(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void EBOT04UserServiceImpl() {
		QueryUserInfo info = BeanUtils.randomClass(QueryUserInfo.class);
		UserInfo result = userServiceImpl.getCousrtomInfo(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void EBOT12UserServiceImpl() {
		ChannelPwdInfo info = BeanUtils.randomClass(ChannelPwdInfo.class);
		CheckChannelPwdResult result = userServiceImpl.checkChannelPwd(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(userServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void MA4000CouponServiceImpl() {
		QueryCouponInfo info = BeanUtils.randomClass(QueryCouponInfo.class);
		QueryCouponInfoResult result = couponServiceImpl.queryCouponInfo(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void MA4001CouponServiceImpl() {
		CouponProjectPage info = BeanUtils.randomClass(CouponProjectPage.class);
		QueryCouponProjectResult result = couponServiceImpl.queryCouponProject(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void MA1000CouponServiceImpl() {
		ActivateCouponInfo info = BeanUtils.randomClass(ActivateCouponInfo.class);
		ActivateCouponProjectResutl result = couponServiceImpl.activateCoupon(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	public void MA1001CouponServiceImpl() {
		ProvideCouponPage info = BeanUtils.randomClass(ProvideCouponPage.class);
		ProvideCouponResult result = couponServiceImpl.provideCoupon(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(couponServiceImpl.getClass().getName() + "对比失败", result);
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

}
