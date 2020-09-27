/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package com.test.outinterface;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.google.common.collect.Lists;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.OrderBaseInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResult;
import cn.com.cgbchina.rest.visit.model.payment.ReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;

/**
 * @author yanjie.cao
 * @version 1.0
 * @Since 2016/8/3.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath*:spring/rest-service-context.xml",
		"classpath*:spring/rest-service-context-real.xml" })
public class paymentServiceTest {

	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Resource
	PaymentService paymentServiceImpl;

	@Test
	// 分期退货
	public void test_ReturnGoods_01() {
		ReturnGoodsInfo info = BeanUtils.randomClass(ReturnGoodsInfo.class);
		/**
		 * 无积分 无优惠券 无活动 O2O商品已过期操作
		 */
		info.setPayee("");
		info.setTradeCode("");
		// 【商城提供部分】
		info.setTradChannel("EBS");
		info.setTradSource("#SC");
		info.setBizSight("00");
		info.setOrderId("201406060068824501"); // 小订单号
		BigDecimal totalMoney = BigDecimal.valueOf(0); // 现金总金额
		info.setTradeMoney(totalMoney); // 交易总金额
		info.setStagesNum("1"); // 分期期数
		info.setCategoryNo("1YT"); // 计费费率编号
		info.setChannel("mall"); // 渠道标识
		info.setOperId("1234567890"); // 操作员
		info.setOperTime(DateHelper.getCurrentDate()); // 请款退货时间
		info.setOrderTime(DateHelper.getCurrentDate()); // 订单生成时间
		info.setCashMoney(totalMoney); // 现金支付金额
		info.setRefundType("01"); // 退款接收方标识

		// 【外部接口提供部分】
		info.setAcrdNo("6225551010295002"); // 支付账号 // TODO: 2016/8/3
		info.setMerId("003400034200378"); // 商城商户号 // TODO: 2016/8/3
		info.setOrderNbr("00000000000"); // 银行订单号 // TODO: 2016/8/3
		info.setQsvendorNo("306581098000114"); // 银联商户号 // TODO: 2016/8/3
		BaseResult result = paymentServiceImpl.returnGoods(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);

	}

	@Test
	// 分期退货
	public void test_ReturnGoods_02() {
		/***
		 * 荷兰拍 无积分 无优惠券 实物 1000原价900拍卖
		 */
		ReturnGoodsInfo info = BeanUtils.randomClass(ReturnGoodsInfo.class);
		// 【商城提供部分】
		info.setTradChannel("EBS");
		info.setTradSource("#SC");
		info.setBizSight("00");
		info.setTradeCode("08"); // 08荷兰式拍卖业务
		info.setOrderId("201608030000054902"); // 小订单号
		info.setTradeMoney(BigDecimal.valueOf(900).setScale(2)); // 交易总金额
		info.setStagesNum("1"); // 分期期数
		info.setCategoryNo("1YT"); // 计费费率编号
		info.setChannel("mall"); // 渠道标识
		info.setOperId("1234567890"); // 操作员
		info.setOperTime(DateHelper.getCurrentTime()); // 请款退货时间
		info.setOrderTime(DateHelper.getCurrentTime()); // 订单生成时间
		info.setDiscountMoney(BigDecimal.valueOf(100).setScale(2)); // 优惠金额
		info.setCashMoney(BigDecimal.valueOf(900).setScale(2)); // 现金支付金额

		// 【外部接口提供部分】
		// info.setQsvendorNo(); //银联商户号 // TODO: 2016/8/3
		// info.setOrderNbr(); //银行订单号 // TODO: 2016/8/3
		// info.setMerId(); //商城商户号 // TODO: 2016/8/3
		// info.setAcrdNo(); //支付账号 // TODO: 2016/8/3
		BaseResult result = paymentServiceImpl.returnGoods(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	// 分期退货
	public void test_ReturnGoods_03() {
		/***
		 * 折扣 无积分 无优惠券 O2O 九折
		 */
		ReturnGoodsInfo info = BeanUtils.randomClass(ReturnGoodsInfo.class);
		// 【商城提供部分】
		info.setTradChannel("EBS");
		info.setTradSource("#SC");
		info.setBizSight("00");
		info.setTradeCode("12"); // 12折扣
		info.setOrderId("201608030000054903"); // 小订单号
		info.setTradeMoney(BigDecimal.valueOf(900).setScale(2)); // 交易总金额
		info.setStagesNum("1"); // 分期期数
		info.setCategoryNo("1YT"); // 计费费率编号
		info.setChannel("mall"); // 渠道标识
		info.setOperId("1234567890"); // 操作员
		info.setOperTime(DateHelper.getCurrentTime()); // 请款退货时间
		info.setOrderTime(DateHelper.getCurrentTime()); // 订单生成时间
		info.setDiscountMoney(BigDecimal.valueOf(100).setScale(2)); // 优惠金额
		info.setCashMoney(BigDecimal.valueOf(900).setScale(2)); // 现金支付金额

		// 【外部接口提供部分】
		// info.setQsvendorNo(); //银联商户号 // TODO: 2016/8/3
		// info.setOrderNbr(); //银行订单号 // TODO: 2016/8/3
		// info.setMerId(); //商城商户号 // TODO: 2016/8/3
		// info.setAcrdNo(); //支付账号 // TODO: 2016/8/3
		BaseResult result = paymentServiceImpl.returnGoods(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	// 分期退货接口
	public void test_ReturnGoods_04() {
		/***
		 * 积分 优惠券 无活动 实物
		 */
		ReturnGoodsInfo info = BeanUtils.randomClass(ReturnGoodsInfo.class);
		// 【商城提供部分】
		info.setTradChannel("EBS");
		info.setTradSource("#SC");
		info.setBizSight("00");
		info.setOrderId("201608030000054904"); // 小订单号
		BigDecimal totalMoney = BigDecimal.ZERO.setScale(2);
		BigDecimal cashMoney = BigDecimal.valueOf(700).setScale(2);
		BigDecimal uitdrtamt = BigDecimal.valueOf(200).setScale(2);
		BigDecimal voucherPrice = BigDecimal.valueOf(100).setScale(2);
		totalMoney = cashMoney.add(uitdrtamt).add(voucherPrice);
		info.setTradeMoney(totalMoney); // 交易总金额
		info.setStagesNum("1"); // 分期期数
		info.setCategoryNo("1YT"); // 计费费率编号
		info.setChannel("mall"); // 渠道标识
		info.setIntegralMoney(uitdrtamt); // 积分抵扣金额
		info.setOperId("1234567890"); // 操作员
		info.setOperTime(DateHelper.getCurrentTime()); // 请款退货时间
		info.setOrderTime(DateHelper.getCurrentTime()); // 订单生成时间
		info.setCashMoney(cashMoney); // 现金支付金额

		// 【外部接口提供部分】
		// info.setQsvendorNo(); //银联商户号 // TODO: 2016/8/3
		// info.setOrderNbr(); //银行订单号 // TODO: 2016/8/3
		// info.setMerId(); //商城商户号 // TODO: 2016/8/3
		// info.setAcrdNo(); //支付账号 // TODO: 2016/8/3
		BaseResult result = paymentServiceImpl.returnGoods(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	/**
	 * 订单状态回查接口 nsct002 pass
	 */
	@Test
	public void test_paymentRequery_01() {
		PaymentRequeryInfo info = BeanUtils.randomClass(PaymentRequeryInfo.class);
		// 【商城提供部分】
		List<OrderBaseInfo> orderBaseInfos = Lists.newArrayList();
		OrderBaseInfo orderBaseInfo = new OrderBaseInfo();
		orderBaseInfo.setOrderId("90000006835935"); // 订单号
		orderBaseInfo.setPayDate(new Date()); // 支付日期
		orderBaseInfo.setMerId("000400004800082"); // 商户号(【外部接口提供部分】)
		orderBaseInfos.add(orderBaseInfo);
		orderBaseInfo = new OrderBaseInfo();
		orderBaseInfo.setOrderId("201205031434401"); // 订单号
		orderBaseInfo.setPayDate(new Date()); // 支付日期
		orderBaseInfo.setMerId("000400004800082"); // 商户号(【外部接口提供部分】)
		orderBaseInfos.add(orderBaseInfo);
		info.setOrderAmount("2"); // 订单数
		info.setRemark("31"); // 备注
		info.setOrderBaseInfos(orderBaseInfos); // 订单集合
		// 【外部接口提供部分】
		info.setTradeSeqNo("2016080423125160759033"); // 交易流水号

		PaymentRequeryResult result = paymentServiceImpl.paymentRequery(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	/**
	 * 分期请款接口 NTSC007
	 */
	@Test
	public void test_reqMoney_01() {
		ReqMoneyInfo info = BeanUtils.randomClass(ReqMoneyInfo.class);
		// 【商城提供部分】
		info.setOrderId("201406060068824501"); // 小订单号
		info.setOrderTime("20151214134036"); // 订单生成时间(14位的字符串)
		info.setOperTime("20151214142827"); // 请款退货时间(14位的字符串)
		info.setTradeMoney(new BigDecimal("241")); // 交易总金额
		info.setCashMoney(new BigDecimal("0")); // 现金支付金额
		info.setIntegralMoney(new BigDecimal("40")); // 积分抵扣金额
		info.setCategoryNo("LYYG"); // 计费费率编号
		info.setStagesNum("12"); // 分期期数
		info.setDiscountMoney(BigDecimal.ZERO); // 差额金额
		info.setTradeCode(""); // 交易类型
		// 【外部接口提供部分】
		info.setAcrdNo("6225551010295002"); // 支付账号
		info.setMerId("003400034200378"); // 商城商户号
		info.setQsvendorNo("306581098000114"); // 银联商户号
		info.setOrderNbr("00000000000"); // 银行订单号
		info.setBalancePayer("01");
		BaseResult result = paymentServiceImpl.reqMoney(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	/**
	 * 分期请款接口(荷兰拍)
	 */
	@Test
	public void test_reqMoney_02() {
		ReqMoneyInfo info = BeanUtils.randomClass(ReqMoneyInfo.class);
		// 【商城提供部分】
		info.setOrderId("201607080000023625"); // 小订单号
		info.setOrderTime("20160801121500"); // 订单生成时间
		info.setOperTime("20160730131849"); // 请款退货时间
		info.setTradeMoney(new BigDecimal("300")); // 交易总金额
		info.setCashMoney(new BigDecimal("200")); // 现金支付金额
		info.setIntegralMoney(new BigDecimal("100")); // 积分抵扣金额
		info.setCategoryNo("6HTY"); // 计费费率编号
		info.setStagesNum("1"); // 分期期数
		info.setDiscountMoney(new BigDecimal("100")); // 差额金额
		info.setTradeCode("08"); // 交易类型
		// 【外部接口提供部分】
		info.setAcrdNo(""); // 支付账号
		info.setMerId(""); // 商城商户号
		info.setQsvendorNo(""); // 银联商户号
		info.setOrderNbr(""); // 银行订单号

		BaseResult result = paymentServiceImpl.reqMoney(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}

	@Test
	// 分期退货
	public void test_NSCT009() {
		ReturnPointsInfo info = BeanUtils.randomClass(ReturnPointsInfo.class);
		info.setChannelID("MALL");
		info.setMerId("003400034200378");
		info.setOrderId("201411180638545001");
		info.setConsumeType("1");
		info.setCurrency("CNY");
		info.setTranDate("20160805");
		info.setTranTiem("162830");
		info.setTradeSeqNo("20160805162830122334");
		info.setSendDate("20150805");
		info.setSendTime("162830");
		info.setSerialNo("20160805162830122334");
		info.setCardNo("6225551010295002");
		info.setExpiryDate("0000");
		info.setPayMomey(BigDecimal.valueOf(0));
		info.setJgId("1");
		info.setDecrementAmt(1l);// 扣减积分额
		info.setTerminalNo("10");
		BaseResult result = paymentServiceImpl.returnPoint(info);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(paymentServiceImpl.getClass().getName() + "对比失败", result);
	}
}
