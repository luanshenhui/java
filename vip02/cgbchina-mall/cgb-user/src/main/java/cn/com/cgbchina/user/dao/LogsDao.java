package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.LogsModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class LogsDao extends SqlSessionDaoSupport {

	public Integer update(LogsModel logs) {
		return getSqlSession().update("LogsModel.update", logs);
	}

	public Integer insert(LogsModel logs) {
		return getSqlSession().insert("LogsModel.insert", logs);
	}

	public List<LogsModel> findAll() {
		return getSqlSession().selectList("LogsModel.findAll");
	}

	public LogsModel findById(Long id) {
		return getSqlSession().selectOne("LogsModel.findById", id);
	}

	public Pager<LogsModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("LogsModel.count", params);
		if (total == 0) {
			return Pager.empty(LogsModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<LogsModel> data = getSqlSession().selectList("LogsModel.pager", paramMap);
		return new Pager<LogsModel>(total, data);
	}

	public Integer delete(LogsModel logs) {
		return getSqlSession().delete("LogsModel.delete", logs);
	}

	public Pager<LogsModel> findByPage1(String params) {
		return null;
	}
}