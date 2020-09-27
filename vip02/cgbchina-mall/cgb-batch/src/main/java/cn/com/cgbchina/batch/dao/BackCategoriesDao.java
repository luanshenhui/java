package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.BackCategory;

import com.google.common.collect.Iterables;
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

import java.util.*;

/**
 * Created by 郝文佳 on 2016/4/19.
 * Modify by xiewl on 2016/8/27
 */
@Repository
public class BackCategoriesDao extends RedisBaseDao<BackCategory> {
    @Autowired
    public BackCategoriesDao(JedisTemplate jedisTemplate) {
        super(jedisTemplate);
    }

	/**
	 * 通过id查类目 无结果时，返回 null
	 *
	 * @param id
	 * @return
	 */
	public BackCategory findById(final Long id, String orderType) {

		final String keyBackCategory;
		if (null == orderType) {
			keyBackCategory = KeyUtil.entityId(BackCategory.class, id);
		} else {
			keyBackCategory = "points-" + KeyUtil.entityId(BackCategory.class, id);
		}
		Map hash = (Map) this.jedisTemplate.execute(new JedisTemplate.JedisAction() {
			public Map<String, String> action(Jedis jedis) {
				return jedis.hgetAll(keyBackCategory);
			}
		});
		BackCategory backCategory = this.stringHashMapper.fromHash(hash);
		return backCategory.getId() != null ? backCategory : null;
    }

	/**
	 * (重载)通过id查类目
	 *
	 * @param id
	 * @return
	 */
	public BackCategory findById(final Long id) {
		return findById(id, null);
	}

	/**
	 * 更新名称
	 * 
	 * @param oldId
	 * @param newName
	 */
	public void update(final Long oldId, final String newName, String orderType) {

		final String keyBackCategory;
		if (null == orderType) {
			keyBackCategory = KeyUtil.entityId(BackCategory.class, oldId);
		} else {
			keyBackCategory = "points-" + KeyUtil.entityId(BackCategory.class, oldId);
		}
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
				jedis.hset(keyBackCategory, "name", newName);
            }
        });
    }
	
	/**
	 * 判断KEY是否存在
	 *
	 * @param key
	 * @return
	 */
    public Boolean exists(final String key) {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<Boolean>() {
            @Override
            public Boolean action(Jedis jedis) {
                return jedis.exists(key);
            }
        });
    }

    /**
     * @return
     */
	public List<BackCategory> allSimpleData(final String orderType) {
		final String keysBackCategoryAll;
		if (null == orderType) {
			keysBackCategoryAll = "back-category:all";
		} else {
			keysBackCategoryAll = "points-back-category:all";
		}
		List<String> ids = jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
            @Override
            public List<String> action(Jedis jedis) {
				return jedis.lrange(keysBackCategoryAll, 0L, -1L);
            }
        });
		return findByIds(ids, orderType);
    }

	/**
	 * 取出后台类目列表
	 */
	public List<BackCategory> allSimpleData() {
		return allSimpleData(null);
	}


    /**
	 * (重载) 通过集合ids 查找 集合属性
	 *
	 * @param ids
	 * @param orderType
	 * @return
	 */
	public List<BackCategory> findByIds(final Iterable<String> ids, final String orderType) {
		if (Iterables.isEmpty(ids)) {
			return Collections.emptyList();
		} else {
			List result = (List) this.jedisTemplate.execute(new JedisTemplate.JedisAction() {
				public List<Response<Map<String, String>>> action(Jedis jedis) {
					ArrayList result = Lists.newArrayListWithCapacity(Iterables.size(ids));
					Pipeline p = jedis.pipelined();
					Iterator i$ = ids.iterator();

					while (i$.hasNext()) {
						String id = (String) i$.next();
						String key;
						if (null == orderType)
							key = KeyUtil.entityId(BackCategory.class, id);
						else
							key = "points-" + KeyUtil.entityId(BackCategory.class, id);
						result.add(p.hgetAll(key));
					}
					p.sync();
					return result;
                }
			});
			ArrayList entities = Lists.newArrayListWithCapacity(result.size());
			Iterator i$ = result.iterator();

			while (i$.hasNext()) {
				Response mapResponse = (Response) i$.next();
				entities.add(this.stringHashMapper.fromHash((Map) mapResponse.get()));
            }

			return entities;
		}
    }
}
