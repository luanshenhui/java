package cn.com.cgbchina.rest.common.util;

import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;

/**
 * Created by 1115012105001 on 2016/12/20.
 */
@Repository
@Slf4j
public class ConnectionLimitRedisLock extends RedisBaseDao<Object> {

	private static final String PACKAGE="limit:";
    private static final String TOTAL_KEY = "_total_limit";
    private static final String CURRENT_KEY = "_current_limit";
	public ConnectionLimitRedisLock(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}


    /**
     * 取出当前时时限流数
     * @param sysId
     * @return
     */
    public Long getCurrentLimit(final String sysId) {
        return getLimit(sysId + CURRENT_KEY);
    }
    private Long getLimit(final String key){
        String current = jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
            @Override
            public String action(Jedis jedis) {
                return jedis.get(PACKAGE+key);
            }
        });
        return current == null ? 0 : Long.parseLong(current);
    }
    /**
     * 接口限流总数
     * @param sysId
     * @return
     */
    public Long getTotalLimit(final String sysId) {
        return getLimit(sysId + TOTAL_KEY);
    }

    /**
     * 设置接口限流总数
     * @param sysId
     * @param value
     */
    public void setTotalLimit(final String sysId, final String value) {
        jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
            @Override
            public String action(Jedis jedis) {
                return jedis.set(PACKAGE+sysId + TOTAL_KEY, value);
            }
        });
    }

    /**
     * 设置接口当前限流数
     * @param sysId
     * @param value
     */
    public void setLimit(final String sysId, final String value) {
        jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
            @Override
            public String action(Jedis jedis) {
                return jedis.set(PACKAGE+sysId + CURRENT_KEY, value);
            }
        });
    }

    /**
     * 校验当前接口并发数+1
     * @param sysId
     */
    public void checkLimit(final String sysId) {
        long total = getTotalLimit(sysId);
        if (total <0) return;
        if(total==0)
            throw new ConnectionLimitException();
        Long current =  jedisTemplate.execute(new JedisTemplate.JedisAction<Long>() {
            @Override
            public Long action(Jedis jedis) {
                return jedis.incr(PACKAGE+sysId + CURRENT_KEY);
            }
        });

        if(current>total){
            decrLimit(sysId);
            throw new ConnectionLimitException();
        }
    }

    /**
     * 当前接口并发数-1
     * @param sysId
     */
    public void decrLimit(final String sysId) {
        long total = getTotalLimit(sysId);
        if (total <=0) return;
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                jedis.decr(PACKAGE+sysId + CURRENT_KEY);
            }
        });
    }

}
