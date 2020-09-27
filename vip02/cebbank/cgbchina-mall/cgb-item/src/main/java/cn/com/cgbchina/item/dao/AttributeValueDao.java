package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.AttributeValue;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.KeyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Pipeline;
import redis.clients.jedis.Response;
import redis.clients.jedis.Transaction;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by 郝文佳 on 2016/4/21.
 */
@Repository
public class AttributeValueDao extends RedisBaseDao<AttributeValue> {
	@Autowired
	public AttributeValueDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	/**
	 * 新增属性value redis
	 *
	 * @param attributeValue
	 */
	public AttributeValue create(final AttributeValue attributeValue) {
		Boolean isValueExists = jedisTemplate.execute(new JedisTemplate.JedisAction<Boolean>() {
			@Override
			public Boolean action(Jedis jedis) {
				// attribute:value:名字是否存在
				Boolean exists = jedis.exists(KeyUtil.attributeValue(attributeValue.getValue()));
				return exists;
			}
		});
		if (isValueExists) {
			String existsId = jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
				@Override
				public String action(Jedis jedis) {
					String s = jedis.get(KeyUtil.attributeValue(attributeValue.getValue()));
					return s;
				}
			});
			attributeValue.setId(Long.valueOf(existsId));
			return attributeValue;
		}
		final Long id = newId();
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Transaction multi = jedis.multi();
				// 把所有属性value的id号存入一个set 管理
				multi.sadd(KeyUtil.attributeValues(), String.valueOf(id));
				// 存入单条属性
				multi.hmset(KeyUtil.attributeValueId(id), stringHashMapper.toHash(attributeValue));
				// 属性值字典表 管理属性值与属性id之间的关系
				multi.set(KeyUtil.attributeValue(attributeValue.getValue()), String.valueOf(id));
				multi.exec();
			}
		});
		attributeValue.setId(id);
		return attributeValue;
	}

	/**
	 * 通过属性Id查属性值 如果id不存在的话返回对象中的value为null，对象本身不是空 注意空指针
	 *
	 * @param id
	 * @return
	 */
	public AttributeValue findById(final Long id) {
		AttributeValue result = jedisTemplate.execute(new JedisTemplate.JedisAction<AttributeValue>() {
			@Override
			public AttributeValue action(Jedis jedis) {
				Map<String, String> stringStringMap = jedis.hgetAll(KeyUtil.attributeValueId(id));
				AttributeValue attributeValue = stringHashMapper.fromHash(stringStringMap);

				return attributeValue;
			}
		});
		result.setId(id);
		return result;
	}

	/**
	 * 通过Id集合 批量查询属性值 如查询中的某一个id不存在 则这个对象中的value字段为空，对象本身不是空
	 *
	 * @param ids
	 * @return
	 */
	public List<AttributeValue> findByIds(final List<Long> ids) {
		List<Response<Map<String, String>>> execute = jedisTemplate
				.execute(new JedisTemplate.JedisAction<List<Response<Map<String, String>>>>() {
					@Override
					public List<Response<Map<String, String>>> action(Jedis jedis) {
						List<Response<Map<String, String>>> result = new ArrayList<Response<Map<String, String>>>();
						Pipeline pipelined = jedis.pipelined();
						for (Long id : ids) {
							Response<Map<String, String>> response = pipelined.hgetAll(KeyUtil.attributeValueId(id));
							result.add(response);
						}
						pipelined.sync();
						return result;
					}
				});
		List<AttributeValue> list = new ArrayList<AttributeValue>();
		for (Response<Map<String, String>> response : execute) {
			Map<String, String> stringStringMap = response.get();
			AttributeValue attributeValue = stringHashMapper.fromHash(stringStringMap);
			list.add(attributeValue);
		}
		return list;

	}

}
