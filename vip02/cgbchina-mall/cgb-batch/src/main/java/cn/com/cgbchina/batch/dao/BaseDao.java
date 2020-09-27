package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.BaseModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.util.List;

/**
 * Created by 11150121040023 on 2016/7/14.
 */
public abstract class BaseDao<M extends BaseModel> extends SqlSessionDaoSupport {

    private String key;
    public BaseDao() {
    }
    public BaseDao(String key) {
        this.key = key;
    }

    public List<M> selectAll() {
        return getSqlSession().selectList(key + ".selectAll");
    }

    public int deleteByPrimaryKey(Integer id) {
        return getSqlSession().insert(key + ".deleteByPrimaryKey", id);
    }

    public M selectByPrimaryKey(Integer id) {
        return getSqlSession().selectOne(key + ".selectByPrimaryKey", id);
    }

    public int insert(M record) {
        return getSqlSession().insert(key + ".insert", record);
    }

    public int updateByPrimaryKey(M record) {
        return getSqlSession().update(key + ".updateByPrimaryKey", record);
    }

    public List<M> selectByObj(M record) {
        return getSqlSession().selectList(key + ".selectByObj", record);
    }
    public int deleteByObj(M record) {
        return getSqlSession().delete(key + ".deleteByObj", record);
    }
}
