package com.hepowdhc.dcapp.dao;

import com.hepowdhc.dcapp.bean.MapperBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

import java.util.List;
import java.util.Map;

/**
 * Created by fzxs on 16-12-14.
 */
public abstract class BaseDao {

    protected Logger logger = LoggerFactory.getLogger(getClass());

    @Autowired
    protected JdbcTemplate jdbcTemplate;

    @Autowired
    protected NamedParameterJdbcTemplate namedParameterJdbcTemplate;


    protected List<Map<String, Object>> query(String sql, MapperBean mapper) {

        return jdbcTemplate.query(sql, (resultSet, i) -> {


            Map<String, Object> map = mapper.copy(resultSet);

            return map;
        });
    }

    /**
     * 批量插入数据
     * @param sql
     * @param params
     * @param mapper
     */
    protected void batchInsert(String sql, Map<String, Object>[] params, MapperBean mapper) {
        namedParameterJdbcTemplate.batchUpdate(sql, params);
    }
    
    /**
     * 批量更新数据
     * @param sql
     * @param params
     * @param mapper
     */
    protected void batchUpdate(String sql, Map<String, Object>[] params, MapperBean mapper) {
        namedParameterJdbcTemplate.batchUpdate(sql, params);
    }

    /**
     * 插入数据
     * @param sql
     * @param paramMap
     * @param mapper
     */
    protected void insert(String sql, Map<String, Object> paramMap, MapperBean mapper) {
        namedParameterJdbcTemplate.update(sql,paramMap);
    }

    /**
     * 带参数的查询
     * @param sql
     * @param mapper
     * @param paramMap
     * @return
     */
    protected List<Map<String, Object>> queryByParams(String sql, MapperBean mapper,Map<String,Object> paramMap) {
        return namedParameterJdbcTemplate.query(sql,paramMap,(resultSet, i) -> {
            Map<String, Object> map = mapper.copy(resultSet);
            return map;
        });
    }

    /**
     * 带参数的查询,查询结果是一个map
     * @param sql
     * @param mapper
     * @param paramMap
     * @return
     */
    protected  Map<String, Object> queryForMap(String sql, MapperBean mapper,Map<String,Object> paramMap){
        return namedParameterJdbcTemplate.queryForMap(sql, paramMap);
    }

    /**
     * 更新数据
     * @param sql
     * @param paramMap
     */
    protected void update(String sql, Map<String, Object> paramMap){
        namedParameterJdbcTemplate.update(sql, paramMap);
    }

}
