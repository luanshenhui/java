package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.FirstLoginCouponModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class FirstLoginCouponDao extends SqlSessionDaoSupport {

	public Integer update(FirstLoginCouponModel firstLoginCouponModel) {
		return getSqlSession().update("FirstLoginCoupon.update", firstLoginCouponModel);
	}

	public Integer insert(FirstLoginCouponModel firstLoginCouponModel) {
		return getSqlSession().insert("FirstLoginCoupon.insert", firstLoginCouponModel);
	}

	public List<FirstLoginCouponModel> findAll() {
		return getSqlSession().selectList("FirstLoginCoupon.findAll");
	}

	public FirstLoginCouponModel findById(Long id) {
		return getSqlSession().selectOne("FirstLoginCoupon.findById", id);
	}

	public Pager<FirstLoginCouponModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("FirstLoginCoupon.count", params);
		if (total == 0) {
			return Pager.empty(FirstLoginCouponModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<FirstLoginCouponModel> data = getSqlSession().selectList("FirstLoginCoupon.pager", paramMap);
		return new Pager<FirstLoginCouponModel>(total, data);
	}

	public Integer delete(FirstLoginCouponModel firstLoginCouponModel) {
		return getSqlSession().delete("FirstLoginCoupon.delete", firstLoginCouponModel);
	}
}