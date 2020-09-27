package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.dto.CategoryMappingDto;
import cn.com.cgbchina.item.dto.FrontCategoryEditDto;
import cn.com.cgbchina.item.model.FrontCategory;
import com.google.common.collect.Lists;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.JsonMapper;
import com.spirit.util.KeyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Pipeline;
import redis.clients.jedis.Transaction;

import java.util.Collections;
import java.util.List;
import java.util.Set;

/**
 * 前台类目 By wenjia.hao@dhc.com.cn
 */
@Repository
public class FrontCategoryDao extends RedisBaseDao<FrontCategory> {
	private final static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Autowired
	public FrontCategoryDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	/**
	 * 通过id查前台类目 如果不存在则返回空
	 *
	 * @param id
	 * @return
	 */
	public FrontCategory findById(Long id) {
		FrontCategory category = findByKey(id);
		return category.getId() != null ? category : null;
	}

	/**
	 * 通过id查子节点
	 *
	 * @param id
	 * @return
	 */
	public List<FrontCategory> findChildrenById(final Long id) {
		List<String> ids = jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
			public List<String> action(Jedis jedis) {
				return jedis.lrange(KeyUtil.frontendCategoryChildrenOf(id.longValue()), 0L, -1L);
			}
		});
		return super.findByIds(ids);
	}

	/**
	 * 创建前台类目 id动态生成 维护一个对象hash 一个父节点下的子节点id列表
	 *
	 * @param category
	 */
	public Long create(final FrontCategory category) {
		final Long id = newId();
		category.setId(id);
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			public void action(Jedis jedis) {
				Transaction t = jedis.multi();
				// 维护哈希
				t.hmset(KeyUtil.entityId(FrontCategory.class, id.longValue()), stringHashMapper.toHash(category));
				// 维护子节点
				t.rpush(KeyUtil.frontendCategoryChildrenOf(category.getParentId().longValue()),
						new String[] { id.toString() });
				t.exec();
			}
		});
		return id;
	}

	/**
	 * 删除
	 *
	 * @param id
	 */
	public void delete(final Long id) {
		final FrontCategory backendCategory = findById(id);
		if (id == null) {
			return;
		}

		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			public void action(Jedis jedis) {
				Transaction t = jedis.multi();

				t.del(KeyUtil.entityId(FrontCategory.class, id.longValue()));
				t.lrem(KeyUtil.frontendCategoryChildrenOf(backendCategory.getParentId()), 1L, id.toString());
				// 有后台类目挂载的时候是不允许删除的 此处不需要
				// t.del(KeyUtil.categoryMapping(id.longValue()));
				t.exec();
			}
		});
	}

	/**
	 * 更新只允许更name
	 *
	 * @param frontCategoryEditDto
	 */
	public void update(final FrontCategoryEditDto frontCategoryEditDto) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			public void action(Jedis jedis) {

				jedis.hset(KeyUtil.entityId(FrontCategory.class, frontCategoryEditDto.getId()), "name",
						frontCategoryEditDto.getNewName());

			}
		});
	}

	public Long maxId() {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Long>() {
			public Long action(Jedis jedis) {
				return Long.valueOf(Long.parseLong(jedis.get(KeyUtil.entityCount(FrontCategory.class))));
			}
		});
	}

	/**
	 * 判断当前节点是否是父节点
	 *
	 * @param id
	 * @return
	 */
	public Boolean isParent(final Long id) {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Boolean>() {
			@Override
			public Boolean action(Jedis jedis) {
				return jedis.exists(KeyUtil.frontendCategoryChildrenOf(id));
			}
		});

	}

	/**
	 * 通过前台类目节点查询前台类目与后台类目的绑定
	 *
	 * @param frontCategory
	 * @return
	 */
	public List<CategoryMappingDto> findCategoryMapping(final Long frontCategory) {
		Set<String> categoryMappings = jedisTemplate.execute(new JedisTemplate.JedisAction<Set<String>>() {
			@Override
			public Set<String> action(Jedis jedis) {

				return jedis.smembers(KeyUtil.categoryMapping(frontCategory));
			}
		});
		if (categoryMappings == null) {
			return Collections.emptyList();
		}
		List<CategoryMappingDto> list = Lists.newArrayList();
		for (String str : categoryMappings) {
			list.add(jsonMapper.fromJson(str, CategoryMappingDto.class));
		}

		return list;
	}

	/**
	 * @param frontCategoryId
	 * @param list
	 */

	public void addCategoryMapping(final Long frontCategoryId, final List<CategoryMappingDto> list) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Pipeline pipelined = jedis.pipelined();
				for (CategoryMappingDto temp : list) {
					String s = jsonMapper.toJson(temp);
					pipelined.sadd(KeyUtil.categoryMapping(frontCategoryId), s);
				}
				pipelined.sync();
			}
		});

	}

	/**
	 * 删除前台类目绑定的某个后台类目 单条删除 不允许多条删除
	 *
	 * @param categoryMappingDto
	 */
	public void deleteBackMapping(final CategoryMappingDto categoryMappingDto) {
		final Long frontCategoryId = categoryMappingDto.getFrontCategoryId();
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				jedis.srem(KeyUtil.categoryMapping(frontCategoryId), jsonMapper.toJson(categoryMappingDto));
			}
		});
	}

	public void changeSort(final Long currentId, final Long changeId, final Long parentId) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				List<String> childIds = jedis.lrange(KeyUtil.frontendCategoryChildrenOf(parentId), 0L, -1L);
				Integer currentSort = childIds.indexOf(currentId.toString());
				Integer changeSort = childIds.indexOf(changeId.toString());
				Transaction multi = jedis.multi();
				multi.lset(KeyUtil.frontendCategoryChildrenOf(parentId), Long.valueOf(currentSort),
						changeId.toString());
				multi.lset(KeyUtil.frontendCategoryChildrenOf(parentId), Long.valueOf(changeSort),
						currentId.toString());
				multi.exec();

			}
		});
	}
}