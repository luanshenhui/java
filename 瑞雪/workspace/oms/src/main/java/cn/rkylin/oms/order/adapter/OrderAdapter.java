package cn.rkylin.oms.order.adapter;

import java.util.ArrayList;
import java.util.Date;
import java.util.Map;

import cn.rkylin.oms.order.domain.Order;
import cn.rkylin.oms.order.domain.OrderStatusEnum;

/**
 * 订单适配器
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:14
 */
public abstract class OrderAdapter {

	private OrderVisitor orderDelegate;



	public void finalize() throws Throwable {

	}

	/**
	 * 构造函数
	 */
	public OrderAdapter(){

	}

	/**
	 * 下载平台订单
	 * @return ArrayList<Order> 返回订单列表
	 * 
	 * @param shopId    店铺id
	 * @param dateTimeStart    开始时间
	 * @param dateTimeEnd    结束时间
	 * @param paramMap    其它平台参数
	 */
	public abstract ArrayList<Order> download(String shopId, Date dateTimeStart, Date dateTimeEnd, Map<String,String> paramMap);

	/**
	 * 上传订单状态
	 * @return int 0:成功，1:失败
	 * 
	 * @param order
	 */
	public abstract int uploadStatus(Order order);

	/**
	 * 下载订单状态
	 * @return OrderStatusEnum 返回订单状态
	 * 
	 * @param order
	 */
	public abstract OrderStatusEnum downloadStatus(Order order);

	/**
	 * 保存系统订单
	 */
	private void saveOrder(){

	}

}