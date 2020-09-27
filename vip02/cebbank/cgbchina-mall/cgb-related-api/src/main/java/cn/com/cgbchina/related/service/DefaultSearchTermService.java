package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.DefaultSearchModel;
import cn.com.cgbchina.related.model.DefaultTerm;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

public interface DefaultSearchTermService {

	/**
	 * 添加默认搜索词
	 * 
	 * @param defaultSearchModel
	 * @return
	 */
	public Response<Boolean> create(DefaultSearchModel defaultSearchModel);

	/**
	 * 删除默认搜索词
	 * 
	 * @param defaultSearchModel
	 * @return
	 */
	public Response<Boolean> delete(DefaultSearchModel defaultSearchModel);

	/**
	 * 更新默认搜索词
	 * 
	 * @param id
	 * @param defaultSearchModel
	 * @return
	 */
	public Response<Boolean> update(String id, final DefaultSearchModel defaultSearchModel);

	/**
	 * 查询默认搜索词列表
	 *
	 * @param pageNo
	 * @param size
	 * @param name
	 * @return
	 */
	public Response<Pager<DefaultSearchModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("name") String name);

	public DefaultSearchModel findDefaultHeader();

	/**
	 * 搜索词名称校验
	 * 
	 * @param name
	 * @return
	 */
	public Response<Boolean> findNameByName(Long id, String name);
}
