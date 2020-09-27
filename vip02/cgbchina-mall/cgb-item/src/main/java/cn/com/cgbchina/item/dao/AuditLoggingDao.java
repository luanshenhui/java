package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.AuditLoggingModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class AuditLoggingDao extends SqlSessionDaoSupport {

	public Integer update(AuditLoggingModel auditLoggingModel) {
		return getSqlSession().update("AuditLoggingModel.update", auditLoggingModel);
	}

	public Integer insert(AuditLoggingModel auditLoggingModel) {
		return getSqlSession().insert("AuditLoggingModel.insert", auditLoggingModel);
	}

	public List<AuditLoggingModel> findAll() {
		return getSqlSession().selectList("AuditLoggingModel.findAll");
	}

	public AuditLoggingModel findById(Long id) {
		return getSqlSession().selectOne("AuditLoggingModel.findById", id);
	}

	public Pager<AuditLoggingModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("AuditLoggingModel.count", params);
		if (total == 0) {
			return Pager.empty(AuditLoggingModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<AuditLoggingModel> data = getSqlSession().selectList("AuditLoggingModel.pager", paramMap);
		return new Pager<AuditLoggingModel>(total, data);
	}

	public Integer delete(AuditLoggingModel auditLoggingModel) {
		return getSqlSession().delete("AuditLoggingModel.delete", auditLoggingModel);
	}

	/**
	 * 根据外部id查询
	 * 
	 * @param outerId
	 * @return
	 */
	public List<AuditLoggingModel> findByOuterId(String outerId) {
		return getSqlSession().selectList("AuditLoggingModel.findByOuterId", outerId);
	}
}