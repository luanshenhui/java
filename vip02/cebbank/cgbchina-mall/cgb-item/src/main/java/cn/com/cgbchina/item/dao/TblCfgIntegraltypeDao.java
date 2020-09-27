package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblCfgIntegraltypeDao extends SqlSessionDaoSupport {

    public Integer update(TblCfgIntegraltypeModel tblCfgIntegraltype) {
        return getSqlSession().update("TblCfgIntegraltypeModel.update", tblCfgIntegraltype);
    }


    public Integer insert(TblCfgIntegraltypeModel tblCfgIntegraltype) {
        return getSqlSession().insert("TblCfgIntegraltypeModel.insert", tblCfgIntegraltype);
    }


    public List<TblCfgIntegraltypeModel> findAll() {
        return getSqlSession().selectList("TblCfgIntegraltypeModel.findAll");
    }


    public TblCfgIntegraltypeModel findById(String integraltypeId) {
        return getSqlSession().selectOne("TblCfgIntegraltypeModel.findById", integraltypeId);
    }


    public Pager<TblCfgIntegraltypeModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblCfgIntegraltypeModel.count", params);
        if (total == 0) {
            return Pager.empty(TblCfgIntegraltypeModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblCfgIntegraltypeModel> data = getSqlSession().selectList("TblCfgIntegraltypeModel.pager", paramMap);
        return new Pager<TblCfgIntegraltypeModel>(total, data);
    }


    public Integer delete(TblCfgIntegraltypeModel tblCfgIntegraltype) {
        return getSqlSession().delete("TblCfgIntegraltypeModel.delete", tblCfgIntegraltype);
    }
}