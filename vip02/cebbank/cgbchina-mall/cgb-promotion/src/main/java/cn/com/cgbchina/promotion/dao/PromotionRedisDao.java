package cn.com.cgbchina.promotion.dao;

import cn.com.cgbchina.promotion.model.PromotionRedisModel;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.KeyUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Pipeline;

import java.util.List;
import java.util.Map;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/8.
 */
@Repository
@Slf4j
public class PromotionRedisDao extends RedisBaseDao<PromotionRedisModel> {
	@Autowired
	public PromotionRedisDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	public void syncDBtoRedis(final List<PromotionRedisModel> list) {
		// 把所有的批处理送过来的数据 存到redis中

		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Pipeline pipelined = jedis.pipelined();
				for (PromotionRedisModel promotionRedisModel : list) {
					Map<String, String> stringStringMap = stringHashMapper.toHash(promotionRedisModel);
					pipelined.hmset(
							KeyUtil.entityId(PromotionRedisModel.class, Long.valueOf(promotionRedisModel.getId())),
							stringStringMap);
				}
				pipelined.sync();
			}
		});
	}

	public void syncPromotionItem() {

	}

	public void insertIdsByDate(final List<Integer> ids, final String date) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Pipeline pipelined = jedis.pipelined();
				for (Integer id : ids) {
					pipelined.lpush("prom:" + date, String.valueOf(id));
				}
				pipelined.sync();
			}
		});

	}
}
