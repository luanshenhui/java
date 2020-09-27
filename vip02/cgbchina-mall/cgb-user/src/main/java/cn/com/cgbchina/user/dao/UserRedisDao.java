/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.dao;

import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.KeyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;

import java.util.List;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/7/2.
 */
@Repository
public class UserRedisDao extends RedisBaseDao<Object> {

    @Autowired
    public UserRedisDao(JedisTemplate jedisTemplate) {
        super(jedisTemplate);
    }

    /**
     * 查询所有登录白名单
     *
     * @return
     */
    public List<String> findWhiteCustIdList() {
        List<String> ids = jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
            public List<String> action(Jedis jedis) {
                return jedis.lrange("white-custid-list", 0L, -1L);
            }
        });
        return ids;
    }
}

