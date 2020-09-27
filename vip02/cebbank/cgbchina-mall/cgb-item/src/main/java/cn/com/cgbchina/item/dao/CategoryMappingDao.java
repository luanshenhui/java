package cn.com.cgbchina.item.dao;

import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.KeyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Pipeline;
import redis.clients.jedis.Response;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * basedao泛型没有使用 Created by 郝文佳 on 2016/5/16.
 */
@Repository
public class CategoryMappingDao extends RedisBaseDao<Object> {
	@Autowired
	public CategoryMappingDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	/**
	 * 得到所有category-mapping:*
	 *
	 * @return
	 */
	private Set<String> getAllMappingIds() {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Set<String>>() {
			@Override
			public Set<String> action(Jedis jedis) {
				return jedis.keys("category-mapping:*");
			}
		});
	}

	/**
	 * 返回所有mapping数据
	 *
	 * @return
	 */
	private List<Set<String>> getAllMapping() {
		final Set<String> allMappingIds = getAllMappingIds();
		List<Response<Set<String>>> execute = jedisTemplate
				.execute(new JedisTemplate.JedisAction<List<Response<Set<String>>>>() {
					@Override
					public List<Response<Set<String>>> action(Jedis jedis) {
						List<Response<Set<String>>> result = new ArrayList<>();
						Pipeline pipelined = jedis.pipelined();
						for (String str : allMappingIds) {
							final Response<Set<String>> smembers = pipelined.smembers(str);
							result.add(smembers);
						}
						pipelined.sync();
						return result;
					}
				});
		List<Set<String>> result = new ArrayList<>();
		for (Response<Set<String>> response : execute) {

			result.add(response.get());
		}
		return result;
	}

	/**
	 * 将所有映射数据进行去重 得到当前所有前台类目绑定的所有后台类目的集合
	 */
	public Set<String> groupSet() {
		List<Set<String>> allMapping = getAllMapping();
		Set<String> result = new HashSet<>();
		for (Set<String> set : allMapping) {
			result.addAll(set);
		}
		return result;

	}

	/**
	 * 查询出当前的绑定键是否存在
	 *
	 * @param id
	 * @return
	 */
	public Boolean isExist(final Long id) {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Boolean>() {
			@Override
			public Boolean action(Jedis jedis) {

				return jedis.exists(KeyUtil.categoryMapping(id));
			}
		});

	}

	/**
	 * 根据前台类目查找于后台类目的对应关系
	 * 
	 * @param frontId
	 * @return
	 */
	public Set<String> getMappingByFrontId(final String frontId) {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Set<String>>() {
			@Override
			public Set<String> action(Jedis jedis) {
				return jedis.smembers("category-mapping:" + frontId);
			}
		});
	}

}
