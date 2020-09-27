package cn.com.cgbchina.trade.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.trade.model.OrderMainModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class OrderMainDao extends SqlSessionDaoSupport {

	public Integer update(OrderMainModel orderMainModel) {
		return getSqlSession().update("OrderMain.update", orderMainModel);
	}

	public Integer insert(OrderMainModel orderMainModel) {
		return getSqlSession().insert("OrderMain.insert", orderMainModel);
	}

	public List<OrderMainModel> findAll() {
		return getSqlSession().selectList("OrderMain.findAll");
	}

	public OrderMainModel findById(String ordermainId) {
		return getSqlSession().selectOne("OrderMain.findById",ordermainId);
	}
	public OrderMainModel findByIdUnion(String ordermainId) {
		return getSqlSession().selectOne("OrderMain.findByIdUnion",ordermainId);
	}
	public Pager<OrderMainModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderMain.count", params);
		if (total == 0) {
			return Pager.empty(OrderMainModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderMainModel> data = getSqlSession().selectList("OrderMain.pager", paramMap);
		return new Pager<OrderMainModel>(total, data);
	}

	public Integer delete(OrderMainModel orderMainModel) {
		return getSqlSession().delete("OrderMain.delete", orderMainModel);
	}

	public List<OrderMainModel> findByOrderMainIds(Map<String, Object> params) {
		return getSqlSession().selectList("OrderMain.selectByOrdermainIds", params);
	}

	public List<String> findOrderMainIdById(String orderMainId) {
		return getSqlSession().selectList("OrderMain.findOrderMainIdById", orderMainId);
	}

	public Integer updateLockedFlag(String ordermainId) {
		return getSqlSession().update("OrderMain.updateLockedFlag", ordermainId);
	}

}