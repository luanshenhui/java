package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GroupClassify;
import com.spirit.common.model.PageInfo;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.KeyUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.SortingParams;
import redis.clients.jedis.Transaction;

import java.util.List;

/**
 * Created by 1115012105001 on 2016/11/1.
 */
@Repository
@Slf4j
public class GroupClassifyRedisDao extends RedisBaseDao<GroupClassify> {

    private final String GROUP_CLASSIFY_ALL = "group-classify-all";

    @Autowired
    public GroupClassifyRedisDao(JedisTemplate jedisTemplate) {
        super(jedisTemplate);
    }

    public void groupClassifyAdd(final String name) {
        final Long id = newId();
        final String key = KeyUtil.entityId(GroupClassify.class, id);
        final GroupClassify groupClassify = new GroupClassify();
        groupClassify.setId(id);
        groupClassify.setName(name);
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Transaction multi = jedis.multi();
                multi.hmset(key, stringHashMapper.toHash(groupClassify));
                multi.set("group:classify:" + name, String.valueOf(id));
                multi.lpush(GROUP_CLASSIFY_ALL, String.valueOf(id));
                multi.exec();
            }
        });
    }

    public void groupClassifyDel(final Long id) {
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                final GroupClassify oldGroupClassify = findByKey(id);
                Transaction multi = jedis.multi();
                multi.del(KeyUtil.entityId(GroupClassify.class, id));
                multi.lrem(GROUP_CLASSIFY_ALL, 0L, String.valueOf(id));
                multi.del("group:classify:" + oldGroupClassify.getName());
                multi.exec();
            }
        });
    }

    public List<GroupClassify> findByPager(final PageInfo pageInfo) {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<List<GroupClassify>>() {
            @Override
            public List<GroupClassify> action(Jedis jedis) {
                SortingParams sortingParams=new SortingParams();
                sortingParams.limit(pageInfo.getOffset(),pageInfo.getLimit());
                List<String> sort = jedis.sort(GROUP_CLASSIFY_ALL, sortingParams);
                return findByIds(sort);
            }
        });

    }

    public Long allKeySize() {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<Long>() {
            @Override
            public Long action(Jedis jedis) {
                return jedis.llen(GROUP_CLASSIFY_ALL);
            }
        });
    }

    public List<GroupClassify> allGroupClassify(){
        List<String> keys = jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
            @Override
            public List<String> action(Jedis jedis) {
                return jedis.lrange(GROUP_CLASSIFY_ALL, 0L, -1L);
            }
        });
        return findByIds(keys);
    }


}
