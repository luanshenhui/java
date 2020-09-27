package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.HotSearchTermModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.Map;

/**
 * Created by 11150721040343 on 16-4-8.
 */
public interface HotSearchService {
	/**
	 * 添加热搜关键词
	 * 
	 * @param hotSearchTermModel
	 * @return
	 */
	public Response<Integer> create(HotSearchTermModel hotSearchTermModel);

	/**
	 * 删除热搜关键词
	 * 
	 * @param hotSearchTermModel
	 * @return
	 */
	public Response<Integer> delete(HotSearchTermModel hotSearchTermModel);

	/**
	 * 更新热搜关键词
	 * 
	 * @param dataMap
	 * @return
	 */
	public Response<Integer> update(Map<String, Object> dataMap);

	/**
	 * 搜索热搜关键词
	 * 
	 * @param pageNo
	 * @return
	 */
	public Response<Pager<HotSearchTermModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("termName") String termName);

	/**
	 * 根据热搜词名称查询
	 * 
	 * @param name
	 * @return
	 */
	public Response<HotSearchTermModel> findByName(String name);

	/**
	 * 搜索商城热搜关键词和默认搜索词
	 * 
	 * @param
	 * @return
	 */
	public Response<Map<String, Object>> findHeader();
}
