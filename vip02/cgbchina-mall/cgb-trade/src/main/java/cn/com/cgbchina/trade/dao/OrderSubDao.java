package cn.com.cgbchina.trade.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.model.BuyCountModel;
import cn.com.cgbchina.trade.model.OrderSubModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class OrderSubDao extends SqlSessionDaoSupport {

	public Integer update(OrderSubModel orderSubModel) {
		return getSqlSession().update("OrderSub.update", orderSubModel);
	}

	public Boolean updateForReturn(Map<String, Object> orderSubModel) {
		return getSqlSession().update("OrderSub.updateForReturn", orderSubModel) == 1;
	}

	public Integer updateStatues(OrderSubModel orderSubModel) {
		return getSqlSession().update("OrderSub.updateStatues", orderSubModel);
	}

	public Integer insert(OrderSubModel orderSubModel) {
		orderSubModel.setCreateTimeStr(DateHelper.date2string(orderSubModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
		orderSubModel.setModifyTimeStr(DateHelper.date2string(orderSubModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
		if (orderSubModel.getOrder_succ_time() != null) {
			orderSubModel.setOrder_succ_timeStr(DateHelper.date2string(orderSubModel.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		return getSqlSession().insert("OrderSub.insert", orderSubModel);
	}

	/**
	 * 批量插入订单表信息
	 *
	 * @param orderSubModelList
	 * @return
	 */
	public Integer insertBatch(List orderSubModelList) {
		for (int i = 0; i < orderSubModelList.size(); i++) {
			OrderSubModel orderSubModel = (OrderSubModel)orderSubModelList.get(i);
			orderSubModel.setCreateTimeStr(DateHelper.date2string(orderSubModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
			orderSubModel.setModifyTimeStr(DateHelper.date2string(orderSubModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
			if (orderSubModel.getOrder_succ_time() != null) {
				orderSubModel.setOrder_succ_timeStr(DateHelper.date2string(orderSubModel.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
			}
		}
		return getSqlSession().insert("OrderSub.insertBatch", orderSubModelList);
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
		String startTime = (String) params.get("startTime");
		String endTime = (String) params.get("endTime");
		if (!StringUtils.isEmpty(startTime)){
			params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		if (!StringUtils.isEmpty(endTime)){
			params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		// 0元秒杀订单不作为检索对象
		params.put("actTypeSecond", Contants.PROMOTION_PROM_TYPE_STRING_30);
		// 供应商请款订单状态 IN(已签收，退货申请，拒绝退货申请) 作为固定检索条件
		params.put("curStatusReceive", Contants.SUB_ORDER_STATUS_0310);
		params.put("curStatusBack", Contants.SUB_ORDER_STATUS_0334);
		params.put("curStatusUnBack", Contants.SUB_ORDER_STATUS_0335);
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

	public List<OrderSubModel> findLikeForReq(Map<String, Object> params) {
		String startTime = (String) params.get("startTime");
		String endTime = (String) params.get("endTime");
		if (!StringUtils.isEmpty(startTime)){
			params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		if (!StringUtils.isEmpty(endTime)){
			params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		// 0元秒杀订单不作为检索对象
		params.put("actTypeSecond", Contants.ORDER_ACT_TYPE_SECOND);
		// 供应商请款订单状态 IN(已签收，退货申请，拒绝退货申请) 作为固定检索条件
		params.put("curStatusReceive", Contants.SUB_ORDER_STATUS_0310);
		params.put("curStatusBack", Contants.SUB_ORDER_STATUS_0334);
		params.put("curStatusUnBack", Contants.SUB_ORDER_STATUS_0335);
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.findLikeForReq", paramMap);
		return data;
	}

	public Pager<OrderSubModel> findLikeByPageForBack(Map<String, Object> params, int offset, int limit) {
		String startTime = (String) params.get("startTime");
		String endTime = (String) params.get("endTime");
		if (!StringUtils.isEmpty(startTime)){
			params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		if (!StringUtils.isEmpty(endTime)){
			params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		// 供应商退货申请订单状态 IN(退货申请，退货成功，拒绝退货申请) 作为固定检索条件
		params.put("curStatusIsBack", Contants.SUB_ORDER_STATUS_0327);
		params.put("curStatusBack", Contants.SUB_ORDER_STATUS_0334);
		params.put("curStatusUnBack", Contants.SUB_ORDER_STATUS_0335);
		Long total = getSqlSession().selectOne("OrderSub.countLikeForBack", params);
		if (total == 0) {
			return Pager.empty(OrderSubModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.pagerLikeForBack", paramMap);
		return new Pager<OrderSubModel>(total, data);
	}

	public Pager<OrderSubModel> findLikeByPageForPush(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderSub.countLikeForPush", params);
		if (total == 0) {
			return Pager.empty(OrderSubModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.pagerLikeForPush", paramMap);
		return new Pager<OrderSubModel>(total, data);
	}

	public Pager<OrderSubModel> findLikeByPage(Map<String, Object> params, int offset, int limit) {
		String startTime = (String) params.get("startTime");
		String endTime = (String) params.get("endTime");
		if (!StringUtils.isEmpty(startTime)){
			params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		if (!StringUtils.isEmpty(endTime)){
			params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		Long total = getSqlSession().selectOne("OrderSub.countLikePage", params);
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

	public List<OrderSubModel> findLikeReq(Map<String, Object> params) {
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			String startTime = (String) params.get("startTime");
			String endTime = (String) params.get("endTime");
			if (!StringUtils.isEmpty(startTime)){
				params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
			}
			if (!StringUtils.isEmpty(endTime)){
				params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
			}
			paramMap.putAll(params);
		}
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.findLikeReq", paramMap);
		return data;
	}

	/**
	 *
	 * 查询订单信息 不带分页
	 *
	 * @param params Created by zhoupeng on 2016/7/20.
	 * @return
	 */
	public List<OrderSubModel> findLike(Map<String, Object> params) {
		String startTime = (String) params.get("startTime");
		String endTime = (String) params.get("endTime");
		if (!StringUtils.isEmpty(startTime)){
			params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		if (!StringUtils.isEmpty(endTime)){
			params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		Long total = getSqlSession().selectOne("OrderSub.countLike", params);

		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", 0);
		paramMap.put("limit", total);
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.pagerLike", paramMap);
		return data;
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

	public OrderSubModel findOrderCountPoints(Map<String, Object> params) {
		return getSqlSession().selectOne("OrderSub.findOrderCountPoints", params);
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

	public List<OrderSubModel> findAcceptOrder() {
		return getSqlSession().selectList("OrderSub.findAcceptOrder");
	}

	public List<OrderSubModel> findByOrderMainId(String orderMainId) {
		return getSqlSession().selectList("OrderSub.findByOrderMainId", orderMainId);
	}

	/**
	 * 根据主订单号查询所有子订单(未删除) niufw
	 * 
	 * @param orderMainId
	 * @return
	 */
	public List<OrderSubModel> findOrderByOrderMainId(String orderMainId) {
		return getSqlSession().selectList("OrderSub.findOrderByOrderMainId", orderMainId);
	}

	public List<OrderSubModel> findByGoodsId(String goodsId) {
		return getSqlSession().selectList("OrderSub.findByGoodsId", goodsId);
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

	/**
	 * 查询商品销量排行
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160816
	 *
	 * change by geshuo 20160816
	 */
	public List<OrderSubModel> findTopOrder(Map<String,Object> paramMap) {
		return getSqlSession().selectList("OrderSub.findTop", paramMap);
	}

	public List<OrderSubModel> findTopGoods(List<OrderSubModel> subList) {
		return getSqlSession().selectList("OrderSub.findTopGoods", subList);
	}
    public List<OrderSubModel> findPointTopGoods(List<OrderSubModel> subList) {
        return getSqlSession().selectList("OrderSub.findPointTopGoods", subList);
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

	/**
	 * 获取单品已购买的件数
	 *
	 * @param paramMap
	 * @return
	 *
	 * 		geshuo 20160707
	 */
	public List<BuyCountModel> findItemBuyCount(Map<String, Object> paramMap) {
		return getSqlSession().selectList("OrderSub.findItemBuyCount", paramMap);
	}

	public OrderSubModel findInfoByConditions(String order_id) {
		return getSqlSession().selectOne("OrderSub.findInfoByConditions", order_id);
	}

	public List<OrderSubModel> findCurStatusIdByConditions(String ordermain_id) {
		return getSqlSession().selectList("OrderSub.findCurStatusIdByConditions", ordermain_id);
	}

	public OrderSubModel findInfoByCurStatusId(Map<String, Object> paramMap) {
		return getSqlSession().selectOne("OrderSub.findInfoByCurStatusId", paramMap);
	}

	public OrderSubModel validateOrderInf(String orderId) {
		return getSqlSession().selectOne("OrderSub.validateOrderInf", orderId);
	}

	public OrderSubModel validateBackMsg(String orderId) {
		return getSqlSession().selectOne("OrderSub.validateBackMsg", orderId);
	}

	public List<OrderSubModel> findOrderCancelByList(Map<String, Object> params) {
		return getSqlSession().selectList("OrderSub.findOrderCancelByList", params);
	}

	public List<String> findJfOrderId() {
		return getSqlSession().selectList("OrderSub.findJfOrderId");
	}

	/**
	 * 获取商城筛选条件下的子订单
	 * 
	 * @param params
	 * @return
	 */
	public List<OrderSubModel> findAllSelection(Map<String, Object> params) {
		return getSqlSession().selectList("OrderSub.findAllSelection", params);
	}

	public OrderSubModel findByOrderMainIdAndOrderId(Map<String, Object> params) {
		return getSqlSession().selectOne("OrderSub.findByOrderMainIdAndOrderId", params);
	}

	public OrderSubModel findJfOrderById(String orderId) {
		return getSqlSession().selectOne("OrderSub.findJfOrderById", orderId);
	}

	public Pager<OrderSubModel> getOrdersByAutoSql(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderSub.getOrderCountByAutoSql", params);
		if (total == 0) {
			return Pager.empty(OrderSubModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.getOrdersByAutoSql", paramMap);
		return new Pager<OrderSubModel>(total, data);
	}

	/**
	 * 获取信用卡大机改造试运行阶段的参数
	 */
	public List<Map> getBigMachineParam() {
		return getSqlSession().selectList("OrderSub.getBigMachineParam");
	}

	public List<OrderSubModel> findXnlpOrder(Map<String, Object> params) {
		return getSqlSession().selectList("OrderSub.findXnlpOrder", params);
	}

	public Integer updateOrderCardNoForSub(String ordermainId, String payAccountNo) {
		Map<String, Object> params = Maps.newHashMap();
		params.put("ordermainId", ordermainId);
		params.put("payAccountNo", payAccountNo);
		return getSqlSession().update("OrderSub.updateOrderCardNoForSub", params);
	}

	public Integer updateOrderUnderControl(Map<String, Object> params) {
		return getSqlSession().update("OrderSub.updateOrderUnderControl", params);
	}

	/**
	 * MAL502更新主订单状态 niufw
	 *
	 * @param orderSubModel
	 * @return
	 */
	public Integer updateForMAL502(OrderSubModel orderSubModel) {
		return getSqlSession().update("OrderSub.updateForMAL502", orderSubModel);
	}

	public Long selectTotalBonusByParam(Map<String,Object> params){
		return getSqlSession().selectOne("OrderSub.selectTotalBonusByParam", params);
	}

	/**
	 * MAL MAL422分页查询接口 niufw
	 * 
	 * @param params
	 * @param offset
	 * @param limit
	 * @return
	 */
	public Pager<OrderSubModel> findByPageFor422(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderSub.countFor422", params);
		if (total == 0) {
			return Pager.empty(OrderSubModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderSubModel> data = getSqlSession().selectList("OrderSub.pagerFor422", paramMap);
		return new Pager<OrderSubModel>(total, data);
	}

	/**
	 * MAL501
	 */
	public Integer updateTblOrderSub(OrderSubModel orderSubModel) {
		return getSqlSession().update("OrderSub.updateTblOrderSub", orderSubModel);
	}

	public String findOrderTypeIdByOrderId(String orderId) {
		return getSqlSession().selectOne("OrderSub.findOrderTypeIdByOrderId", orderId);
	}

	/**
	 * 更新广发商城小订单流水号
	 * @param orderSubModel
	 */
	public Integer updateOrderSerialNo(OrderSubModel orderSubModel) {
		return getSqlSession().update("OrderSub.updateOrderSerialNo", orderSubModel);
	}

	/**
	 * 更新广发商城小订单的流水号
	 * @param params
	 * @return
	 */
	public Integer updateOrderSerialNo(Map<String,Object> params) {
		return getSqlSession().update("OrderSub.updateOrderSerialNo",params);
	}

	/**
	 * 更新子订单
	 * @param orderSubModel
	 * @return
	 */
	public Integer updateOrder(OrderSubModel orderSubModel){
		return getSqlSession().update("OrderSub.updateOrder",orderSubModel);
	}

	/**
	 * 根据主订单号更新订单状态
	 * 
	 * @param orderSubModel
	 * @return
	 */
	public Integer updateByOrderMainId(OrderSubModel orderSubModel) {
		return getSqlSession().update("OrderSub.updateByOrderMainId", orderSubModel);
	}

	/**
	 * 查询订单信息for MAL113
	 * @param params
	 * @return
	 */
	public List<OrderSubModel> findOrderInfo113(Map<String,Object> params){
		return getSqlSession().selectList("OrderSub.findOrderInfo113",params);
	}

	/**
	 * 供应商平台请款管理查询
	 *
	 * @param params
	 * @return
	 */
	public List<OrderSubModel> findForRequest(Map<String, Object> params) {
		return getSqlSession().selectList("OrderSub.findForRequest", params);
	}

}