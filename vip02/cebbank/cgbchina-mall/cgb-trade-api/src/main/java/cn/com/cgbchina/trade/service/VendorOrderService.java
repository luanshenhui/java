package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.OrderSubModel;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by 张成 on 16-4-26.
 */
public interface VendorOrderService {
	/**
	 * 查找供应商各种状态的订单数
	 * 
	 * @return 各种订单的个数
	 */
	public Response<OrderSubModel> find(@Param("_USER_") User user);

}
