package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderPartBackModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderPartBackDao extends SqlSessionDaoSupport {

	public Integer update(OrderPartBackModel orderPartBack) {
		return getSqlSession().update("OrderPartBack.update", orderPartBack);
	}

	public Integer insert(OrderPartBackModel orderPartBack) {
		return getSqlSession().insert("OrderPartBack.insert", orderPartBack);
	}

	public List<OrderPartBackModel> findAll() {
		return getSqlSession().selectList("OrderPartBack.findAll");
	}

	public OrderPartBackModel findById(Long id) {
		return getSqlSession().selectOne("OrderPartBack.findById", id);
	}

	public OrderPartBackModel findByOrderId(String orderId) {
		return getSqlSession().selectOne("OrderPartBack.findByOrderId", orderId);
	}

	public Pager<OrderPartBackModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderPartBack.count", params);
		if (total == 0) {
			return Pager.empty(OrderPartBackModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderPartBackModel> data = getSqlSession().selectList("OrderPartBack.pager", paramMap);
		return new Pager<OrderPartBackModel>(total, data);
	}

	public Integer delete(OrderPartBackModel orderPartBack) {
		return getSqlSession().delete("OrderPartBack.delete", orderPartBack);
	}

	public Integer updateAll(Map<String, Object> params) {
		return getSqlSession().update("OrderPartBack.updateAll", params);
	}
}