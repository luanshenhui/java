package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by 张成 on 16-6-27.
 */
@Repository
public class TblOrderCheckDao extends SqlSessionDaoSupport {

    public List<OrderCheckModel> orderCancelService(Map<String, Object> paramMap) {
        return getSqlSession().selectList("OrderCheckModel.orderCancelService", paramMap);
    }

    public void saveTblOrderCheck(OrderCheckModel orderCheckModel) {
        getSqlSession().insert("OrderCheckModel.insert", orderCheckModel);
    }

    public void saveTblOrderCheck(Map<String, Object> paramMap) {
        getSqlSession().insert("OrderCheckModel.insert", paramMap);
    }

    public Integer insert(OrderCheckModel orderCheckModel) {
        return getSqlSession().insert("OrderCheckModel.insert", orderCheckModel);
    }

    public Integer insertBatch(List orderCheckModelList) {
        return getSqlSession().insert("OrderCheckModel.insertBatch", orderCheckModelList);
    }
}
