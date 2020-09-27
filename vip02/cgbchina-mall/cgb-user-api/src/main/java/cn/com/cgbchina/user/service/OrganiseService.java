package cn.com.cgbchina.user.service;

import java.util.List;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.user.model.OrganiseModel;

/**
 * 机构管理 Created by 11140721050130 on 2016/5/8.
 */
public interface OrganiseService {

	/**
	 * 分页查询，机构列表
	 *
	 * @param pageNo 页码
	 * @param size 页数
	 * @param code
	 * @param sName
	 * @param level
	 * @return 结果对象
	 */
	public Response<Pager<OrganiseModel>> findByPager(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("code") String code, @Param("sName") String sName, @Param("level") String level);

	/**
	 * 根据code查询
	 *
	 * @param code 机构编码
	 * @return 机构信息
	 */
	public Response<OrganiseModel> findByCode(@Param("code") String code);

	/**
	 * 添加机构信息
	 *
	 * @param organiseModel 机构信息
	 * @return 创建结果
	 */
	public Response<Boolean> create(OrganiseModel organiseModel);

	/**
	 * 更新机构信息
	 *
	 * @param organiseModel 机构信息
	 * @return 更新结果
	 */
	public Response<Boolean> update(OrganiseModel organiseModel);

	/**
	 * 删除机构信息
	 *
	 * @return
	 */
	public Response<Boolean> delete(OrganiseModel organiseModel);

	/**
	 * 查询所有的机构信息
	 *
	 * @return 机构信息列表
	 */
	public Response<List<OrganiseModel>> findAll();

    /**
     * 根据机构简称，模糊查询所有的机构信息
     *
     * @return 机构信息列表
     * add by liuhan
     */
    public Response<List<String>> findBySimpleName(String simpleName);

}
