package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.EspAdvertiseModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class EspAdvertiseDao extends SqlSessionDaoSupport {

    public Integer update(EspAdvertiseModel espAdvertise) {
        return getSqlSession().update("EspAdvertiseModel.update", espAdvertise);
    }


    public Integer insert(EspAdvertiseModel espAdvertise) {
        return getSqlSession().insert("EspAdvertiseModel.insert", espAdvertise);
    }


    public List<EspAdvertiseModel> findAll() {
        return getSqlSession().selectList("EspAdvertiseModel.findAll");
    }


    public EspAdvertiseModel findById(Long id) {
        return getSqlSession().selectOne("EspAdvertiseModel.findById", id);
    }


    public Pager<EspAdvertiseModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("EspAdvertiseModel.count", params);
        if (total == 0) {
        return Pager.empty(EspAdvertiseModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<EspAdvertiseModel> data = getSqlSession().selectList("EspAdvertiseModel.pager", paramMap);
        return new Pager<EspAdvertiseModel>(total, data);
    }


    public Integer delete(EspAdvertiseModel espAdvertise) {
        return getSqlSession().delete("EspAdvertiseModel.delete", espAdvertise);
    }
    public Integer updateAdvetiseStatus(EspAdvertiseModel espAdvertise) {
        return getSqlSession().update("EspAdvertiseModel.updateAdvetiseStatus", espAdvertise);
    }
    public Integer updateIsStop(EspAdvertiseModel espAdvertise) {
        return getSqlSession().update("EspAdvertiseModel.updateIsStop", espAdvertise);
    }
}