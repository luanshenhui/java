package cn.com.cgbchina.item.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.item.model.PromotionPayWayModel;

@Repository
public class PromotionPayWayDao extends SqlSessionDaoSupport {

	public Integer update(PromotionPayWayModel promotionPayway) {
		return getSqlSession().update("PromotionPayWayModel.update", promotionPayway);
	}

	public Integer insert(PromotionPayWayModel promotionPayway) {
		return getSqlSession().insert("PromotionPayWayModel.insert", promotionPayway);
	}

	public List<PromotionPayWayModel> findAll() {
		return getSqlSession().selectList("PromotionPayWayModel.findAll");
	}

	public PromotionPayWayModel findById(String goodsPaywayId) {
		return getSqlSession().selectOne("PromotionPayWayModel.findById", goodsPaywayId);
	}

	public Pager<PromotionPayWayModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PromotionPayWayModel.count", params);
		if (total == 0) {
			return Pager.empty(PromotionPayWayModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PromotionPayWayModel> data = getSqlSession().selectList("PromotionPayWayModel.pager", paramMap);
		return new Pager<PromotionPayWayModel>(total, data);
	}

	public Integer delete(PromotionPayWayModel promotionPayway) {
		return getSqlSession().delete("PromotionPayWayModel.delete", promotionPayway);
	}

	public List<PromotionPayWayModel> findByGoodsId(String goodsId) {
		return getSqlSession().selectList("PromotionPayWayModel.findByGoodsId", goodsId);
	}

	public List<PromotionPayWayModel> findByGoodsIdAndPromType(String goodsId, String promType) {
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("goodsId", goodsId);
		paramMap.put("promType", promType);
		return getSqlSession().selectList("PromotionPayWayModel.findByGoodsIdAndPromType", paramMap);
	}

	public PromotionPayWayModel findByPromotionMap(Map<String, Object> param) {
		return getSqlSession().selectOne("PromotionPayWayModel.findByPromotionMap", param);
	}

	public PromotionPayWayModel findMaxPromotionPayway(Map<String, Object> params) {
		return getSqlSession().selectOne("PromotionPayWayModel.findMaxPromotionPayway", params);
	}

	/**
	 * 通过单品id和活动id获得支付方式
	 * @param itemCode
	 * @param promId
	 * @return
	 */
	public List<PromotionPayWayModel> findInfoByItemCode(String itemCode, Integer promId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("itemCode", itemCode);
		params.put("promId", promId);
		return getSqlSession().selectList("PromotionPayWayModel.findInfoByItemCode", params);
	}

	public Integer insertAllPayWay(List<PromotionPayWayModel> list) {
		return getSqlSession().insert("PromotionPayWayModel.insertAllPayWay", list);
	}
}