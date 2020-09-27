package com.letv.account;

import java.util.Map;

import com.letv.common.LevpUtils;
import com.letv.common.Responseheader;

public class AccountRequest {

	/**
	 * 查询渠道乐视用户请求
	 * 
	 * @param util
	 * @param account
	 * @param token
	 * @return
	 * @throws Exception
	 */
	public AccountResponse GetAccount(LevpUtils util, String account,
			String token) throws Exception {
		AccountResponse rep = new AccountResponse();

		// 请求参数
		String QS = "account=" + account;
		// 获取时间戳
		String strtimestamp = util.GetTimestampStr();
		// 生成签名
		String Signature = util.getSignature(QS, "", strtimestamp);

		// 请求并返回结果
		String result = util.sendGet(Signature, strtimestamp, token, account);

		// 将返回的响应结果序列化成类
		Map<String, Object> map2 = (Map) com.Utilts.JsonUtil
				.JsonToObject(result);

		// 转换
		rep.header = (Responseheader) com.Utilts.JsonUtil.JsonToObject(
				map2.get("head"), Responseheader.class);

		rep.header.setResult(result);

		rep.body = (AccountResponseBody) com.Utilts.JsonUtil.JsonToObject(
				map2.get("body"), AccountResponseBody.class);

		return rep;

	}
}
