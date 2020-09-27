package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;



@Repository
public class ACardCustToelectronbankDao extends SqlSessionDaoSupport {

	public Integer update(ACardCustToelectronbankModel aCardCustToelectronbank) {
		return getSqlSession().update("ACardCustToelectronbankModel.update", aCardCustToelectronbank);
	}

	public Integer insert(ACardCustToelectronbankModel aCardCustToelectronbank) {
		return getSqlSession().insert("ACardCustToelectronbankModel.insert", aCardCustToelectronbank);
	}

	public List<ACardCustToelectronbankModel> findAll() {
		return getSqlSession().selectList("ACardCustToelectronbankModel.findAll");
	}

	public ACardCustToelectronbankModel findById(String cardNbr) {
		return getSqlSession().selectOne("ACardCustToelectronbankModel.findById", cardNbr);
	}

	public Pager<ACardCustToelectronbankModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("ACardCustToelectronbankModel.count", params);
		if (total == 0) {
			return Pager.empty(ACardCustToelectronbankModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<ACardCustToelectronbankModel> data = getSqlSession().selectList("ACardCustToelectronbankModel.pager",
				paramMap);
		return new Pager<ACardCustToelectronbankModel>(total, data);
	}

	public Integer delete(ACardCustToelectronbankModel aCardCustToelectronbank) {
		return getSqlSession().delete("ACardCustToelectronbankModel.delete", aCardCustToelectronbank);
	}

	/**
	 * 根据卡号查找卡客户明细
	 *
	 * @param cardNbr
	 * @return
	 */
	public ACardCustToelectronbankModel findByCardNbr(String cardNbr) {
		return getSqlSession().selectOne("ACardCustToelectronbankModel.findByCardNbr", cardNbr);
	}

	public List<ACardCustToelectronbankModel> findListByCertNbr(String certNbr) {
		return getSqlSession().selectOne("ACardCustToelectronbankModel.findListByCertNbr", certNbr);
	}
}