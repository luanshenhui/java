package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.OrderReturnTrackDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;

/**
 * Created by yuxinxin on 16-4-30.
 */
public interface OrderReturnTrackService {
	/**
	 * 根据ID查询退货详情
	 *
	 * @return
	 */

	public Response<OrderReturnTrackDto> findById(@Param("partbackId") Long partbackId);
}
