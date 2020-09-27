package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderCancelModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderCancelDao extends SqlSessionDaoSupport {

    public Integer update(OrderCancelModel orderCancel) {
        return getSqlSession().update("OrderCancelModel.update", orderCancel);
    }


    public Integer insert(OrderCancelModel orderCancel) {
        return getSqlSession().insert("OrderCancelModel.insert", orderCancel);
    }


    public List<OrderCancelModel> findAll() {
        return getSqlSession().selectList("OrderCancelModel.findAll");
    }


    public OrderCancelModel findById(Long orderCancelId) {
        return getSqlSession().selectOne("OrderCancelModel.findById", orderCancelId);
    }

    public List<OrderCancelModel> findByOrderId(String orderId) {
        return getSqlSession().selectList("OrderCancelModel.findByOrderId", orderId);
    }


    public Pager<OrderCancelModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("OrderCancelModel.count", params);
        if (total == 0) {
        return Pager.empty(OrderCancelModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<OrderCancelModel> data = getSqlSession().selectList("OrderCancelModel.pager", paramMap);
        return new Pager<OrderCancelModel>(total, data);
    }


    public Integer delete(OrderCancelModel orderCancel) {
        return getSqlSession().delete("OrderCancelModel.delete", orderCancel);
    }
}