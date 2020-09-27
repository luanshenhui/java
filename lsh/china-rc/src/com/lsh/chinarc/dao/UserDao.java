package com.lsh.chinarc.dao;

import java.io.Serializable;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import com.lsh.chinarc.domain.User;



@Repository
public class UserDao {

    @Autowired
    protected RedisTemplate<Serializable, Serializable> redisTemplate;

    public void saveUser(final User user) {
        redisTemplate.execute(new RedisCallback<Object>() {

            public Object doInRedis(RedisConnection connection) throws DataAccessException {

                connection.set(
                		redisTemplate.getStringSerializer().serialize(user.getId() + ""),
                        redisTemplate.getStringSerializer().serialize(user.getName())
//                        redisTemplate.getStringSerializer().serialize("AGE18")
                        );

                return null;
            }

        });
    }

    public User getUser(final long id) {
        return redisTemplate.execute(new RedisCallback<User>() {

            public User doInRedis(RedisConnection connection) throws DataAccessException {
                byte[] key = redisTemplate.getStringSerializer().serialize(id + "");
                if (connection.exists(key)) {
                    byte[] value = connection.get(key);
                    String name = redisTemplate.getStringSerializer().deserialize(value);
                    User user = new User();
                    user.setName(name);
                    user.setId(id);
                    return user;
                }
                return null;
            }

        });
    }

}