package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblMakecheckjobHistoryModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblMakecheckjobHistoryDao extends SqlSessionDaoSupport {

	public Integer update(TblMakecheckjobHistoryModel tblMakecheckjobHistory) {
		return getSqlSession().update("TblMakecheckjobHistoryModel.update", tblMakecheckjobHistory);
	}

	public Integer insert(TblMakecheckjobHistoryModel tblMakecheckjobHistory) {
		return getSqlSession().insert("TblMakecheckjobHistoryModel.insert", tblMakecheckjobHistory);
	}

	public List<TblMakecheckjobHistoryModel> findAll() {
		return getSqlSession().selectList("TblMakecheckjobHistoryModel.findAll");
	}

	public TblMakecheckjobHistoryModel findById(Long id) {
		return getSqlSession().selectOne("TblMakecheckjobHistoryModel.findById", id);
	}

	public Pager<TblMakecheckjobHistoryModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblMakecheckjobHistoryModel.count", params);
		if (total == 0) {
			return Pager.empty(TblMakecheckjobHistoryModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblMakecheckjobHistoryModel> data = getSqlSession().selectList("TblMakecheckjobHistoryModel.pager",
				paramMap);
		return new Pager<TblMakecheckjobHistoryModel>(total, data);
	}

	public Integer delete(TblMakecheckjobHistoryModel tblMakecheckjobHistory) {
		return getSqlSession().delete("TblMakecheckjobHistoryModel.delete", tblMakecheckjobHistory);
	}

	/**
	 * 查询对账失败
	 */
	public Pager<TblMakecheckjobHistoryModel> findByPageQuery(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblMakecheckjobHistoryModel.count", params);
		if (total == 0) {
			return Pager.empty(TblMakecheckjobHistoryModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblMakecheckjobHistoryModel> data = getSqlSession().selectList("TblMakecheckjobHistoryModel.pagerQuery",
				paramMap);
		return new Pager<TblMakecheckjobHistoryModel>(total, data);
	}

	/**
	 * 查询对账失败异常
	 */
	public Pager<TblMakecheckjobHistoryModel> findByPageQueryError(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblMakecheckjobHistoryModel.countError", params);
		if (total == 0) {
			return Pager.empty(TblMakecheckjobHistoryModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblMakecheckjobHistoryModel> data = getSqlSession()
				.selectList("TblMakecheckjobHistoryModel.pagerQueryError", paramMap);
		return new Pager<TblMakecheckjobHistoryModel>(total, data);
	}
}