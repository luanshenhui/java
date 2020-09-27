package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblOrderMainHisModel;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblOrderMainHisDao extends SqlSessionDaoSupport {

    public Integer update(TblOrderMainHisModel tblOrderMainHis) {
        return getSqlSession().update("TblOrderMainHisModel.update", tblOrderMainHis);
    }


    public Integer insert(TblOrderMainHisModel tblOrderMainHis) {
        return getSqlSession().insert("TblOrderMainHisModel.insert", tblOrderMainHis);
    }


    public List<TblOrderMainHisModel> findAll() {
        return getSqlSession().selectList("TblOrderMainHisModel.findAll");
    }


    public TblOrderMainHisModel findById(Long hisId) {
        return getSqlSession().selectOne("TblOrderMainHisModel.findById", hisId);
    }


    public Pager<TblOrderMainHisModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderMainHisModel.count", params);
        if (total == 0) {
        return Pager.empty(TblOrderMainHisModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderMainHisModel> data = getSqlSession().selectList("TblOrderMainHisModel.pager", paramMap);
        return new Pager<TblOrderMainHisModel>(total, data);
    }
    
    /**
     * Description : 根据主订单查询
     * @author xiewl
     * @param orderMainId
     * @return
     */
    public List<TblOrderMainHisModel> findByOrderMainId(String orderMainId){
    	return getSqlSession().selectList("TblOrderMainHisModel.findByOrderMainId", orderMainId);
    }


    public Integer delete(TblOrderMainHisModel tblOrderMainHis) {
        return getSqlSession().delete("TblOrderMainHisModel.delete", tblOrderMainHis);
    }
}