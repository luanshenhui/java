package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.BrandRequest;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class BrandRequestDao extends SqlSessionDaoSupport {

	public Integer update(BrandRequest brandRequest) {
		return getSqlSession().update("BrandRequest.update", brandRequest);
	}

	public Integer insert(BrandRequest brandRequest) {
		return getSqlSession().insert("BrandRequest.insert", brandRequest);
	}

	public List<BrandRequest> findAll() {
		return getSqlSession().selectList("BrandRequest.findAll");
	}

	public BrandRequest findById(Long id) {
		return getSqlSession().selectOne("BrandRequest.findById", id);
	}

	public Pager<BrandRequest> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("BrandRequest.count", params);
		if (total == 0) {
			return Pager.empty(BrandRequest.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<BrandRequest> data = getSqlSession().selectList("BrandRequest.pager", paramMap);
		return new Pager<BrandRequest>(total, data);
	}

	public Integer delete(BrandRequest brandRequest) {
		return getSqlSession().delete("BrandRequest.delete", brandRequest);
	}
}