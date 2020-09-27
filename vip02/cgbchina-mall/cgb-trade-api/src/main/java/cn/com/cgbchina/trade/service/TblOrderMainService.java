/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import java.util.Date;
import java.util.List;

import cn.com.cgbchina.trade.model.OrderMainModel;

import com.spirit.common.model.Response;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/8/13.
 */
public interface TblOrderMainService {
	/**
	 * MAL105 CC积分商城订单列表查询接口 niufw
	 * 
	 * @param cardNo
	 * @param orderMainId
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<List<OrderMainModel>> findForCC(String cardNo, String orderMainId, Date startDate, Date endDate);

	/**
	 * MAL108 根据主订单号查询 niufw
	 * 
	 * @param orderMainId
	 * @return
	 */
	public Response<OrderMainModel> findByOrderMainId(String orderMainId);

	/**
	 * MAL501 接口
	 */
	public Response<Integer> insertTblOrderMain(OrderMainModel orderMainModel);

	/**
	 * MAL501 接口
	 */
	public Response<Integer> updateTblOrderMain(OrderMainModel orderMainModel);

	/**
	 * 更新投递方式信息
	 */
	public Response<Integer> updateOrderMainAddr(OrderMainModel orderMainModel);
}
