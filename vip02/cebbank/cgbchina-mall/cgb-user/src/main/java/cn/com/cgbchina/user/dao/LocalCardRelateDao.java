package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.user.model.LocalCardRelateModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class LocalCardRelateDao extends SqlSessionDaoSupport {

	public Integer update(LocalCardRelateModel localCardRelate) {
		return getSqlSession().update("LocalCardRelateModel.update", localCardRelate);
	}

	public Integer insert(LocalCardRelateModel localCardRelate) {
		return getSqlSession().insert("LocalCardRelateModel.insert", localCardRelate);
	}

	public List<LocalCardRelateModel> findAll() {
		return getSqlSession().selectList("LocalCardRelateModel.findAll");
	}

	public LocalCardRelateModel findById(String proCode) {
		return getSqlSession().selectOne("LocalCardRelateModel.findById", proCode);
	}

	public List<LocalCardRelateModel> findFormatIdAll(String proCode) {
		return getSqlSession().selectList("LocalCardRelateModel.findFormatIdAll", proCode);
	}

	public Pager<LocalCardRelateModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("LocalCardRelateModel.count", params);
		if (total == 0) {
			return Pager.empty(LocalCardRelateModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<LocalCardRelateModel> data = getSqlSession().selectList("LocalCardRelateModel.pager", paramMap);
		return new Pager<LocalCardRelateModel>(total, data);
	}

	public Integer delete(LocalCardRelateModel localCardRelate) {
		return getSqlSession().delete("LocalCardRelateModel.delete", localCardRelate);
	}

	public LocalCardRelateModel findByFormatId(String formatId) {
		return getSqlSession().selectOne("LocalCardRelateModel.findByFormatId", formatId);
	}

}