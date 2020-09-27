package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.model.TblOrderHistoryModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblOrderHistoryDao extends SqlSessionDaoSupport {

    public Integer update(TblOrderHistoryModel tblOrderHistory) {
        return getSqlSession().update("TblOrderHistoryModel.update", tblOrderHistory);
    }


    public Integer insert(TblOrderHistoryModel tblOrderHistory) {
        return getSqlSession().insert("TblOrderHistoryModel.insert", tblOrderHistory);
    }


    public List<TblOrderHistoryModel> findAll() {
        return getSqlSession().selectList("TblOrderHistoryModel.findAll");
    }


    public TblOrderHistoryModel findById(String orderId) {
        return getSqlSession().selectOne("TblOrderHistoryModel.findById", orderId);
    }


    public Pager<TblOrderHistoryModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.count", params);
        if (total == 0) {
        return Pager.empty(TblOrderHistoryModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.pager", paramMap);
        return new Pager<TblOrderHistoryModel>(total, data);
    }
   //订单管理模糊查询
    public Pager<TblOrderHistoryModel> findLikeByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.countLike", params);
        if (total == 0) {
            return Pager.empty(TblOrderHistoryModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.pagerLike", paramMap);
        return new Pager<TblOrderHistoryModel>(total, data);
    }


    public Integer delete(TblOrderHistoryModel tblOrderHistory) {
        return getSqlSession().delete("TblOrderHistoryModel.delete", tblOrderHistory);
    }

    public Integer updateById(Map<String, Object> dataMap) {
        return getSqlSession().update("TblOrderHistoryModel.updateByIds", dataMap);
    }

    public Integer updatePassById(Map<String, Object> dataMap) {
        return getSqlSession().update("TblOrderHistoryModel.updatePassById", dataMap);
    }

    public Integer updateRefuseById(Map<String, Object> dataMap) {
        return getSqlSession().update("TblOrderHistoryModel.updateRefuseById", dataMap);
    }

    public Pager<TblOrderHistoryModel> findLikeByPageForReq(Map<String, Object> params, int offset, int limit) {
        //0元秒杀订单不作为检索对象
        params.put("actTypeSecond", Contants.ORDER_ACT_TYPE_SECOND);
        //供应商请款订单状态 IN(已签收，退货申请，拒绝退货申请) 作为固定检索条件
        params.put("curStatusReceive",Contants.SUB_ORDER_STATUS_0310);
        params.put("curStatusBack",Contants.SUB_ORDER_STATUS_0334);
        params.put("curStatusUnBack",Contants.SUB_ORDER_STATUS_0335);
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.countLikeForReq", params);
        if (total == 0) {
            return Pager.empty(TblOrderHistoryModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.pagerLikeForReq", paramMap);
        return new Pager<TblOrderHistoryModel>(total, data);
    }

    public Pager<String> findMainIdLikeByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.countLikeMainId", params);
        if (total == 0) {
            return Pager.empty(String.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<String> data = getSqlSession().selectList("TblOrderHistoryModel.pagerLikeMainId", paramMap);
        return new Pager<String>(total, data);
    }

    public List<TblOrderHistoryModel> findByOrderMainId(String orderMainId) {
        return getSqlSession().selectList("TblOrderHistoryModel.findByOrderMainId", orderMainId);
    }
}