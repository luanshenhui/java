package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.PointCollocation;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

/**
 * Created by yuxinxin on 16-4-14.
 */
public interface PointCollocationService {

	Response<Boolean> deleteAll(PointCollocation pointCollocation);

	/**
	 * 查找
	 *
	 * @return
	 */
	public Response<Pager<PointCollocation>> findAll(@Param("pageNo") Integer pageNo);

}
