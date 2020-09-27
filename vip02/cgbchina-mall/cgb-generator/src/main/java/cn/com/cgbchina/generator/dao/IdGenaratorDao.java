package cn.com.cgbchina.generator.dao;

import cn.com.cgbchina.generator.IdEnum;
import com.spirit.redis.JedisTemplate;
import com.spirit.util.KeyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;

/**
 * Created by 11140721050130 on 2016/4/30.
 */
@Repository
public class IdGenaratorDao {
	@Autowired
	private JedisTemplate jedisTemplate;

	public Long newId(final IdEnum type) {
		return this.jedisTemplate.execute(new JedisTemplate.JedisAction<Long>() {
			public Long action(Jedis jedis) {
				return jedis.incr(KeyUtil.idGenerator(type.toString()));
			}
		});
	}
}
