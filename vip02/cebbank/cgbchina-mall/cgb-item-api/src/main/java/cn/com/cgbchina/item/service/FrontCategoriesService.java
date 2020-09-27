package cn.com.cgbchina.item.service;

import java.util.List;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;

import cn.com.cgbchina.item.dto.CategoryMappingDto;
import cn.com.cgbchina.item.dto.FrontCategoryDto;
import cn.com.cgbchina.item.dto.FrontCategoryEditDto;
import cn.com.cgbchina.item.model.FrontCategory;

/**
 * Created by 郝文佳 on 2016/4/28.
 */
public interface FrontCategoriesService {
	/**
	 * 前台类目新建 返回新建成功后自增的主键ID
	 * 
	 * @param frontCategory
	 * @return
	 */
	Response<Long> create(FrontCategory frontCategory);
	/**
	 * 前台类目编辑
	 * 
	 * @param frontCategoryEditDto
	 * @return
	 */
	Response<Boolean> update(FrontCategoryEditDto frontCategoryEditDto);

	/**
	 * 通过id查单条前台类目
	 *
	 * @param id
	 * @return
	 */
	Response<FrontCategory> findById(Long id);

	/**
	 * 删除某条前台类目 后子节点不让删 已经挂载后台类目的不让删
	 * 
	 * @param id
	 * @return
	 */
	Response<Boolean> delete(Long id);

	/**
	 * 算出第几级
	 * 
	 * @param id
	 * @return
	 */
	Response<List<Long>> ancestorsOfNoCache(Long id);

	/**
	 * 查找子节点 不包含挂载的后台类目
	 * 
	 * @param id
	 * @return
	 */
	Response<List<FrontCategory>> findChildById(@Param("id") Long id);

	/**
	 * 查找子节点 包含挂载的后台类目
	 * 
	 * @param id
	 * @return
	 */
	Response<FrontCategoryDto> childrenWithMapping(Long id);

	/**
	 * 挂载后台类目
	 * 
	 * @param categoryMappingDtos
	 * @return
	 */

	Response<Boolean> addCategoryMapping(List<CategoryMappingDto> categoryMappingDtos);

	/**
	 * 删除挂载的后台类目
	 * 
	 * @param categoryMappingDto
	 * @return
	 */
	Response<Boolean> deleteBackMapping(CategoryMappingDto categoryMappingDto);

	/**
	 * 交换顺序
	 * 
	 * @param currentId
	 * @param changeId
	 * @return
	 */
	Response<Boolean> changeSord(Long currentId, Long changeId);

	/**
	 * 通过id集合查询前台类目集合
	 * @param ids
     * @return
     */
	public Response<List<FrontCategory>> findByIds(Iterable<String> ids);
}
