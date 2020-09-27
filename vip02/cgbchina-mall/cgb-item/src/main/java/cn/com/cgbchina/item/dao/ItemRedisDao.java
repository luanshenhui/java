/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.dto.ItemStockDto;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.KeyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Pipeline;

import java.util.List;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/7/11.
 */

@Repository
public class ItemRedisDao extends RedisBaseDao<ItemStockDto>{

    @Autowired
    public ItemRedisDao(JedisTemplate jedisTemplate) {
        super(jedisTemplate);
    }

    /**
     * 批量插入
     * @param itemStockList
     */
    public void insertAll(final List<ItemStockDto> itemStockList){
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                for(ItemStockDto itemStockDto:itemStockList){
                    pipelined.hmset(KeyUtil.entityId(ItemStockDto.class,itemStockDto.getItemCode()),stringHashMapper.toHash(itemStockDto));
                }
                pipelined.sync();
            }
        });
    }

    /**
     * 更新
     */
    public void update(final String itemCode, final Long stock){

        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                jedis.hset(KeyUtil.entityId(ItemStockDto.class, itemCode),"stock",String.valueOf(stock));
            }
       });
    }

    /**
     * 插入操作
     * @param userId
     * @param level
     */
    public void insert(final String userId, final String level){
        final String key="userlevels:" + userId;
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                pipelined.set(key,level);
                pipelined.expire(key,600);
                pipelined.sync();
            }
        });
    }
    /**
     * 插入操作
     * @param userId
     */
    public String get(final String userId) {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
            @Override
            public String action(Jedis jedis) {
                String level = jedis.get("userlevels:" +userId);
                return level;
            }
        });
    }
}

