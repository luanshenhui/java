package com.letv.order;

import java.util.Map;

import com.letv.common.LevpUtils;
import com.letv.common.Responseheader;


public class OrderRequest {

	String token;
	LevpUtils levpUtils;

	/*
	 * Order请求
	 *
	 */
	public OrderResponse DoPost(LevpUtils utils,String token,
								String open_id ,String channel_order_id ,String channel_order_amount ,String months,String type
	) throws Exception {

		this.token = token;
		levpUtils = utils;
		OrderResponse rep = new OrderResponse();
		rep = GenOrder(open_id ,channel_order_id ,channel_order_amount ,months,type);

		return rep;

	}

	/*
	 * Order请求
	 *
	 */
	private OrderResponse GenOrder(String open_id ,String channel_order_id ,String channel_order_amount ,String months,String type) throws Exception {

		OrderResponse rep = new OrderResponse();
		//生成请求报文体
		String BS = "{\"open_id\":\""+open_id+"\",\"channel_order_id\":\""+channel_order_id+"\",\"channel_order_amount\":\""+channel_order_amount+"\",\"months\":\""+months+"\",\"type\":\""+type+"\"}";
		//获取时间戳
		String strtimestamp = levpUtils.GetTimestampStr();
		//生成签名
		String Signature = levpUtils.getSignature("", BS, strtimestamp);

		// 请求并返回结果
		String result = levpUtils.sendPost(
				"/backend-membership-charge/open/v1/membership/order",this.token, Signature,
				strtimestamp, BS);
		//将返回的响应结果序列化成类
		Map<String, Object> map2 = (Map) com.Utilts.JsonUtil.JsonToObject(result);
		rep.header = (Responseheader) com.Utilts.JsonUtil.JsonToObject(
				map2.get("head"), Responseheader.class);
		rep.header.setResult(result);
		rep.body = (OrderResponseBody) com.Utilts.JsonUtil.JsonToObject(
				map2.get("body"), OrderResponseBody.class);

		if(rep.body !=null)
		{
			//转换创建日期格式
			rep.body.setCreate_time_YYYYMMDDHHmmss(levpUtils.TimeStamp2Date(rep.body.getCreate_time(),"yyyy-MM-dd HH:mm:ss"));
		}

		return rep;

	}
}
