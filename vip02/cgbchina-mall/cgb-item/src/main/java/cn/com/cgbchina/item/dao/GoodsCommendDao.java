package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsCommendModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsCommendDao extends SqlSessionDaoSupport {

    public Integer update(GoodsCommendModel goodsCommend) {
        return getSqlSession().update("GoodsCommendModel.update", goodsCommend);
    }


    public Integer insert(GoodsCommendModel goodsCommend) {
        return getSqlSession().insert("GoodsCommendModel.insert", goodsCommend);
    }


    public List<GoodsCommendModel> findAll() {
        return getSqlSession().selectList("GoodsCommendModel.findAll");
    }


    public GoodsCommendModel findById(Long id) {
        return getSqlSession().selectOne("GoodsCommendModel.findById", id);
    }


    public Pager<GoodsCommendModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("GoodsCommendModel.count", params);
        if (total == 0) {
        return Pager.empty(GoodsCommendModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<GoodsCommendModel> data = getSqlSession().selectList("GoodsCommendModel.pager", paramMap);
        return new Pager<GoodsCommendModel>(total, data);
    }


    public Integer delete(GoodsCommendModel goodsCommend) {
        return getSqlSession().delete("GoodsCommendModel.delete", goodsCommend);
    }

    public List<GoodsCommendModel> findGoodsCommends(String brandId) {
        return getSqlSession().selectList("GoodsCommendModel.findGoodsCommendsByTypeId", brandId);
    }

    public Long countByBrandId(String brandId){
        return getSqlSession().selectOne("GoodsCommendModel.countByBrandId", brandId);
    }

    public GoodsCommendModel findByGoodsId(String goodsId){
        return getSqlSession().selectOne("GoodsCommendModel.findByGoodsId", goodsId);
    }

    public GoodsCommendModel findByModel(GoodsCommendModel goodsCommend){
        return getSqlSession().selectOne("GoodsCommendModel.findByModel", goodsCommend);
    }
}