/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import java.util.Date;
import java.util.List;

import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;

import com.spirit.common.model.Response;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/8/13.
 */
public interface TblOrderMainHistoryService {
	/**
	 * MAL105 CC积分商城订单列表查询接口 niufw
	 * 
	 * @param cardNo
	 * @param orderMainId
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<List<TblOrdermainHistoryModel>> findForCC(String cardNo, String orderMainId, Date startDate,
			Date endDate);

	/**
	 * MAL108根据主订单号查询 niufw
	 * 
	 * @param orderMainId
	 * @return
	 */
	public Response<TblOrdermainHistoryModel> findByOrderMainId(String orderMainId);

	/**
	 * 更新投递方式信息
	 * @param ordermainHistoryModel
	 * @return
	 */
	public Response<Integer> updateOrderMainHistoryAddr(TblOrdermainHistoryModel ordermainHistoryModel);
}
