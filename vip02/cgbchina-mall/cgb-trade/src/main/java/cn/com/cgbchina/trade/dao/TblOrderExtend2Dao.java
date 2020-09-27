package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblOrderExtend2Model;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblOrderExtend2Dao extends SqlSessionDaoSupport {

    public Integer update(TblOrderExtend2Model tblOrderExtend2) {
        return getSqlSession().update("TblOrderExtend2Model.update", tblOrderExtend2);
    }


    public Integer insert(TblOrderExtend2Model tblOrderExtend2) {
        return getSqlSession().insert("TblOrderExtend2Model.insert", tblOrderExtend2);
    }


    public List<TblOrderExtend2Model> findAll() {
        return getSqlSession().selectList("TblOrderExtend2Model.findAll");
    }


    public TblOrderExtend2Model findById(String orderId) {
        return getSqlSession().selectOne("TblOrderExtend2Model.findById", orderId);
    }


    public Pager<TblOrderExtend2Model> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderExtend2Model.count", params);
        if (total == 0) {
        return Pager.empty(TblOrderExtend2Model.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderExtend2Model> data = getSqlSession().selectList("TblOrderExtend2Model.pager", paramMap);
        return new Pager<TblOrderExtend2Model>(total, data);
    }


    public Integer delete(TblOrderExtend2Model tblOrderExtend2) {
        return getSqlSession().delete("TblOrderExtend2Model.delete", tblOrderExtend2);
    }

    public List<TblOrderExtend2Model> findByOrderCancelIds(Map<String, Object> params) {
        return getSqlSession().selectList("TblOrderExtend2Model.findByOrderCancelIds", params);
    }
}