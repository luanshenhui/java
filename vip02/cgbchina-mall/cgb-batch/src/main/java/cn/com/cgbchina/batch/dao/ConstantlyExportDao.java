package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.OrderExportModel;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Transaction;

import java.io.*;

/**
 * @author wenjia.hao
 * @version 1.0
 */
@Repository
@Slf4j
public class ConstantlyExportDao extends RedisBaseDao<OrderExportModel> {

    @Autowired
    public ConstantlyExportDao(JedisTemplate jedisTemplate) {
        super(jedisTemplate);
    }
    public void create(final String key, final Object value , final Integer time) {
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Transaction multi = jedis.multi();
                multi.set(key.getBytes(), ConstantlyExportDao.serialize(value));
                if(time != null){
                    multi.expire(key, time);
                }
                multi.exec();
            }
        });
    }

    private static byte[] serialize(Object value) {
        if (value == null) {
            throw new NullPointerException("Can't serialize null");
        }
        byte[] rv=null;
        ByteArrayOutputStream bos = null;
        ObjectOutputStream os = null;
        try {
            bos = new ByteArrayOutputStream();
            os = new ObjectOutputStream(bos);
            os.writeObject(value);
            os.close();
            bos.close();
            rv = bos.toByteArray();
        } catch (IOException e) {
            throw new IllegalArgumentException("Non-serializable object", e);
        } finally {
            try {
                if(os!=null)os.close();
                if(bos!=null)bos.close();
            }catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return rv;
    }

    public void delete(final String key){
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                jedis.del(key.getBytes());
            }
        });
    }
    public Object get(final String key) {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<Object>() {
            @Override
            public Object action(Jedis jedis) {
                byte[] out = jedis.get(key.getBytes());
                return deserialize(out);
            }
        });
    }
    private static Object deserialize(byte[] in) {
        Object rv=null;
        ByteArrayInputStream bis = null;
        ObjectInputStream is = null;
        try {
            if(in != null) {
                bis=new ByteArrayInputStream(in);
                is=new ObjectInputStream(bis);
                rv=is.readObject();
                is.close();
                bis.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            try {
                if(is!=null)is.close();
                if(bis!=null)bis.close();
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return rv;
    }
}
