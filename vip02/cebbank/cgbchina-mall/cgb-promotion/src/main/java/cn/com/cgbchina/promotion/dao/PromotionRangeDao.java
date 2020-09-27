package cn.com.cgbchina.promotion.dao;

import cn.com.cgbchina.promotion.dto.RangeStatusDto;
import cn.com.cgbchina.promotion.model.PromotionRangeModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class PromotionRangeDao extends SqlSessionDaoSupport {

	public Integer update(PromotionRangeModel promotionRange) {
		return getSqlSession().update("PromotionRangeModel.update", promotionRange);
	}

	public Integer updateByCodeAndPromId(PromotionRangeModel promotionRange) {
		return getSqlSession().update("PromotionRangeModel.updateByCodeAndPromId", promotionRange);
	}

	public Integer insert(PromotionRangeModel promotionRange) {
		return getSqlSession().insert("PromotionRangeModel.insert", promotionRange);
	}

	public List<PromotionRangeModel> findAll() {
		return getSqlSession().selectList("PromotionRangeModel.findAll");
	}

	public PromotionRangeModel findById(Integer id) {
		return getSqlSession().selectOne("PromotionRangeModel.findById", id);
	}

	public Pager<PromotionRangeModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PromotionRangeModel.count", params);
		if (total == 0) {
			return Pager.empty(PromotionRangeModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PromotionRangeModel> data = getSqlSession().selectList("PromotionRangeModel.pager", paramMap);
		return new Pager<PromotionRangeModel>(total, data);
	}

	public Integer delete(PromotionRangeModel promotionRange) {
		return getSqlSession().delete("PromotionRangeModel.delete", promotionRange);
	}

	public Integer insertAllForVendor(List<PromotionRangeModel> list) {
		return getSqlSession().insert("PromotionRangeModel.insertAllForVendor", list);
	}

	public List<PromotionRangeModel> findByPromId(Integer promotionId) {
		return getSqlSession().selectList("PromotionRangeModel.findByPromId", promotionId);
	}

	public List<String> findSelectCodeByPromId(Integer promotionId) {
		return getSqlSession().selectList("PromotionRangeModel.findSelectCodeByPromId", promotionId);
	}

	public List<PromotionRangeModel> findByParams(Map<String, Object> params) {
		return getSqlSession().selectList("PromotionRangeModel.findByParams", params);
	}

	public Integer insertAll(List<PromotionRangeModel> list) {
		return getSqlSession().insert("PromotionRangeModel.insertAll", list);
	}

	public Integer insertAllForAdmin(List<PromotionRangeModel> list) {
		return getSqlSession().insert("PromotionRangeModel.insertAllForAdmin", list);
	}

	public Integer updateAll(List<PromotionRangeModel> list) {
		return getSqlSession().update("PromotionRangeModel.updateAll", list);
	}

	public Integer updateCheckStatus(Map<String, Object> map) {
		return getSqlSession().update("PromotionRangeModel.updateCheckStatus", map);
	}

	public List<Integer> findPromotionId(Map<String, Object> map) {
		return getSqlSession().selectList("PromotionRangeModel.findPromotionId", map);
	}

	public Integer updateStatusByPromotion(Map<String, Object> map) {
		return getSqlSession().update("PromotionRangeModel.updateStatusByPromotion", map);
	}

	public RangeStatusDto rangeStatus(Integer promotionId) {
		return getSqlSession().selectOne("PromotionRangeModel.rangeStatus", promotionId);
	}

	public Integer promRangeByParamCount(Map<String, Object> map) {
		return getSqlSession().selectOne("PromotionRangeModel.promRangeByParamCount", map);

	}

	public Integer updateAllForAdmin(Map<String,Object> map) {
		return getSqlSession().update("PromotionRangeModel.updateAllForAdmin", map);
	}

	// 获取供应商当前正在参加活动的ItemCode list集合
	public List<String> findItemCodes(Map<String, Object> map) {
		return getSqlSession().selectList("PromotionRangeModel.findItemCodes", map);
	}
	public Integer logicDelete(Map<String,Object> map){
		return getSqlSession().update("PromotionRangeModel.logicDelete",map);
	}

	/**
	 * 根据活动id查询活动单品列表
	 * @param idList
	 * @return
	 * geshuo 20160713
	 */
	public List<PromotionRangeModel> findRangeByPromIdList(List<Integer> idList) {
		return getSqlSession().selectList("PromotionRangeModel.findRangeByPromIdList", idList);
	}
}