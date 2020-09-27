package cn.com.cgbchina.restful.controller;

import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.SpringContextUtils;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProjectPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponPage;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPay;
import cn.com.cgbchina.rest.visit.model.payment.ChannelPayInfo;
import cn.com.cgbchina.rest.visit.model.payment.Orderluck;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryInfo;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.user.ChannelPwdInfo;
import cn.com.cgbchina.rest.visit.model.user.LoginInfo;
import cn.com.cgbchina.rest.visit.model.user.MobileValidCode;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.RegisterInfo;
import cn.com.cgbchina.restful.testEntity.EEA1XML;

/**
 * 测试调用接口
 * 
 * @author zjq
 * @version 2016年6月3日 上午10:11:00
 */
@Controller
@RequestMapping("/call")
public class CallServiceTest3Controller {

	public List<String> getMethods(String beanName) {
		List<String> methodsName = new ArrayList<String>();
		Object bean = SpringContextUtils.getBean(beanName);
		Method[] methods = bean.getClass().getMethods();
		for (Method method : methods) {
			methodsName.add(method.getName() + ":" + method.getParameterTypes()[0].getName());
		}
		return methodsName;
	}

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
		Class clazz = method.getParameterTypes()[0];// 参数类
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		Object param = jsonMapper.fromJson(value, clazz);
		Object result = method.invoke(bean, param);
		return result;
	}

	private String createBp0005Json() {
		// OPS受理
		StagingRequest obj = BeanUtils.randomClass(StagingRequest.class);

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestBP0005")
	@ResponseBody
	private String TestPayment() throws Exception {
		String callJson = createBp0005Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("stagingRequestServiceImpl", "getStagingRequest", callJson))
				+ "\n";
		sb.append("getStagingRequest " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createNSCT002Json() {
		// OPS受理
		PaymentRequeryInfo obj = BeanUtils.randomClass(PaymentRequeryInfo.class);

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestNSCT002")
	@ResponseBody
	private String testNSCT002() throws Exception {
		String callJson = createNSCT002Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("paymentServiceImpl", "paymentRequery", callJson)) + "\n";
		sb.append("TestNSCT002:paymentRequery " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createNSCT004Json() {
		Orderluck obj = new Orderluck();
		obj.setOrderId("2015080400105813");

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestNSCT004")
	@ResponseBody
	private String testNSCT004() throws Exception {
		String callJson = createNSCT004Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("paymentServiceImpl", "luckPackReturn", callJson)) + "\n";
		sb.append("TestNSCT004:luckPackReturn " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createNSCT016Json() {
		// OPS受理
		CCPointsPay obj = BeanUtils.randomClass(CCPointsPay.class);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestNSCT016")
	@ResponseBody
	private String testNSCT016() throws Exception {
		String callJson = createNSCT016Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("paymentServiceImpl", "ccPointsPay", callJson)) + "\n";
		sb.append("TestNSCT016:ccPointsPay " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	// 分期请款接口
	private String createNSCT007Json() {
		// OPS受理
		ReqMoneyInfo obj = BeanUtils.randomClass(ReqMoneyInfo.class);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestNSCT007")
	@ResponseBody
	private String testNSCT007() throws Exception {
		String callJson = createNSCT007Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("paymentServiceImpl", "reqMoney", callJson)) + "\n";
		sb.append("TestNSCT007:reqMoney " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	@RequestMapping("/TestNSCT018")
	@ResponseBody
	private String testNSCT018() throws Exception {
		String callJson = createNSCT018Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("paymentServiceImpl", "reqMoney", callJson)) + "\n";
		sb.append("TestNSCT018:returnGoods " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createNSCT018Json() {
		ReturnGoodsInfo obj = BeanUtils.randomClass(ReturnGoodsInfo.class);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestNSCT009")
	@ResponseBody
	private String testNSCT009() throws Exception {
		String callJson = createNSCT009Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("paymentServiceImpl", "returnPoint", callJson)) + "\n";
		sb.append("TestNSCT009:returnPoint " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createNSCT009Json() {
		ReturnPointsInfo obj = BeanUtils.randomClass(ReturnPointsInfo.class);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestNSCT010")
	@ResponseBody
	private String testNSCT010() throws Exception {
		String callJson = createNSCT010Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("paymentServiceImpl", "pointsMallReqMoney", callJson)) + "\n";
		sb.append("TestNSCT010:pointsMallReqMoney " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createNSCT010Json() {
		PointsMallReqMoneyInfo obj = BeanUtils.randomClass(PointsMallReqMoneyInfo.class);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestNSCT012")
	@ResponseBody
	private String testNSCT012() throws Exception {
		String callJson = createNSCT012Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("paymentServiceImpl", "pointsMallReturnGoods", callJson))
				+ "\n";
		sb.append("TestNSCT012:pointsMallReturnGoods " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createNSCT012Json() {
		PointsMallReturnGoodsInfo obj = BeanUtils.randomClass(PointsMallReturnGoodsInfo.class);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestMMP011")
	@ResponseBody
	private String testMMP011() throws Exception {
		String callJson = createMMP011() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("paymentServiceImpl", "channelPay", callJson)) + "\n";
		sb.append("TestMMP011:channelPay " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createMMP011() {
		ChannelPayInfo obj = BeanUtils.randomClass(ChannelPayInfo.class);
		obj.setTradeSeqNo("59689000000869635214");
		obj.setMerId("000199999999917");
		obj.setOrderId("201611180638545001");
		obj.setAccountNo("4392698541256326");
		obj.setCertNo("210204198603016986");
		obj.setCurType("CNY");
		obj.setValidDate("1820");
		obj.setIsMerger("0");
		obj.setChannelID("CCAG");
		obj.setTradeDate("20160604");
		obj.setTradeTime("145008");
		obj.setOrders("59689000000869635214|000199999999917|20161118063854500101|1.00|||0|0");
		obj.setTerminalCode("01");
		obj.setCvv2("");
		obj.setCertType("CNY");

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestEBOT01")
	@ResponseBody
	private String testEBOT01() throws Exception {
		String callJson = createEBOT01() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("userServiceImpl", "login", callJson)) + "\n";
		sb.append("TestEBOT01:login " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createEBOT01() {
		LoginInfo obj = BeanUtils.randomClass(LoginInfo.class);
		obj.setIsCreditCard((byte) 1);
		Byte type = '2';
		obj.setLogonType(type);
		obj.setLoginId("1");
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestEBOT02")
	@ResponseBody
	private String testEBOT02() throws Exception {
		String callJson = createEBOT02() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("userServiceImpl", "register", callJson)) + "\n";
		sb.append("TestEBOT02:register " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createEBOT02() {
		RegisterInfo obj = BeanUtils.randomClass(RegisterInfo.class);
		obj.setIsCreditCard("0".getBytes()[0]);
		obj.setCvv2Code(null);
		obj.setCvv2CodeFlag(null);
		obj.setCardValidPeriod(null);
		obj.setPinBlockFlag(null);
		obj.setValidDateFlag(null);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestEBOT03")
	@ResponseBody
	private String testEBOT03() throws Exception {
		String callJson = createEBOT03() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("userServiceImpl", "getMobileValidCode", callJson)) + "\n";
		sb.append("TestEBOT03:getMobileValidCode " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createEBOT03() {
		MobileValidCode obj = BeanUtils.randomClass(MobileValidCode.class);
		obj.setMobileNo("18624420153");
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestEBOT04")
	@ResponseBody
	private String testEBOT04() throws Exception {
		String callJson = createEBOT04() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("userServiceImpl", "getCousrtomInfo", callJson)) + "\n";
		sb.append("Test EBOT04:getCousrtomInfo " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createEBOT04() {
		QueryUserInfo obj = BeanUtils.randomClass(QueryUserInfo.class);
		obj.setCertNo(String.valueOf(BeanUtils.randomNum(20)));
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestEBOT12")
	@ResponseBody
	private String testEBOT12() throws Exception {
		String callJson = createEBOT12() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("userServiceImpl", "checkChannelPwd", callJson)) + "\n";
		sb.append("Test EBOT12:checkChannelPwd " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createEBOT12() {
		ChannelPwdInfo obj = BeanUtils.randomClass(ChannelPwdInfo.class);
		obj.setCertNo(String.valueOf(BeanUtils.randomNum(20)));
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestMA4000")
	@ResponseBody
	private String testMA4000() throws Exception {
		String callJson = createMA4000() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("couponServiceImpl", "queryCouponInfo", callJson)) + "\n";
		sb.append("TestMA4000:queryCouponInfo " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createMA4000() {
		QueryCouponInfo obj = new QueryCouponInfo();
		obj.setChannel("BC");
		obj.setQryType("01");
		obj.setRowsPage("10");
		obj.setCurrentPage("0");
		obj.setContIdCard("440100199009080456");
		obj.setProjectNO("100702");
		obj.setContIdType("01");
		byte s = 2;
		obj.setUseState(s);
		byte p = 1;
		obj.setPastDueState(p);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestSMS093")
	@ResponseBody
	private String testSMS093() throws Exception {
		String callJson = createSMS093() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("SMSServiceImpl", "batchSMSNotify", callJson)) + "\n";
		sb.append("TestSMS093:batchSMSNotify " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createSMS093() {
		BatchSendSMSNotify obj = BeanUtils.randomClass(BatchSendSMSNotify.class);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	private String createBMS007() {
		BatchSendSMSNotify obj = BeanUtils.randomClass(BatchSendSMSNotify.class);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestBMS007")
	@ResponseBody
	private String testBMS007() throws Exception {
		String callJson = createBMS007() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("pointServiceImpl", "queryPointType", callJson)) + "\n";
		sb.append("BMS007:queryPointType " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createBMS011() {
		QueryPointsInfo obj = BeanUtils.randomClass(QueryPointsInfo.class);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestBMS011")
	@ResponseBody
	private String testBMS011() throws Exception {
		String callJson = createBMS011() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("pointServiceImpl", "queryPoint", callJson)) + "\n";
		sb.append("BMS011:queryPoint " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createMA4001Json() {
		// OPS受理
		CouponProjectPage obj = new CouponProjectPage();
		obj.setChannel("BC");
		obj.setQryType("01");
		obj.setRowsPage("10");
		obj.setCurrentPage("0");
		obj.setContIdCard("440100199009080456");
		obj.setProjectNO("100702");
		obj.setContIdType("01");
		obj.setUseState((byte) 1);
		obj.setPastDueState((byte) 2);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestMA4001")
	@ResponseBody
	private String testMA4001() throws Exception {
		String callJson = createMA4001Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("couponServiceImpl", "queryCouponProject", callJson)) + "\n";
		sb.append("MA4001:queryCouponProject " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createMA1000Json() {
		// OPS受理
		ActivateCouponInfo obj = new ActivateCouponInfo();
		obj.setChannel("BC");
		obj.setContIdType("01");
		obj.setContIdCard("440100199009080456");
		obj.setActivation("20150508");
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestMA1000")
	@ResponseBody
	private String testMA1000() throws Exception {
		String callJson = createMA1000Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("couponServiceImpl", "activateCoupon", callJson)) + "\n";
		sb.append("MA1000:activateCoupon " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	private String createMA1001Json() {
		// OPS受理
		ProvideCouponPage obj = new ProvideCouponPage();
		obj.setChannel("BC");
		obj.setContIdType("01");
		obj.setContIdCard("440100199009080456");
		obj.setGrantType((byte) 1);
		obj.setProjectNO("1");
		obj.setNum(1);
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		String json = jsonMapper.toJson(obj);
		return json;
	}

	@RequestMapping("/TestMA1001")
	@ResponseBody
	private String testMA1001() throws Exception {
		String callJson = createMA1001Json() + "\n";

		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		StringBuilder sb = new StringBuilder();

		String resultJson = jsonMapper.toJson(callMethods("couponServiceImpl", "provideCoupon", callJson)) + "\n";
		sb.append("MA1001:provideCoupon " + callJson + resultJson + "\n");
		System.out.println(sb);
		return sb.toString();
	}

	@RequestMapping("/TestEEA1")
	@ResponseBody
	private String EEA1() {

		EEA1XML eea1 = new EEA1XML();
		eea1.setClientIPAddr("10.2.21.147");
		eea1.setPinBlock(
				"6AD70D58CE1C09CD98AF51D0612CC30B12CE561973B9EBE278CB248E12DE14267F773225E511CE1CBDCFFD4C83C40A63CB4003D3EA14935699F19676F05FB54B8049A7A94BA060BD976C67FCAAFE4D6750C20871D216EE9147CAAC27939469E97A4B2B4764FDA5A3AD800E2CD7772C0DA0D941DF01AA484B2DF5191AC02A82CC318DA7351207C38C656201B957052240EE46D173D88EC5B716969C4536017CF873FE0EC3684F6C7E124595602C61E99E70D9843047426508D5A05E980B6D984605274F6F0084A37D62F79CC12EEAD8479E3850AFEDD2F57DA99217A0A4A1196E98D7852EC957C7F60CF022FD5C9CF7E4227F3E23A35E397A38989E6092267183");

		eea1.setRandom("");

		// 得到转密后的密文
		eea1.getRequestXml();
		// SocketClient.send(xml, ip, port)
		// String res =SocketClient.send("<?xml version=\"1.0\"
		// encoding=\"GBK\"?> <union> <head> <serviceCode>0001</serviceCode>
		// <userID>0001</ serID > <transFlag>1</transFlag> </head> <body>
		// <data>test</data> </body> </union>", "10.2.37.244",8805);
		return "AA";
	}

	private String tradeCode() {
		SimpleDateFormat sdf = new SimpleDateFormat("");
		return sdf.format(new Date()) + "1000" + new Random().nextInt();
	}
}
