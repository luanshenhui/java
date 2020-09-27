package cn.com.cgbchina.promotion.dao;

import cn.com.cgbchina.promotion.model.PromotionFormalModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class PromotionFormalDao extends SqlSessionDaoSupport {

	public Integer update(PromotionFormalModel promotionFormal) {
		return getSqlSession().update("PromotionFormalModel.update", promotionFormal);
	}

	public Integer insert(PromotionFormalModel promotionFormal) {
		return getSqlSession().insert("PromotionFormalModel.insert", promotionFormal);
	}

	public List<PromotionFormalModel> findAll() {
		return getSqlSession().selectList("PromotionFormalModel.findAll");
	}

	public PromotionFormalModel findById(Integer id) {
		return getSqlSession().selectOne("PromotionFormalModel.findById", id);
	}

	public Pager<PromotionFormalModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PromotionFormalModel.count", params);
		if (total == 0) {
			return Pager.empty(PromotionFormalModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PromotionFormalModel> data = getSqlSession().selectList("PromotionFormalModel.pager", paramMap);
		return new Pager<PromotionFormalModel>(total, data);
	}

	public Integer delete(PromotionFormalModel promotionFormal) {
		return getSqlSession().delete("PromotionFormalModel.delete", promotionFormal);
	}
}