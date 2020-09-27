package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblOrderCancelModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblOrderCancelDao extends SqlSessionDaoSupport {

    public Integer update(TblOrderCancelModel tblOrderCancel) {
        return getSqlSession().update("TblOrderCancelModel.update", tblOrderCancel);
    }


    public Integer insert(TblOrderCancelModel tblOrderCancel) {
        return getSqlSession().insert("TblOrderCancelModel.insert", tblOrderCancel);
    }


    public List<TblOrderCancelModel> findAll() {
        return getSqlSession().selectList("TblOrderCancelModel.findAll");
    }


    public TblOrderCancelModel findById(Long orderCancelId) {
        return getSqlSession().selectOne("TblOrderCancelModel.findById", orderCancelId);
    }


    public Pager<TblOrderCancelModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderCancelModel.count", params);
        if (total == 0) {
        return Pager.empty(TblOrderCancelModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderCancelModel> data = getSqlSession().selectList("TblOrderCancelModel.pager", paramMap);
        return new Pager<TblOrderCancelModel>(total, data);
    }


    public Integer delete(TblOrderCancelModel tblOrderCancel) {
        return getSqlSession().delete("TblOrderCancelModel.delete", tblOrderCancel);
    }

    public List<TblOrderCancelModel> findSumTblOrderCancel(String create_date) {
        return getSqlSession().selectList("TblOrderCancelModel.findSumTblOrderCancel", create_date);
    }

    public Integer updateTblOrderCancel(String create_date) {
        return getSqlSession().update("TblOrderCancelModel.updateTblOrderCancel", create_date);
    }

    public List<TblOrderCancelModel> findCancelDate(Map<String, Object> params) {
        return getSqlSession().selectList("TblOrderCancelModel.findCancelDate", params);
    }
}