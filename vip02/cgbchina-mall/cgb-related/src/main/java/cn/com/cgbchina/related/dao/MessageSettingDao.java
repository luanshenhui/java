package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.MessageSettingModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MessageSettingDao extends SqlSessionDaoSupport {

	public Boolean update(MessageSettingModel messageSetting) {
		return getSqlSession().update("MessageSetting.updateMessage", messageSetting) == 1;
	}

	public Integer insert(MessageSettingModel messageSetting) {
		return getSqlSession().insert("MessageSetting.insert", messageSetting);
	}

	public List<MessageSettingModel> findAll() {
		return getSqlSession().selectList("MessageSetting.findAll");
	}

	public MessageSettingModel findById(Long id) {
		return getSqlSession().selectOne("MessageSetting.findById", id);
	}

	public Pager<MessageSettingModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("MessageSetting.count", params);
		if (total == 0) {
			return Pager.empty(MessageSettingModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<MessageSettingModel> data = getSqlSession().selectList("MessageSetting.pager", paramMap);
		return new Pager<MessageSettingModel>(total, data);
	}

	public Integer delete(MessageSettingModel messageSetting) {
		return getSqlSession().delete("MessageSetting.delete", messageSetting);
	}
}