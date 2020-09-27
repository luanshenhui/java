/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.manager;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.trade.dao.OrderDoDetailDao;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderGoodsDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/5/27.
 */
@Component
@Transactional
public class OrderMainManager {

	@Resource
	OrderSubDao orderSubDao;
	@Resource
	OrderDoDetailDao orderDoDetailDao;
	@Resource
	OrderMainDao orderMainDao;
	// @Resource
	// OrderGoodsDetailDao orderGoodsDetailDao;
	@Resource
	ItemService itemService;
	@Resource
	private IdGenarator idGenarator;

	/**
	 * 新建主订单子订单以及订单记录表
	 *
	 * @param orderMainModel
	 * @param orderSubModelList
	 * @param orderGoodsDetailModelList
	 * @param orderDoDetailModelList
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean createOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList,
			List<OrderGoodsDetailModel> orderGoodsDetailModelList, List<OrderDoDetailModel> orderDoDetailModelList,
			List<ItemModel> itemModelList) throws Exception {
		String orderMainId = idGenarator.orderMainId(orderMainModel.getSourceId());
		orderMainModel.setOrdermainId(orderMainId);
		orderMainModel.setSerialNo(idGenarator.orderSerialNo());
		for (int i = 0; i < orderSubModelList.size(); i++) {
			OrderSubModel orderSubModel = orderSubModelList.get(i);
			orderSubModel.setOrdermainId(orderMainId);
			orderSubModel.setOrderId(orderMainId + StringUtils.leftPad(String.valueOf(i + 1), 2, "0"));
			orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
			// orderGoodsDetailModelList.get(i).setOrderNo(orderSubModel.getOrderId());
			orderDoDetailModelList.get(i).setOrderId(orderSubModel.getOrderId());
		}
		orderMainDao.insert(orderMainModel);
		orderSubDao.insertBatch(orderSubModelList);
		// orderGoodsDetailDao.insertBatch(orderGoodsDetailModelList);
		orderDoDetailDao.insertBatch(orderDoDetailModelList);
		try {
			// 更新库存
			for (ItemModel itemModel : itemModelList) {
				itemService.update(itemModel);
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
			OrderDoDetailModel orderDoDetailModel, ItemModel itemModel) throws Exception {
		// 获取主订单号
		String orderMainId = orderMainModel.getOrdermainId();
		Integer orderMainInt = orderMainDao.update(orderMainModel);
		// 子订单插入数据
		orderSubModel.setOrdermainId(orderMainId);
		orderSubModel.setOrderId(
				orderMainId + StringUtils.leftPad(String.valueOf(orderMainModel.getTotalNum() + 1), 2, "0"));
		orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
		orderSubDao.insert(orderSubModel);
		orderDoDetailDao.insert(orderDoDetailModel);
		try {
			// 更新库存
			itemService.update(itemModel);
		} catch (Exception e) {
			throw e;
		}
		return Boolean.TRUE;
	}

	/**
	 * 取消订单
	 *
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean updateCancelOrder(OrderMainModel orderMainModel) throws Exception {
		try {
			orderMainDao.update(orderMainModel);
			String ordermainId = orderMainModel.getOrdermainId();
			String id = orderMainModel.getModifyOper();
			List<OrderSubModel> orderSubModels = Lists.newArrayList();
			orderSubModels = orderSubDao.findByOrderMainId(ordermainId);
			if (orderSubModels == null || orderSubModels.isEmpty()) {
				throw new Exception("orderSubModels.be.empty");
			}
			List<OrderSubModel> orderSubModelList = Lists.newArrayList();
			List<ItemModel> itemModelList = Lists.newArrayList();
			List<OrderDoDetailModel> orderDoDetailModels = Lists.newArrayList();
			for (OrderSubModel orderSubModel : orderSubModels) {
				if (!Contants.SUB_ORDER_STATUS_0301.equals(orderSubModel.getCurStatusId())) {
					throw new Exception("orderSub.changed");
				}
				orderSubModel.setCurStatusNm(Contants.SUB_ORDER_CANCELED);
				orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_7777);
				orderSubModel.setModifyOper(id);
				orderSubModelList.add(orderSubModel);
				String goodsId = orderSubModel.getGoodsId();
				if (StringUtils.isBlank(goodsId)) {
					throw new Exception("itemCode.can.not.be.empty");
				}
				ItemModel itemModel = itemService.findById(goodsId);
				if (itemModel == null) {
					throw new Exception("itemModel.be.null");
				}
				itemModel.setStock(itemModel.getStock() + 1);
				itemModel.setModifyOper(id);
				itemModelList.add(itemModel);

				OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
				orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
				orderDoDetailModel.setModifyOper(id);
				orderDoDetailModel.setCreateOper(id);
				orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_7777);
				orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_CANCELED);
				orderDoDetailModel.setDoUserid(id);
				orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);
				orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
				orderDoDetailModels.add(orderDoDetailModel);
			}
			orderSubDao.updateBatch(orderSubModelList);
			orderDoDetailDao.insertBatch(orderDoDetailModels);
			// 更新库存
			for (ItemModel itemModel : itemModelList) {
				itemService.update(itemModel);
			}
		} catch (Exception e) {
			throw e;
		}
		return Boolean.TRUE;
	}
}
