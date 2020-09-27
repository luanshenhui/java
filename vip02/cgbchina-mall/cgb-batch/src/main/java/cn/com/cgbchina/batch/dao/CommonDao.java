package cn.com.cgbchina.batch.dao;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by 11150121050003 on 2016/9/5.
 */
@Repository
public class CommonDao extends BaseDao{

    /**
     * 得到需要迁移的当前表记录的行数
     * @param dateName
     * @param transferDate
     * @param orgTableName
     * @return
     */
    public Integer getTableRowsSum(String dateName, String transferDate, String orgTableName) {
        Map<String,Object> params = Maps.newHashMap();
        params.put("dateName",dateName);
        params.put("transferDate",transferDate);
        params.put("orgTableName",orgTableName);
        return getSqlSession().selectOne("CommonDao.getTableRowsSum",params);
    }

    /**
     * 得到需要迁移的当前表记录
     * @param idName
     * @param dateName
     * @param transferDate
     * @param orgTableName
     * @param rows
     * @return
     */
    public List<Map<String,Object>> getFirstRowsTable(String idName, String dateName, String transferDate, String orgTableName, Integer rows) {
        Map<String,Object> params = Maps.newHashMap();
        params.put("idName",idName);
        params.put("orgTableName",orgTableName);
        params.put("dateName",dateName);
        params.put("transferDate",transferDate);
        params.put("rows",rows);
        return getSqlSession().selectList("CommonDao.getFirstRowsTable",params);
    }

    /**
     * 插入小订单相关表
     * @param orgTableName
     * @param targetTableName
     * @param idName
     * @param idList
     * @return
     */
    public Integer insertOrderTable(String orgTableName,String targetTableName,String idName,List<String> idList){
        Map<String,Object> params = Maps.newHashMap();
        params.put("orgTableName",orgTableName);
        params.put("targetTableName",targetTableName);
        params.put("idName",idName);
        params.put("idList",idList);
        return getSqlSession().insert("CommonDao.insertOrderTable",params);
    }

    /**
     * 插入大订单相关表
     * @param orgTableName
     * @param targetTableName
     * @param idName
     * @param idList
     * @return
     */
    public Integer insertOrderMainTable(String orgTableName,String targetTableName,String idName,List<String> idList){
        Map<String,Object> params = Maps.newHashMap();
        params.put("orgTableName",orgTableName);
        params.put("targetTableName",targetTableName);
        params.put("idName",idName);
        params.put("idList",idList);
        return getSqlSession().insert("CommonDao.insertOrderMainTable",params);
    }

    /**
     * 插入订单处理历史相关表
     * @param orgTableName
     * @param targetTableName
     * @param idName
     * @param idList
     * @return
     */
    public Integer insertOrderDoDetailTable(String orgTableName,String targetTableName,String idName,List<String> idList){
        Map<String,Object> params = Maps.newHashMap();
        params.put("orgTableName",orgTableName);
        params.put("targetTableName",targetTableName);
        params.put("idName",idName);
        params.put("idList",idList);
        return getSqlSession().insert("CommonDao.insertOrderDoDetailTable",params);
    }

    /**
     * 插入关键字相关表
     * @param orgTableName
     * @param targetTableName
     * @param idName
     * @param idList
     * @return
     */
    public Integer insertKeyWordTable(String orgTableName,String targetTableName,String idName,List<String> idList){
        Map<String,Object> params = Maps.newHashMap();
        params.put("orgTableName",orgTableName);
        params.put("targetTableName",targetTableName);
        params.put("idName",idName);
        params.put("idList",idList);
        return getSqlSession().insert("CommonDao.insertKeyWordTable",params);
    }

    public Integer deleteTable(String orgTableName,String idName,List<String> idList){
        Map<String,Object> params = Maps.newHashMap();
        params.put("orgTableName",orgTableName);
        params.put("idName",idName);
        params.put("idList",idList);
        return getSqlSession().delete("CommonDao.deleteTable",params);
    }
}
