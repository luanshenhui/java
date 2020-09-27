package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.BatchSmspCustModel;
import cn.com.cgbchina.batch.model.BatchSmspInfModel;
import cn.com.cgbchina.batch.model.BatchSmspRecordModel;
import cn.com.cgbchina.item.model.SmspCustModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class BatchSmspInfDao extends SqlSessionDaoSupport {

    public Integer update(BatchSmspInfModel smspInf) {
        return getSqlSession().update("BatchSmspInfModel.update", smspInf);
    }
    /**
     * 根据短信维护表id查询所有名单
     *
     * @param id
     * @return
     */
    public List<String> findSmspCustById(Long id, int offset, int limit) {
        Map<String, Object> param = Maps.newHashMap();
        param.put("id", id);
        param.put("offset", offset);
        param.put("limit", limit);
        return getSqlSession().selectList("BatchSmspInfModel.findSmspCustById", param);
    }

    public int countSmspCustById(Long id) {
        return getSqlSession().selectOne("BatchSmspInfModel.countSmspCustById", id);
    }

    public Integer insertBatch(List<BatchSmspCustModel> smspCusts) {
        return getSqlSession().insert("BatchSmspInfModel.insertBatch", smspCusts);
    }
    public Integer updateBatch(List<BatchSmspCustModel> smspCusts) {
        return getSqlSession().update("BatchSmspInfModel.updateBatch", smspCusts);
    }

    public Integer insert(BatchSmspRecordModel smspRecord) {
        return getSqlSession().insert("BatchSmspInfModel.insert", smspRecord);
    }

    public Integer updateSmspCust(BatchSmspCustModel smspRecord) {
        return getSqlSession().update("BatchSmspInfModel.updateSmspCust", smspRecord);
    }

    public Integer replaceBatch(List<BatchSmspCustModel> smspCusts) {
        return getSqlSession().update("BatchSmspInfModel.replaceBatch", smspCusts);
    }
}