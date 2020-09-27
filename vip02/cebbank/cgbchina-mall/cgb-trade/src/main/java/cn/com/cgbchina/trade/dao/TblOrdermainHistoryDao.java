package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblOrdermainHistoryDao extends SqlSessionDaoSupport {

    public Integer update(TblOrdermainHistoryModel tblOrdermainHistory) {
        return getSqlSession().update("TblOrdermainHistoryModel.update", tblOrdermainHistory);
    }


    public Integer insert(TblOrdermainHistoryModel tblOrdermainHistory) {
        return getSqlSession().insert("TblOrdermainHistoryModel.insert", tblOrdermainHistory);
    }


    public List<TblOrdermainHistoryModel> findAll() {
        return getSqlSession().selectList("TblOrdermainHistoryModel.findAll");
    }


    public TblOrdermainHistoryModel findById(String ordermainId) {
        return getSqlSession().selectOne("TblOrdermainHistoryModel.findById", ordermainId);
    }


    public Pager<TblOrdermainHistoryModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrdermainHistoryModel.count", params);
        if (total == 0) {
        return Pager.empty(TblOrdermainHistoryModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrdermainHistoryModel> data = getSqlSession().selectList("TblOrdermainHistoryModel.pager", paramMap);
        return new Pager<TblOrdermainHistoryModel>(total, data);
    }


    public Integer delete(TblOrdermainHistoryModel tblOrdermainHistory) {
        return getSqlSession().delete("TblOrdermainHistoryModel.delete", tblOrdermainHistory);
    }
}