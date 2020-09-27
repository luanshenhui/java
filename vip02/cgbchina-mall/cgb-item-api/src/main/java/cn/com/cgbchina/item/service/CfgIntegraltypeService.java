package cn.com.cgbchina.item.service;


import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * 积分类型Service
 *
 * geshuo 20160823
 */
public interface CfgIntegraltypeService {

	/**
	 * 查询积分类型
	 * @param id 积分类型id
	 * @return 查询结果
	 *
	 * geshuo 20160823
	 */
	Response<TblCfgIntegraltypeModel> findById(String id);

	/**
	 * 查询积分类型列表
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160823
	 */
	Response<List<TblCfgIntegraltypeModel>> findByParams(Map<String,Object> paramMap);
}
