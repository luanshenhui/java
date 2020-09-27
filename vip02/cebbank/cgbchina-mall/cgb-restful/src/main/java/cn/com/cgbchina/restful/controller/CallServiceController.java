package cn.com.cgbchina.restful.controller;

import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.cgbchina.rest.common.utils.SpringContextUtils;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPay;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPayBaseInfo;
import cn.com.cgbchina.rest.visit.model.payment.ChannelPayInfo;
import cn.com.cgbchina.rest.visit.model.payment.OrderBaseInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryInfo;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.restful.testEntity.CouponTestEntity;
import cn.com.cgbchina.restful.testEntity.SMSTestEntity;
import cn.com.cgbchina.restful.testEntity.StagingRequestTestEntity;

import com.spirit.util.JsonMapper;

/**
 * 测试调用接口
 * 
 * @author xiewl
 * @version 2016年5月25日 上午9:31:20
 */
@Controller
@RequestMapping("/call")
public class CallServiceController {

	@RequestMapping("/index")
	public String index() {
		return "index";
	}

	@RequestMapping("/getBeansName")
	@ResponseBody
	public List<String> getBeansName() {
		List<String> beansName = new ArrayList<String>();
		String[] beanDefinitionNames = SpringContextUtils.getApplicationContext().getBeanDefinitionNames();
		for (String name : beanDefinitionNames) {
			beansName.add(name);
		}
		return beansName;
	}

	@RequestMapping("/getMethods")
	@ResponseBody
	public List<String> getMethods(String beanName) {
		List<String> methodsName = new ArrayList<String>();
		Object bean = SpringContextUtils.getBean(beanName);
		Method[] methods = bean.getClass().getMethods();
		for (Method method : methods) {
			methodsName.add(method.getName() + ":" + method.getParameterTypes()[0].getName());
		}
		return methodsName;
	}

	@RequestMapping("/callMethod")
	@ResponseBody
	public Object callMethods(String beanName, String methodName, String value) throws Exception {
		System.out.println("cccc");
		Object bean = SpringContextUtils.getBean(beanName);
		System.out.println(beanName + " " + methodName);
		System.out.println(value);

		Method[] methods = bean.getClass().getMethods();
		Method method = null;
		for (Method m : methods) {
			if (m.getName().equals(methodName)) {
				method = m;
				break;
			}
		}
		Object result = null;
		if (method.getParameterTypes().length > 0) {
			Class clazz = method.getParameterTypes()[0];// 参数类
			JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
			Object param = jsonMapper.fromJson(value, clazz);
			result = method.invoke(bean, param);
		} else {
			result = method.invoke(bean);
		}
		return result;
	}

	@RequestMapping("/CreateJson1")
	@ResponseBody
	private String CreateJson1() {
		PaymentRequeryInfo a = new PaymentRequeryInfo();
		// a.setOrderBaseInfos(orderBaseInfos)
		a.setTradeSeqNo(tradeCode());
		a.setOrderAmount("1");
		OrderBaseInfo info = new OrderBaseInfo();
		List<OrderBaseInfo> infos = new ArrayList<OrderBaseInfo>();
		info.setMerId("ddd");
		info.setOrderId("1234");
		info.setPayDate(new Date());
		infos.add(info);
		a.setOrderBaseInfos(infos);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(a);
		return json;
	}

	@RequestMapping("/CreateJson2")
	@ResponseBody
	private String Creatajson2() {
		CCPointsPay cc = new CCPointsPay();
		cc.setTradeCode(tradeCode());
		cc.setOrderId("sss");
		cc.setAccountNo("123456789");
		cc.setCurType("156");
		cc.setValidDate("2112");
		cc.setMerId("ddd");
		cc.setIsMerger(0);
		cc.setTradeDate(new Date());
		cc.setTradeTime("23:59:59");
		cc.setChannelID("MALL");
		cc.setTradeCode("8200");
		cc.setEntryCard("sss");
		cc.setVirtualPrice("123");
		cc.setTradeDesc("deal");
		cc.setTerminalCode("02");

		List<CCPointsPayBaseInfo> ccPointsPayBaseInfos = new ArrayList<>();
		CCPointsPayBaseInfo info = new CCPointsPayBaseInfo();
		info.setFracAmount("999");
		info.setFracCardNo("123123");
		info.setFracType("001");
		info.setFracValidDate("20991231");
		ccPointsPayBaseInfos.add(info);
		cc.setCcPointsPayBaseInfos(ccPointsPayBaseInfos);
		cc.setAccountNo("AAAA");
		cc.setAmount("1");
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(cc);
		return json;
	}

