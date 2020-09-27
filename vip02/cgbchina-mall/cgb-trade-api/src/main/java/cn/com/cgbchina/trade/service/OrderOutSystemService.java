package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderOutSystemModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;

import com.spirit.common.model.Response;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by 11141021040453 on 16-4-25.
 */
public interface OrderOutSystemService {

	public Response<OrderOutSystemModel> findHanleTuiSongMsg(String subOrderNo) ;

	public Response<Integer> updateTuiSongMsg(OrderOutSystemModel orderOutSystemModel) ;

	public Response<Integer> insertOrderOutSystem(OrderOutSystemModel orderOutSystemModel);

	/**
	 * 存储大订单，小订单，订单历史（需事务控制）
	 */
	Response<Integer> saveWXVirtualOrders(OrderMainModel orderMain, OrderSubModel orderSubModel, OrderDoDetailModel orderDodetail,
									 boolean subFlag, Integer stock, OrderVirtualModel orderVirtualModel);
}
