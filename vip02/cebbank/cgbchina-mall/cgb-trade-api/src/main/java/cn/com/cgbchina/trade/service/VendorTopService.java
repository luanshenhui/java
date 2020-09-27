package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by 张成 on 16-4-26.
 */
public interface VendorTopService {
	/**
	 * 查找供应商热门收藏商品和热门交易商品
	 * 
	 * @return Map 两个list
	 */
	public Response<Map<String, Object>> find(@Param("_USER_") User user);

	/**
	 * 查找供应商本周订单量
	 * 
	 * @return Map
	 */
	public Response<Map<String, Object>> findOrderCountByWeek(@Param("_USER_") User user);

	/**
	 * 查找热销商品
	 * 
	 * @return
	 */
	public Response<List<Map<String, Object>>> findSellTop();
}
