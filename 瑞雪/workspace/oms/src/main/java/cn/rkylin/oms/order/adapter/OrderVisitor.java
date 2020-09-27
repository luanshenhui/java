package cn.rkylin.oms.order.adapter;

import java.util.Date;
import java.util.Map;

/**
 * 订单代理，负责与具体的电商平台对接
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:14
 */
public abstract class OrderVisitor {



	public void finalize() throws Throwable {

	}

	/**
	 * 构造函数
	 */
	public OrderVisitor(){

	}

	/**
	 * 获取指定时间范围内的订单列表
	 * 
	 * @param startTime
	 * @param endTime
	 * @param paramMap
	 */
	public abstract int getOrderList(Date startTime, Date endTime, Map<String,String> paramMap);

	/**
	 * 获取1个订单
	 * 
	 * @param orderNumber
	 * @param paramMap
	 */
	public abstract int getOrder(String orderNumber, Map<String,String> paramMap);

	/**
	 * 保存平台订单
	 */
	protected abstract void saveOrder();

	protected int restVisit(){
		return 0;
	}

	protected int webserviceVisit(){
		return 0;
	}

	protected int rmiVisit(){
		return 0;
	}

}