/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import java.util.Date;
import java.util.List;

import cn.com.cgbchina.trade.model.TblOrderMainBackupModel;

import com.spirit.common.model.Response;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/8/13.
 */
public interface TblOrderMainBackupService {
	/**
	 * MAL105 CC积分商城订单列表查询接口 niufw
	 * 
	 * @param cardNo
	 * @param orderMainId
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<List<TblOrderMainBackupModel>> findForCC(String cardNo, String orderMainId, Date startDate,
			Date endDate);

	/**
	 * MAL108 根据主订单号查询 niufw
	 * 
	 * @param orderMainId
	 * @return
	 */
	public Response<TblOrderMainBackupModel> findByOrderMainId(String orderMainId);
}
