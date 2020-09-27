package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.SmspCustModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class SmspCustDao extends SqlSessionDaoSupport {

	public Integer update(SmspCustModel smspCust) {
		return getSqlSession().update("SmspCustModel.update", smspCust);
	}

	public Integer insert(SmspCustModel smspCust) {
		return getSqlSession().insert("SmspCustModel.insert", smspCust);
	}

	public List<SmspCustModel> findAll() {
		return getSqlSession().selectList("SmspCustModel.findAll");
	}

	public SmspCustModel findById(Long id) {
		return getSqlSession().selectOne("SmspCustModel.findById", id);
	}

	/**
	 * 根据短信维护表id查询所有名单
	 * 
	 * @param id
	 * @return
	 */
	public List<SmspCustModel> findSmspCustById(Long id) {
		return getSqlSession().selectList("SmspCustModel.findSmspCustById", id);
	}

	public Pager<SmspCustModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("SmspCustModel.count", params);
		if (total == 0) {
			return Pager.empty(SmspCustModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<SmspCustModel> data = getSqlSession().selectList("SmspCustModel.pager", paramMap);
		return new Pager<SmspCustModel>(total, data);
	}

	public Integer delete(SmspCustModel smspCust) {
		return getSqlSession().delete("SmspCustModel.delete", smspCust);
	}
}