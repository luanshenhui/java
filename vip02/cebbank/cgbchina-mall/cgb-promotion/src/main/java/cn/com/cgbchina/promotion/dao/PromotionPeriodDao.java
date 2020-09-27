package cn.com.cgbchina.promotion.dao;

import cn.com.cgbchina.promotion.model.PromotionPeriodModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class PromotionPeriodDao extends SqlSessionDaoSupport {

	public Integer update(PromotionPeriodModel promotionPeriod) {
		return getSqlSession().update("PromotionPeriodModel.update", promotionPeriod);
	}

	public Integer insert(PromotionPeriodModel promotionPeriod) {
		return getSqlSession().insert("PromotionPeriodModel.insert", promotionPeriod);
	}

	public List<PromotionPeriodModel> findAll() {
		return getSqlSession().selectList("PromotionPeriodModel.findAll");
	}

	public PromotionPeriodModel findById(Integer id) {
		return getSqlSession().selectOne("PromotionPeriodModel.findById", id);
	}

	public Pager<PromotionPeriodModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PromotionPeriodModel.count", params);
		if (total == 0) {
			return Pager.empty(PromotionPeriodModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PromotionPeriodModel> data = getSqlSession().selectList("PromotionPeriodModel.pager", paramMap);
		return new Pager<PromotionPeriodModel>(total, data);
	}

	public Integer delete(PromotionPeriodModel promotionPeriod) {
		return getSqlSession().delete("PromotionPeriodModel.delete", promotionPeriod);
	}

	public Integer insertAll(List<PromotionPeriodModel> list) {
		return getSqlSession().insert("PromotionPeriodModel.insertAll", list);
	}

	public List<PromotionPeriodModel> getForBatch(Map<String, Object> map) {
		return getSqlSession().selectList("PromotionPeriodModel.getForBatch", map);
	}


	/**
	 * 查询正在进行的活动
	 *
	 * @return
	 */
	public List<Integer> findNowPromotionIds(){
		return getSqlSession().selectList("PromotionPeriodModel.findNowPromotionIds");
	}
}