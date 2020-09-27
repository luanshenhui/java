package com.cebbank.ccis.cebmall.user.dao;

import java.util.List;
import java.util.Map;

import com.cebbank.ccis.cebmall.user.model.TblParametersModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;


@Repository
public class TblParametersDao extends SqlSessionDaoSupport {

	public Integer update(TblParametersModel tblParameters) {
		return getSqlSession().update("TblParametersModel.update", tblParameters);
	}

	public Integer updatePrompt(TblParametersModel tblParameters) {
		return getSqlSession().update("TblParametersModel.updatePrompt", tblParameters);
	}

	// 修改
	public Integer updateOpenCloseFlag(TblParametersModel tblParameters) {
		return getSqlSession().update("TblParametersModel.updateOpenCloseFlag", tblParameters);
	}

	public Integer insert(TblParametersModel tblParameters) {
		return getSqlSession().insert("TblParametersModel.insert", tblParameters);
	}

	public List<TblParametersModel> findAll() {
		return getSqlSession().selectList("TblParametersModel.findAll");
	}

	public TblParametersModel findById(Long parametersId) {
		return getSqlSession().selectOne("TblParametersModel.findById", parametersId);
	}

	/**
	 * 获取web渠道的登录信息
	 * 
	 * @return
	 */
	public List<TblParametersModel> findByWebLogin() {
		return getSqlSession().selectList("TblParametersModel.findByWebLogin");
	}

	public Pager<TblParametersModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblParametersModel.count", params);
		if (total == 0) {
			return Pager.empty(TblParametersModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblParametersModel> data = getSqlSession().selectList("TblParametersModel.pager", paramMap);
		return new Pager<TblParametersModel>(total, data);
	}

	/*
	 * 查询所有业务启停信息
	 */
	public Pager<TblParametersModel> findByPageQuery(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblParametersModel.count", params);
		if (total == 0) {
			return Pager.empty(TblParametersModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblParametersModel> data = getSqlSession().selectList("TblParametersModel.pagerQuery", paramMap);
		return new Pager<TblParametersModel>(total, data);
	}

	public Integer delete(TblParametersModel tblParameters) {
		return getSqlSession().delete("TblParametersModel.delete", tblParameters);
	}

	public List<TblParametersModel> findJudgeQT(String ordertypeId, String sourceId) {
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("parametersType", "2");
		paramMap.put("ordertypeId", ordertypeId);
		paramMap.put("sourceId", sourceId);
		return getSqlSession().selectList("TblParametersModel.findJudgeQT", paramMap);
	}

	public List<TblParametersModel> findParameters(Integer parametersType,String ordertypeId, String sourceId) {
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("parametersType",parametersType);
		paramMap.put("ordertypeId", ordertypeId);
		paramMap.put("sourceId", sourceId);
		return getSqlSession().selectList("TblParametersModel.findJudgeQT", paramMap);
	}

}