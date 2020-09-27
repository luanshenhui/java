package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.OrderInfo;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import org.springframework.beans.factory.annotation.Autowired;

import javax.annotation.Resource;
import java.util.Date;

/**
 * Created by 11140721050130 on 2016/4/29.
 */
@Resource
public class OrderRedisDao extends RedisBaseDao<OrderInfo> {

	@Autowired
	public OrderRedisDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

}
