/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.CodeToName;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.*;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.OrderCCAndIVRAddDto;
import cn.com.cgbchina.trade.exception.TradeException;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.service.AuctionRecordService;
import cn.com.cgbchina.user.model.EspCustNewModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.EspCustNewService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/5/27.
 */
@Component
@Transactional
@Slf4j
public class OrderMainManager {

	@Resource
	OrderSubDao orderSubDao;
	@Resource
	OrderDoDetailDao orderDoDetailDao;
	@Resource
	OrderMainDao orderMainDao;
	@Resource
	OrderVirtualDao orderVirtualDao;
	@Resource
	PointsPoolService pointsPoolService;
	@Resource
	MallPromotionService mallPromotionService;
	@Resource
	ItemService itemService;
	@Resource
	private IdGenarator idGenarator;
	@Resource
	TblOrdermainHistoryDao tblOrdermainHistoryDao;
	@Resource
	AuctionRecordService auctionRecordService;
	@Resource
	AuctionRecordDao auctionRecordDao;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	EspCustNewService espCustNewService;
	@Resource
	TblOrderCardMappingDao orderCardMappingDao;
	@Resource
	GoodsService goodsService;
	@Resource
	private TblOrderExtend1Dao tblOrderExtend1Dao;
	@Value("#{app.birthdayLimit}")
	private String birthdayLimit;

	/**
	 * 广发商城新建主订单子订单以及订单记录表
	 *
	 * @param orderMainModel
	 * @param orderSubModelList
	 * @param orderDoDetailModelList
	 * @param itemModelList
	 * @param pointPoolModel
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean createOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList,
			List<OrderDoDetailModel> orderDoDetailModelList, List<ItemModel> itemModelList,
			PointPoolModel pointPoolModel, List<Map<String, String>> promItemMap, User user) throws Exception {
		String orderMainId = idGenarator.orderMainId(orderMainModel.getSourceId());
		orderMainModel.setOrdermainId(orderMainId);
		orderMainModel.setSerialNo(idGenarator.orderSerialNo());
		for (int i = 0; i < orderSubModelList.size(); i++) {
			OrderSubModel orderSubModel = orderSubModelList.get(i);
			orderSubModel.setOrdermainId(orderMainId);
			orderSubModel.setOrderId(orderMainId + StringUtils.leftPad(String.valueOf(i + 1), 2, "0"));
			orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
			orderDoDetailModelList.get(i).setOrderId(orderSubModel.getOrderId());
		}
		orderMainDao.insert(orderMainModel);
		orderSubDao.insertBatch(orderSubModelList);
		orderDoDetailDao.insertBatch(orderDoDetailModelList);
		try {
			// 更新非活动商品库存
			if (itemModelList != null) {
				for (ItemModel itemModel : itemModelList) {
					Response<Boolean> result = itemService.update(itemModel);
					if (!result.isSuccess() || !result.getResult()) {
						throw new TradeException("更新库存失败");
					}
				}
			}
			// 更新活动商品数量
			if (promItemMap != null) {
				for (Map<String, String> map : promItemMap) {
					String promId = map.get("promId");
					String periodId = map.get("periodId");
					String itemCode = map.get("itemCode");
					String itemCount = map.get("itemCount");
					Response<Boolean> result = mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode,
							itemCount, user);
					if (!result.isSuccess() || !result.getResult()) {
						throw new TradeException("更新库存失败");
					}
				}
			}

			// 更新荷兰拍表
			if (orderSubModelList != null) {
				for (OrderSubModel orderSubModel : orderSubModelList) {
					if ("50".equals(orderSubModel.getActType())) {
						AuctionRecordModel model = new AuctionRecordModel();
						model.setId(Long.parseLong(orderSubModel.getCustCartId()));
						model.setCardno(orderMainModel.getCardno());
						model.setOrderId(orderSubModel.getOrderId());
						model.setBeginPayTime(new Date());
						Response<Integer> result = auctionRecordService.updatePayFlagForOrder(model);
						if (!result.isSuccess() || result.getResult() == 0) {
							throw new TradeException("您所选中的拍卖商品资格已过期");
						}
					}
				}
			}
		} catch (TradeException e) {
			log.error("OrderMainManager createOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			throw e;
		} catch (NumberFormatException e) {
			log.error("OrderMainManager createOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			throw e;
		}
		if (pointPoolModel != null) {
			try {
				// 更新积分池
				Response<Boolean> result = pointsPoolService.update(pointPoolModel);
				if (!result.isSuccess() || !result.getResult()) {
					throw new TradeException("更新库存失败");
				}
			} catch (Exception e) {
				log.error("OrderMainManager createOrder error,cause:{}", Throwables.getStackTraceAsString(e));
				throw e;
			}
		}
		return true;
	}
//
//	/**
//	 * 积分商城新建主订单子订单以及订单记录表
//	 *
//	 * @param orderMainModel
//	 * @param orderSubModelList
//	 * @param orderDoDetailModelList
//	 * @param itemModelList
//	 * @return
//	 */
//	@Transactional(rollbackFor = { Exception.class })
//	public Boolean createJfOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList, List<OrderDoDetailModel> orderDoDetailModelList, List<OrderVirtualModel> orderVirtualModelListModelList, List<ItemModel> itemModelList, User user) throws Exception {
//		String orderMainId = idGenarator.orderMainId(orderMainModel.getSourceId());
//		orderMainModel.setOrdermainId(orderMainId);
//		orderMainModel.setSerialNo(idGenarator.orderSerialNo());
//		int birthCount = 0;
//		for (int i = 0; i < orderSubModelList.size(); i++) {
//			OrderSubModel orderSubModel = orderSubModelList.get(i);
//			orderSubModel.setOrdermainId(orderMainId);
//			orderSubModel.setOrderId(orderMainId + StringUtils.leftPad(String.valueOf(i + 1), 2, "0"));
//			orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
//			orderDoDetailModelList.get(i).setOrderId(orderSubModel.getOrderId());
//			if(orderSubModel.getMemberLevel().equals("0004")){
//				birthCount = birthCount + 1;
//			}
//			for (OrderVirtualModel orderVirtualModelModel : orderVirtualModelListModelList) {
//				orderVirtualModelModel.setOrderId(orderSubModel.getOrderId());
//			}
//		}
//		orderMainDao.insert(orderMainModel);
//		orderSubDao.insertBatch(orderSubModelList);
//		orderDoDetailDao.insertBatch(orderDoDetailModelList);
//		if(orderVirtualModelListModelList.size() != 0) {
//			orderVirtualDao.insertBatch(orderVirtualModelListModelList);
//		}
//		try {
//			// 更新库存
//			for (ItemModel itemModel : itemModelList) {
//				Response<Boolean> result = itemService.update(itemModel);
//				if (!result.isSuccess() || !result.getResult()) {
//					throw new TradeException("更新库存失败");
//				}
//			}
//			// 更新生日购买件数
//			Response<EspCustNewModel> reponse = espCustNewService.findById(orderMainModel.getCreateOper());
//			if(!reponse.isSuccess()){
//				log.error("Response.error,error code: {}", reponse.getError());
//				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
//			}
//			EspCustNewModel espCustNewModel = reponse.getResult();
//			if(espCustNewModel == null) {
//				throw new TradeException("查询会员信息失败");
//			}else {
//				int birthUsedCount = espCustNewModel.getBirthUsedCount();
//				if(birthUsedCount + birthCount > Integer.valueOf(birthdayLimit)){
//					throw new TradeException("不能支付,超过生日次数限制");
//				}else{
//					espCustNewModel.setBirthUsedCount(birthUsedCount + birthCount);
//					espCustNewService.update(espCustNewModel);
//				}
//			}
//		} catch (Exception e) {
//			throw e;
//		}
//		return true;
//	}

