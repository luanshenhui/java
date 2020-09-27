package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderTransModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderTransDao extends SqlSessionDaoSupport {

	public Integer update(OrderTransModel orderTransModel) {
		return getSqlSession().update("OrderTrans.update", orderTransModel);
	}

	public Integer insert(OrderTransModel orderTransModel) {
		return getSqlSession().insert("OrderTrans.insert", orderTransModel);
	}

	public List<OrderTransModel> findAll() {
		return getSqlSession().selectList("OrderTrans.findAll");
	}

	public OrderTransModel findById(Long id) {
		return getSqlSession().selectOne("OrderTrans.findById", id);
	}

	public OrderTransModel findByOrderId(String orderId) {
		return getSqlSession().selectOne("OrderTrans.findByOrderId", orderId);
	}

	public Pager<OrderTransModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderTrans.count", params);
		if (total == 0) {
			return Pager.empty(OrderTransModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderTransModel> data = getSqlSession().selectList("OrderTrans.pager", paramMap);
		return new Pager<OrderTransModel>(total, data);
	}

	public Integer delete(OrderTransModel orderTransModel) {
		return getSqlSession().delete("OrderTrans.delete", orderTransModel);
	}
	public List<OrderTransModel> findByOrderIds(List subOrderIds) {
		return getSqlSession().selectList("OrderTrans.findByOrderIds", subOrderIds);
	}

	/**
	 * 批量签收更新签收人签收时间
	 * @param orderTransModel
	 * @return
	 */
	public Integer updateDoDesc(OrderTransModel orderTransModel) {
		return getSqlSession().update("OrderTrans.updateDoDesc", orderTransModel);
	}

}