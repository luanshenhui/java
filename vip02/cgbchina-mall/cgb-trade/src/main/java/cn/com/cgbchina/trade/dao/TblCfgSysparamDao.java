package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblCfgSysparamModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblCfgSysparamDao extends SqlSessionDaoSupport {

    public Integer update(TblCfgSysparamModel tblCfgSysparam) {
        return getSqlSession().update("TblCfgSysparamModel.update", tblCfgSysparam);
    }


    public Integer insert(TblCfgSysparamModel tblCfgSysparam) {
        return getSqlSession().insert("TblCfgSysparamModel.insert", tblCfgSysparam);
    }


    public List<TblCfgSysparamModel> findAll() {
        return getSqlSession().selectList("TblCfgSysparamModel.findAll");
    }


    public TblCfgSysparamModel findById(String paramId) {
        return getSqlSession().selectOne("TblCfgSysparamModel.findById", paramId);
    }


    public Pager<TblCfgSysparamModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblCfgSysparamModel.count", params);
        if (total == 0) {
        return Pager.empty(TblCfgSysparamModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblCfgSysparamModel> data = getSqlSession().selectList("TblCfgSysparamModel.pager", paramMap);
        return new Pager<TblCfgSysparamModel>(total, data);
    }


    public Integer delete(TblCfgSysparamModel tblCfgSysparam) {
        return getSqlSession().delete("TblCfgSysparamModel.delete", tblCfgSysparam);
    }
}