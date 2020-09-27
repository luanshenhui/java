package com.letv.order;

import com.letv.common.Responseheader;

/**
 * 用于接收Order请求后返回响应结果的类
 */
public class OrderResponse {
	//响应结果中的head
	public Responseheader header = new Responseheader();
	//响应结果中的body
	public OrderResponseBody body = new OrderResponseBody();	
}
