package cn.com.cgbchina.restful.testEntity;

import cn.com.cgbchina.rest.visit.model.order.ResendOrderInfo;

import com.spirit.util.JsonMapper;

public class OrderTest {
	JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	String mobile = "18675186626";

	public String getResendOrderInfoJson() {
		ResendOrderInfo info = new ResendOrderInfo();
		info.setMobile(mobile);
		info.setOrderNo("999");
		info.setSubOrderNo("123");
		info.setVendorName("SONY");
		String json = jsonMapper.toJson(info);
		return json;
	}
}
