package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderClearModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderClearDao extends SqlSessionDaoSupport {

    public Integer update(OrderClearModel orderClear) {
        return getSqlSession().update("OrderClearModel.update", orderClear);
    }


    public Integer insert(OrderClearModel orderClear) {
        return getSqlSession().insert("OrderClearModel.insert", orderClear);
    }

    /**
     * 批量插入订单清算表
     *
     * @param orderClearModelList
     * @return
     */
    public Integer insertBatch(List orderClearModelList) {
        return getSqlSession().insert("OrderClearModel.insertBatch", orderClearModelList);
    }
    public List<OrderClearModel> findAll() {
        return getSqlSession().selectList("OrderClearModel.findAll");
    }

    public OrderClearModel findByOrderId(String orderId) {
        return getSqlSession().selectOne("OrderClearModel.findByOrderId",orderId);
    }

    public OrderClearModel findById(Long id) {
        return getSqlSession().selectOne("OrderClearModel.findById", id);
    }


    public Pager<OrderClearModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("OrderClearModel.count", params);
        if (total == 0) {
        return Pager.empty(OrderClearModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<OrderClearModel> data = getSqlSession().selectList("OrderClearModel.pager", paramMap);
        return new Pager<OrderClearModel>(total, data);
    }


    public Integer delete(OrderClearModel orderClear) {
        return getSqlSession().delete("OrderClearModel.delete", orderClear);
    }
}