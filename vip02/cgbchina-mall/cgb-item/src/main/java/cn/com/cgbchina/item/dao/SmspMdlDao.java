package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.SmspMdlModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class SmspMdlDao extends SqlSessionDaoSupport {

    public Integer update(SmspMdlModel smspMdl) {
        return getSqlSession().update("SmspMdlModel.update", smspMdl);
    }


    public Integer insert(SmspMdlModel smspMdl) {
        return getSqlSession().insert("SmspMdlModel.insert", smspMdl);
    }


    public List<SmspMdlModel> findAll() {
        return getSqlSession().selectList("SmspMdlModel.findAll");
    }


    public SmspMdlModel findById(String smspId) {
        return getSqlSession().selectOne("SmspMdlModel.findById", smspId);
    }

    public Map findAllById(String smspId) {
        return getSqlSession().selectOne("SmspMdlModel.findAllById", smspId);
    }


    public Pager<SmspMdlModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("SmspMdlModel.count", params);
        if (total == 0) {
        return Pager.empty(SmspMdlModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<SmspMdlModel> data = getSqlSession().selectList("SmspMdlModel.pager", paramMap);
        return new Pager<SmspMdlModel>(total, data);
    }


    public Integer delete(SmspMdlModel smspMdl) {
        return getSqlSession().delete("SmspMdlModel.delete", smspMdl);
    }
}