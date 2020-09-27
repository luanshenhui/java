package cn.com.cgbchina.trade.dao;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;

import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Transaction;

/**
 * Created by 11140821050155 on 2016/9/21.
 */
@Repository
@Slf4j
public class RedisDao extends RedisBaseDao<CouponInfo> {
	@Autowired
	public RedisDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	public void create(final String key, final Object value) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Transaction multi = jedis.multi();

				multi.set(key.getBytes(), RedisDao.serialize(value));

				multi.expire(key, 60 * 10);
				multi.exec();
			}
		});
	}

	public Object get(final String key) {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<Object>() {
			@Override
			public Object action(Jedis jedis) {
				byte[] out = jedis.get(key.getBytes());
				return RedisDao.deserialize(out);
			}
		});
	}
    public void delete(final String key){
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                jedis.del(key.getBytes());
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
