package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsPointRegionModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsPointRegionDao extends SqlSessionDaoSupport {

    public Integer update(GoodsPointRegionModel goodsPointRegion) {
        return getSqlSession().update("GoodsPointRegionModel.update", goodsPointRegion);
    }


    public Integer insert(GoodsPointRegionModel goodsPointRegion) {
        return getSqlSession().insert("GoodsPointRegionModel.insert", goodsPointRegion);
    }


    public List<GoodsPointRegionModel> findAll() {
        return getSqlSession().selectList("GoodsPointRegionModel.findAll");
    }


    public GoodsPointRegionModel findById(Integer regionId) {
        return getSqlSession().selectOne("GoodsPointRegionModel.findById", regionId);
    }


    public Pager<GoodsPointRegionModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("GoodsPointRegionModel.count", params);
        if (total == 0) {
            return Pager.empty(GoodsPointRegionModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<GoodsPointRegionModel> data = getSqlSession().selectList("GoodsPointRegionModel.pager", paramMap);
        return new Pager<GoodsPointRegionModel>(total, data);
    }


    public Integer delete(GoodsPointRegionModel goodsPointRegion) {
        return getSqlSession().delete("GoodsPointRegionModel.delete", goodsPointRegion);
    }

    public List<GoodsPointRegionModel> findGoodsPointRegionList() {
        return getSqlSession().selectList("GoodsPointRegionModel.findGoodsPointRegionList");
    }

    /**
     * 删除积分区间
     *
     * @param param
     * @return
     */
    public Integer deletePointsRegion(Map<String,Object> param) {
        return getSqlSession().update("GoodsPointRegionModel.deletePointsRegion", param);
    }
}