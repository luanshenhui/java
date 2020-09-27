package cn.com.cgbchina.item.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.item.model.TblGoodsRecommendationJfModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class TblGoodsRecommendationJfDao extends SqlSessionDaoSupport {

	public Integer update(TblGoodsRecommendationJfModel tblGoodsRecommendationJf) {
		return getSqlSession().update("TblGoodsRecommendationJfModel.update", tblGoodsRecommendationJf);
	}

	public Integer insert(TblGoodsRecommendationJfModel tblGoodsRecommendationJf) {
		return getSqlSession().insert("TblGoodsRecommendationJfModel.insert", tblGoodsRecommendationJf);
	}

	public List<TblGoodsRecommendationJfModel> findAll() {
		return getSqlSession().selectList("TblGoodsRecommendationJfModel.findAll");
	}

	public List<String> findItemCodeListByRegionId(Integer regionId) {
		return getSqlSession().selectList("TblGoodsRecommendationJfModel.findItemCodeListByRegionId", regionId);
	}

	public TblGoodsRecommendationJfModel findById(Integer id) {
		return getSqlSession().selectOne("TblGoodsRecommendationJfModel.findById", id);
	}

	public Pager<TblGoodsRecommendationJfModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblGoodsRecommendationJfModel.count", params);
		if (total == 0) {
			return Pager.empty(TblGoodsRecommendationJfModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblGoodsRecommendationJfModel> data = getSqlSession().selectList("TblGoodsRecommendationJfModel.pager",
				paramMap);
		return new Pager<TblGoodsRecommendationJfModel>(total, data);
	}

	public Integer delete(TblGoodsRecommendationJfModel tblGoodsRecommendationJf) {
		return getSqlSession().delete("TblGoodsRecommendationJfModel.delete", tblGoodsRecommendationJf);
	}
}