package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.user.model.LocalProcodeModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;



@Repository
public class LocalProcodeDao extends SqlSessionDaoSupport {

	public Integer update(LocalProcodeModel localProcode) {
		return getSqlSession().update("LocalProcodeModel.update", localProcode);
	}

	public Integer insert(LocalProcodeModel localProcode) {
		return getSqlSession().insert("LocalProcodeModel.insert", localProcode);
	}

	public List<LocalProcodeModel> findAll() {
		return getSqlSession().selectList("LocalProcodeModel.findAll");
	}

	public LocalProcodeModel findById(Long id) {
		return getSqlSession().selectOne("LocalProcodeModel.findById", id);
	}

	public LocalProcodeModel findByProCode(String proCode) {
		return getSqlSession().selectOne("LocalProcodeModel.findByProCode", proCode);
	}

	public Pager<LocalProcodeModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("LocalProcodeModel.count", params);
		if (total == 0) {
			return Pager.empty(LocalProcodeModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<LocalProcodeModel> data = getSqlSession().selectList("LocalProcodeModel.pager", paramMap);
		return new Pager<LocalProcodeModel>(total, data);
	}

	public Integer delete(LocalProcodeModel localProcode) {
		return getSqlSession().delete("LocalProcodeModel.delete", localProcode);
	}

	/**
	 * 重复校验
	 * 
	 * @param proNm
	 * @return
	 */
	public Long findNameByName(String proNm) {
		Long total = getSqlSession().selectOne("LocalProcodeModel.findNameByName", proNm);
		return total;
	}

	public Long findProCodeByProCode(String proCode) {
		Long total = getSqlSession().selectOne("LocalProcodeModel.findProCodeByProCode", proCode);
		return total;
	}
}