package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblBatchStatusModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblBatchStatusDao extends SqlSessionDaoSupport {

    public Integer update(TblBatchStatusModel tblBatchStatus) {
        return getSqlSession().update("TblBatchStatusModel.update", tblBatchStatus);
    }


    public Integer insert(TblBatchStatusModel tblBatchStatus) {
        return getSqlSession().insert("TblBatchStatusModel.insert", tblBatchStatus);
    }


    public List<TblBatchStatusModel> findAll() {
        return getSqlSession().selectList("TblBatchStatusModel.findAll");
    }


    public TblBatchStatusModel findById(Long id) {
        return getSqlSession().selectOne("TblBatchStatusModel.findById", id);
    }


    public Pager<TblBatchStatusModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblBatchStatusModel.count", params);
        if (total == 0) {
        return Pager.empty(TblBatchStatusModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblBatchStatusModel> data = getSqlSession().selectList("TblBatchStatusModel.pager", paramMap);
        return new Pager<TblBatchStatusModel>(total, data);
    }


    public Integer delete(TblBatchStatusModel tblBatchStatus) {
        return getSqlSession().delete("TblBatchStatusModel.delete", tblBatchStatus);
    }

    public Integer updateBatchStatus(Map<String,String> runTime) {
        return getSqlSession().update("TblBatchStatusModel.updateBatchStatus",runTime);
    }
}