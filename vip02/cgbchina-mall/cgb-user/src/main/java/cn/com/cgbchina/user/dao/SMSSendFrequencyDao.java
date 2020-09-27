package cn.com.cgbchina.user.dao;

import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Transaction;

/**
 * Created by 1115012105001 on 2016/10/4.
 */
@Repository
public class SMSSendFrequencyDao extends RedisBaseDao<Object> {
	public static final String SMS_FREQUENCY_ALL = "SMSFrequency:all";

	@Autowired
	public SMSSendFrequencyDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	/**
	 *得到键值 没有返回空
	 * @param userId 用户id
	 * @param smsType 短信类型 留着扩展 此时只有首次登陆的时候有用
	 */
	public String getKey(String userId, String smsType) {
		final String SMSKey = "SMSFrequency:" + userId + ":" + smsType;
		return jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
			@Override
			public String action(Jedis jedis) {
				return jedis.get(SMSKey);
			}
		});
	}

	/**
	 *设置键值  存在则覆盖  设置聚合建用于维护
	 * @param userId 用户id
	 * @param smsType 短信类型
	 * @param value 键值 格式为 "yyyy-MM-dd HH:mm:ss|times"
	 */
	public void create(String userId, String smsType, final String value) {
		final String SMSKey = "SMSFrequency:" + userId + ":" + smsType;
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Transaction multi = jedis.multi();
				multi.set(SMSKey, value);//基础键
				multi.sadd(SMS_FREQUENCY_ALL,SMSKey);//聚合键
				multi.exec();
			}
		});

	}

}
