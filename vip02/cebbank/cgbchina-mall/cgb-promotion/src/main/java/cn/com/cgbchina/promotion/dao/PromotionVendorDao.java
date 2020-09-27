package cn.com.cgbchina.promotion.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.promotion.model.PromotionVendorModel;

@Repository
public class PromotionVendorDao extends SqlSessionDaoSupport {

	public Integer update(PromotionVendorModel promotionVendor) {
		return getSqlSession().update("PromotionVendorModel.update", promotionVendor);
	}

	public Integer insert(PromotionVendorModel promotionVendor) {
		return getSqlSession().insert("PromotionVendorModel.insert", promotionVendor);
	}

	public List<PromotionVendorModel> findAll() {
		return getSqlSession().selectList("PromotionVendorModel.findAll");
	}

	public PromotionVendorModel findById(Integer id) {
		return getSqlSession().selectOne("PromotionVendorModel.findById", id);
	}

	public Pager<PromotionVendorModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PromotionVendorModel.count", params);
		if (total == 0) {
			return Pager.empty(PromotionVendorModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PromotionVendorModel> data = getSqlSession().selectList("PromotionVendorModel.pager", paramMap);
		return new Pager<PromotionVendorModel>(total, data);
	}

	public Integer delete(PromotionVendorModel promotionVendor) {
		return getSqlSession().delete("PromotionVendorModel.delete", promotionVendor);
	}

	public Integer promAvailable(Map<String, Object> params) {
		return getSqlSession().selectOne("PromotionVendorModel.countPromAvailable", params);
	}

	public List<PromotionVendorModel> findByPromotion(Integer promotionId) {
		return getSqlSession().selectList("PromotionVendorModel.findByPromotion", promotionId);
	}

	public Integer insertAll(List<PromotionVendorModel> list) {
		return getSqlSession().insert("PromotionVendorModel.insertAll", list);
	}

	public List<String> findVendorByPromotionId(Integer promotionId) {
		return getSqlSession().selectList("PromotionVendorModel.findVendorByPromotionId", promotionId);
	}

	public Integer logicDelete(List<PromotionVendorModel> list) {
		return getSqlSession().update("PromotionVendorModel.logicDelete", list);
	}
}