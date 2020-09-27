package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderReturnTrackDetailModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderReturnTrackDetailDao extends SqlSessionDaoSupport {

    public Integer update(OrderReturnTrackDetailModel orderReturnTrackDetail) {
        return getSqlSession().update("OrderReturnTrackDetailModel.update", orderReturnTrackDetail);
    }


    public Integer insert(OrderReturnTrackDetailModel orderReturnTrackDetail) {
        return getSqlSession().insert("OrderReturnTrackDetailModel.insert", orderReturnTrackDetail);
    }


    public List<OrderReturnTrackDetailModel> findAll() {
        return getSqlSession().selectList("OrderReturnTrackDetailModel.findAll");
    }

    public List<OrderReturnTrackDetailModel> findAllByOrderId(Map<String, Object> params) {
        return getSqlSession().selectList("OrderReturnTrackDetailModel.findAll",params);
    }

    public OrderReturnTrackDetailModel findById(Long id) {
        return getSqlSession().selectOne("OrderReturnTrackDetailModel.findById", id);
    }
    public List<OrderReturnTrackDetailModel> findByOrderId(String orderId) {
        return getSqlSession().selectList("OrderReturnTrackDetailModel.findByOrderId", orderId);
    }
    public List<OrderReturnTrackDetailModel> findReturnByOrderId(String orderId) {
        return getSqlSession().selectList("OrderReturnTrackDetailModel.findReturnByOrderId", orderId);
    }
    public Pager<OrderReturnTrackDetailModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("OrderReturnTrackDetailModel.count", params);
        if (total == 0) {
        return Pager.empty(OrderReturnTrackDetailModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<OrderReturnTrackDetailModel> data = getSqlSession().selectList("OrderReturnTrackDetailModel.pager", paramMap);
        return new Pager<OrderReturnTrackDetailModel>(total, data);
    }


    public Integer delete(OrderReturnTrackDetailModel orderReturnTrackDetail) {
        return getSqlSession().delete("OrderReturnTrackDetailModel.delete", orderReturnTrackDetail);
    }
}