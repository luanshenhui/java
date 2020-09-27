package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.PersonalMessageModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class PersonalMessageDao extends SqlSessionDaoSupport {

	public Integer update(PersonalMessageModel personalMessageModel) {
		return getSqlSession().update("PersonalMessage.update", personalMessageModel);
	}

	public Integer insert(PersonalMessageModel personalMessageModel) {
		return getSqlSession().insert("PersonalMessage.insert", personalMessageModel);
	}

	public List<PersonalMessageModel> findAll() {
		return getSqlSession().selectList("PersonalMessage.findAll");
	}

	public PersonalMessageModel findById(Long id) {
		return getSqlSession().selectOne("PersonalMessage.findById", id);
	}

	public Pager<PersonalMessageModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PersonalMessage.count", params);
		if (total == 0) {
			return Pager.empty(PersonalMessageModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PersonalMessageModel> data = getSqlSession().selectList("PersonalMessage.pager", paramMap);
		return new Pager<PersonalMessageModel>(total, data);
	}

	public Integer delete(PersonalMessageModel personalMessageModel) {
		return getSqlSession().delete("PersonalMessage.delete", personalMessageModel);
	}

	/**
	 * 消息全部已读功能
	 * 
	 * @param personalMessageMode
	 * @return
	 */
	public Integer updateMessage(PersonalMessageModel personalMessageMode) {
		return getSqlSession().update("PersonalMessage.updateMessage", personalMessageMode);
	}

	public Integer updateToRead(Long id){
		return getSqlSession().update("PersonalMessage.updateToRead",id);
	}
}