package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.CouponScaleModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class CouponScaleDao extends SqlSessionDaoSupport {

	public Integer update(CouponScaleModel couponScale) {
		return getSqlSession().update("CouponScaleModel.update", couponScale);
	}

	public Integer insert(CouponScaleModel couponScale) {
		return getSqlSession().insert("CouponScaleModel.insert", couponScale);
	}

	public List<CouponScaleModel> findAll() {
		return getSqlSession().selectList("CouponScaleModel.findAll");
	}
	//检出未删除的
	public List<CouponScaleModel> findValidAll() {
		return getSqlSession().selectList("CouponScaleModel.findValidAll");
	}


	public CouponScaleModel findById(Long id) {
		return getSqlSession().selectOne("CouponScaleModel.findById", id);
	}

	public Pager<CouponScaleModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("CouponScaleModel.count", params);
		if (total == 0) {
			return Pager.empty(CouponScaleModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<CouponScaleModel> data = getSqlSession().selectList("CouponScaleModel.pager", paramMap);
		return new Pager<CouponScaleModel>(total, data);
	}

	public Integer delete(CouponScaleModel couponScale) {
		return getSqlSession().delete("CouponScaleModel.delete", couponScale);
	}

	public List<CouponScaleModel> getBirthScale() {
		return getSqlSession().selectList("CouponScaleModel.getBirthScale");
	}
}