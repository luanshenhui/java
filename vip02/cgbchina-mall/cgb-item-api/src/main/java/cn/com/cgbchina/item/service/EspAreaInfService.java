package cn.com.cgbchina.item.service;


import cn.com.cgbchina.item.model.EspAreaInfModel;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * 首页分区Service
 */
public interface EspAreaInfService {

	/**
	 * 查询分区信息
	 * @param paramaMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160728
	 */
	Response<List<EspAreaInfModel>> findAreaInfoByParams(Map<String,Object> paramaMap);

	/**
	 * 查询分区信息
	 * @param paramaMap
	 * @return
	 */
	public Response<EspAreaInfModel> findByAreaId(Map<String, Object> paramaMap);
}
