package com.letv.token;
import java.util.Map;
import java.util.UUID;

import com.letv.common.LevpUtils;
import com.letv.common.Responseheader;

public class TokenRequest {

	//全局参数以及公共方法
	LevpUtils levpUtils ;

	/**
	 * Token请求
	 *
	 * @LevpUtils utils
	 */
	public TokenResponse DoPost(LevpUtils utils) throws Exception {

		levpUtils = utils;
		TokenResponse rep = new TokenResponse();
		//请求并获取响应
		rep = GetToken(UUID.randomUUID().toString());

		return rep;

	}

	/**
	 * Token请求
	 *
	 * @random_string 随机32位字符串
	 */
	private  TokenResponse GetToken(String random_string) throws Exception
	{
		TokenResponse rep = new TokenResponse();
		//生成请求报文体
		String BS = "{\"random_string\":\""+random_string+"\"}";
		//获取时间戳
		String strtimestamp = levpUtils.GetTimestampStr();
		//生成签名
		String Signature = levpUtils.getSignature("",BS,strtimestamp);

		//请求并返回结果
		String result = levpUtils.sendPost("/backend-membership-charge/open/v1/token",""
				,Signature, strtimestamp,BS);
		//将返回的响应结果序列化成类
		Map<String, Object>  map2 = (Map) com.Utilts.JsonUtil.JsonToObject(result);
		rep.header =  (Responseheader) com.Utilts.JsonUtil.JsonToObject(map2.get("head"),
				Responseheader.class);
		rep.header.setResult(result);
		rep.body =   (TokenResponseBody) com.Utilts.JsonUtil.JsonToObject(map2.get("body"),
				TokenResponseBody.class);
		return rep;

	}
}
