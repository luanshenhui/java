package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.MessageTemplateModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MessageTemplateDao extends SqlSessionDaoSupport {

	public Integer update(MessageTemplateModel messageTemplateModel) {
		return getSqlSession().update("MessageTemplate.update", messageTemplateModel);
	}

	public Integer insert(MessageTemplateModel messageTemplateModel) {
		return getSqlSession().insert("MessageTemplate.insert", messageTemplateModel);
	}

	public List<MessageTemplateModel> findAll() {
		return getSqlSession().selectList("MessageTemplate.findAll");
	}

	public MessageTemplateModel findById(Long id) {
		return getSqlSession().selectOne("MessageTemplate.findById", id);
	}

	public Pager<MessageTemplateModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("MessageTemplate.count", params);
		if (total == 0) {
			return Pager.empty(MessageTemplateModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<MessageTemplateModel> data = getSqlSession().selectList("MessageTemplate.pager", paramMap);
		return new Pager<MessageTemplateModel>(total, data);
	}

	public Integer delete(MessageTemplateModel messageTemplateModel) {
		return getSqlSession().delete("MessageTemplate.delete", messageTemplateModel);
	}
}