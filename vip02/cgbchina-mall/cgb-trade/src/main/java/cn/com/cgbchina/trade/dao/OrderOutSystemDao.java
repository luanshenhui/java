package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderOutSystemModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderOutSystemDao extends SqlSessionDaoSupport {

    public Integer update(OrderOutSystemModel orderOutSystem) {
        return getSqlSession().update("OrderOutSystemModel.update", orderOutSystem);
    }


    public Integer insert(OrderOutSystemModel orderOutSystem) {
        return getSqlSession().insert("OrderOutSystemModel.insert", orderOutSystem);
    }


    public List<OrderOutSystemModel> findAll(Map<String, Object> params) {
        return getSqlSession().selectList("OrderOutSystemModel.findAll",params);
    }


    public OrderOutSystemModel findById(Long id) {
        return getSqlSession().selectOne("OrderOutSystemModel.findById", id);
    }


    public Pager<OrderOutSystemModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("OrderOutSystemModel.count", params);
        if (total == 0) {
            return Pager.empty(OrderOutSystemModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<OrderOutSystemModel> data = getSqlSession().selectList("OrderOutSystemModel.pager", paramMap);
        return new Pager<OrderOutSystemModel>(total, data);
    }


    public Integer delete(OrderOutSystemModel orderOutSystem) {
        return getSqlSession().delete("OrderOutSystemModel.delete", orderOutSystem);
    }

    public OrderOutSystemModel findHanleTuiSongMsg(String orderId) {
        OrderOutSystemModel orderOutSystemModel = new OrderOutSystemModel();
        orderOutSystemModel.setOrderId(orderId);
        orderOutSystemModel.setTuisongFlag("0");
        return getSqlSession().selectOne("OrderOutSystemModel.findHanleTuiSongMsg", orderOutSystemModel);
    }

    public Integer updateTuiSongMsg(OrderOutSystemModel orderOutSystem) {
        return getSqlSession().update("OrderOutSystemModel.updateTuiSongMsg", orderOutSystem);
    }

    public Integer updateByFlag(Map<String,Object> dataMap){
        return getSqlSession().update("OrderOutSystemModel.updateByFlag", dataMap) ;
    }

    public List<OrderOutSystemModel> findByOrderId(String orderId) {
        return getSqlSession().selectList("OrderOutSystemModel.findByOrderId", orderId);
    }
}