package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblOrderCardMappingModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblOrderCardMappingDao extends SqlSessionDaoSupport {

    public Integer update(TblOrderCardMappingModel tblOrderCardMapping) {
        return getSqlSession().update("TblOrderCardMappingModel.update", tblOrderCardMapping);
    }


    public Integer insert(TblOrderCardMappingModel tblOrderCardMapping) {
        return getSqlSession().insert("TblOrderCardMappingModel.insert", tblOrderCardMapping);
    }


    public List<TblOrderCardMappingModel> findAll() {
        return getSqlSession().selectList("TblOrderCardMappingModel.findAll");
    }


    public TblOrderCardMappingModel findById(Long id) {
        return getSqlSession().selectOne("TblOrderCardMappingModel.findById", id);
    }


    public Pager<TblOrderCardMappingModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderCardMappingModel.count", params);
        if (total == 0) {
        return Pager.empty(TblOrderCardMappingModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderCardMappingModel> data = getSqlSession().selectList("TblOrderCardMappingModel.pager", paramMap);
        return new Pager<TblOrderCardMappingModel>(total, data);
    }


    public Integer delete(TblOrderCardMappingModel tblOrderCardMapping) {
        return getSqlSession().delete("TblOrderCardMappingModel.delete", tblOrderCardMapping);
    }

    public List<TblOrderCardMappingModel> findCCCheckAccOrder(Map<String, Object> params) {
        return getSqlSession().selectList("TblOrderCardMappingModel.findCCCheckAccOrder", params);
    }
    
    public List<TblOrderCardMappingModel> findByOrderMainIdOrCardNo(Map<String, Object> params) {
        return getSqlSession().selectList("TblOrderCardMappingModel.findByOrderMainIdOrCardNo", params);
    }

}