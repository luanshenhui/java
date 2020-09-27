package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderVirtualModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class OrderVirtualDao extends SqlSessionDaoSupport {

	public Integer update(OrderVirtualModel orderVirtual) {
		return getSqlSession().update("OrderVirtualModel.update", orderVirtual);
	}

	public Integer insert(OrderVirtualModel orderVirtual) {
		return getSqlSession().insert("OrderVirtualModel.insert", orderVirtual);
	}

	public Integer insertBatch(List orderVirtualList) {
		return getSqlSession().insert("OrderVirtualModel.insertBatch", orderVirtualList);
	}

	public List<OrderVirtualModel> findAll() {
		return getSqlSession().selectList("OrderVirtualModel.findAll");
	}

	public OrderVirtualModel findById(Long orderVirtualId) {
		return getSqlSession().selectOne("OrderVirtualModel.findById", orderVirtualId);
	}

	public Pager<OrderVirtualModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderVirtualModel.count", params);
		if (total == 0) {
			return Pager.empty(OrderVirtualModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderVirtualModel> data = getSqlSession().selectList("OrderVirtualModel.pager", paramMap);
		return new Pager<OrderVirtualModel>(total, data);
	}

	public Integer delete(OrderVirtualModel orderVirtual) {
		return getSqlSession().delete("OrderVirtualModel.delete", orderVirtual);
	}

	/**
	 * Description : 通过订单ID查找扩展
	 *
	 * @param OrderIds 订单ID
	 * @return
	 */
	public List<OrderVirtualModel> findVirualByOrderIds(List OrderIds) {
		if (OrderIds != null && !OrderIds.isEmpty()) {
			return getSqlSession().selectList("OrderVirtualModel.findVirualByOrderIds", OrderIds);
		}
		return new ArrayList<OrderVirtualModel>();
	}

	public List<OrderVirtualModel> findListByIds(List<String> orderIds) {
		return getSqlSession().selectList("OrderVirtualModel.findListByIds", orderIds);
	}

	public List<OrderVirtualModel> findByCertNo(Map<String, Object> paramaMap) {
		return getSqlSession().selectList("OrderVirtualModel.findByCertNo",paramaMap);
	}
	/***
	 * 通过订单Id查询对象List
	 * @param orderId
	 * @return
	 */
	public List<OrderVirtualModel> findByOrderId(String orderId) {
		return getSqlSession().selectList("OrderVirtualModel.findByOrderId", orderId);
	}
}