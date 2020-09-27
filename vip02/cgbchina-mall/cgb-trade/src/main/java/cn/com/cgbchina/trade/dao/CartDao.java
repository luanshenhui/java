package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.dto.CartDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.HashMultiset;
import com.google.common.collect.Multiset;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.JsonMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Transaction;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static com.spirit.util.KeyUtil.shopCart;

@Repository
public class CartDao extends RedisBaseDao<CartDto> {
	private final static Logger log = LoggerFactory.getLogger(CartDao.class);

	private final ObjectMapper jackson = JsonMapper.nonEmptyMapper().getMapper();

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	public static final TypeReference<Multiset<Long>> type = new TypeReference<Multiset<Long>>() {
	};

	private static final int TWO_WEEKSINT_IN_SECONDS = (int) TimeUnit.DAYS.toSeconds(14);

	// private final JedisTemplate template;

	/*
	 * @Autowired public CartDao(JedisTemplate template) { this.template = template; jackson =
	 * JsonMapper.nonEmptyMapper().getMapper(); }
	 */
	@Autowired
	public CartDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	public Multiset<Long> getTemporary(final String key) throws Exception {
		String existed = jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
			@Override
			public String action(Jedis jedis) {
				return jedis.get(shopCart(key));
			}
		});
		return unmarshal(existed);
	}

	public Map<String, String> getPermanent(final String userId) throws Exception {
		Map<String, String> existed = jedisTemplate.execute(new JedisTemplate.JedisAction<Map<String, String>>() {
			@Override
			public Map<String, String> action(Jedis jedis) {
				return jedis.hgetAll(shopCart(userId.toString()));
			}
		});
		return existed;
	}

	public void setPermanent(final String userId, final Multiset<Long> current) throws Exception {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				String serialized = marshal(current);
				jedis.set(shopCart(userId.toString()), serialized);
			}
		});
	}

	public void deleteByItemCode(final String userId, final List<String> keyList) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				for (String key : keyList) {
					jedis.hdel(shopCart(userId.toString()), key);
				}
			}
		});
	}

	public void delete(final String key) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				jedis.del(shopCart(key));
			}
		});
	}

	Multiset<Long> unmarshal(String existed) {
		if (Strings.isNullOrEmpty(existed)) {
			return HashMultiset.create(1);
		}
		try {
			return jackson.readValue(existed, type);
		} catch (Exception e) {
			log.error("failed to unmarshal {} to Multiset<Long>,cause:{}", existed,
					Throwables.getStackTraceAsString(e));
			throw new RuntimeException("failed to deserialize json string", e);
		}
	}

	String marshal(Multiset<Long> current) {
		try {
			return jackson.writeValueAsString(current);
		} catch (JsonProcessingException e) {
			log.error("failed to serialize {} to json,cause:{}", current, Throwables.getStackTraceAsString(e));
			throw new RuntimeException("failed to serialize object to json", e);
		}
	}

	public void changeTemporaryCart(final String key, final String skuId, final Integer quantity) throws Exception {
		final Multiset<Long> skuIds = getTemporary(key);
		if (quantity > 0) {
			skuIds.add(Long.valueOf(skuId), quantity);
		} else {
			skuIds.remove(Long.valueOf(skuId), -quantity);
		}
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				jedis.setex(shopCart(key), TWO_WEEKSINT_IN_SECONDS, marshal(skuIds));
			}
		});
	}

	public void changePermanentCart(final String userId, final String key, final Map<String, String> paramMap)
			throws Exception {

		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				jedis.hdel(shopCart(userId), key);
				Transaction t = jedis.multi();
				// 如果存在旧数据则删除
				//t.hdel(shopCart(userId), key);
				/* t = jedis.multi(); */
				// 新增数据
				t.hmset(shopCart(userId), paramMap);
				t.exec();
			}
		});
	}
}
