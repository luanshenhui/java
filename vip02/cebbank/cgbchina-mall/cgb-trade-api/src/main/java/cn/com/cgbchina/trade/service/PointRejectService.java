package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.PointReject;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

/**
 * Created by yuxinxin on 16-4-15.
 */
public interface PointRejectService {

	/**
	 * 根据订单ID查询退货详情
	 *
	 * @return
	 */
	Response<Pager<PointReject>> findRejectDetail();
}
