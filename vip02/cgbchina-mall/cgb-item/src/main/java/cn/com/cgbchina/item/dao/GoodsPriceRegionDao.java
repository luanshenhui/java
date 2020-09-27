package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsPriceRegionModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsPriceRegionDao extends SqlSessionDaoSupport {

    public Integer update(GoodsPriceRegionModel goodsPriceRegion) {
        return getSqlSession().update("GoodsPriceRegionModel.update", goodsPriceRegion);
    }


    public Integer insert(GoodsPriceRegionModel goodsPriceRegion) {
        return getSqlSession().insert("GoodsPriceRegionModel.insert", goodsPriceRegion);
    }


    public List<GoodsPriceRegionModel> findAll() {
        return getSqlSession().selectList("GoodsPriceRegionModel.findAll");
    }


    public GoodsPriceRegionModel findById(Integer regionId) {
        return getSqlSession().selectOne("GoodsPriceRegionModel.findById", regionId);
    }


    public Pager<GoodsPriceRegionModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("GoodsPriceRegionModel.count", params);
        if (total == 0) {
        return Pager.empty(GoodsPriceRegionModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<GoodsPriceRegionModel> data = getSqlSession().selectList("GoodsPriceRegionModel.pager", paramMap);
        return new Pager<GoodsPriceRegionModel>(total, data);
    }


    public Integer delete(GoodsPriceRegionModel goodsPriceRegion) {
        return getSqlSession().delete("GoodsPriceRegionModel.delete", goodsPriceRegion);
    }

    public List<GoodsPriceRegionModel> findGoodsPriceRegionList() {
        return getSqlSession().selectList("GoodsPriceRegionModel.findGoodsPriceRegionList");
    }
}