package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.DefaultSearchModel;
import cn.com.cgbchina.related.model.HotSearchTermModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class HotSearchTermDao extends SqlSessionDaoSupport {

	public Integer update(Map<String, Object> dataMap) {
		return getSqlSession().update("HotSearchTermModel.update", dataMap);
	}

	public Integer insert(HotSearchTermModel hotSearchTermModel) {
		return getSqlSession().insert("HotSearchTermModel.insert", hotSearchTermModel);
	}

	public List<HotSearchTermModel> findAll(Map<String, Object> queryMap) {
		return getSqlSession().selectList("HotSearchTermModel.findAll", queryMap);
	}

	public List<HotSearchTermModel> findHotHeader(Map<String, Object> queryMap) {
		return getSqlSession().selectList("HotSearchTermModel.findHotHeader", queryMap);
	}

	public HotSearchTermModel findByName(String name) {
		return getSqlSession().selectOne("HotSearchTermModel.findByName", name);
	}

	public Pager<HotSearchTermModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("HotSearchTermModel.count", params);
		if (total == 0) {
			return Pager.empty(HotSearchTermModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<HotSearchTermModel> data = getSqlSession().selectList("HotSearchTermModel.pager", paramMap);
		return new Pager<HotSearchTermModel>(total, data);
	}

	public Integer delete(HotSearchTermModel hotSearchTermModel) {
		return getSqlSession().delete("HotSearchTermModel.logicDelete", hotSearchTermModel);
	}

	public Integer count(Map<String, Object> map) {
		return getSqlSession().<Integer> selectOne("HotSearchTermModel.countAll", map);
	}

	public Integer countTo(Map<String, Object> map) {
		return getSqlSession().<Integer> selectOne("HotSearchTermModel.countTo", map);
	}
}