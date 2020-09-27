package cn.com.cgbchina.trade.service;

import java.util.List;

import cn.com.cgbchina.trade.dto.OrderPartBackDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.trade.model.OrderSubModel;

/**
 * Created by yuxinxin on 16-4-29.
 */

public interface OrderPartBackService {

	/**
	 * 更新撤单审核状态
	 *
	 * @param orderSubModel
	 * @return
	 */
	Response<Boolean> updateRevocation(OrderSubModel orderSubModel, String memo, String memoExt);

	/**
	 * 供应商撤单 新更改后的撤单查询
	 * 
	 * @param pageNo
	 * @param size
	 * @param startTime
	 * @param endTime
	 * @param orderId
	 * @param sourceId
	 * @param ordertypeId
	 * @param ordermainId
	 * @return
	 */

	public Response<Pager<OrderPartBackDto>> findRevocationAll(@Param("_USER_") User user, @Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("orderId") String orderId, @Param("sourceId") String sourceId,
			@Param("ordertypeId") String ordertypeId, @Param("ordermainId") String ordermainId);

	/**
	 * 批量撤单
	 *
	 * @param updateAll
	 * @return
	 */
	public Response<Integer> updateAllRevocation(User user,List<String> updateAll, String memo,String memoExt);


}
