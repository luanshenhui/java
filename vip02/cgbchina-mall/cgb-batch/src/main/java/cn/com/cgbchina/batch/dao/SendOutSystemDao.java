package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.*;
import cn.com.cgbchina.common.utils.StringUtils;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class SendOutSystemDao extends BaseDao<ItemModel> {

    public ItemModel findByCode(String code) {
        return getSqlSession().selectOne("SendOutSystem.findByCode", code);
    }
    public String findByOrderMainId(String ordermainId) {
        return getSqlSession().selectOne("SendOutSystem.findByOrderMainId",ordermainId);
    }

    public void updateOrderOutSystem(OrderOutSystemModel orderOutSystemModel) {
        getSqlSession().update("SendOutSystem.updateByOrderId",orderOutSystemModel);
    }
    /**
     * 查询大订单对应的小订单
     *
     */
    public List<OrderList1Model> findOrderList1(String sid, String orderno) {
        Map<String, Object> param = Maps.newHashMap();
        param.put("outSystemId", sid);
        param.put("orderMainId", orderno);
        return getSqlSession().selectList("SendOutSystem.findOrderList1", param);
    }
    /**
     * 获取大订单号的List,以大订单号为单位，批次推送
     *
     */
    public List<String> findOrderMainList(String sid) {
        return getSqlSession().selectList("SendOutSystem.findOrderMainList", sid);
    }
    /**
     * 获取需要推送的外网合作商id
     *
     */
    public List<String> findOutsytemIds() {
        return getSqlSession().selectList("SendOutSystem.findOutsytemIds");
    }
}
