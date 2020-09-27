package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.AttributeKeyDao;
import cn.com.cgbchina.item.dto.AttributeKeyDto;
import cn.com.cgbchina.item.model.AttributeKey;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by 11150221040129 on 16-4-8.
 */
@Service
@Slf4j
public class AttributeKeyServiceImpl implements AttributeKeyService {
	@Resource
	private AttributeKeyDao attributeKeyDao;

	/**
	 * 通过名字模糊查询
	 *
	 * @param name
	 * @return
	 */
	@Override
	public Response<List<AttributeKeyDto>> fuzzyQuery(final String name) {
		Response<List<AttributeKeyDto>> response = new Response<List<AttributeKeyDto>>();
		try {
			List<AttributeKey> list = attributeKeyDao.fuzzyQuery(name);

			// 声明一个转换规则 泛型第一个参数接受源类型，第二个参数为目标类型
			Function<AttributeKey, AttributeKeyDto> function = new Function<AttributeKey, AttributeKeyDto>() {
				@Override
				public AttributeKeyDto apply(AttributeKey input) {
					AttributeKeyDto attributeKeyDto = new AttributeKeyDto();
					BeanMapper.copy(input, attributeKeyDto);
					return attributeKeyDto;
				}
			};
			List<AttributeKeyDto> transform = Lists.transform(list, function);

			response.setResult(new ArrayList<AttributeKeyDto>(transform));
		} catch (Exception e) {
			log.error("failed to findAttributeKeyByName name={};cause by{}", name, Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;

	}

	/**
	 * 查询
	 *
	 * @param pageNo
	 * @return
	 */
	@Override
	public Response<Pager<AttributeKeyDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("attributeName") String attributeName) {
		Response<Pager<AttributeKeyDto>> result = new Response<Pager<AttributeKeyDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Response<Pager<AttributeKey>> daoResult = null;
		try {
			daoResult = attributeKeyDao.pagination(pageInfo, attributeName);
		} catch (Exception e) {
			log.error("attribute.find.error attributeName={}", attributeName, Throwables.getStackTraceAsString(e));
			result.setError("attribute.find.error");
			return result;

		}
		// 对这个集合处理将model对象中的所有字段都变成String类型写给前台，注意到目前为止 Long Integer 的0 在json的时候会丢失 为回避此
		// 情况，故转换成String 不要使用基本类型的int 和long等 其他类型的Date等根据需要转换dto对象需要实现序列化接口
		List<AttributeKey> data = daoResult.getResult().getData();
		// 声明一个转换规则 泛型第一个参数接受源类型，第二个参数为目标类型
		Function<AttributeKey, AttributeKeyDto> function = new Function<AttributeKey, AttributeKeyDto>() {
			@Nullable
			@Override
			public AttributeKeyDto apply(@Nullable AttributeKey input) {
				AttributeKeyDto attributeKeyDto = new AttributeKeyDto();
				BeanMapper.copy(input, attributeKeyDto);
				return attributeKeyDto;
			}
		};
		// 转换集合
		Collection<AttributeKeyDto> transform = Collections2.transform(data, function);
		ArrayList<AttributeKeyDto> list = Lists.newArrayList(transform);
		Pager<AttributeKeyDto> pager = new Pager<>(daoResult.getResult().getTotal(), list);
		result.setResult(pager);
		return result;
	}

	/**
	 * 添加
	 *
	 * @param attributeKey
	 * @return
	 */
	@Override
	public Response<Boolean> create(AttributeKey attributeKey) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			attributeKeyDao.create(attributeKey);

		} catch (IllegalArgumentException e) {
			log.error(e.getMessage() + "para={},cause by{}", attributeKey, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("attribute.create.error key={},cause by {}", attributeKey, Throwables.getStackTraceAsString(e));
			response.setError("attribute.create.error");
			return response;
		}
		response.setResult(Boolean.TRUE);

		return response;
	}

	/**
	 * 删除 有类目挂钩的话不让删除
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> delete(Long id) {
		Response<Boolean> response = new Response<Boolean>();

		try {
			AttributeKey attributeKeyById = attributeKeyDao.findAttributeKeyById(id);

			if (null == attributeKeyById) {
				response.setResult(false);
				response.setError("attribute.del.unuseful");
				return response;
			}
			// 有后台类目挂载的时候不允许删除
			if (attributeKeyById.getCount() != null && attributeKeyById.getCount() > 0L) {
				response.setResult(false);
				response.setError("attribute.category.check");
				return response;
			}
			attributeKeyDao.delete(id);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("fail to delete {} ,cause:{}", id, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
		}
		return response;
	}

	/**
	 * 通过id查hash
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<AttributeKey> findAttributeKeyById(Long id) {
		Response<AttributeKey> response = new Response<AttributeKey>();
		try {
			AttributeKey attributeKey = attributeKeyDao.findAttributeKeyById(id);
			response.setResult(attributeKey);
		} catch (Exception e) {
			log.error("failed to findAttributeKeyById id={};cause by{}", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	/**
	 * 通过名字查hash 不存在则返回空
	 *
	 * @param name
	 * @return
	 */
	@Override
	public Response<AttributeKey> findAttributeByName(String name) {
		Response<AttributeKey> response = new Response<AttributeKey>();
		try {
			AttributeKey attributeKey = attributeKeyDao.findAttributeByName(name);
			response.setResult(attributeKey);
		} catch (Exception e) {
			log.error("failed to findAttributeKeyByName name={};cause by {}", name,
					Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}
}
