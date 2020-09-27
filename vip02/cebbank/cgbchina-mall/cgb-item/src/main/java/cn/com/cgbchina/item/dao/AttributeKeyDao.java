package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.AttributeKey;
import com.google.common.collect.Lists;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.KeyUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Pipeline;
import redis.clients.jedis.SortingParams;
import redis.clients.jedis.Transaction;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by 郝文佳 on 2016/4/18.
 */
@Repository
public class AttributeKeyDao extends RedisBaseDao<AttributeKey> {
	@Autowired
	public AttributeKeyDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	/**
	 * 首页
	 *
	 * @param pageInfo
	 * @param attributeName
	 * @return
	 */
	public Response<Pager<AttributeKey>> pagination(final PageInfo pageInfo, final String attributeName) {
		Response<Pager<AttributeKey>> response = new Response<Pager<AttributeKey>>();
		if (!StringUtils.isEmpty(attributeName)) {
			List<AttributeKey> list = fuzzyQuery(attributeName);
			Pager<AttributeKey> pager = new Pager<>(new Long(list.size()), list);
			response.setResult(pager);
			return response;

		}
		// 总数用于分页
		Long total = jedisTemplate.execute(new JedisTemplate.JedisAction<Long>() {
			@Override
			public Long action(Jedis jedis) {
				Long scard = jedis.scard(KeyUtil.attributeKeys());
				return scard;
			}
		});

		List<AttributeKey> result = jedisTemplate.execute(new JedisTemplate.JedisAction<List<AttributeKey>>() {
			@Override
			public List<AttributeKey> action(Jedis jedis) {
				SortingParams sortingParams = new SortingParams();
				sortingParams.limit(pageInfo.getOffset(), pageInfo.getLimit());
				sortingParams.desc();
				List<String> sort = jedis.sort(KeyUtil.attributeKeys(), sortingParams);// 返回拍完序的ID
				List<AttributeKey> byIds = findByIds(sort);// 通过排好序的ID获得所有属性对象
				return byIds;
			}
		});
		Pager<AttributeKey> pager = new Pager<AttributeKey>(total, result);
		response.setResult(pager);
		return response;

	}

	/**
	 * 通过属性ID查找属性对象 无对应id则返回空
	 *
	 * @param id
	 * @return
	 */
	public AttributeKey findAttributeKeyById(final Long id) {
		AttributeKey attributeKey = jedisTemplate.execute(new JedisTemplate.JedisAction<AttributeKey>() {
			@Override
			public AttributeKey action(Jedis jedis) {
				if (jedis.exists(KeyUtil.entityId(AttributeKey.class, id))) {
					Map<String, String> stringStringMap = jedis.hgetAll(KeyUtil.entityId(AttributeKey.class, id));
					return stringHashMapper.fromHash(stringStringMap);
				}
				return null;
			}
		});
		return attributeKey;
	}

	/**
	 * 通过属性名查找属性对象无属性名则返回空
	 *
	 * @param name
	 * @return
	 */
	public AttributeKey findAttributeByName(final String name) {
		AttributeKey execute = jedisTemplate.execute(new JedisTemplate.JedisAction<AttributeKey>() {
			@Override
			public AttributeKey action(Jedis jedis) {
				if (jedis.exists(KeyUtil.attributeKey(name))) {
					String s = jedis.get(KeyUtil.attributeKey(name));
					AttributeKey attributeKeyById = findAttributeKeyById(Long.valueOf(s));
					return attributeKeyById;

				}

				return null;
			}
		});
		return execute;
	}

	/**
	 * 创建 name都不允许重复
	 *
	 * @param attributeKey
	 */
	public void create(final AttributeKey attributeKey) {
		Boolean isNameExist = jedisTemplate.execute(new JedisTemplate.JedisAction<Boolean>() {
			@Override
			public Boolean action(Jedis jedis) {
				Boolean exists = jedis.exists(KeyUtil.attributeKey(attributeKey.getName()));
				return exists;
			}
		});
		if (isNameExist) {
			throw new IllegalArgumentException("attribute.name.exist");
		}

		final Long id = newId();
		attributeKey.setId(id);
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Transaction multi = jedis.multi();
				multi.sadd(KeyUtil.attributeKeys(), String.valueOf(id));
				multi.hmset(KeyUtil.entityId(AttributeKey.class, id), stringHashMapper.toHash(attributeKey));// 增加每一个key的对象哈希
				multi.set(KeyUtil.attributeKey(attributeKey.getName()), String.valueOf(id));// 维护每一个属性名与id的对应
				multi.exec();
			}
		});
	}

	/**
	 * 根据id删除 包括所有创建时候维护的都会被删除
	 *
	 * @param id
	 */
	public void delete(final Long id) {

		final AttributeKey attributeKey = jedisTemplate.execute(new JedisTemplate.JedisAction<AttributeKey>() {
			@Override
			public AttributeKey action(Jedis jedis) {
				Map<String, String> stringStringMap = jedis.hgetAll(KeyUtil.entityId(AttributeKey.class, id));
				return stringHashMapper.fromHash(stringStringMap);
			}
		});

		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {

				Transaction multi = jedis.multi();
				multi.del(KeyUtil.entityId(AttributeKey.class, id));
				multi.del(KeyUtil.attributeKey(attributeKey.getName()));
				multi.srem(KeyUtil.attributeKeys(), attributeKey.getId().toString());
				multi.exec();
			}
		});

	}

	/**
	 * 通过名字模糊查询
	 *
	 * @param name
	 * @return
	 */
	public List<AttributeKey> fuzzyQuery(String name) {
		final String query = KeyUtil.attributeKey("*") + name + "*";
		final Set<String> ids = jedisTemplate.execute(new JedisTemplate.JedisAction<Set<String>>() {
			@Override
			public Set<String> action(Jedis jedis) {
				Set<String> keys = jedis.keys(query);
				return keys;
			}
		});
		List<redis.clients.jedis.Response<String>> execute = jedisTemplate
				.execute(new JedisTemplate.JedisAction<List<redis.clients.jedis.Response<String>>>() {
					@Override
					public List<redis.clients.jedis.Response<String>> action(Jedis jedis) {
						Pipeline pipelined = jedis.pipelined();
						List<redis.clients.jedis.Response<String>> result = Lists.newArrayList();
						for (String id : ids) {
							redis.clients.jedis.Response<String> stringResponse = pipelined.get(id);
							result.add(stringResponse);
						}
						pipelined.sync();
						return result;
					}
				});
		List<String> resultIds = Lists.newArrayList();
		for (redis.clients.jedis.Response res : execute) {

			resultIds.add(String.valueOf(res.get()));

		}
		return findByIds(resultIds);

	}

	public void incrAttributeCount(final Long id, final Long step) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Boolean exists = jedis.exists(KeyUtil.entityId(AttributeKey.class, id));
				if (exists) {
					jedis.hincrBy(KeyUtil.entityId(AttributeKey.class, id.toString()), "count", step);

				}

			}
		});

	}

	public void incrAttributesCount(final Iterable<Long> ids, final Long step) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Pipeline pipelined = jedis.pipelined();
				for (Long id : ids) {
					pipelined.hincrBy(KeyUtil.entityId(AttributeKey.class, id.toString()), "count", step);
				}
				pipelined.sync();

			}
		});
	}
}
