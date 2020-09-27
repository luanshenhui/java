package cn.com.cgbchina.item.service;

//import com.spirit.Annotation.Param;

import java.util.List;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.item.dto.AttributeKeyDto;
import cn.com.cgbchina.item.model.AttributeKey;

/**
 * Created by 11150221040129 on 16-4-8.
 */
public interface AttributeKeyService {

	/**
	 * 查询
	 *
	 * @param pageNo
	 * @return
	 */
	public Response<Pager<AttributeKeyDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("attributeName") String attributeName);

	/**
	 * 添加
	 *
	 * @param model
	 * @return
	 */
	public Response<Boolean> create(AttributeKey model);

	/**
	 * 删除
	 *
	 * @param id
	 * @return
	 */
	Response<Boolean> delete(Long id);

	/**
	 *
	 * @param id
	 * @return
	 */
	Response<AttributeKey> findAttributeKeyById(Long id);

	/**
	 *
	 * @param name
	 * @return
	 */
	Response<AttributeKey> findAttributeByName(String name);

	/**
	 * 模糊查询
	 * 
	 * @param name
	 * @return
	 */
	Response<List<AttributeKeyDto>> fuzzyQuery(final String name);
}
