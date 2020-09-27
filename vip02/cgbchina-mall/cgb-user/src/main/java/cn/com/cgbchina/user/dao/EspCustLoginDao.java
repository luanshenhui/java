package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.EspCustLoginModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class EspCustLoginDao extends SqlSessionDaoSupport {

	public Integer update(EspCustLoginModel espCustLoginModel) {
		return getSqlSession().update("EspCustLogin.update", espCustLoginModel);
	}

	public Integer insert(EspCustLoginModel espCustLoginModel) {
		return getSqlSession().insert("EspCustLogin.insert", espCustLoginModel);
	}

	public List<EspCustLoginModel> findAll() {
		return getSqlSession().selectList("EspCustLogin.findAll");
	}

	public EspCustLoginModel findById(Long id) {
		return getSqlSession().selectOne("EspCustLogin.findById", id);
	}

	public Pager<EspCustLoginModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("EspCustLogin.count", params);
		if (total == 0) {
			return Pager.empty(EspCustLoginModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<EspCustLoginModel> data = getSqlSession().selectList("EspCustLogin.pager", paramMap);
		return new Pager<EspCustLoginModel>(total, data);
	}

	public Integer delete(EspCustLoginModel espCustLoginModel) {
		return getSqlSession().delete("EspCustLogin.delete", espCustLoginModel);
	}
}