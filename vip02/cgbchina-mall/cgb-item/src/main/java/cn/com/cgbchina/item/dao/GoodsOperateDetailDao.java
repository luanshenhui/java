package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsOperateDetailModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsOperateDetailDao extends SqlSessionDaoSupport {

    public Integer update(GoodsOperateDetailModel goodsOperateDetail) {
        return getSqlSession().update("GoodsOperateDetailModel.update", goodsOperateDetail);
    }


    public Integer insert(GoodsOperateDetailModel goodsOperateDetail) {
        return getSqlSession().insert("GoodsOperateDetailModel.insert", goodsOperateDetail);
    }


    public List<GoodsOperateDetailModel> findAll() {
        return getSqlSession().selectList("GoodsOperateDetailModel.findAll");
    }


    public GoodsOperateDetailModel findById(Long id) {
        return getSqlSession().selectOne("GoodsOperateDetailModel.findById", id);
    }


    public Pager<GoodsOperateDetailModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("GoodsOperateDetailModel.count", params);
        if (total == 0) {
        return Pager.empty(GoodsOperateDetailModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<GoodsOperateDetailModel> data = getSqlSession().selectList("GoodsOperateDetailModel.pager", paramMap);
        return new Pager<GoodsOperateDetailModel>(total, data);
    }


    public Integer delete(GoodsOperateDetailModel goodsOperateDetail) {
        return getSqlSession().delete("GoodsOperateDetailModel.delete", goodsOperateDetail);
    }
}