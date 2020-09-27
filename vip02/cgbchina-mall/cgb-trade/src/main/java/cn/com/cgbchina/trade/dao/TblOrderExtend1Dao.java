package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblOrderExtend1Dao extends SqlSessionDaoSupport {

    public Integer update(TblOrderExtend1Model tblOrderExtend1) {
        return getSqlSession().update("TblOrderExtend1Model.update", tblOrderExtend1);
    }


    public Integer insert(TblOrderExtend1Model tblOrderExtend1) {
        return getSqlSession().insert("TblOrderExtend1Model.insert", tblOrderExtend1);
    }

    public Integer insertBatch(List tblOrderExtend1ModelIns) {
        return getSqlSession().insert("TblOrderExtend1Model.insertBatch", tblOrderExtend1ModelIns);
    }

    public List<TblOrderExtend1Model> findAll() {
        return getSqlSession().selectList("TblOrderExtend1Model.findAll");
    }


    public TblOrderExtend1Model findById(Long orderExtend1Id) {
        return getSqlSession().selectOne("TblOrderExtend1Model.findById", orderExtend1Id);
    }

    public TblOrderExtend1Model findByOrderId(String orderId) {
        return getSqlSession().selectOne("TblOrderExtend1Model.findByOrderId", orderId);
    }

    /**
     * 获取TblOrderExtend1ModelList by orderId
     * @param orderId
     * @return
     */
    public List<TblOrderExtend1Model> findListByOrderId(String orderId) {
        return getSqlSession().selectList("TblOrderExtend1Model.findListByOrderId", orderId);
    }

    public Pager<TblOrderExtend1Model> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderExtend1Model.count", params);
        if (total == 0) {
        return Pager.empty(TblOrderExtend1Model.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderExtend1Model> data = getSqlSession().selectList("TblOrderExtend1Model.pager", paramMap);
        return new Pager<TblOrderExtend1Model>(total, data);
    }


    public Integer delete(TblOrderExtend1Model tblOrderExtend1) {
        return getSqlSession().delete("TblOrderExtend1Model.delete", tblOrderExtend1);
    }

    /**
     * for MAL113
     * @param ordernbr
     * @return
     */
    public List<TblOrderExtend1Model> findOrderExtend1for113(String ordernbr){
        return getSqlSession().selectList("TblOrderExtend1Model.findOrderExtend1for113",ordernbr);
    }

    /**
     * 根据orderId更新
     * @param tblOrderExtend1
     * @return
     */
    public Integer updateByOrderId(TblOrderExtend1Model tblOrderExtend1) {
        return getSqlSession().update("TblOrderExtend1Model.updateByOrderId",tblOrderExtend1);
    }


    public List<TblOrderExtend1Model> findByOrderIds(List<String> orderids) {
        return getSqlSession().selectList("TblOrderExtend1Model.findByOrderIds", orderids);
    }

}