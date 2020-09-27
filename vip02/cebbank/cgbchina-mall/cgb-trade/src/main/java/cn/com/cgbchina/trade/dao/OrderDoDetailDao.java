package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderDoDetailDao extends SqlSessionDaoSupport {

	public Integer update(OrderDoDetailModel orderDoDetailModel) {
		return getSqlSession().update("OrderDoDetail.update", orderDoDetailModel);
	}

	public Integer insert(OrderDoDetailModel orderDoDetailModel) {
		return getSqlSession().insert("OrderDoDetail.insert", orderDoDetailModel);
	}

	/**
	 * 批量插入订单处理历史明细表信息
	 *
	 * @param orderDoDetailModelList
	 * @return
	 */
	public Integer insertBatch(List orderDoDetailModelList) {
		return getSqlSession().insert("OrderDoDetail.insertBatch", orderDoDetailModelList);
	}

	public List<OrderDoDetailModel> findAll() {
		return getSqlSession().selectList("OrderDoDetail.findAll");
	}

	public OrderDoDetailModel findById(Long id) {
		return getSqlSession().selectOne("OrderDoDetail.findById", id);
	}

	public List<OrderDoDetailModel> findByOrderId(String orderId) {
		return getSqlSession().selectList("OrderDoDetail.findByOrderId", orderId);
	}

	public Pager<OrderDoDetailModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderDoDetail.count", params);
		if (total == 0) {
			return Pager.empty(OrderDoDetailModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderDoDetailModel> data = getSqlSession().selectList("OrderDoDetail.pager", paramMap);
		return new Pager<OrderDoDetailModel>(total, data);
	}

	public Integer delete(OrderDoDetailModel orderDoDetailModel) {
		return getSqlSession().delete("OrderDoDetail.delete", orderDoDetailModel);
	}
}