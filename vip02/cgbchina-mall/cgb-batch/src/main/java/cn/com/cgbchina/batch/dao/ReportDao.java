package cn.com.cgbchina.batch.dao;

import java.util.List;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.spirit.common.model.Pager;

import cn.com.cgbchina.batch.model.IntegralExchangeModel;
import cn.com.cgbchina.batch.model.OrderBatchModel;
import cn.com.cgbchina.batch.model.QueryParams;

/**
 * 查询报表数据<br>
 * 仅限长得帅的人使用该dao<br>
 * 日期 : 2016年7月1日<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-trade<br>
 * 功能 : <br>
 */
@Repository
public class ReportDao extends SqlSessionDaoSupport {

	/**
	 * Description :商户销售统计
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public List<OrderBatchModel> findVendorSaleStatistics(QueryParams queryParams) {
		return getSqlSession().selectList("OrderBatch.findVendorSaleStatistics", queryParams);
	}

	/**
	 * 
	 * Description : 商户销售明细查询
	 * 
	 * @author Huangcy
	 * @param queryParams
	 * @return
	 */
	//TODO
	public Pager<OrderBatchModel> findVendorSaleDetail(QueryParams queryParams) {
		Long total = null;
		if(queryParams.isFirstVisit()){
			total = getSqlSession().selectOne("OrderBatch.countVendorSaleDetail", queryParams);
		}
				
		if (total != null && total == 0) {
			return Pager.empty(OrderBatchModel.class);
		}
		List<OrderBatchModel> orderBatchModels = getSqlSession().selectList("OrderBatch.findVendorSaleDetail",
				queryParams);
		return new Pager<OrderBatchModel>(total, orderBatchModels);
	}
	
	/**
	 * 
	 * Description : 积分兑换订单查询，主要用于周、月报表分页查询
	 * 
	 * @author Huangcy
	 * @param queryParams
	 * @return
	 */
	public Pager<IntegralExchangeModel> findJFOrderByPage(QueryParams queryParams) {
		Long total = null;
		if(queryParams.isFirstVisit()){
			total = getSqlSession().selectOne("IntegralExchange.count", queryParams);
		}
				
		if (total != null && total == 0) {
			return Pager.empty(IntegralExchangeModel.class);
		}
		List<IntegralExchangeModel> integralExchangeModels = getSqlSession().selectList("IntegralExchange.pager",
				queryParams);
		return new Pager<IntegralExchangeModel>(total, integralExchangeModels);
	}

	/**
	 * 
	 * Description : 积分兑换订单查询，主要用于日报表全部查询
	 * 
	 * @author Huangcy
	 * @param params
	 * @return
	 */
	public List<IntegralExchangeModel> findJFOrderOfDayAll(QueryParams params) {
		return getSqlSession().selectList("IntegralExchange.findAll", params);
	}
	
	/**
	 * 
	 * Description : 商户兑换统计
	 * 
	 * @author Huangcy
	 * @param params
	 * @return
	 */
	//TODO
	public List<OrderBatchModel> findVendorExchangeStat(QueryParams params){
		return getSqlSession().selectList("OrderBatch.findVendorExchangeStat", params);
	}
	
	/**
	 * Description :商品销售明细(广发商城)
	 * 
	 * @param queryParams
	 * @return
	 */
	public Pager<OrderBatchModel> findGoodsSaleDetail(QueryParams queryParams) {
		Pager<OrderBatchModel> pager = new Pager<OrderBatchModel>();
		Long total = getSqlSession().selectOne("OrderBatch.countGoodsSaleDetail", queryParams);
		if (total == 0) {
			return Pager.empty(OrderBatchModel.class);
		}
		List<OrderBatchModel> orderBatchModels = getSqlSession().selectList("OrderBatch.findGoodsSaleDetail",
				queryParams);
		pager.setData(orderBatchModels);
		pager.setTotal(total);
		return pager;
	}

	/**
	 * Description :分期请款(广发商城)
	 * 
	 * @param queryParams
	 * @return
	 */
	public Pager<OrderBatchModel> findStageReqCash(QueryParams queryParams) {
		Pager<OrderBatchModel> pager = new Pager<OrderBatchModel>();
		Long total = getSqlSession().selectOne("OrderBatch.countStageReqCash", queryParams);
		if (total == 0) {
			return Pager.empty(OrderBatchModel.class);
		}
		List<OrderBatchModel> orderBatchModels = getSqlSession().selectList("OrderBatch.findStageReqCash", queryParams);
		pager.setData(orderBatchModels);
		pager.setTotal(total);
		return pager;
	}

	/**
	 * Description :分期退货统计(广发商城)
	 * 
	 * @param queryParams
	 * @return
	 */
	public Pager<OrderBatchModel> findStageReturnGoods(QueryParams queryParams) {
		Pager<OrderBatchModel> pager = new Pager<OrderBatchModel>();
		Long total = getSqlSession().selectOne("OrderBatch.countStageReturnGoods", queryParams);
		if (total == 0) {
			return Pager.empty(OrderBatchModel.class);
		}
		List<OrderBatchModel> orderBatchModels = getSqlSession().selectList("OrderBatch.findStageReturnGoods",
				queryParams);
		pager.setData(orderBatchModels);
		pager.setTotal(total);
		return pager;
	}

