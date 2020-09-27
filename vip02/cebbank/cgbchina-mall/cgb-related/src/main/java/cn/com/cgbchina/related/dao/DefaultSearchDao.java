package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.DefaultSearchModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class DefaultSearchDao extends SqlSessionDaoSupport {

	public Integer update(DefaultSearchModel defaultSearchModel) {
		return getSqlSession().update("DefaultSearch.update", defaultSearchModel);
	}

	public Integer insert(DefaultSearchModel defaultSearchModel) {
		return getSqlSession().insert("DefaultSearch.insert", defaultSearchModel);
	}

	public List<DefaultSearchModel> findAll() {
		return getSqlSession().selectList("DefaultSearch.findAll");
	}

	public DefaultSearchModel findById(Long id) {
		return getSqlSession().selectOne("DefaultSearch.findById", id);
	}

	public Pager<DefaultSearchModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("DefaultSearch.count", params);
		if (total == 0) {
			return Pager.empty(DefaultSearchModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<DefaultSearchModel> data = getSqlSession().selectList("DefaultSearch.pager", paramMap);
		return new Pager<DefaultSearchModel>(total, data);
	}

	public Integer delete(DefaultSearchModel defaultSearchModel) {
		return getSqlSession().delete("DefaultSearch.todelete", defaultSearchModel);
	}

	/**
	 * 搜索词名称重复校验
	 * 
	 * @param name
	 * @return
	 */
	public Long findNameByName(String name) {
		Long total = getSqlSession().selectOne("DefaultSearch.findNameByName", name);
		return total;
	}

	public DefaultSearchModel findDefaultHeader(Map<String, Object> queryMap) {
		return getSqlSession().selectOne("DefaultSearch.findDefaultHeader", queryMap);
	}

	public Integer count(Map<String, Object> map) {
		return getSqlSession().<Integer> selectOne("DefaultSearch.countAll", map);
	}

	public Integer countTo(Map<String, Object> map) {
		return getSqlSession().<Integer> selectOne("DefaultSearch.countTo", map);
	}
}