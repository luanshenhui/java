package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderBackupModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderBackupDao extends SqlSessionDaoSupport {

    public Integer update(OrderBackupModel orderBackup) {
        return getSqlSession().update("OrderBackupModel.update", orderBackup);
    }


    public Integer insert(OrderBackupModel orderBackup) {
        return getSqlSession().insert("OrderBackupModel.insert", orderBackup);
    }


    public List<OrderBackupModel> findAll() {
        return getSqlSession().selectList("OrderBackupModel.findAll");
    }


    public OrderBackupModel findById(String orderId) {
        return getSqlSession().selectOne("OrderBackupModel.findById", orderId);
    }


    public Pager<OrderBackupModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("OrderBackupModel.count", params);
        if (total == 0) {
        return Pager.empty(OrderBackupModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<OrderBackupModel> data = getSqlSession().selectList("OrderBackupModel.pager", paramMap);
        return new Pager<OrderBackupModel>(total, data);
    }


    public Integer delete(OrderBackupModel orderBackup) {
        return getSqlSession().delete("OrderBackupModel.delete", orderBackup);
    }

    /**
     * 根据主订单号查询tblorder_backup所有子订单(未删除) niufw
     *
     * @param orderMainId
     * @return
     */
    public List<OrderBackupModel> findBackupByorderMainId(String orderMainId) {
        return getSqlSession().selectList("OrderBackupModel.findBackupByorderMainId", orderMainId);
    }
}