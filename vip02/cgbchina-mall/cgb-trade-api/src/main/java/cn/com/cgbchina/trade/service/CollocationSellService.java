package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.CollocationSell;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

/**
 * Created by 张成 on 16-4-11.
 */
public interface CollocationSellService {

	/**
	 * 查找
	 *
	 * @return
	 */
	public Response<Pager<CollocationSell>> findCollocationAll(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size);

	/**
	 * 删除
	 *
	 * @param collocationSell
	 * @return
	 */
	public Response<Boolean> delete(CollocationSell collocationSell);

}
