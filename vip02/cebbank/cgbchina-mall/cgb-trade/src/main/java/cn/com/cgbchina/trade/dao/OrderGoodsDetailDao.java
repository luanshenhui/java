package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderGoodsDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Deprecated
public class OrderGoodsDetailDao extends SqlSessionDaoSupport {

    public Integer update(OrderGoodsDetailModel orderGoodsDetailModel) {
        return getSqlSession().update("OrderGoodsDetail.update", orderGoodsDetailModel);
    }

    public Integer insert(OrderGoodsDetailModel orderGoodsDetailModel) {
        return getSqlSession().insert("OrderGoodsDetail.insert", orderGoodsDetailModel);
    }

    /**
     * 批量插入订单商品详情表信息
     *
     * @param orderGoodsDetailModelList
     * @return
     */
    public Integer insertBatch(List orderGoodsDetailModelList) {
        return getSqlSession().insert("OrderGoodsDetail.insertBatch", orderGoodsDetailModelList);
    }

    public List<OrderGoodsDetailModel> findAll() {
        return getSqlSession().selectList("OrderGoodsDetail.findAll");
    }

    public OrderGoodsDetailModel findById(Long id) {
        return getSqlSession().selectOne("OrderGoodsDetail.findById", id);
    }

    public Pager<OrderGoodsDetailModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("OrderGoodsDetail.count", params);
        if (total == 0) {
            return Pager.empty(OrderGoodsDetailModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<OrderGoodsDetailModel> data = getSqlSession().selectList("OrderGoodsDetail.pager", paramMap);
        return new Pager<OrderGoodsDetailModel>(total, data);
    }

    public Integer delete(OrderGoodsDetailModel orderGoodsDetailModel) {
        return getSqlSession().delete("OrderGoodsDetail.delete", orderGoodsDetailModel);
    }

    public List<OrderGoodsDetailModel> findTopOrder(List<OrderSubModel> subList) {
        return getSqlSession().selectList("OrderGoodsDetail.findTop", subList);
    }

    public List<OrderGoodsDetailModel> findTopGoods(List<OrderSubModel> subList) {
        return getSqlSession().selectList("OrderGoodsDetail.findTopGoods", subList);
    }

    public OrderGoodsDetailModel findByOrderId(Map<String, Object> params) {
        return getSqlSession().selectOne("OrderGoodsDetail.findAll", params);
    }
}