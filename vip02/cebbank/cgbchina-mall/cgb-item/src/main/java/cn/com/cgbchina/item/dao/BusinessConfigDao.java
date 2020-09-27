package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.BusinessConfig;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class BusinessConfigDao extends SqlSessionDaoSupport {

	public Integer update(BusinessConfig businessConfig) {
		return getSqlSession().update("BusinessConfig.update", businessConfig);
	}

	public Integer insert(BusinessConfig businessConfig) {
		return getSqlSession().insert("BusinessConfig.insert", businessConfig);
	}

	public List<BusinessConfig> findAll() {
		return getSqlSession().selectList("BusinessConfig.findAll");
	}

	public BusinessConfig findById(Long id) {
		return getSqlSession().selectOne("BusinessConfig.findById", id);
	}

	public Pager<BusinessConfig> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("BusinessConfig.count", params);
		if (total == 0) {
			return Pager.empty(BusinessConfig.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<BusinessConfig> data = getSqlSession().selectList("BusinessConfig.pager", paramMap);
		return new Pager<BusinessConfig>(total, data);
	}

	public Integer delete(BusinessConfig businessConfig) {
		return getSqlSession().delete("BusinessConfig.delete", businessConfig);
	}
}