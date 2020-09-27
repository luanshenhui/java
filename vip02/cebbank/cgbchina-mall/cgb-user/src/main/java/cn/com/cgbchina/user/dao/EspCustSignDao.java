package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.EspCustSignModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class EspCustSignDao extends SqlSessionDaoSupport {

	public Integer update(EspCustSignModel espCustSignModel) {
		return getSqlSession().update("EspCustSign.update", espCustSignModel);
	}

	public Integer insert(EspCustSignModel espCustSignModel) {
		return getSqlSession().insert("EspCustSign.insert", espCustSignModel);
	}

	public List<EspCustSignModel> findAll() {
		return getSqlSession().selectList("EspCustSign.findAll");
	}

	public EspCustSignModel findById(Long id) {
		return getSqlSession().selectOne("EspCustSign.findById", id);
	}

	public Pager<EspCustSignModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("EspCustSign.count", params);
		if (total == 0) {
			return Pager.empty(EspCustSignModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<EspCustSignModel> data = getSqlSession().selectList("EspCustSign.pager", paramMap);
		return new Pager<EspCustSignModel>(total, data);
	}

	public Integer delete(EspCustSignModel espCustSignModel) {
		return getSqlSession().delete("EspCustSign.delete", espCustSignModel);
	}
}