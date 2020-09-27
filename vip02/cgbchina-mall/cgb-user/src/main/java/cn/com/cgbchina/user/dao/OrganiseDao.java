package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.user.model.OrganiseModel;

@Repository
public class OrganiseDao extends SqlSessionDaoSupport {

	public Boolean update(OrganiseModel organiseModel) {
		return getSqlSession().update("Organise.update", organiseModel) == 1;
	}

	public boolean insert(OrganiseModel organiseModel) {
		return getSqlSession().insert("Organise.insert", organiseModel) == 1;
	}

	public List<OrganiseModel> findAll() {
		return getSqlSession().selectList("Organise.findAll");
	}

    public List<String> findBySimpleName(String simpleName) {
        return getSqlSession().selectList("Organise.findBySimpleName",simpleName);
    }

	public OrganiseModel findById(String code) {
		return getSqlSession().selectOne("Organise.findById", code);
	}

	public OrganiseModel findByIdAll(String code) {
		return getSqlSession().selectOne("Organise.findByIdAll", code);
	}

	public Pager<OrganiseModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("Organise.count", params);
		if (total == 0) {
			return Pager.empty(OrganiseModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrganiseModel> data = getSqlSession().selectList("Organise.pager", paramMap);
		return new Pager<OrganiseModel>(total, data);
	}

	public boolean delete(String code) {
		return getSqlSession().delete("Organise.delete", code) == 1;
	}
}