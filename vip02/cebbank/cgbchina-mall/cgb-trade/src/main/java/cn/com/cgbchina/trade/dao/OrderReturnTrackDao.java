package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderReturnTrackModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderReturnTrackDao extends SqlSessionDaoSupport {

	public Integer update(OrderReturnTrackModel orderReturnTrack) {
		return getSqlSession().update("OrderReturnTrack.update", orderReturnTrack);
	}

	public Integer insert(OrderReturnTrackModel orderReturnTrack) {
		return getSqlSession().insert("OrderReturnTrack.insert", orderReturnTrack);
	}

	public List<OrderReturnTrackModel> findAll() {
		return getSqlSession().selectList("OrderReturnTrack.findAll");
	}

	public OrderReturnTrackModel findById(Long id) {
		return getSqlSession().selectOne("OrderReturnTrack.findById", id);
	}

	public List<OrderReturnTrackModel> findByPartbackId(Long partbackId) {
		return getSqlSession().selectList("OrderReturnTrack.findByPartbackId", partbackId);
	}

	public Pager<OrderReturnTrackModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderReturnTrack.count", params);
		if (total == 0) {
			return Pager.empty(OrderReturnTrackModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderReturnTrackModel> data = getSqlSession().selectList("OrderReturnTrack.pager", paramMap);
		return new Pager<OrderReturnTrackModel>(total, data);
	}

	public Integer delete(OrderReturnTrackModel orderReturnTrack) {
		return getSqlSession().delete("OrderReturnTrack.delete", orderReturnTrack);
	}

	public Integer insertList(List<OrderReturnTrackModel> orderReturnTrackModelList) {
		return getSqlSession().insert("OrderReturnTrack.insertList", orderReturnTrackModelList);
	}
}