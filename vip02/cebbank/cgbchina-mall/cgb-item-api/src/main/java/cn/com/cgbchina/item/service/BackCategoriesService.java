package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.AttributeDto;
import cn.com.cgbchina.item.dto.AttributeTransDto;
import cn.com.cgbchina.item.dto.BackCategoryDto;
import cn.com.cgbchina.item.dto.BackCategoryEditDto;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.CategoryNode;
import com.spirit.common.model.Response;

import java.util.Collection;
import java.util.List;

/**
 * Created by 11150221040129 on 16-4-8.
 */
public interface BackCategoriesService {

	/**
	 * 新增后台类目
	 * 
	 * @param backCategory
	 * @return
	 */
	public Response<Long> create(BackCategory backCategory);

	/**
	 * 编辑后台类目
	 * 
	 * @param backCategoryEditDto
	 * @return
	 */
	public Response<Boolean> update(BackCategoryEditDto backCategoryEditDto);

	/**
	 * 查询当前节点的层级 返回的集合长度就是层级 其中集合的内容是当前节点及其所有父节点的ID
	 * 
	 * @param id
	 * @return
	 */
	public Response<List<Long>> ancestorsOfNoCache(Long id);

	/**
	 * 通过id查后台类目
	 * 
	 * @param id
	 * @return
	 */
	public Response<BackCategory> findById(Long id);

	/**
	 * 显示根节点的初始数据
	 *
	 * @return
	 */
	Response<List<BackCategory>> rootNode();

	/**
	 * 通过id查找子节点 使用当前的level层级用于返回前台时的显示使用
	 *
	 * @param id
	 * @param currentLevel
	 * @return
	 */
	Response<List<CategoryNode<BackCategory>>> findChildById(Long id, Integer currentLevel);

	/**
	 * 删除 有前台类目绑定的不让删
	 * 
	 * @param id
	 * @return
	 */
	Response<Boolean> delete(Long id);

	/**
	 * 通过id集合查询后台类目
	 *
	 * @param list
	 * @return
	 */
	Response<List<BackCategory>> findByIds(List<Long> list);

	/**
	 * 通过id查询子类目及当前类目和父类目过挂载的属性
	 * 
	 * @param id
	 * @return
	 */
	Response<BackCategoryDto> findChildWithAttribute(Long id);

	/**
	 * 添加属性
	 *
	 * @param categoryId
	 * @param attributeTransDto
	 * @return
	 */
	Response<Boolean> addAttribute(Long categoryId, AttributeTransDto attributeTransDto);

	/**
	 * 通过id查询子类目的信息 不带属性值
	 * 
	 * @param parentId
	 * @return
	 */

	Response<List<BackCategory>> withoutAttribute(Long parentId);

	/**
	 * 删除当前类目下挂载的某一个属性
	 * 
	 * @param categoryId
	 * @param attributeId
	 * @param type
	 * @return
	 */

	Response<Boolean> deleteAttribute(Long categoryId, Long attributeId, Integer type);

	/**
	 * 棒极当前类目下的某一个属性 只有销售属性与产品属性之间的变更
	 * 
	 * @param categoryId
	 * @param attributeId
	 * @param oldType
	 * @param newType
	 * @return
	 */
	Response<Boolean> editAttribute(Long categoryId, Long attributeId, Integer oldType, Integer newType);

	/**
	 * 判断当前类目是否有子类目
	 * 
	 * @param categoryId
	 * @return
	 */
	Response<Boolean> isParent(Long categoryId);

	/**
	 * 通过类目id查询当前类目的属性
	 * 
	 * @param id
	 * @return
	 */
	Response<AttributeDto> getAttributeById(Long id);

	/**
	 * 返回所有后台类目 平行结构 用于ztree渲染接口
	 * 
	 * @return
	 */
	public Response<List<BackCategory>> allSimpleData();

	/**
	 * 改变后台类目的计数器  goodCount  商品或产品在添加的时候 要调用此方法吧挂载的后台类目的第三极类目的count值加1  step
	 * 传入1    删除的时候 step传入-1  跟属性不是一个计数器
	 * @param backcategoryId
	 * @param step
     * @return
     */
	public Response<Boolean> changeCount(Long backcategoryId, Long step);
}
