package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.Merchandise;
import cn.com.cgbchina.trade.model.OrderInfo;

import com.google.common.collect.Lists;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by 11141021040453 on 16-4-15.
 */
public interface PointsOrderService {

	/**
	 * 查找
	 *
	 * @return
	 */
	public Response<Pager<OrderInfo>> find(@Param("pageNo") Integer pageNo);

	/**
	 * 查看订单详情
	 * 
	 * @param id
	 * @return
	 */
	public Response<OrderInfo> findOrderInfo(@Param("id") String id);

}
