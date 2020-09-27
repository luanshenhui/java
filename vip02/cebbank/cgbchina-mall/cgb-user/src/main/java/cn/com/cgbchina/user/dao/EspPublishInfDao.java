package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.EspPublishInfModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class EspPublishInfDao extends SqlSessionDaoSupport {

	public Integer update(EspPublishInfModel espPublishInf) {
		return getSqlSession().update("EspPublishInfModel.update", espPublishInf);
	}

	public Integer insert(EspPublishInfModel espPublishInf) {
		return getSqlSession().insert("EspPublishInfModel.insert", espPublishInf);
	}

	public List<EspPublishInfModel> findAll() {
		return getSqlSession().selectList("EspPublishInfModel.findAll");
	}

	public EspPublishInfModel findById(Long id) {
		return getSqlSession().selectOne("EspPublishInfModel.findById", id);
	}

	public Pager<EspPublishInfModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("EspPublishInfModel.count", params);
		if (total == 0) {
			return Pager.empty(EspPublishInfModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<EspPublishInfModel> data = getSqlSession().selectList("EspPublishInfModel.pager", paramMap);
		return new Pager<EspPublishInfModel>(total, data);
	}

	public Integer delete(EspPublishInfModel espPublishInf) {
		return getSqlSession().delete("EspPublishInfModel.delete", espPublishInf);
	}
}