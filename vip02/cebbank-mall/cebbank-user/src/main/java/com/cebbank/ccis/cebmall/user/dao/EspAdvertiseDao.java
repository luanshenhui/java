package com.cebbank.ccis.cebmall.user.dao;


import com.cebbank.ccis.cebmall.user.model.EspAdvertiseModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
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


    /**
     * 顺序校验
     *
     * @param checkAdvertiseSeq
     * @return
     */
    public Long checkAdvertiseSeq(String checkAdvertiseSeq) {
        Long total = getSqlSession().selectOne("EspAdvertiseModel.checkAdvertiseSeq", checkAdvertiseSeq);
        return total;
    }

    /**
     * 查询有效广告，外部接口调用
     * @param paramMap 参数Map
     * @return 广告列表
     *
     * geshuo 20160721
     */
    public List<EspAdvertiseModel> findAvailableAds(Map<String,Object> paramMap) {
        return getSqlSession().selectList("EspAdvertiseModel.findAvailableAds",paramMap);
    }
}