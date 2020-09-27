package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.AttributeValue;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * Created by 郝文佳 on 2016/4/25.
 */
public interface AttributeValueService {
	/**
	 * 属性值添加
	 * 
	 * @param attributeValue
	 * @return
	 */
	Response<AttributeValue> create(AttributeValue attributeValue);

	/**
	 * 通过Id查询
	 * 
	 * @param id
	 * @return
	 */
	Response<AttributeValue> findById(Long id);

	/**
	 * 通过List列表查询属性值
	 * 
	 * @param list
	 * @return
	 */
	Response<List<AttributeValue>> findByIds(List<Long> list);

}
