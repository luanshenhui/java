package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderSubModel;
import com.fasterxml.jackson.databind.annotation.JsonValueInstantiator;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.Map;
import java.util.List;


/**
 * Created by 张成 on 16-6-27.
 */
@Repository
public class TblOrderDao2 extends SqlSessionDaoSupport {

    public Integer getCountOverOrder(Map<String, Object> paramMap) {
        return getSqlSession().selectOne("OrderSub.getCountOverOrder", paramMap);
    }

    public List<OrderSubModel> getOverOrders(Map<String, Object> paramMap) {
        return getSqlSession().selectList("OrderSub.getOverOrders", paramMap);
    }
    public void updateOrderStatus(Map<String, Object> paramMap) {
        getSqlSession().update("OrderSub.updateOrderStatus", paramMap);
    }

    public void updateOrderMainStatus(Map<String, Object> paramMap) {
        getSqlSession().update("OrderMain.update", paramMap);
    }

    public Integer getTblEspCustNew(Map<String, Object> paramMap) {
        return getSqlSession().selectOne("EspCustNew.getTblEspCustNew", paramMap);
    }
    public void updateTblEspCustNew(Map<String, Object> paramMap) {
        getSqlSession().update("EspCustNew.updateTblEspCustNew", paramMap);
    }
    public void updateTblEspCustNew0(Map<String, Object> paramMap) {
        getSqlSession().update("EspCustNew.updateTblEspCustNew0", paramMap);
    }
}
