package cn.com.cgbchina.item.dao;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.model.PromotionRangeModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.item.dto.RangeStatusDto;

@Repository
public class PromotionRangeDao extends SqlSessionDaoSupport {



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

	public List<String> findSelectCodeByPromId(Map<String, Object> map) {
		return getSqlSession().selectList("PromotionRangeModel.findSelectCodeByPromId", map);
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

	public Integer updateAllForAdmin(Map<String, Object> map) {
		return getSqlSession().update("PromotionRangeModel.updateAllForAdmin", map);
	}

	// 获取供应商当前正在参加活动的ItemCode list集合
	public List<String> findItemCodes(Map<String, Object> map) {
		return getSqlSession().selectList("PromotionRangeModel.findItemCodes", map);
	}

	public Integer logicDelete(Map<String, Object> map) {
		return getSqlSession().update("PromotionRangeModel.logicDelete", map);
	}

	/**
	 * 根据活动id查询活动单品列表
	 *
	 * @param paramMap
	 * @return geshuo 20160713
	 */
	public List<PromotionRangeModel> findRangeListByParams(Map<String, Object> paramMap) {
		return getSqlSession().selectList("PromotionRangeModel.findRangeListByParams", paramMap);
	}

	/**
	 * 根据活动id列表查询所有三级后台类目
	 *
	 * @param idList
	 * @return
	 */
	public List<Long> findBackCategory3IdList(List<Integer> idList) {
		return getSqlSession().selectList("PromotionRangeModel.findBackCategory3IdList", idList);
	}

	public Long getPerStockByPromItem(Map<String, Object> map) {
		return getSqlSession().selectOne("PromotionRangeModel.getPerStockByPromItem", map);
	}

	/**
	 * 根据rangeid List 查询活动单品数据
	 *
	 * @param rangeIdList
	 * @return
	 */
	public List<PromotionRangeModel> findByRangIds(List<String> rangeIdList) {
		return getSqlSession().selectList("PromotionRangeModel.findByRangIds", rangeIdList);
	}

	public List<Integer> getPromByItemIds(List<String> itemCodes) {
		return getSqlSession().selectList("PromotionRangeModel.getPromByItemIds", itemCodes);
	}

	public List<Integer> getPromByItemId(String itemCode) {
		return getSqlSession().selectList("PromotionRangeModel.getPromByItemId", itemCode);
	}

	public Pager<PromotionRangeModel> findRangeForStatistics(Map<String, Object> param) {
		Long total = getSqlSession().selectOne("PromotionRangeModel.findRangeForStatisticsCount", param);
		if (total == 0) {
			return Pager.empty(PromotionRangeModel.class);
		}
		List<PromotionRangeModel> data = getSqlSession().selectList("PromotionRangeModel.findRangeForStatistics",
				param);
		return new Pager<>(total, data);
	}

	public Integer updateSaleCount(Map<String, Object> param) {
		return getSqlSession().update("PromotionRangeModel.updateSaleCount", param);
	}

	public List<PromotionRangeModel> findByGoodsId(String goodsId) {
		return getSqlSession().selectList("PromotionRangeModel.findByGoodsId", goodsId);
	}

	/**
	 * 根据rangeid List 查询活动已售完单品数据
	 *
	 * @param param
	 * @return
	 */
	public List<PromotionRangeModel> findSaleOverByRangIds(Map<String, Object> param) {
		return getSqlSession().selectList("PromotionRangeModel.findSaleOverByRangIds", param);
	}

	public List<PromotionRangeModel> findByPromIdAndVendor(Map<String, Object> param) {
		return getSqlSession().selectList("PromotionRangeModel.findByPromIdAndVendor", param);
	}

	public Integer updateRangesByIds(List<PromotionRangeModel> param) {
		return getSqlSession().update("PromotionRangeModel.updateRangesByIds", param);
	}

	public Integer deleteByIds(List<Integer> ids) {
		return getSqlSession().delete("PromotionRangeModel.deleteByIds", ids);
	}

	public Integer updatePromotionStock(Map<String, Object> param) {
		return getSqlSession().update("PromotionRangeModel.updatePromotionStok", param);
	}

	public Integer updateRollbackPromotionStock(Map<String, Object> param) {
		return getSqlSession().update("PromotionRangeModel.updateRollbackPromotionStok", param);
	}

	public List<Integer> findWorkPromByItem(List<String> itemCodes) {
		return getSqlSession().selectList("PromotionRangeModel.findWorkPromByItem", itemCodes);
	}
	public List<PromotionRangeModel> findByPromIdAndClassify(Map<String,Object> params){
		return getSqlSession().selectList("PromotionRangeModel.findByPromIdAndClassify",params);
	}
}