package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.dto.AttributeDto;
import cn.com.cgbchina.item.model.AttributeKey;
import cn.com.cgbchina.item.model.BackCategory;
import com.google.common.collect.Lists;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.JsonMapper;
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
import java.util.Set;

/**
 * Created by 郝文佳 on 2016/4/19.
 */
@Repository
public class BackCategoriesDao extends RedisBaseDao<BackCategory> {
	@Autowired
	public BackCategoriesDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	/**
	 * 通过id查出其本身及其父类目的所有属性 实现类中传入的是父节点，查父节点本身及父节点的父节点的属性
	 *
	 * @param id
	 * @return
	 */

	public AttributeDto findParentsAttribute(Long id) {
		AttributeDto attributeDto = new AttributeDto();
		List<AttributeKey> attribute = new ArrayList<AttributeKey>();
		List<AttributeKey> sku = new ArrayList<AttributeKey>();
		attributeDto.setAttribute(attribute);
		attributeDto.setSku(sku);
		BackCategory current = findById(id);// 等于空说明是0 是零的话他就是一级类目 一级类目没有父类目 所以属性不在这传
		if (current != null) {
			while (current != null) {
				String currentAttribute = current.getAttribute();
				AttributeDto currentDto = JsonMapper.nonEmptyMapper().fromJson(currentAttribute, AttributeDto.class);
				if (currentDto != null) {
					if (currentDto.getAttribute() != null) {
						attribute.addAll(currentDto.getAttribute());
					}
					if (currentDto.getSku() != null) {
						sku.addAll(currentDto.getSku());
					}
				}

				current = findById(current.getParentId());
			}
			;
		}
		return attributeDto;
	}

	/**
	 * 通过id查类目
	 *
	 * @param id
	 * @return
	 */
	public BackCategory findById(final Long id) {
		BackCategory backCategory = (BackCategory) findByKey(id);
		return backCategory.getId() != null ? backCategory : null;
	}

	/**
	 * 通过id查子节点
	 *
	 * @param id
	 * @return
	 */
	public List<BackCategory> findChildrenById(final Long id) {
		List<String> ids = jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
			public List<String> action(Jedis jedis) {
				return jedis.lrange(KeyUtil.backendCategoryChildrenOf(id.longValue()), 0L, -1L);
			}
		});
		// 返回的集合中没有isParent的值 处理这个值 将其加入对象中
		List<BackCategory> result = super.findByIds(ids);
		for (BackCategory temp : result) {
			temp.setIsParent(isParent(temp.getId()));
		}
		return result;
	}

	/**
	 * 创建
	 *
	 * @param backCategory
	 */
	public Long create(final BackCategory backCategory) {
		final Long id = newId();
		backCategory.setId(id);
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			public void action(Jedis jedis) {
				Transaction t = jedis.multi();
				t.hmset(KeyUtil.entityId(BackCategory.class, id.longValue()), stringHashMapper.toHash(backCategory));
				t.rpush(KeyUtil.backendCategoryChildrenOf(backCategory.getParentId().longValue()),
						new String[] { id.toString() });

				t.exec();
			}
		});
		return id;
	}

	/**
	 * @param oldId
	 * @param newName
	 */
	public void update(final Long oldId, final String newName) {

		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {

				jedis.hset(KeyUtil.entityId(BackCategory.class, oldId), "name", newName);
			}

		});
	}

	/**
	 * 删除
	 *
	 * @param id
	 */
	public void delete(final Long id, final Long parentId) {

		// 真正开始删除
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Transaction multi = jedis.multi();
				multi.lrem(KeyUtil.backendCategoryChildrenOf(parentId), 0, id.toString());
				multi.del(KeyUtil.entityId(BackCategory.class, id));
				multi.exec();
			}
		});
	}

	/**
	 * 判断是否存在
	 *
	 * @param key
	 * @return
	 */
	public Boolean exists(final String key) {
		Boolean execute = jedisTemplate.execute(new JedisTemplate.JedisAction<Boolean>() {
			@Override
			public Boolean action(Jedis jedis) {

				return jedis.exists(key);
			}
		});
		return execute;
	}

	/**
	 * 添加某一个类目的属性json字符串
	 *
	 * @param categoryId 类目id
	 * @param jsonAttribute 属性转换完成的json字符串
	 */
	public void addAttribute(final Long categoryId, final String jsonAttribute) {

		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				jedis.hset(KeyUtil.entityId(BackCategory.class, categoryId), "attribute", jsonAttribute);
			}
		});
	}

	/**
	 * 改变某一个属性
	 *
	 * @param categoryId
	 * @param attribute
	 */
	public void changeAttribute(final Long categoryId, final String attribute) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				jedis.hset(KeyUtil.entityId(BackCategory.class, categoryId), "attribute", attribute);

			}
		});

	}

	/**
	 * 判断某一个节点是否是父节点
	 *
	 * @param categoryId
	 * @return
	 */
	public Boolean isParent(final Long categoryId) {
		Boolean isParent = jedisTemplate.execute(new JedisTemplate.JedisAction<Boolean>() {
			@Override
			public Boolean action(Jedis jedis) {
				return jedis.exists(KeyUtil.backendCategoryChildrenOf(categoryId));
			}
		});

		return isParent;
	}

	/**
	 * 传入后台类目的Id和增加的数 对当前后台类目的使用次数进行修改
	 *
	 * @param backCategoryIds
	 * @param step
	 */
	public void incrCount(final Iterable<String> backCategoryIds, final Integer step) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Pipeline pipelined = jedis.pipelined();
				for (String backCategoryId : backCategoryIds) {

					pipelined.hincrBy(KeyUtil.entityId(BackCategory.class, backCategoryId), "count",
							Long.valueOf(step));

				}
				pipelined.sync();
			}
		});
	}

	/**
	 * @return
	 */
	public List<BackCategory> allSimpleData() {
		final Set<String> execute = jedisTemplate.execute(new JedisTemplate.JedisAction<Set<String>>() {
			@Override
			public Set<String> action(Jedis jedis) {

				return jedis.keys("back-category:*[0-9]");
			}
		});
		List<Response<Map<String, String>>> result = jedisTemplate
				.execute(new JedisTemplate.JedisAction<List<Response<Map<String, String>>>>() {
					@Override
					public List<Response<Map<String, String>>> action(Jedis jedis) {
						Pipeline pipelined = jedis.pipelined();
						List<Response<Map<String, String>>> list = Lists.newArrayList();
						for (String key : execute) {
							Response<Map<String, String>> mapResponse = pipelined.hgetAll(key);
							list.add(mapResponse);
						}
						pipelined.sync();
						return list;
					}
				});
		List<BackCategory> backCategories = Lists.newArrayList();
		for (Response<Map<String, String>> response : result) {
			backCategories.add(stringHashMapper.fromHash(response.get()));
		}

		return backCategories;
	}


	public void changeCount(final Long backcategoryId,final Long step){
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				jedis.hincrBy(KeyUtil.entityId(BackCategory.class,backcategoryId),"goodCount",step);



			}
		});


	}
}
