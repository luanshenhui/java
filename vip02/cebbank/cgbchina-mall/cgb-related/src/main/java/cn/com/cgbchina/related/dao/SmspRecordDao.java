package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.SmspRecordModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class SmspRecordDao extends SqlSessionDaoSupport {

    public Integer update(SmspRecordModel smspRecord) {
        return getSqlSession().update("SmspRecordModel.update", smspRecord);
    }


    public Integer insert(SmspRecordModel smspRecord) {
        return getSqlSession().insert("SmspRecordModel.insert", smspRecord);
    }


    public List<SmspRecordModel> findAll() {
        return getSqlSession().selectList("SmspRecordModel.findAll");
    }


    public SmspRecordModel findById(Long id) {
        return getSqlSession().selectOne("SmspRecordModel.findById", id);
    }


    public Pager<SmspRecordModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("SmspRecordModel.count", params);
        if (total == 0) {
        return Pager.empty(SmspRecordModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<SmspRecordModel> data = getSqlSession().selectList("SmspRecordModel.pager", paramMap);
        return new Pager<SmspRecordModel>(total, data);
    }


    public Integer delete(SmspRecordModel smspRecord) {
        return getSqlSession().delete("SmspRecordModel.delete", smspRecord);
    }
}