	@RequestMapping("/CreateJson3")
	@ResponseBody
	private String Creatajson3() {
		ReqMoneyInfo info = new ReqMoneyInfo();
		info.setOrderId("3333");
		info.setOrderTime("20161111125959");
		info.setOperTime("20161112125959");
		info.setAcrdNo("12341234");
		info.setTradeMoney(new BigDecimal("999"));
		info.setCashMoney(new BigDecimal("111"));
		info.setIntegralMoney(new BigDecimal("111"));
		info.setMerId("123");
		info.setQsvendorNo("123");
		info.setCategoryNo("11");
		info.setOrderNbr("assdfd");
		info.setStagesNum("12");
		info.setDiscountMoney(new BigDecimal("22"));
		info.setTradeCode("01");
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(info);
		return json;
	}

	@RequestMapping("/CreateJson4")
	@ResponseBody
	private String Creatajson4() {
		ReturnGoodsInfo info = new ReturnGoodsInfo();
		info.setOrderId("999");
		info.setOrderTime("20121212235959");
		info.setOperTime("20121212235959");
		info.setAcrdNo("123451233");
		info.setTradeMoney(new BigDecimal("999"));
		info.setCashMoney(new BigDecimal("111"));
		info.setIntegralMoney(new BigDecimal("111"));
		info.setMerId("sssss");
		info.setQsvendorNo("ssssdd");
		info.setCategoryNo("sss");
		info.setOrderNbr("ssss");
		info.setStagesNum("12");
		info.setOperId("22");
		info.setDiscountMoney(new BigDecimal("111"));

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(info);
		return json;
	}

	@RequestMapping("/CreateJson5")
	@ResponseBody
	private String Creatajson5() {
		BigDecimal tmp = new BigDecimal("111");
		ReturnPointsInfo info = new ReturnPointsInfo();
		info.setOrderId("999");
		info.setMerId("sssss");
		info.setConsumeType("1");
		info.setCurrency("CNY");
		info.setTranDate("20121225");
		info.setTranTiem("125959");
		info.setSerialNo("2313226556");
		info.setCardNo("1234123123");
		info.setExpiryDate("0000");
		info.setPayMomey(tmp);
		info.setJgId("001");
		info.setDecrementAmt(1000L);
		info.setTerminalNo("01");
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(info);
		return json;
	}

	@RequestMapping("/CreateJson6")
	@ResponseBody
	private String Creatajson6() {
		BigDecimal tmp = new BigDecimal("111");
		PointsMallReqMoneyInfo info = new PointsMallReqMoneyInfo();
		info.setOrderId("999");
		info.setMerId("sssss");
		info.setOrderNumber("1111");
		info.setOrderTime(new Date());
		info.setOperTime(new Date());
		info.setAcrdNo("1233121221123");
		info.setTradeMoney(tmp);
		info.setCashMoney(tmp);
		info.setIntegralMoney(tmp);
		info.setMerId("aaaa");
		info.setMERNO("aaa");
		info.setQsvendorNo("ccc");
		info.setOrderNbr("ddd");
		info.setStagesNum("12");
		info.setOperId("dd");
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(info);
		return json;
	}

	@RequestMapping("/CreateJson7")
	@ResponseBody
	private String Creatajson7() {
		BigDecimal tmp = new BigDecimal("111");
		PointsMallReturnGoodsInfo info = new PointsMallReturnGoodsInfo();
		info.setOrderId("999");
		info.setMerId("sssss");
		info.setOrderNumber("1111");
		info.setOrderTime(new Date());
		info.setOperTime(new Date());
		info.setAcrdNo("1233121221123");
		info.setTradeMoney(tmp);
		info.setCashMoney(tmp);
		info.setIntegralMoney(tmp);
		info.setMerId("aaaa");
		info.setMERNO("aaa");
		info.setQsvendorNo("ccc");
		info.setOrderNbr("ddd");
		info.setStagesNum("12");
		info.setOperId("dd");
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(info);
		return json;
	}

	@RequestMapping("/CreateJson8")
	@ResponseBody
	private String Creatajson8() {
		BigDecimal tmp = new BigDecimal("111");
		ChannelPayInfo info = new ChannelPayInfo();
		info.setOrderId("999");
		info.setMerId("sssss");
		info.setTradeSeqNo(tradeCode());
		info.setAccountNo("11111111111");
		info.setCertType("123");
		info.setCertNo("123");
		info.setCurType("156");
		info.setValidDate("1212");
		info.setIsMerger("0");
		info.setTradeDate("20160101");
		info.setTradeTime("125959");
		info.setOrders("1231231231");
		info.setTerminalCode("01");
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(info);
		return json;
	}