	/**
	 * 积分商城新建主订单子订单以及订单记录表
	 *
	 * @param orderMainModel
	 * @param orderSubModelList
	 * @param orderDoDetailModelList
	 * @param itemModelList
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean createJfOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList, List<OrderDoDetailModel> orderDoDetailModelList, List<OrderVirtualModel> orderVirtualModelListModelList, List<ItemModel> itemModelList, User user) throws Exception {
		String orderMainId = idGenarator.orderMainId(orderMainModel.getSourceId());
		orderMainModel.setOrdermainId(orderMainId);
		orderMainModel.setSerialNo(idGenarator.orderSerialNo());
		int birthCount = 0;
		for (int i = 0; i < orderSubModelList.size(); i++) {
			OrderSubModel orderSubModel = orderSubModelList.get(i);
			orderSubModel.setOrdermainId(orderMainId);
			orderSubModel.setOrderId(orderMainId + StringUtils.leftPad(String.valueOf(i + 1), 2, "0"));
			orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
			orderDoDetailModelList.get(i).setOrderId(orderSubModel.getOrderId());
			if(orderSubModel.getMemberLevel().equals("0004")){
				birthCount = birthCount + 1;
			}
			for (OrderVirtualModel orderVirtualModelModel : orderVirtualModelListModelList) {
				orderVirtualModelModel.setOrderId(orderSubModel.getOrderId());
			}
		}
		orderMainDao.insert(orderMainModel);
		orderSubDao.insertBatch(orderSubModelList);
		orderDoDetailDao.insertBatch(orderDoDetailModelList);
		if(orderVirtualModelListModelList.size() != 0) {
			orderVirtualDao.insertBatch(orderVirtualModelListModelList);
		}
		try {
			// 更新库存
			for (ItemModel itemModel : itemModelList) {
				Response<Boolean> result = itemService.update(itemModel);
				if (!result.isSuccess() || !result.getResult()) {
					throw new TradeException("更新库存失败");
				}
			}
			// 更新生日购买件数
			EspCustNewModel espCustNewModel = espCustNewService.findById(orderMainModel.getCreateOper()).getResult();
			if(espCustNewModel == null) {
				throw new TradeException("查询会员信息失败");
			}else {
				int birthUsedCount = espCustNewModel.getBirthUsedCount();
				if(birthUsedCount + birthCount > Integer.valueOf(birthdayLimit)){
					throw new TradeException("不能支付,超过生日次数限制");
				}else{
					espCustNewModel.setBirthUsedCount(birthUsedCount + birthCount);
					espCustNewService.update(espCustNewModel);
				}
			}
		} catch (Exception e) {
			throw e;
		}
		return true;
	}

	/**
	 * 广发商城新建主订单子订单以及订单记录表
	 *
	 * @param orderMainModel
	 * @param orderSubModelList
	 * @param orderDoDetailModelList
	 * @param itemModelMap
	 * @param pointPoolModel
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean createOrder_new(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList,
			List<OrderDoDetailModel> orderDoDetailModelList, Map<String, Long> itemModelMap,
			PointPoolModel pointPoolModel, List<Map<String, String>> promItemMap, User user) throws Exception {
		try {
			// 更新荷兰拍表
			if (orderSubModelList != null) {
				for (OrderSubModel orderSubModel : orderSubModelList) {
					if ("50".equals(orderSubModel.getActType())) {
						AuctionRecordModel model = new AuctionRecordModel();
						model.setId(Long.parseLong(orderSubModel.getCustCartId()));
						model.setCardno(orderMainModel.getCardno());
						model.setOrderId(orderSubModel.getOrderId());
						model.setBeginPayTime(new Date());
						Response<Integer> result = auctionRecordService.updatePayFlagForOrder(model);
						if (!result.isSuccess() || result.getResult() == 0) {
							throw new TradeException("您所选中的拍卖商品资格已过期");
						}
					}
				}
			}
			if (pointPoolModel != null) {
				// 更新积分池
				Response<Boolean> result = pointsPoolService.updateById(pointPoolModel);
				if (!result.isSuccess() || !result.getResult()) {
					throw new TradeException("您所选中的商品积分池不足");
				}
			}

			orderMainDao.insert(orderMainModel);
			orderSubDao.insertBatch(orderSubModelList);
			orderDoDetailDao.insertBatch(orderDoDetailModelList);
			// 更新非活动商品库存
			if (itemModelMap != null) {
				Response<Boolean> result = itemService.updateStockForOrder(itemModelMap);
				if (!result.isSuccess() || !result.getResult()) {
					throw new TradeException("您所选中的商品库存数量不足");
				}
			}

			// 更新活动商品数量
			if (promItemMap != null) {
				for (Map<String, String> map : promItemMap) {
					String promId = map.get("promId");
					String periodId = map.get("periodId");
					String itemCode = map.get("itemCode");
					String itemCount = map.get("itemCount");
					// 荷兰拍不更新Redis
					if (!"50".equals(map.get("promotionType"))) {
						// 更新redis库存
						Response<Boolean> result = mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, itemCount, user);
						if (!result.isSuccess() || !result.getResult()) {
							throw new TradeException("您所选中的商品库存数量不足");
						}
					}
				}
				// 更新数据库(活动选品表)库存
				Response<Boolean> result = mallPromotionService.updatePromotionStock(promItemMap);
				if (!result.isSuccess() || !result.getResult()) {
					throw new TradeException("您所选中的活动商品库存数量不足");
				}
			}

		} catch (TradeException e) {
			log.error("OrderMainManager createOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			throw e;
		} catch (NumberFormatException e) {
			log.error("OrderMainManager createOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			throw e;
		}

		return true;
	}

	/**
	 * MAL115广发商城新建主订单子订单以及订单记录表
	 *
	 * @param orderMainModel
	 * @param orderSubModelList
	 * @param orderDoDetailModelList
	 * @param goodsNumList
	 * @param actNumList
	 * @param tblOrderExtend1List
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean createOrder_mal115(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList,
								      List<OrderDoDetailModel> orderDoDetailModelList, List<Map<String, Object>> goodsNumList,
									  List<Map<String, Object>> actNumList,
									  List<TblOrderExtend1Model> tblOrderExtend1List) throws Exception {
		try {
			orderMainDao.insert(orderMainModel);
			orderSubDao.insertBatch(orderSubModelList);
			orderDoDetailDao.insertBatch(orderDoDetailModelList);

			//			// 扣减商品数量
			for (Map<String, Object> goodsNum : goodsNumList) {
				ItemModel itemModel = (ItemModel) goodsNum.get("itemModel");
				String goods_num = (String) goodsNum.get("goods_num");
				String discountPrivilege = (String) goodsNum.get("discountPrivilege");

				Response<Integer> result = itemService.subtractStock(itemModel.getCode(), Long.valueOf(goods_num));
				if (!result.isSuccess() || result.getResult() <= 0) {
					throw new TradeException("您所选中的商品库存数量不足");
				}

				if (discountPrivilege != null && !"".equals(discountPrivilege)) {
					Map<String, Object> params = Maps.newHashMap();
					params.put("cur_month", DateHelper.getyyyyMM());
					params.put("used_point", discountPrivilege);
					Response<Boolean> rest = pointsPoolService.subtractPointPool(params);
					if (!rest.isSuccess() || !rest.getResult()) {
						throw new TradeException("更新积分池表失败!");
					}
				}
			}
			// TODO
			// for (int i = 0; i < actNumList.size(); i++) {// 加上活动
			// Map map = (Map) actNumList.get(i);
			// TblEspGoodsAct tblEspGoodsAct = (TblEspGoodsAct) map
			// .get("tblEspGoodsAct");
			// String goods_num = (String) map.get("goods_num");
			// //tblEspGoodsActDao.addAction(tblEspGoodsAct.getId().getGoodsPaywayId(), goods_num);
			// tblEspGoodsActDao.addAction(tblEspGoodsAct.getGoodsId(), goods_num);//活动表所有期数的记录都要加上活动购买数量
			// }
			// 加上tblOrderExtend1表
			for (TblOrderExtend1Model orderExtend1Model : tblOrderExtend1List) {
				tblOrderExtend1Dao.insert(orderExtend1Model);
			}
		} catch (TradeException e) {
			log.error("OrderMainManager createOrder_mal115 error,cause:{}", Throwables.getStackTraceAsString(e));
			throw e;
		}
		return true;
	}

	/**
	 * 积分商城新建主订单子订单以及订单记录表
	 *
	 * @param orderMainModel
	 * @param orderSubModelList
	 * @param orderDoDetailModelList
	 * @param itemModelMap
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean createJfOrder_new(OrderMainModel orderMainModel,
									 List<OrderSubModel> orderSubModelList,
									 List<OrderDoDetailModel> orderDoDetailModelList,
									 List<OrderVirtualModel> orderVirtualList,
									 Map<String, Long> itemModelMap, User user,
									 EspCustNewModel espCustNewModel) throws Exception {
		try {
			orderMainDao.insert(orderMainModel);
			orderSubDao.insertBatch(orderSubModelList);
			orderDoDetailDao.insertBatch(orderDoDetailModelList);
			if(orderVirtualList != null && orderVirtualList.size() != 0) {
				orderVirtualDao.insertBatch(orderVirtualList);
			}
			// 更新库存
			Response<Boolean> result = itemService.updateStockForOrder(itemModelMap);
			if (!result.isSuccess() || !result.getResult()) {
				throw new TradeException("更新库存失败");
			}
			// 更新生日购买件数
			if (espCustNewModel != null) {
				Response<Integer> response = espCustNewService.update(espCustNewModel);
				if (!response.isSuccess()) {
					throw new TradeException("更新生日购买件数失败");
				}
			}
		} catch (Exception e) {
			throw e;
		}
		return true;
	}

	/**
	 * 新建搭销子订单以及订单记录表
	 *
	 * @param orderMainModel
	 * @param orderSubModel
	 * @param orderDoDetailModel
	 * @param itemModel
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean createOrder(OrderMainModel orderMainModel, OrderSubModel orderSubModel,
			OrderDoDetailModel orderDoDetailModel, ItemModel itemModel,Boolean orderMianFlag) throws Exception {
		// 获取主订单号
		String orderMainId = orderMainModel.getOrdermainId();
		// 判断主订单所在表
		OrderMainModel orderMainModelResult = orderMainDao.findById(orderMainId);
		if (orderMianFlag){
			orderMainDao.update(orderMainModel);
		}else {
			TblOrdermainHistoryModel tblOrdermainHistoryModel=new TblOrdermainHistoryModel();
			BeanMapper.copy(orderMainModel, tblOrdermainHistoryModel);
			tblOrdermainHistoryDao.update(tblOrdermainHistoryModel);
		}
		// 子订单插入数据
		orderSubModel.setOrdermainId(orderMainId);
		orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
		orderSubModel
				.setOrderId(orderMainId + StringUtils.leftPad(String.valueOf(orderMainModel.getTotalNum()), 2, "0"));
		orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
		orderSubDao.insert(orderSubModel);
		orderDoDetailDao.insert(orderDoDetailModel);
		try {
			// 更新库存
			Map<String,Long>map=Maps.newHashMap();
			map.put(itemModel.getCode(),1L);
			itemService.updateStockForOrder(map);
		} catch (TradeException e) {
			throw e;
		}
		return Boolean.TRUE;
	}

	/**
	 * 取消订单
	 *
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateCancelOrder(OrderMainModel orderMainModel,
									 User user,
									 Map<String, Integer> itemStockmap,
									 List<String> countLIst,
									 List<OrderSubModel> orderSubModelList,
									 List<OrderDoDetailModel> orderDoDetailModels,
									 List<Map<String, Object>> paramList) throws Exception {
		try {
			orderMainDao.update(orderMainModel);
			String ordermainId = orderMainModel.getOrdermainId();
			String ordertypeId = orderMainModel.getOrdertypeId();
			String id = user.getId();
			List<OrderSubModel> orderSubModels = Lists.newArrayList();
			orderSubModels = orderSubDao.findByOrderMainId(ordermainId);
			if (orderSubModels == null || orderSubModels.isEmpty()) {
				log.error("orderMainManager updateCancelOrder orderSubModels be empty");
				throw new TradeException("orderSubModels.be.empty");
			}
			if (Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
				//修改库存
				Response<Boolean> booleanResponse = itemService.updateRollBackStockForJF(itemStockmap, user);
				if (!booleanResponse.isSuccess()) {
					log.error("orderMainManager updateCancelOrder,itemService updateRollBackStockForJF returnResult be wrong");
					throw new TradeException("itemService.updateRollBackStockForJF.be.wrong");
				}
				//释放生日资格 按子订单使用的次数进行释放
				if (countLIst != null && !countLIst.isEmpty()) {
					for(String number:countLIst){
						Response espResponse = espCustNewService.updBirthUsedCount(orderMainModel.getCreateOper());
						if (!espResponse.isSuccess()) {
							log.error("orderMainManager updateCancelOrder,espCustNewService updBirthUsedCount failed");
							throw new TradeException("espCustNewService.updBirthUsedCount.failed");
						}
					}
				}
			}else {
				//广发商城
				// 回滚普通单品库存
				if (itemStockmap != null && !itemStockmap.isEmpty()) {
					// 批量更新
					Response<Boolean> booleanResponse = itemService.updateBatchStock(itemStockmap, user);
					if (!booleanResponse.isSuccess()) {
						log.error("orderMainManager updateCancelOrder,itemService updateBatchStock returnResult be wrong");
						throw new TradeException("itemService.updateBatchStock.be.wrong");
					}
				}
				// 活动库存回滚
				if (paramList != null && !paramList.isEmpty()) {
					for (Map<String, Object> map : paramList) {
						String actType = (String) map.get("actType");
						// 回滚荷兰拍redis库存
						if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(actType)) {
							String promId = (String) map.get("promId");
							String periodId = (String) map.get("periodId");
							String itemCode = (String) map.get("itemCode");
							String itemCount = "-"+(Integer) map.get("itemCount");
							String orderId= (String) map.get("orderId");
							Response<Boolean> result = mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode,
									itemCount, user);
							if (!result.isSuccess() || !result.getResult()) {
								log.error("orderId:"+orderId+",orderMainManager updateCancelOrder,mallPromotionService updatePromSaleInfo failed");
								throw new TradeException("OrderMainManager.mallPromotionService.updatePromSaleInfo.failed");
							}
							Map<String,Object>paramMap=Maps.newHashMap();
							paramMap.put("orderId",orderId);
							auctionRecordDao.updateRecordReleased(paramMap);
						}
					}
					// 更新数据库(活动选品表)库存
					Response<Boolean> result = mallPromotionService.updateRollbackPromotionStock(paramList);
					if (!result.isSuccess() || !result.getResult()) {
						throw new TradeException("您所选中的商品库存回滚失败");
					}

				}
			}
			orderSubDao.updateBatch(orderSubModelList);
			orderDoDetailDao.insertBatch(orderDoDetailModels);
		} catch (TradeException e) {
			throw e;
		}
		return Boolean.TRUE;
	}

	/**
	 * MAL502更新主订单状态 niufw
	 * 
	 * @return
	 */
	public Integer updateForMAL502(OrderMainModel orderMainModel) {
		Integer result = orderMainDao.updateForMAL502(orderMainModel);
		return result;
	}

