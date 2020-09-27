package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderCheckModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderCheckDao extends SqlSessionDaoSupport {

    public Integer update(OrderCheckModel orderCheck) {
        return getSqlSession().update("OrderCheckModel.update", orderCheck);
    }


    public Integer insert(OrderCheckModel orderCheck) {
        return getSqlSession().insert("OrderCheckModel.insert", orderCheck);
    }


    public List<OrderCheckModel> findAll() {
        return getSqlSession().selectList("OrderCheckModel.findAll");
    }


    public OrderCheckModel findById(Long id) {
        return getSqlSession().selectOne("OrderCheckModel.findById", id);
    }


    public Pager<OrderCheckModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("OrderCheckModel.count", params);
        if (total == 0) {
        return Pager.empty(OrderCheckModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<OrderCheckModel> data = getSqlSession().selectList("OrderCheckModel.pager", paramMap);
        return new Pager<OrderCheckModel>(total, data);
    }


    public Integer delete(OrderCheckModel orderCheck) {
        return getSqlSession().delete("OrderCheckModel.delete", orderCheck);
    }
}