	@RequestMapping("/TestPayment")
	@ResponseBody
	private String TestPayment() throws Exception {
		String t1 = CreateJson1() + "\n";
		String t2 = "11111" + "\n";
		String t3 = Creatajson2() + "\n";
		String t4 = Creatajson3() + "\n";
		String t5 = Creatajson4() + "\n";
		String t6 = Creatajson5() + "\n";
		String t7 = Creatajson6() + "\n";
		String t8 = Creatajson8() + "\n";
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String r1 = jsonMapper.toJson(callMethods("paymentServiceImpl", "paymentRequery", t1)) + "\n";
		String r2 = jsonMapper.toJson(callMethods("paymentServiceImpl", "luckPackReturn", t2)) + "\n";
		String r3 = jsonMapper.toJson(callMethods("paymentServiceImpl", "ccPointsPay", t3)) + "\n";
		String r4 = jsonMapper.toJson(callMethods("paymentServiceImpl", "reqMoney", t4)) + "\n";
		String r5 = jsonMapper.toJson(callMethods("paymentServiceImpl", "returnGoods", t5)) + "\n";

		String r6 = jsonMapper.toJson(callMethods("paymentServiceImpl", "returnPoint", t6)) + "\n";
		String r7 = jsonMapper.toJson(callMethods("paymentServiceImpl", "pointsMallReqMoney", t7)) + "\n";
		String r8 = jsonMapper.toJson(callMethods("paymentServiceImpl", "channelPay", t8)) + "\n";
		sb.append("paymentRequery " + t1 + r1 + "\n");
		sb.append("luckPackReturn " + t2 + r2 + "\n");
		sb.append("ccPointsPay " + t3 + r3 + "\n");
		sb.append("reqMoney " + t4 + r4 + "\n");
		sb.append("returnGoods " + t5 + r5 + "\n");
		sb.append("returnPoint" + t6 + r6 + "\n");
		sb.append("pointsMallReqMoney" + t7 + r7 + "\n");
		sb.append("channelPay" + t8 + r8 + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	@RequestMapping("/TestCoupon")
	@ResponseBody
	private String TestCoupon() throws Exception {
		CouponTestEntity ccte = new CouponTestEntity();
		String t1 = ccte.QueryCouponInfoJson() + "\n";
		String t2 = ccte.CouponProjectPageJson() + "\n";
		String t3 = ccte.ActivateCouponInfoJson() + "\n";
		String t4 = ccte.ProvideCouponPageJson() + "\n";
		String servicename = "couponServiceImpl";
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();
		try {
			String r1 = jsonMapper.toJson(callMethods(servicename, "queryCouponInfo", t1)) + "\n";
			sb.append("queryCouponInfo " + t1 + r1 + "\n");
		} catch (RuntimeException ex) {
			ex.printStackTrace();
		}
		try {
			String r2 = jsonMapper.toJson(callMethods(servicename, "queryCouponProject", t2)) + "\n";
			sb.append("queryCouponProject " + t2 + r2 + "\n");
		} catch (RuntimeException ex) {
			ex.printStackTrace();
		}
		try {
			String r3 = jsonMapper.toJson(callMethods(servicename, "activateCoupon", t3)) + "\n";
			sb.append("activateCoupon " + t3 + r3 + "\n");
		} catch (RuntimeException ex) {
			ex.printStackTrace();
		}
		try {
			String r4 = jsonMapper.toJson(callMethods(servicename, "provideCoupon", t4)) + "\n";
			sb.append("provideCoupon " + t4 + r4 + "\n");
		} catch (RuntimeException ex) {
			ex.printStackTrace();
		}
		System.out.println(sb);
		return sb.toString();
	}

	@RequestMapping("/TestStagingRequest")
	@ResponseBody
	private String TestStagingRequest() throws Exception {
		StagingRequestTestEntity srte = new StagingRequestTestEntity();
		String t1 = srte.StagingRequestJson() + "\n";

		String t2 = srte.WorkOrderQueryJson() + "\n";
		StringBuilder sb = new StringBuilder();
		String servicename = "stagingRequestServiceImpl";
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String r1 = jsonMapper.toJson(callMethods(servicename, "getStagingRequest", t1)) + "\n";
		String r2 = jsonMapper.toJson(callMethods(servicename, "workOrderQuery", t2)) + "\n";

		sb.append("getStagingRequest " + t1 + r1 + "\n");
		sb.append("workOrderQuery " + t2 + r2 + "\n");

		System.out.println(sb);
		return sb.toString();
	}

	@RequestMapping("/Testsms")
	@ResponseBody
	private String Testsms() throws Exception {
		SMSTestEntity smste = new SMSTestEntity();
		String t1 = smste.getBatchSendSMSNotifyJson() + "\n";

		String t2 = smste.getSendSMSInfoJson() + "\n";
		StringBuilder sb = new StringBuilder();
		String servicename = "SMSServiceImpl";
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String r1 = jsonMapper.toJson(callMethods(servicename, "batchSMSNotify", t1)) + "\n";
		String r2 = jsonMapper.toJson(callMethods(servicename, "sendSMS", t2)) + "\n";

		sb.append("batchSMSNotify " + t1 + r1 + "\n");
		sb.append("sendSMS " + t2 + r2 + "\n");

		System.out.println(sb);
		return sb.toString();
	}

	private String tradeCode() {
		SimpleDateFormat sdf = new SimpleDateFormat("");
		return sdf.format(new Date()) + "1000" + new Random().nextInt();
	}
}
