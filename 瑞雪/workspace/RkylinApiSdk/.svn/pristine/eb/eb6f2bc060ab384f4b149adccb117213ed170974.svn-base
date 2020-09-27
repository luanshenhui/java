package com.jdecard.gameapi;

import com.jdecard.common.JdEcardUtils;

public class ActionRequest {

	public ActionResponse DoPost(JdEcardUtils jdEcardUtils, String orderId,
			String orderStatus) throws Exception {

		String data = "{\"orderid\":\"" + orderId + "\",\"orderStatus\":\""
				+ orderStatus + "\"}";
		String customerid = jdEcardUtils.getCustomerId();
		String timestamp = jdEcardUtils.GetTimestampStr();
		String sign = jdEcardUtils.getSignature(customerid, data, timestamp,
				jdEcardUtils.getPrivateKey());
		String version = "";

		String result = jdEcardUtils.sendPost("gameApi.action", customerid,
				data, timestamp, sign, version);

		ActionResponse rep = new ActionResponse();
		rep = (ActionResponse) com.Utilts.JsonUtil.JsonToObject(result,
				ActionResponse.class);
		rep.setResult(result);

		return rep;

	}

}
