package cn.com.cgbchina.log.dao;

import cn.com.cgbchina.log.model.MessageLogModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MessageLogDao extends SqlSessionDaoSupport {

    public Integer update(MessageLogModel messageLog) {
        return getSqlSession().update("MessageLogModel.update", messageLog);
    }


    public Integer insert(MessageLogModel messageLogModel) {
        return getSqlSession().insert("MessageLogModel.insert", messageLogModel);
    }


    public List<MessageLogModel> findAll() {
        return getSqlSession().selectList("MessageLogModel.findAll");
    }


    public MessageLogModel findById(Long logId) {
        return getSqlSession().selectOne("MessageLogModel.findById", logId);
    }


    public Pager<MessageLogModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("MessageLogModel.count", params);
        if (total == 0) {
        return Pager.empty(MessageLogModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<MessageLogModel> data = getSqlSession().selectList("MessageLogModel.pager", paramMap);
        return new Pager<MessageLogModel>(total, data);
    }


    public Integer delete(MessageLogModel messageLog) {
        return getSqlSession().delete("MessageLogModel.delete", messageLog);
    }
}