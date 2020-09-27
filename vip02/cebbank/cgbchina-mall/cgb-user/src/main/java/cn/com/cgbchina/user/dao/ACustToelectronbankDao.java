package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;



@Repository
public class ACustToelectronbankDao extends SqlSessionDaoSupport {

	public Integer update(ACustToelectronbankModel aCustToelectronbank) {
		return getSqlSession().update("ACustToelectronbankModel.update", aCustToelectronbank);
	}

	public Integer insert(ACustToelectronbankModel aCustToelectronbank) {
		return getSqlSession().insert("ACustToelectronbankModel.insert", aCustToelectronbank);
	}

	public List<ACustToelectronbankModel> findAll() {
		return getSqlSession().selectList("ACustToelectronbankModel.findAll");
	}

	public ACustToelectronbankModel findById(String certNbr) {
		return getSqlSession().selectOne("ACustToelectronbankModel.findById", certNbr);
	}

	public Pager<ACustToelectronbankModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("ACustToelectronbankModel.count", params);
		if (total == 0) {
			return Pager.empty(ACustToelectronbankModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<ACustToelectronbankModel> data = getSqlSession().selectList("ACustToelectronbankModel.pager", paramMap);
		return new Pager<ACustToelectronbankModel>(total, data);
	}

	public Integer delete(ACustToelectronbankModel aCustToelectronbank) {
		return getSqlSession().delete("ACustToelectronbankModel.delete", aCustToelectronbank);
	}

	public List<ACustToelectronbankModel> selectBirthDay(String certNo) {
		return getSqlSession().selectList("ACustToelectronbankModel.selectBirthDay", certNo);
	}

	public ACustToelectronbankModel findMaxCardLevelInfo(String certNbr) {
		return getSqlSession().selectOne("ACustToelectronbankModel.findMaxCardLevelInfo", certNbr);
	}
}