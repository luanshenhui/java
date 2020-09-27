package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsBrandAdvertiseModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsBrandAdvertiseDao extends SqlSessionDaoSupport {

    public Integer update(GoodsBrandAdvertiseModel goodsBrandAdvertise) {
        return getSqlSession().update("GoodsBrandAdvertiseModel.update", goodsBrandAdvertise);
    }


    public Integer insert(GoodsBrandAdvertiseModel goodsBrandAdvertise) {
        return getSqlSession().insert("GoodsBrandAdvertiseModel.insert", goodsBrandAdvertise);
    }


    public List<GoodsBrandAdvertiseModel> findAll() {
        return getSqlSession().selectList("GoodsBrandAdvertiseModel.findAll");
    }


    public GoodsBrandAdvertiseModel findById(Long id) {
        return getSqlSession().selectOne("GoodsBrandAdvertiseModel.findById", id);
    }


    public Pager<GoodsBrandAdvertiseModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("GoodsBrandAdvertiseModel.count", params);
        if (total == 0) {
        return Pager.empty(GoodsBrandAdvertiseModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<GoodsBrandAdvertiseModel> data = getSqlSession().selectList("GoodsBrandAdvertiseModel.pager", paramMap);
        return new Pager<GoodsBrandAdvertiseModel>(total, data);
    }


    public Integer delete(GoodsBrandAdvertiseModel goodsBrandAdvertise) {
        return getSqlSession().delete("GoodsBrandAdvertiseModel.delete", goodsBrandAdvertise);
    }

    public GoodsBrandAdvertiseModel findByBrandId(Long id) {
        return getSqlSession().selectOne("GoodsBrandAdvertiseModel.findByBrandId", id);
    }

    public Integer updateByBrandId(GoodsBrandAdvertiseModel goodsBrandAdvertise) {
        return getSqlSession().update("GoodsBrandAdvertiseModel.updateByBrandId", goodsBrandAdvertise);
    }
}