package cn.com.cgbchina.related.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.related.model.TblCfgProCodeModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class TblCfgProCodeDao extends SqlSessionDaoSupport {

	public Integer update(TblCfgProCodeModel tblCfgProCode) {
		return getSqlSession().update("TblCfgProCodeModel.update", tblCfgProCode);
	}

	public Integer insert(TblCfgProCodeModel tblCfgProCode) {
		return getSqlSession().insert("TblCfgProCodeModel.insert", tblCfgProCode);
	}

	public List<TblCfgProCodeModel> findAll() {
		return getSqlSession().selectList("TblCfgProCodeModel.findAll");
	}

	public TblCfgProCodeModel findById(Integer id) {
		return getSqlSession().selectOne("TblCfgProCodeModel.findById", id);
	}

	public Pager<TblCfgProCodeModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblCfgProCodeModel.count", params);
		if (total == 0) {
			return Pager.empty(TblCfgProCodeModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblCfgProCodeModel> data = getSqlSession().selectList("TblCfgProCodeModel.pager", paramMap);
		return new Pager<TblCfgProCodeModel>(total, data);
	}

	public Integer delete(TblCfgProCodeModel tblCfgProCode) {
		return getSqlSession().delete("TblCfgProCodeModel.delete", tblCfgProCode);
	}

	public List<TblCfgProCodeModel> findProCodeInfo() {
		return getSqlSession().selectList("TblCfgProCodeModel.findProCodeInfo");
	}

	public TblCfgProCodeModel findProcode(Map<String, String> params) {
		return getSqlSession().selectOne("TblCfgProcodeModel.findProcode", params);
	}

	/**
	 * 根据参数查询
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160818
	 */
	public List<TblCfgProCodeModel> findProCodeByParams(Map<String,Object> paramMap){
		return getSqlSession().selectList("TblCfgProCodeModel.findProCodeByParams", paramMap);
	}

}