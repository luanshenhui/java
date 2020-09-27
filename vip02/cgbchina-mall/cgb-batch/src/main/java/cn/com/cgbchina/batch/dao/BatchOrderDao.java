package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.BatchOrderModel;
import cn.com.cgbchina.batch.model.ItemModel;
import cn.com.cgbchina.batch.model.OrderCheckModel;
import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import com.google.common.collect.Maps;
import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by 11150121040023 on 2016/7/14.
 */
@Repository
public class BatchOrderDao extends BaseDao<BatchOrderModel> {

    public Integer getCountOverOrder(String date) {
        return getSqlSession().selectOne("BatchOrder.getCountOverOrder", date);
    }
    public List<BatchOrderModel> getOverOrders(String date, int offset, int limit) {
        Map<String, Object> param = Maps.newHashMap();
        param.put("create_time", date);
        param.put("offset", offset);
        param.put("limit", limit);
        return getSqlSession().selectList("BatchOrder.getOverOrders", param);
    }

    public void updateOrderStatus(Map<String, Object> paramMap) {
        getSqlSession().update("BatchOrder.updateOrderStatus", paramMap);
    }

    public List<OrderCheckModel> orderCancelService(String orderId) {
        return getSqlSession().selectList("BatchOrder.orderCancelService", orderId);
    }

    public void saveTblOrderCheck(OrderCheckModel orderCheckModel) {
        getSqlSession().insert("BatchOrder.insertOrderCheckModel", orderCheckModel);
    }

    public void updateOrderMainStatus(Map<String, Object> paramMap) {
        getSqlSession().update("BatchOrder.update", paramMap);
    }

    public void updateGoodsJF(ItemModel item) {
        getSqlSession().update("BatchOrder.updateGoodsJF", item);
    }

    public void updateGoodsYG(ItemModel item) {
        getSqlSession().update("BatchOrder.updateGoodsYG", item);
    }

    public void dealPointPoolForDate(Map<String, Object> paramMap){
        getSqlSession().update("BatchOrder.dealPointPoolForDate",paramMap);
    }
    // 插入订单处理历史明细表
    public Integer insertOrderDoDetail(OrderDoDetailModel orderDoDetailModel) {
        return getSqlSession().insert("BatchOrder.insertOrderDoDetail", orderDoDetailModel);
    }

    public Integer getTblEspCustNew(String param) {
        return getSqlSession().selectOne("BatchOrder.getTblEspCustNew", param);
    }

    public void updateTblEspCustNew(Map<String, Object> paramMap) {
        getSqlSession().update("BatchOrder.updateTblEspCustNew", paramMap);
    }

    public void updateTblEspCustNew0(Map<String, Object> paramMap) {
        getSqlSession().update("BatchOrder.updateTblEspCustNew0", paramMap);
    }
}
