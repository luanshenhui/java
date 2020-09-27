package cn.rkylin.oms.order.adapter;

import java.util.ArrayList;
import java.util.Date;
import java.util.Map;

import cn.rkylin.oms.order.domain.Order;
import cn.rkylin.oms.order.domain.OrderStatusEnum;

/**
 * 阿里巴巴订单适配器
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:10
 */
public class AlibabaOrderAdapter extends OrderAdapter {



	public void finalize() throws Throwable {
		super.finalize();
	}

	public AlibabaOrderAdapter(){

	}

	@Override
	public ArrayList<Order> download(String shopId, Date dateTimeStart, Date dateTimeEnd,
			Map<String, String> paramMap) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int uploadStatus(Order order) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public OrderStatusEnum downloadStatus(Order order) {
		// TODO Auto-generated method stub
		return null;
	}

}