	/**
	 * Description : 普通礼品销售明细(积分商城)
	 * 
	 * @param queryParams
	 * @return
	 */
	public Pager<OrderBatchModel> findCommonGiftSale(QueryParams queryParams) {
		Pager<OrderBatchModel> pager = new Pager<OrderBatchModel>();
		Long total = getSqlSession().selectOne("OrderBatch.countCommonGiftSale", queryParams);
		if (total == 0) {
			return Pager.empty(OrderBatchModel.class);
		}
		List<OrderBatchModel> orderBatchModels = getSqlSession().selectList("OrderBatch.findCommonGiftSale",
				queryParams);
		pager.setData(orderBatchModels);
		pager.setTotal(total);
		return pager;
	}

	/**
	 * Description : 退货详细(积分商城)
	 * 
	 * @param queryParams
	 * @return
	 */
	public Pager<OrderBatchModel> findGoodBack(QueryParams queryParams) {
		Pager<OrderBatchModel> pager = new Pager<OrderBatchModel>();
		Long total = getSqlSession().selectOne("OrderBatch.countGoodBack", queryParams);
		if (total == 0) {
			return Pager.empty(OrderBatchModel.class);
		}
		List<OrderBatchModel> orderBatchModels = getSqlSession().selectList("OrderBatch.findGoodBack", queryParams);
		pager.setData(orderBatchModels);
		pager.setTotal(total);
		return pager;
	}

	/**
	 * Description :结算详细(积分商城)
	 * 
	 * @param queryParams
	 * @return
	 */
	public List<OrderBatchModel> findClearingDetail(QueryParams queryParams) {
		return getSqlSession().selectList("OrderBatch.findClearingDetail", queryParams);
	}

	/**
	 * Description : 兑换统计细节(积分商城)
	 * 
	 * @param queryParams
	 * @return
	 */
	public List<OrderBatchModel> findExchangeStatistics(QueryParams queryParams) {
		return getSqlSession().selectList("OrderBatch.findExchangeStatistics", queryParams);
	}

	/**
	 * Description :信用卡请款报表记录(供应商平台)
	 * 
	 * @param queryParams
	 * @return
	 */
	public Pager<OrderBatchModel> findCreditCardReqMoney(QueryParams queryParams) {
		Pager<OrderBatchModel> pager = new Pager<OrderBatchModel>();
		Long total = getSqlSession().selectOne("OrderBatch.countCreditCardReqMoney", queryParams);
		if (total == 0) {
			return Pager.empty(OrderBatchModel.class);
		}
		List<OrderBatchModel> orderBatchModels = getSqlSession().selectList("OrderBatch.findCreditCardReqMoney",
				queryParams);
		pager.setData(orderBatchModels);
		pager.setTotal(total);
		return pager;
	}

	/**
	 * Description :商户退货详细(供应商平台)
	 * 
	 * @param queryParams
	 * @return
	 */
	public Pager<OrderBatchModel> findVendorGoodsBack(QueryParams queryParams) {
		Pager<OrderBatchModel> pager = new Pager<OrderBatchModel>();
		Long total = getSqlSession().selectOne("OrderBatch.countVendorGoodsBack", queryParams);
		if (total == 0) {
			return Pager.empty(OrderBatchModel.class);
		}
		List<OrderBatchModel> orderBatchModels = getSqlSession().selectList("OrderBatch.findVendorGoodsBack",
				queryParams);
		pager.setData(orderBatchModels);
		pager.setTotal(total);
		return pager;
	}

	/**
	 * Description : 商户销售明细报表(供应商平台)
	 * 
	 * @param queryParams
	 * @return
	 */
	public Pager<OrderBatchModel> findVendorSellDetail(QueryParams queryParams) {
		Pager<OrderBatchModel> pager = new Pager<OrderBatchModel>();
		Long total = getSqlSession().selectOne("OrderBatch.countVendorSellDetail", queryParams);
		if (total == 0) {
			return Pager.empty(OrderBatchModel.class);
		}
		List<OrderBatchModel> orderBatchModels = getSqlSession().selectList("OrderBatch.findVendorSellDetail",
				queryParams);
		pager.setData(orderBatchModels);
		pager.setTotal(total);
		return pager;
	}

	/**
	 * Description :获取会员数量(会员报表)
	 * 
	 * @param queryParams
	 * @return
	 */
	public List<OrderBatchModel> findMemberNumDto(QueryParams queryParams) {
		return getSqlSession().selectList("OrderBatch.findMemberNumDto", queryParams);
	}

	/**
	 * Description : 根据ItemCode获得goodsName (会员购物车报表)
	 * @author xiewl
	 * @param itemCode
	 * @return
	 */
	public String findGoodsNameByItemCode(String itemCode) {
		return getSqlSession().selectOne("OrderBatch.findGoodsNameByItemCode", itemCode);
	}

		/**
		 * Description : 根据ItemCode获得goodsName (会员购物车报表)
		 * @return
		 */
	public List<IntegralExchangeModel> findBankCity() {
		return getSqlSession().selectList("IntegralExchange.findBankCity");
	}
}
