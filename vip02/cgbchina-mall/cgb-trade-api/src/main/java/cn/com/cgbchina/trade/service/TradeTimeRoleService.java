package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.DeadlineModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.List;

public interface TradeTimeRoleService {

	/**
	 * 更新交易期限
	 *
	 * @param deadlineModel
	 * @return
	 */
	public Response<Boolean> update(DeadlineModel deadlineModel);

	/**
	 * 查找交易期限
	 *
	 * @return
	 */
	/**
	 *
	 * @param pageNo
	 * @param size
	 * @param type
	 * @return
	 */
	public Response<Pager<DeadlineModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("type") String type);

}
