package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.model.BuyCountModel;
import cn.com.cgbchina.trade.model.OrderGoodsDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class OrderSubDao extends SqlSessionDaoSupport {

	public Integer update(OrderSubModel orderSubModel) {
		return getSqlSession().update("OrderSub.update", orderSubModel);
	}
	public Integer updateStatues(OrderSubModel orderSubModel) {
		return getSqlSession().update("OrderSub.updateStatues", orderSubModel);
	}

	public Integer insert(OrderSubModel orderSubModel) {
		return getSqlSession().insert("OrderSub.insert", orderSubModel);
	}

	/**
	 * 批量插入订单表信息
	 *
	 * @param orderSubModelList
	 * @return
	 */
	public Integer insertBatch(List orderSubModelList) {
		return getSqlSession().insert("OrderSub.insertBatch", orderSubModelList);
	}

	/**
	 * 批量更新订单表信息
	 *
	 * @param orderSubModelList
	 * @return
	 */
	public Integer updateBatch(List orderSubModelList) {
		return getSqlSession().update("OrderSub.updateBatch", orderSubModelList);
	}


	public List<OrderSubModel> findAll() {
		return getSqlSession().selectList("OrderSub.findAll");
	}

	public OrderSubModel findById(String orderId) {
		return getSqlSession().selectOne("OrderSub.findById", orderId);
	}

	public Pager<OrderSubModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderSub.count", params);
		if (total == 0) {
			return Pager.empty(OrderSubModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.pager", paramMap);
		return new Pager<OrderSubModel>(total, data);
	}

	public Pager<OrderSubModel> findLikeByPageForReq(Map<String, Object> params, int offset, int limit) {
		//0元秒杀订单不作为检索对象
		params.put("actTypeSecond", Contants.ORDER_ACT_TYPE_SECOND);
		//供应商请款订单状态 IN(已签收，退货申请，拒绝退货申请) 作为固定检索条件
		params.put("curStatusReceive",Contants.SUB_ORDER_STATUS_0310);
		params.put("curStatusBack",Contants.SUB_ORDER_STATUS_0334);
		params.put("curStatusUnBack",Contants.SUB_ORDER_STATUS_0335);
		Long total = getSqlSession().selectOne("OrderSub.countLikeForReq", params);
		if (total == 0) {
			return Pager.empty(OrderSubModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.pagerLikeForReq", paramMap);
		return new Pager<OrderSubModel>(total, data);
	}

	public Pager<OrderSubModel> findLikeByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderSub.countLike", params);
		if (total == 0) {
			return Pager.empty(OrderSubModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.pagerLike", paramMap);
		return new Pager<OrderSubModel>(total, data);
	}
	public Pager<OrderSubModel> findLikeByPagePart(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderSub.countLikePart", params);
		if (total == 0) {
			return Pager.empty(OrderSubModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.pagerLikePart", paramMap);
		return new Pager<OrderSubModel>(total, data);
	}

	public Integer delete(OrderSubModel orderSubModel) {
		return getSqlSession().delete("OrderSub.delete", orderSubModel);
	}

	public List<OrderSubModel> findSuccess(Map<String, Object> params) {
		return getSqlSession().selectList("OrderSub.findSuccess", params);
	}

    public OrderSubModel findOrderCount(Map<String, Object> params) {
        return getSqlSession().selectOne("OrderSub.findOrderCount", params);
    }

	public List<OrderSubModel> findTopVendor(Map<String, Object> params) {
		return getSqlSession().selectList("OrderSub.findTopVendor", params);
	}

	public List<OrderSubModel> findTopBrand(Map<String, Object> params) {
		return getSqlSession().selectList("OrderSub.findTopBrand", params);
	}

	public Integer updateById(Map<String, Object> dataMap) {
		return getSqlSession().update("OrderSub.updateByIds", dataMap);
	}

	public Integer updateRefuseById(HashMap<String, Object> dataMap) {
		return getSqlSession().update("OrderSub.updateRefuseById", dataMap);
	}

	public Integer updatePassById(HashMap<String, Object> dataMap) {
		return getSqlSession().update("OrderSub.updatePassById", dataMap);
	}

	public List<OrderSubModel> findOrderCountByWeekDay(Map<String, Object> params) {
		return getSqlSession().selectList("OrderSub.findOrderCountByWeekDay", params);
	}

	public List<OrderSubModel> findPersonCountByWeekDay(Map<String, Object> params) {
		return getSqlSession().selectList("OrderSub.findPersonCountByWeekDay", params);
	}

	public List<OrderSubModel> findAcceptOrder(){
		return getSqlSession().selectList("OrderSub.findAcceptOrder");
	}

	public List<OrderSubModel> findByOrderMainId(String orderMainId) {
		return getSqlSession().selectList("OrderSub.findByOrderMainId", orderMainId);
	}

	public List<String> findVendorIdsByOrderMainId(String orderMainId) {
		return getSqlSession().selectList("OrderSub.findByOrderMainId", orderMainId);
	}

    public Integer updateAllRevocation(Map<String, Object> paramMap) {
        return getSqlSession().update("OrderSub.updateAllRevocation", paramMap);
    }

	public Pager<String> findMainIdLikeByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderSub.countLikeMainId", params);
		if (total == 0) {
			return Pager.empty(String.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<String> data = getSqlSession().selectList("OrderSub.pagerLikeMainId", paramMap);
		return new Pager<String>(total, data);
	}

	public List<OrderSubModel> findTopOrder(List<OrderSubModel> subList) {
		return getSqlSession().selectList("OrderSub.findTop", subList);
	}

	public List<OrderSubModel> findTopGoods(List<OrderSubModel> subList) {
		return getSqlSession().selectList("OrderSub.findTopGoods", subList);
	}

	/**
	 * 获取单品已购买的件数
	 * @param paramMap
	 * @return
	 *
	 * geshuo 20160707
	 */
	public List<BuyCountModel> findItemBuyCount(Map<String, Object> paramMap){
		return getSqlSession().selectList("OrderSub.findItemBuyCount", paramMap);
	}
}