	/**
	 * 积分商城-虚拟礼品下单(外部接口 MAL104 调用)
	 * 
	 * @param orderCCAndIVRAddDto 下单参数
	 *
	 *            geshuo 20160825
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void createCCAndIVRVirtualOrder(OrderCCAndIVRAddDto orderCCAndIVRAddDto) throws Exception { OrderMainModel orderMain = orderCCAndIVRAddDto.getOrderMainModel();// 主订单
		String[] cardNoArray = orderCCAndIVRAddDto.getCardNoArray();// 卡号
		String[] goodsPriceArray = orderCCAndIVRAddDto.getGoodsPriceArray();// 价格
		String[] intergralTypeArray = orderCCAndIVRAddDto.getIntergralTypeArray();// 积分类型
		String[] intergralNoArray = orderCCAndIVRAddDto.getIntergralNoArray();// 积分
		String[] goodsNoArray=orderCCAndIVRAddDto.getGoodsNoArray();
		String orderType = orderCCAndIVRAddDto.getOrderType();// 订单类型
		Map<String,Long> deductStock=new HashMap<>();
		// 插入主订单表 tbl_order_main
		orderMainDao.insert(orderMain);
		saveCardMapping(orderMain.getOrdermainId(), orderMain.getSerialNo(), cardNoArray, goodsPriceArray,
				intergralTypeArray, intergralNoArray, orderType);

		OrderSubModel orderSubModel = orderCCAndIVRAddDto.getOrderSubModel();// 子订单
		// bug-305197 fixed by ldk
		orderSubModel.setOrder_succ_time(orderMain.getCreateTime());
		// 插入子订单表 tbl_order
		orderSubDao.insert(orderSubModel);

		OrderDoDetailModel orderDoDetailModel = orderCCAndIVRAddDto.getOrderDoDetailModel();// 订单操作历史
		// 插入订单操作历史表
		orderDoDetailDao.insert(orderDoDetailModel);

		OrderVirtualModel orderVirtualModel = orderCCAndIVRAddDto.getOrderVirtualModel();// 虚拟订单扩展(虚拟商品下单用)
		// 插入虚拟礼品表
		orderVirtualDao.insert(orderVirtualModel);
		long goodsNum = orderSubModel.getGoodsNum().longValue();
		String[] strs=orderCCAndIVRAddDto.getGoodsIdArray();
		Map<String,ItemGoodsDetailDto> itemMap=orderCCAndIVRAddDto.getItemMap();
		for(String str:strs){
			ItemGoodsDetailDto item = itemMap.get(str);
			if(item.getStock()<9999){
				deductStock.put(orderSubModel.getGoodsId(), goodsNum);
				Response<Boolean> response = itemService.updateStockForOrder(deductStock);
				if(!response.isSuccess()||!response.getResult()){
					throw new ResponseException("000022");
				}
			}
		}
		
		//更新生日价--add by dengbing 20160105,xq2015121701-积分礼品兑换增加卡等级规则判断
		/*if(Contants.MEMBER_LEVEL_BIRTH_CODE.equals(orderCCAndIVRAddDto.getPayway().getMemberLevel())){//支付方式为生日价
			List<String> birthList = orderCCAndIVRAddDto.getBirthList();//客户号列表
			int goodsNum = orderCCAndIVRAddDto.getGoodsNum();//商品数量
			if(birthList!=null&&birthList.size()>0){
				for(String custId : birthList){
					int row = updateBirthUsedCount(custId,goodsNum,Integer.parseInt(birthdayLimit));
					if(row<=0){
						// 回滚
						throw new ResponseException("000102");
					}
				}
			}
		}*/
	}

	private void saveCardMapping(String orderMainId, String serialNo, String[] cardNoArray, String[] goodsPriceArray,
			String[] intergralTypeArray, String[] intergralNoArray, String orderType) {
		double amount = 0;// 支付金额，每次交易只可以有一张卡用于现金支付
		for (int index = 0; index < cardNoArray.length; index++) {
			String tempCardNo = cardNoArray[index].trim();
			if ("".equals(tempCardNo.trim())) {
				continue;
			}
			String tempAmount = goodsPriceArray[index].trim();
			String tempIntergralType = intergralTypeArray[index].trim();
			long tempIntergralNo = 0;
			String tempIntergralNoStr = intergralNoArray[index].trim();
			if (tempIntergralNoStr.length() > 0) {
				try {
					tempIntergralNo = Long.parseLong(tempIntergralNoStr);
				} catch (Exception e) {
					log.error("【MAL104】转换积分类型为Long类型时发生异常，转换数据：" + tempIntergralNoStr);
				}
			}

			try {
				if (tempAmount.length() == 12 && StringUtil.ccEnvelopeStringToDouble(tempAmount) > 0) {// 应用网关约定现金是不带小数点的12位字符串
					amount = StringUtil.ccEnvelopeStringToDouble(tempAmount);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			TblOrderCardMappingModel orderCardMapping = new TblOrderCardMappingModel();
			orderCardMapping.setOrdermainId(orderMainId);
			orderCardMapping.setCardNo(tempCardNo);
			orderCardMapping.setTxnDate(LocalDate.now().toDate());
			orderCardMapping.setSerialNo(serialNo);
			orderCardMapping.setDefrayType("");
			orderCardMapping.setAmount(new BigDecimal(amount));
			orderCardMapping.setBonusType(tempIntergralType);
			orderCardMapping.setBonusValue(tempIntergralNo);

			if ("1".equals(orderType)) {// 1：表示指定下单,多卡积分支付 bms102
				orderCardMapping.setBonusTxnCode("bms102");
			} else {// 2：表示由积分系统自动扣减，对应积分系统客户积分支付 bms103
				orderCardMapping.setBonusTxnCode("bms103");
			}

			orderCardMapping.setCheckStatus("0");

			// 插入 tbl_order_card_mapping
			orderCardMappingDao.insert(orderCardMapping);
		}
	}

	/**
	 * 更新生日价兑换次数
	 * 
	 * @param custId 客户号
	 * @param goodsNum 商品数量
	 * @param birthLimitCount 生日价限制次数
	 * @return 更新结果
	 *
	 *         gehsuo 20160824
	 */
	private int updateBirthUsedCount(String custId, int goodsNum, int birthLimitCount) {
		Map<String, Object> updateMap = Maps.newHashMap();
		updateMap.put("goodsCount", goodsNum);
		updateMap.put("birthLimitCount", birthLimitCount);
		updateMap.put("lastLoginTime", LocalDate.now().toDate());
		updateMap.put("custId", custId);

		// 更新生日价次数
		Response<Integer> custNewResponse = espCustNewService.updateCustNewByParams(updateMap);
		if (custNewResponse.isSuccess()) {
			return custNewResponse.getResult();
		}
		return 0;
	}
	/**
	 * 积分商城-实物商品下单(外部接口 MAL104 调用)
	 * 
	 * @param orderCCAndIVRAddDto 下单参数
	 *
	 *            gehsuo 20160825
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Map<String, Object> createCCAndIVRRealOrder(OrderCCAndIVRAddDto orderCCAndIVRAddDto) throws Exception {
		Map<String, Object> resultMap = Maps.newHashMap();

		OrderMainModel orderMain = orderCCAndIVRAddDto.getOrderMainModel();// 主订单
		String[] cardNoArray = orderCCAndIVRAddDto.getCardNoArray();// 卡号
		String[] goodsPriceArray = orderCCAndIVRAddDto.getGoodsPriceArray();// 价格
		String[] intergralTypeArray = orderCCAndIVRAddDto.getIntergralTypeArray();// 积分类型
		String[] intergralNoArray = orderCCAndIVRAddDto.getIntergralNoArray();// 积分
		String orderType = orderCCAndIVRAddDto.getOrderType();// 订单类型
		String createOper = orderCCAndIVRAddDto.getCreateOper();// 客户号
		String[] goodsNoArray = orderCCAndIVRAddDto.getGoodsNoArray();// 商品数量
		
		// 插入主订单表
		// s1.save(orderMain);
		orderMainDao.insert(orderMain);
		saveCardMapping(orderMain.getOrdermainId(), orderMain.getSerialNo(), cardNoArray, goodsPriceArray,
				intergralTypeArray, intergralNoArray, orderType);

		// 组装子订单
		int orderCount = 0;
		int birthLimitCount = Integer.parseInt(birthdayLimit);
		List<String> birthList = Lists.newArrayList();// 客户号列表

		String[] goodsIdArray = orderCCAndIVRAddDto.getGoodsIdArray();// 商品id列表
		Map<String, ItemGoodsDetailDto> itemMap = orderCCAndIVRAddDto.getItemMap();// 单品map
		Map<String, TblGoodsPaywayModel> paywayMap = orderCCAndIVRAddDto.getPaywayMap();// 支付方式map
		Map<String, VendorInfoModel> vendorMap = orderCCAndIVRAddDto.getVendorMap();// 供应商map
		String[] paywayIdArray = orderCCAndIVRAddDto.getPaywayIdArray();// 支付方式id

		long smsTotalBonus = 0;
		double smsTotalPrice = 0;
		Map<String,Long> deductStock=new HashMap<String, Long>(0);
		for (int goodsIndex = 0; goodsIndex < goodsIdArray.length; goodsIndex++) {
			ItemGoodsDetailDto goodsInf = itemMap.get(goodsIdArray[goodsIndex]);// 单品信息
			TblGoodsPaywayModel payway = paywayMap.get(paywayIdArray[goodsIndex]);// 支付方式
			VendorInfoModel vendorInf = vendorMap.get(goodsInf.getVendorId());// 供应商信息
			int goodsNum = 0;
			try {
				goodsNum = Integer.parseInt(goodsNoArray[goodsIndex].trim());// 商品数量
			} catch (Exception e) {
				e.printStackTrace();
				log.error("【MAL104】流水：Exception:{}", Throwables.getStackTraceAsString(e));
			}
			if(goodsInf.getStock()<9999){
				deductStock.put(goodsInf.getCode(), (long)goodsNum);
			}

			// 增加客户生日月兑换礼品的限制 start --add by dengbing 20160105,xq2015121701-积分礼品兑换增加卡等级规则判断
			if (Contants.MEMBER_LEVEL_BIRTH_CODE.equals(payway.getMemberLevel())) {// 支付方式为生日价
				String contIdCard = orderCCAndIVRAddDto.getContIdCard();
				// 查询生日价已使用次数
				Response<Map<String, Object>> birthCountResponse = espCustNewService
						.getBirthUsedCount(contIdCard.trim(), createOper);
				if (!birthCountResponse.isSuccess()) {
					throw new ResponseException("000011");
				}
				Map<String, Object> map = birthCountResponse.getResult();
				int usedCount = Integer.parseInt(String.valueOf(map.get("usedCount")));
				//FIXME:mark by ldk 生日价根据大订单来的
//				if(birthLimitCount-usedCount<=0){
//					// 回滚
//					// t1.rollback();
//					throw new ResponseException("000102");
//				}
				//if (birthLimitCount - usedCount - goodsNum < 0) {
					// 回滚
					// t1.rollback();
				//	throw new ResponseException("000103");
				//}
				birthList = (List<String>) map.get("custIds");// 客户号列表
				resultMap.put("birthList",birthList);
			}
			// 增加客户生日月兑换礼品的限制 end
			
			while (goodsNum > 0) {
				goodsNum--;
				String merId = orderCCAndIVRAddDto.getMerId();// 供应商id
				int moneyCardIndex = orderCCAndIVRAddDto.getMoneyCardIndex();// 卡号索引
				String custType = orderCCAndIVRAddDto.getCustType();// 客户类型
				String ivrFlag = orderCCAndIVRAddDto.getIvrFlag();// ivr标志
				Map<String, TblCfgIntegraltypeModel> integraltypeMap = orderCCAndIVRAddDto.getIntegraltypeMap();// 积分类型map

				OrderSubModel order = accTblOrder(merId, orderMain, orderCount, goodsInf, payway, vendorInf,
						cardNoArray[moneyCardIndex], ivrFlag, createOper, goodsNum, integraltypeMap);
				order.setCustType(custType);// vip客户优先发货客户等级 add by panHui 非虚拟礼品

				orderCount++;
				// 插入子订单表
				// s1.save(order);
				orderSubDao.insert(order);
				smsTotalBonus += order.getSingleBonus() != null ? order.getSingleBonus() : 0;
				smsTotalPrice += order.getSinglePrice() != null ? order.getSinglePrice().doubleValue() : 0;

				OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
				orderDodetail.setOrderId(order.getOrderId());
				orderDodetail.setDoTime(LocalDate.now().toDate());
				orderDodetail.setDoUserid("Call Center");
				orderDodetail.setUserType("1");
				orderDodetail.setStatusId(order.getCurStatusId());
				orderDodetail.setStatusNm(order.getCurStatusNm());
				orderDodetail.setDoDesc("新建订单");
				orderDodetail.setDelFlag(0);
				orderDodetail.setModifyOper("SYSTEM");
				orderDodetail.setCreateOper("SYSTEM");

				// 插入订单操作历史
				orderDoDetailDao.insert(orderDodetail);

				//更新生日价 start--add by dengbing 20160105,xq2015121701-积分礼品兑换增加卡等级规则判断
				if(Contants.MEMBER_LEVEL_BIRTH_CODE.equals(payway.getMemberLevel())){//支付方式为生日价
					if(birthList!=null&&birthList.size()>0){
						for(String custId: birthList){
							int row = updateBirthUsedCount(custId,order.getGoodsNum(),birthLimitCount);
							if(row<=0){
								// 回滚
								throw new ResponseException("000102");
							}
						}
					}
				}
				// 更新生日价 end
			}
		}
		//FIXME:mark by ldk 扣减库存
		Response<Boolean> response = itemService.updateStockForOrder(deductStock);
		if(!response.isSuccess()||!response.getResult()){
			throw new ResponseException("000022");
		}
		resultMap.put("smsTotalBonus", smsTotalBonus);
		resultMap.put("smsTotalPrice", smsTotalPrice);
		return resultMap;
	}

	/**
	 * 积分商城下单-实物商品(外部接口 MAL104 调用) 更新订单状态(支付成功)
	 * 
	 * @param uOrderMain
	 * @param orderList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void updateCCAndIVRTureOrder(OrderMainModel uOrderMain, List<OrderSubModel> orderList) throws Exception {
		// 更新主订单
		orderMainDao.update(uOrderMain);
		// 统计积分和现金总数，发送短信
		// 更新订单支付状态
		for (OrderSubModel uOrder : orderList) {
			uOrder.setCurStatusId(Contants.SUB_ORDER_STATUS_0308);
			uOrder.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);
			uOrder.setModifyTime(LocalDate.now().toDate());
			uOrder.setModifyOper("System");

			// 更新子订单
			orderSubDao.update(uOrder);

			OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
			orderDodetail.setOrderId(uOrder.getOrderId());
			orderDodetail.setDoTime(LocalDate.now().toDate());
			orderDodetail.setDoUserid("Call Center");
			orderDodetail.setUserType("1");
			orderDodetail.setStatusId(uOrder.getCurStatusId());
			orderDodetail.setStatusNm(uOrder.getCurStatusNm());
			orderDodetail.setDoDesc("新建订单");
			orderDodetail.setDelFlag(0);
			orderDodetail.setCreateOper("SYSTEM");
			orderDodetail.setModifyOper("SYSTEM");
			// 插入订单操作历史
			orderDoDetailDao.insert(orderDodetail);
		}
	}

	/**
	 * 积分商城下单-实物商品(外部接口 MAL104 调用) 更新订单状态(支付不成功)
	 * 
	 * @param uOrderMain
	 * @param orderList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void updateCCAndIVRFalseOrder(OrderMainModel uOrderMain, List<OrderSubModel> orderList, String payState,
			String senderSN, List<String> birthList, String retCode, String message) throws Exception {
		// 更新主订单
		orderMainDao.update(uOrderMain);

		// 更新订单支付状态
		for (OrderSubModel uOrder : orderList) {
			if ("3".equals(payState)) {
				uOrder.setCurStatusId(Contants.SUB_ORDER_STATUS_0316);
				uOrder.setCurStatusNm(Contants.SUB_ORDER_UNCLEAR);
			} else {
				uOrder.setCurStatusId(Contants.SUB_ORDER_STATUS_0307);
				uOrder.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_FAILED);
				// 支付失败 ,如果有使用生日价，回滚生日兑换次数--add by dengbing 20160107,xq2015121701-积分礼品兑换增加卡等级规则判断
				if (Contants.MEMBER_LEVEL_BIRTH_CODE.equals(uOrder.getMemberLevel())) {
					if (birthList != null && birthList.size() > 0) {
						for (String custId : birthList) {
							rollbackBirthUsedCount(custId, uOrder.getGoodsNum());
						}
					}
				}
			}
			uOrder.setErrorCode(retCode);
			uOrder.setModifyTime(LocalDate.now().toDate());
			uOrder.setModifyOper("企业网银");
			// 更新子订单
			orderSubDao.update(uOrder);
			OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
			orderDodetail.setOrderId(uOrder.getOrderId());
			orderDodetail.setDoTime(LocalDate.now().toDate());
			orderDodetail.setDoUserid("企业网银");
			orderDodetail.setUserType("0");
			orderDodetail.setStatusId(uOrder.getCurStatusId());
			orderDodetail.setStatusNm(uOrder.getCurStatusNm());
			orderDodetail.setDelFlag(0);
			orderDodetail.setModifyOper("企业网银");
			orderDodetail.setCreateOper("企业网银");
			try {
				orderDodetail.setDoDesc(uOrder.getCurStatusNm() + ",原因：" + message);
			} catch (Exception e) {
				log.error("【MAL104】流水：" + senderSN + "，Exception:{}", Throwables.getStackTraceAsString(e));
			}

			// 插入订单操作历史
			orderDoDetailDao.insert(orderDodetail);
			
			goodsService.updateGoodsJF(uOrder.getGoodsId(),uOrder.getGoodsNum().longValue());
		}

	}
	/**
	 * 回滚生日价使用次数
	 *
	 * @param custId 客户号
	 * @param goodsNum 单品数量
	 * @return 回滚结果
	 */
	private int rollbackBirthUsedCount(String custId, int goodsNum) {
		Map<String, Object> rollBackMap = Maps.newHashMap();
		rollBackMap.put("rollBackCount", goodsNum);
		rollBackMap.put("custId", custId);

		// 更新生日价次数
		Response<Integer> rollBackResponse = espCustNewService.updateCustNewByParams(rollBackMap);
		if (rollBackResponse.isSuccess()) {
			return rollBackResponse.getResult();
		}
		return 0;
	}

	private OrderSubModel accTblOrder(String merId, OrderMainModel orderMain, int operSeq, ItemGoodsDetailDto goodsInf,
			TblGoodsPaywayModel payway, VendorInfoModel vendorInf, String cardno, String ivrFlag, String createOper,
			int goodsNum, Map<String, TblCfgIntegraltypeModel> integraltypeMap) {
		OrderSubModel order = new OrderSubModel();
		String orderId = orderMain.getOrdermainId() + (operSeq < 10 ? ("0" + operSeq) : operSeq);
		order.setDelFlag("0");// 未删除
		order.setRemindeFlag(0);// 未提醒
		order.setO2oExpireFlag(0);// O2O未操作过
		order.setItemSmallPic(goodsInf.getImage1());// 商品图片
		order.setFenefit(new BigDecimal("0.00"));// 优惠差额
		order.setOrderId(orderId);// ORDER_ID 子订单号
		order.setReferenceNo("");// REFERENCE_NO 参考号码
		order.setOperSeq(operSeq);// OPER_SEQ 业务订单同步序号
		order.setOrderIdHost("");// ORDER_ID_HOST 主机订单号
		order.setOrdertypeId("JF");// ORDERTYPE_ID 业务类型代码
		order.setOrdertypeNm("积分");// ORDERTYPE_NM 业务类型名称
		order.setPaywayCode(payway.getPaywayCode());// PAYWAY_CODE 支付方式代码
		order.setPaywayNm("积分");// PAYWAY_NM 支付方式名称
		order.setOrdermainId(orderMain.getOrdermainId());// ORDERMAIN_ID 主订单号
		order.setCardno(cardno);// CARDNO 卡号
		order.setCardnoBenefit("");// CARDNO_BENEFIT 受益卡号
		order.setValidateCode("");// VALIDATE_CODE 验证码
		order.setVerifyFlag("");// VERIFY_FLAG 下单验证标记
		order.setVendorId(vendorInf.getVendorId());// VENDOR_ID 供应商代码
		order.setVendorSnm(vendorInf.getSimpleName());// VENDOR_SNM 供应商名称简写
		order.setGoodsType(goodsInf.getGoodsType());
		order.setGoodsTypeName(CodeToName.goodsType(goodsInf.getGoodsType()));
		if ("0".equals(ivrFlag)) {
			order.setSourceId("01");// SOURCE_ID 订购渠道（下单渠道）
			order.setSourceNm("CALL CENTER");// SOURCE_NM 渠道名称
		} else {
			order.setSourceId("02");// SOURCE_ID 订购渠道（下单渠道）
			order.setSourceNm("IVR");// SOURCE_NM 渠道名称
		}

		order.setOtSourceId("");// OT_SOURCE_ID 业务渠道代码
		order.setOtSourceNm("");// OT_SOURCE_NM 业务渠道名称
		order.setGoodsId(goodsInf.getCode());// 单品编码
		order.setGoodsCode(goodsInf.getGoodsCode());
		order.setGoodsPaywayId(payway.getGoodsPaywayId());// GOODS_PAYWAY_ID
		// 商品支付编码

		/**
		 * 20150617 hwh 修改:ivr买虚拟商品数量问题（CC自建，IVR也能买虚拟礼品）
		 * if(ivrFlag!=null&&"0".equals(ivrFlag)&&"0001".equals(goodsInf.getGoodsType())){//针对虚拟礼品，
		 */
		//FIXME:mark by ldk 这个方法就是用来组装非虚拟礼品的
		/*if (cont.equals(goodsInf.getGoodsType())) {// 针对虚拟礼品
			order.setGoodsNum(goodsNum);// 订单中商品数目可能不为1
			order.setSingleBonus(payway.getGoodsPoint());// 针对CC虚拟礼品的订单，该字段存入总的积分值
			order.setBonusTotalvalue(goodsNum * payway.getGoodsPoint());// BONUS_TOTALVALUE
			// 积分总数
			*//********** 需要确认是否需要乘以商品数量 **********//*
			order.setCalMoney(new BigDecimal(goodsNum).multiply(payway.getCalMoney()));// CAL_MONEY 清算总金额
			order.setOrigMoney(new BigDecimal(goodsNum).multiply(payway.getGoodsPrice()));// ORIG_MONEY 原始现金总金额
			order.setTotalMoney(new BigDecimal(goodsNum).multiply(payway.getGoodsPrice()));// TOTAL_MONEY 现金总金额
		} else {// 非虚拟礼品
*/			order.setGoodsNum(1);// GOODS_NUM 商品数量,一个子订单只有一件商品
			order.setSingleBonus(payway.getGoodsPoint());// 积分
			order.setBonusTotalvalue(payway.getGoodsPoint());// BONUS_TOTALVALUE
			// 积分总数
			order.setCalMoney(payway.getCalMoney());// CAL_MONEY 清算总金额
			order.setOrigMoney(payway.getGoodsPrice());// ORIG_MONEY 原始现金总金额
			order.setTotalMoney(payway.getGoodsPrice());// TOTAL_MONEY 现金总金额
//		}
		order.setGoodsNm(goodsInf.getGoodsName());// GOODS_NM 商品名称
		order.setMachCode(goodsInf.getMachCode());// MACH_COD 商品条行码
		order.setCurrType("156");// CURR_TYPE 商品币种
		order.setExchangeRate(new BigDecimal(0));// EXCHANGE_RATE 对人民币的汇率值
		order.setTypeId(goodsInf.getGoodsType());// TYPE_ID 商品类别ID
		order.setLevelNm("");// LEVEL_NM 商品类别名称
		order.setGoodsBrand(goodsInf.getGoodsBrandName());// GOODS_BRAND 品牌
		order.setGoodsModel("");// GOODS_MODEL 型号
		order.setGoodsColor("");// GOODS_COLOR 商品颜色
		order.setGoodsPresent("");// GOODS_PRESENT 赠品
		order.setGoodsPresentDesc("");// GOODS_PRESENT_DESC
		// 赠品说明
		order.setSpecFlag("");// SPEC_FLAG 是否特选商品
		order.setSpecDesc("");// SPEC_DESC 特别备注信息
		order.setGoodsRange("");// GOODS_RANGE 送货范围
		order.setGoodsLocal("");// GOODS_LOCAL 是否现场兑换
		order.setGoodssendFlag("0");// GOODSSEND_FLAG 发货标记
		order.setGoodsaskforFlag("0");// GOODSASKFOR_FLAG 请款标记
		order.setGoodsBill("");// GOODS_BILL 商品账单描述
		order.setGoodsDesc("");// GOODS_DESC 商品备注
		order.setGoodsResv1("");// GOODS_RESV1 商品保留字段一
		order.setSpecShopnoType("");// SPEC_SHOPNO_TYPE 特店类型
		// order.setPayType("");// PAY_TYPE 佣金代码
		order.setPayTypeNm("");// PAY_TYPE_NM 佣金代码名称
		order.setIncCode("");// INC_CODE 手续费率代码
		order.setIncCodeNm("");// INC_CODE_NM 手续费率名称
		order.setStagesNum(1);// STAGES_NUM 现金[或积分]分期数
		order.setCommissionType("");// COMMISSION_TYPE 佣金计算类别
		order.setCommissionRate(new BigDecimal(0));// COMMISSION_RATE 佣金区间佣金率(不包含%)
		order.setCommission(new BigDecimal(0));// COMMISSION 佣金金额【与币种一致】
		order.setBankNbr("");// BANK_NBR 银行号
		order.setSpecShopno("");// SPEC_SHOPNO 特店号
		order.setBonusBankNbr("");// BONUS_BANK_NBR 积分银行号
		order.setBonusSpecShopno("");// BONUS_SPEC_SHOPNO 积分特店号
		order.setPayCode("");// PAY_CODE 缴款方案代码
		order.setProdCode("");// PROD_CODE 分期产品代码
		order.setPlanCode("");// PLAN_CODE 分期计划代码
		order.setStagesDesc("");// STAGES_DESC 分期描述
		order.setMcc(vendorInf.getMcc());// MCC mcc号
		order.setIncWay("00");// INC_WAY 手续费获取方式
		order.setIncTakeWay("");// INC_TAKE_WAY 手续费计算方式
		order.setIncType("");// INC_TYPE 手续费类别
		order.setIncRate(new BigDecimal(0));// INC_RATE 手续费率(不包含%)
		order.setIncMoney(new BigDecimal(0));// INC_MONEY 手续费总金额
		order.setIncDesc("");// INC_DESC 手续费描述
		order.setUitopsfee("");// UITOPSFEE 手续费收取方式
		order.setUitfeeflg(0);// UITFEEFLG 手续费减免期数
		order.setUitfeedam(new BigDecimal(0));// UITFEEDAM 手续费减免金额
		order.setUitopsdate("");// UITOPSDATE 分期开始日期
		order.setUitdrtuit(0);// UITDRTUIT 本金减免期数
		order.setUitdrtamt(new BigDecimal(0));// UITDRTAMT 本金减免金额
		order.setIncBackway("");// INC_BACKWAY 手续费退回方式
		order.setIncBackPrice(new BigDecimal(0));// INC_BACK_PRICE 手续费退回指定金额
		order.setIncTakePrice(new BigDecimal(0));// INC_TAKE_PRICE 退单时收取指定金额手续费

		if ("0".equals(payway.getIsAction())) {// 非活动
			order.setActType("0");// ACT_TYPE 活动类型
		} else {
			// 查询单品活动类型 ADD BY geshuo
			// CC，短信，搭销默认商城渠道00
			//查询商品活动信息 type传1，代表只取得正在进行的活动
			Response<MallPromotionResultDto> promResponse = mallPromotionService.findPromByItemCodes("1", goodsInf.getCode(), "00");
			if(!promResponse.isSuccess()){
				log.error("Response.error,error code: {}", promResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
			}

			if (promResponse.isSuccess() && promResponse.getResult() != null) {
				MallPromotionResultDto promotionResultDto = promResponse.getResult();
				if (promotionResultDto.getPromItemResultList() != null
						&& promotionResultDto.getPromItemResultList().size() > 0) {
					promotionResultDto.getPromType();
					order.setActType(String.valueOf(promotionResultDto.getPromType()));// 取得活动类型
				}
			}
		}

		order.setVoucherId("");// VOUCHER_ID 优惠券代码
		order.setVoucherNm("");// VOUCHER_NM 优惠券名称
		order.setVoucherPrice(new BigDecimal(0));// VOUCHER_PRICE 优惠金额
		order.setCreditFlag("0");// CREDIT_FLAG 授权额度不足处理方式
		order.setCashAuthType("");// CASH_AUTH_TYPE 现金授权类型
		order.setAccreditDate("");// ACCREDIT_DATE 授权日期
		order.setAccreditTime("");// ACCREDIT_TIME 授权时间
		order.setAuthCode("");// AUTH_CODE 授权码
		order.setRtnCode("");// RTN_CODE 主机授权回应代码
		order.setRtnDesc("");// RTN_DESC 主机授权回应代码说明
		order.setTxnMsg1Desc("");// TXN_MSG1_DESC 通讯消息说明1
		order.setTxnMsg2Desc("");// TXN_MSG2_DESC 通讯消息说明2
		order.setHostAccCode("");// HOST_ACC_CODE 主机入账回应代码
		order.setHostAccDesc("");// HOST_ACC_DESC 主机入账回应代码说明
		order.setBonusTrnDate("");// BONUS_TRN_DATE 支付日期
		order.setBonusTrnTime("");// BONUS_TRN_TIME 支付时间
		order.setBonusTraceNo("");// BONUS_TRACE_NO 系统跟踪号
		order.setBonusAuthType("");// BONUS_AUTH_TYPE 积分授权类型
		order.setBonusAccreditDate("");// BONUS_ACCREDIT_DATE BONUS授权日期
		order.setBonusAccreditTime("");// BONUS_ACCREDIT_TIME BONUS授权时间
		order.setBonusAuthCode("");// BONUS_AUTH_CODE BONUS授权码
		order.setBonusRtnCode("");// BONUS_RTN_CODE BONUS主机授权回应代码
		order.setBonusRtnDesc("");// BONUS_RTN_DESC BONUS主机授权回应代码说明
		order.setBonusTxnMsgDesc("");// BONUS_TXN_MSG_DESC BONUS通讯消息说明
		order.setCalWay("1");// CAL_WAY 退货方式
		order.setLockedFlag("0");// LOCKED_FLAG 订单锁标记
		order.setVendorOperFlag("0");// VENDOR_OPER_FLAG 供应商操作标记
		order.setMsgContent("");// MSG_CONTENT 上行短信内容
		order.setOrderDesc("");// ORDER_DESC 订单表备注
		order.setTmpStatusId("0000");// TMP_STATUS_ID 临时状态代码
		order.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// CUR_STATUS_ID
		// 当前状态代码
		order.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// CUR_STATUS_NM
		// 当前状态名称
		order.setCreateOper(createOper);// CREATE_OPER 创建操作员ID
		order.setModifyOper(createOper);// MODIFY_OPER 修改操作员ID
		order.setCreateTime(orderMain.getCreateTime());// CREATE_TIME 创建时间
		order.setCommDate(DateHelper.getyyyyMMdd());// COMM_DATE 业务日期
		order.setCommTime(DateHelper.getHHmmss());// COMM_TIME 业务时间
		order.setModifyTime(orderMain.getCreateTime());// MODIFY_TIME 修改时间
		order.setVersionNum(0);// VERSION_NUM 记录更新控制版本号
		order.setExt1("");// EXT_1 扩展属性一
		order.setExt2("");// EXT_2 分期为BIU的分期代码
		order.setExt3("");// EXT_3 扩展属性三
		order.setReserved1("");// RESERVED1 保留字段
		order.setRuleId("");// RULE_ID 规则ID
		order.setRuleNm("");// RULE_NM 规则名称
		order.setLimitCode("");// LIMIT_CODE 规则限制代码
		order.setVoucherNo("");// VOUCHER_NO 优惠券编码
		order.setActId("");// ACT_ID ACT_ID
		order.setCustType("");// CUST_TYPE CUST_TYPE
		order.setAccreditType("");// ACCREDIT_TYPE ACCREDIT_TYPE
		order.setAcctNo("");// ACCT_NO ACCT_NO
		order.setAppFlag("");// APP_FLAG APP_FLAG
		order.setCashTraceNo1("");// CASH_TRACE_NO_1 CASH_TRACE_NO_1
		order.setCashTraceNo2("");// CASH_TRACE_NO_2 CASH_TRACE_NO_2
		order.setBankNbr2("");// BANK_NBR_2 BANK_NBR_2
		order.setSpecShopno2("");// SPEC_SHOPNO_2 SPEC_SHOPNO_2
		order.setAccreditDate2("");// ACCREDIT_DATE_2 ACCREDIT_DATE_2
		order.setAccreditTime2("");// ACCREDIT_TIME_2 ACCREDIT_TIME_2
		order.setAuthCode2("");// AUTH_CODE_2 AUTH_CODE_2
		order.setActCategory("");// ACT_CATEGORY ACT_CATEGORY
		order.setActName("");// ACT_NAME ACT_NAME
		order.setUserAsscNbr("");//
		order.setVendorPhone("");//
		order.setDfacct("");//
		order.setDfname("");//
		order.setDfhnbr("");//
		order.setDfhname("");//
		order.setCvv2("");//
		order.setLogisticsSynFlag("");//
		order.setSinglePrice(payway.getGoodsPrice());// 单价

		String integralId = goodsInf.getPointsType();// 积分类型id
		order.setBonusType(integralId);// 积分类型

		TblCfgIntegraltypeModel tblCfgIntegraltype = integraltypeMap.get(integralId);

		// 查询积分类型
		order.setBonusTypeNm(tblCfgIntegraltype != null ? tblCfgIntegraltype.getIntegraltypeNm() : "");// 积分类型名称
		order.setBalanceStatus("");//
		order.setBatchNo("");//

		order.setEUpdateStatus("0");// 更新状态
		order.setMemberLevel(payway.getMemberLevel());// 会员等级
		order.setIntegraltypeId(goodsInf.getPointsType());// 积分类型
		order.setMerId(merId);// 商户号
		order.setMiaoshaActionFlag(0);//活动标志 非空
		return order;
	}

	/**
	 * MAL401更新主订单状态 niufw
	 *
	 * @return
	 */
	public Integer updateForMAL401(OrderMainModel orderMainModel) {
		Integer result = orderMainDao.updateForMAL401(orderMainModel);
		return result;
	}

	/**
	 * 新增
	 * 
	 * @param orderMainModel
	 * @return Integer
	 */
	public Integer insert(OrderMainModel orderMainModel) {
		return orderMainDao.insert(orderMainModel);
	}

	public Integer insert(AuctionRecordModel auctionRecordModel){
		return auctionRecordDao.insert(auctionRecordModel);
	}

	/**
	 * MAL501
	 *
	 * @param orderMainModel
	 * @return Integer
	 */
	public Integer updateTblOrderMain(OrderMainModel orderMainModel) {
		return orderMainDao.updateTblOrderMain(orderMainModel);
	}

	/**
	 * MAL109 订单投递信息修改
	 * 
	 * @param orderMainModel
	 * @return
	 */
	public Integer updateOrderMainAddr(OrderMainModel orderMainModel) {
		return orderMainDao.updateOrderMainAddr(orderMainModel);
	}

	/**
	 * 更新状态
	 *
	 * @param params
	 * @return Integer
	 */
	public Integer updateorderMainStatusUnderControl(Map<String, Object> params) {
		return orderMainDao.updateorderMainStatusUnderControl(params);
	}

	/**
	 * 更新状态 ？
	 *
	 * @param orderMainModel 更新对象
	 * @return Integer
	 */
	public Integer updateOrderMainStatus(OrderMainModel orderMainModel) {
		return orderMainDao.updateOrderMainStatus(orderMainModel);
	}

	/**
	 * 更新
	 *
	 * @param orderMainModel 更新对象
	 * @return Integer
	 */
	public Integer update(OrderMainModel orderMainModel) {
		return orderMainDao.update(orderMainModel);
	}

	public Integer update(AuctionRecordModel auctionRecordModel){
		return auctionRecordDao.update(auctionRecordModel);
	}

	/**
	 * 更新
	 *
	 * @param ordermainId 主订单id
	 * @param payAccountNo
     * @return Integer
     */
	public Integer updateOrderCardNoForMain(String ordermainId, String payAccountNo) {
		return orderMainDao.updateOrderCardNoForMain(ordermainId, payAccountNo);
	}

	public Integer updateByIdAndBackLock(AuctionRecordModel auctionRecordModel){
		return auctionRecordDao.updateByIdAndBackLock(auctionRecordModel);
	}


	/**
	 * 存储大订单，小订单，订单历史, 虚拟礼品订单扩展表（需事务控制）
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Integer saveWXVirtualOrders(OrderMainModel orderMain, OrderSubModel orderSubModel, OrderDoDetailModel orderDodetail,
									 boolean subFlag, Integer stock, OrderVirtualModel orderVirtualModel) throws Exception {
		log.info("进入保存订单方法saveOrders");
		if (orderMain != null) {
			String goods_id = "";
			log.info("保存的大订单号：" + orderMain.getOrdermainId() + "商品数量：" + orderMain.getTotalNum());
			orderMainDao.insert(orderMain);
			// 保存小订单
			if (null != orderSubModel) {
				log.info("保存小订单:" + orderSubModel.getOrderId() + ",商品数量：" + orderSubModel.getGoodsNum());
				orderSubDao.insert(orderSubModel);
				goods_id = orderSubModel.getGoodsId();
				if (subFlag) {
					// 扣减库存  (判断库存是否大于商品数量)
					if (stock >= orderSubModel.getGoodsNum()) {
						//goodsService.updateGoodsYG(goods_id, 0 - orderSubModel.getGoodsNum().longValue());
						Map<String, Long> itemModelMap = Maps.newHashMap();
						itemModelMap.put(goods_id, orderSubModel.getGoodsNum().longValue());
						Response<Boolean> response = itemService.updateStockForOrder(itemModelMap);
						if (!response.isSuccess() || !response.getResult()) {
							throw new TradeException("您所选中的商品库存数量不足");
						}											
					}
				}
			}
			
			// 保存虚拟礼品表
			if(null != orderVirtualModel){
				log.info("保存虚拟礼品订单扩展表：" + orderVirtualModel.getOrderId());
				orderVirtualDao.insert(orderVirtualModel);
			}
			
			// 保存订单dodetail
			if (null != orderDodetail) {
				log.info("保存订单操作记录表：" + orderDodetail.getOrderId());
				orderDoDetailDao.insert(orderDodetail);
			}
		}
		log.info("保存完毕，事务完成");
		return 0;
	}

	/**
	 * 更大小订单里的卡号
	 * @param ordermain_id 大订单号
	 * @param payAccountNo 银行卡号
	 * @return
	 */
	public Integer updateOrderCardNoForAll(String ordermain_id,
			String payAccountNo) {
		int main=orderMainDao.updateOrderCardNoForMain(ordermain_id, payAccountNo);
		if(main>0){
			main=orderSubDao.updateOrderCardNoForSub(ordermain_id, payAccountNo);
		}
		if(main<=0){
			String msg = "更新大小订单里的支付银行卡号因为找不到订单失败";
			log.error(msg);
			throw new RuntimeException(msg);
		}
		return main;
	}
}
