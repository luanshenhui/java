package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.user.model.ACardLevelToelectronbankModel;

@Repository
public class ACardLevelToelectronbankDao extends SqlSessionDaoSupport {

	public Integer update(ACardLevelToelectronbankModel acardLevelToelectronbank) {
		return getSqlSession().update("AcardLevelToelectronbankModel.update", acardLevelToelectronbank);
	}

	public Integer insert(ACardLevelToelectronbankModel acardLevelToelectronbank) {
		return getSqlSession().insert("AcardLevelToelectronbankModel.insert", acardLevelToelectronbank);
	}

	public List<ACardLevelToelectronbankModel> findAll() {
		return getSqlSession().selectList("AcardLevelToelectronbankModel.findAll");
	}

	public ACardLevelToelectronbankModel findById(String cardLevelNbr) {
		return getSqlSession().selectOne("AcardLevelToelectronbankModel.findById", cardLevelNbr);
	}

	/**
	 * 根据 cardLevelNbr 查询ACardLevelToelectronbankModel
	 * @param cardLevelNbr 查询条件
	 * @return ACardLevelToelectronbankModel
	 *
	 * add by zhoupeng
     */
	public ACardLevelToelectronbankModel findByCardLevelNbr(String cardLevelNbr) {
		return getSqlSession().selectOne("AcardLevelToelectronbankModel.findByCardLevelNbr", cardLevelNbr);
	}

	public Pager<ACardLevelToelectronbankModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("AcardLevelToelectronbankModel.count", params);
		if (total == 0) {
			return Pager.empty(ACardLevelToelectronbankModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<ACardLevelToelectronbankModel> data = getSqlSession().selectList("AcardLevelToelectronbankModel.pager",
				paramMap);
		return new Pager<ACardLevelToelectronbankModel>(total, data);
	}

	public Integer delete(ACardLevelToelectronbankModel acardLevelToelectronbank) {
		return getSqlSession().delete("AcardLevelToelectronbankModel.delete", acardLevelToelectronbank);
	}

	/**
	 * 根据卡等级代码列表查询详细信息
	 * @param idList 卡等级代码列表
	 * @return 查询结果
	 *
	 * geshuo 20160721
	 */
	public List<ACardLevelToelectronbankModel> findCardLevelByIdList(List<String> idList) {
		return getSqlSession().selectList("AcardLevelToelectronbankModel.findCardLevelByIdList",idList);
	}
}