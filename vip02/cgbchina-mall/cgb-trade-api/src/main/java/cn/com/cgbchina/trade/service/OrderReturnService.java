/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.trade.dto.RequestOrderDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderReturnTrackDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;

/**
 * 退货管理
 * 
 * @author 11150721040343
 * @version 1.0
 * @Since 2016/7/11
 */
public interface OrderReturnService {
	/**
	 * 分页查询所有退货
	 *
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<RequestOrderDto>> find(@Param("_USER_") User user, @Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("ordermainId") String ordermainId, @Param("orderId") String orderId,
			@Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("curStatusId") String curStatusId, @Param("goodsNm") String goodsNm,
			@Param("sourceId") String sourceId, @Param("orderType") String orderType);

	/**
	 * 根据orderId查询退货撤单履历表
	 * 
	 * @param orderId
	 * @return
	 */
	public Response<List<OrderReturnTrackDetailModel>> findReturnTrackByOrderId(String orderId);

	/**
	 * 供应商拒绝退货申请
	 * 
	 * @param orderSubModel
	 * @param orderReturnTrackDetailModelNew
	 * @param orderDoDetailModel
	 * @return
	 */
	public Response<Map<String, Object>> refuseReturn(OrderSubModel orderSubModel,
			OrderReturnTrackDetailModel orderReturnTrackDetailModelNew, OrderDoDetailModel orderDoDetailModel,
			User user);

	/**
	 * 供应商同意退货申请
	 * 
	 * @param paramMap
	 * @return
	 */
	public Response agreeReturn(Map<String, String> paramMap, User user);

}
