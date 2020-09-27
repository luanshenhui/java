package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.ClearQueryModel;
import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import cn.com.cgbchina.batch.model.OrderSubModel;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by dhc on 2016/7/14.
 */
@Repository
public class ClearQueryDao extends BaseDao<ClearQueryModel>{

    /**
     * 更新清算订单状态
     * @param params
     * @return
     */
    public Integer updateClearFlagStatus(Map<String, Object> params) {
        return getSqlSession().update("ClearQuery.updateClearFlagStatus",params);
    }

    public List<ClearQueryModel> getClearOrders(String statusId) {
        return getSqlSession().selectList("ClearQuery.getClearOrders",statusId);
    }

    public Integer updateOrderClear(Map<String,Object> params){
        return getSqlSession().update("ClearQuery.updateOrderClear",params);
    }

    public Integer updateSinStatusId(Map<String,Object> params) {
        return getSqlSession().update("ClearQuery.updateSinStatusId", params);
    }

    public Integer insertOrderDoDetail(OrderDoDetailModel orderDoDetailModel){
        return getSqlSession().insert("ClearQuery.insertOrderDoDetail",orderDoDetailModel);
    }

    public Integer updateBalanceStatus(Map<String,Object> params){
        return getSqlSession().update("ClearQuery.updateBalanceStatus",params);
    }

    public List<ClearQueryModel> getClearOrdersJF(String statusId){
        return getSqlSession().selectList("ClearQuery.getClearOrdersJF",statusId);
    }

    public Map<String,Object> getCfgMsg(String birthLevel){
        return getSqlSession().selectOne("ClearQuery.getCfgMsg",birthLevel);
    }

    public OrderSubModel findOrderById(String orderId) {
        return getSqlSession().selectOne("ClearQuery.findOrderById",orderId);
    }


}
