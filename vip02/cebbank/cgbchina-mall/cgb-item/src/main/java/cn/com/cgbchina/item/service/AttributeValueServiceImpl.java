package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.AttributeValueDao;
import cn.com.cgbchina.item.model.AttributeValue;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/4/25.
 */
@Service
@Slf4j
public class AttributeValueServiceImpl implements AttributeValueService {
	@Resource
	private AttributeValueDao attributeValueDao;

	/**
	 * 调此接口前数据校验
	 *
	 * @param attributeValue
	 * @return
	 */
	@Override
	public Response<AttributeValue> create(AttributeValue attributeValue) {
		Response<AttributeValue> response = new Response<AttributeValue>();
		if (attributeValue == null) {
			response.setError("attributeValue.notNull");
			return response;
		}
		if (StringUtils.isEmpty(attributeValue.getValue())) {
			response.setError("attributeValue.value.notNull");
			return response;
		}
		try {
			AttributeValue result = attributeValueDao.create(attributeValue);
			response.setResult(result);
		} catch (Exception e) {
			log.error("fail to create {},cause{}", attributeValue, Throwables.getStackTraceAsString(e));
			response.setError("attribute.value.create");
		}
		return response;
	}

	@Override
	public Response<AttributeValue> findById(Long id) {
		Response<AttributeValue> response = new Response<AttributeValue>();
		if (id == null) {
			response.setError("query.id.notNull");
			return response;
		}
		try {
			AttributeValue byId = attributeValueDao.findById(id);
			response.setResult(byId);
		} catch (Exception e) {
			log.error("fail to findById {},cause{}", id, Throwables.getStackTraceAsString(e));
			response.setError("attribute.value.findById");
		}

		return response;
	}

	/**
	 * @param list
	 * @return
	 */
	@Override
	public Response<List<AttributeValue>> findByIds(List<Long> list) {
		Response<List<AttributeValue>> response = new Response<List<AttributeValue>>();
		if (list == null || list.size() == 0) {
			response.setError("query.ids.notNull");
			return response;
		}
		try {
			List<AttributeValue> byIds = attributeValueDao.findByIds(list);
			response.setResult(byIds);
		} catch (Exception e) {
			log.error("fail to findByIds {},cause{}", list, Throwables.getStackTraceAsString(e));
			response.setError("attribute.value.findById");
		}

		return response;
	}
}
