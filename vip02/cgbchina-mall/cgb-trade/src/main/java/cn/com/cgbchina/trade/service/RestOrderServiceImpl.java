package cn.com.cgbchina.trade.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.GoodsItemDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.trade.dao.OrderGoodsDetailDao;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dao.OrderTransDao;
import cn.com.cgbchina.trade.dao.OrderVirtualDao;
import cn.com.cgbchina.trade.dao.SaleRankDao;
import cn.com.cgbchina.trade.dto.OrderItemAttributeDto;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderSubDto;
import cn.com.cgbchina.trade.manager.OrderMainManager;
import cn.com.cgbchina.trade.manager.OrderTradeManager;
import cn.com.cgbchina.trade.model.OrderDetailDtoExtend;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderGoodsDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderSubModelVirtualExtend;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import cn.com.cgbchina.trade.model.SaleRankModel;

import com.fasterxml.jackson.databind.JavaType;
import com.google.common.base.Throwables;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.util.JsonMapper;

@Service
@Slf4j
public class RestOrderServiceImpl implements RestOrderService {

	private final static JavaType javaType = JsonMapper.JSON_NON_EMPTY_MAPPER.createCollectionType(ArrayList.class,
			OrderItemAttributeDto.class);
	private final static DateTimeFormatter DFT = DateTimeFormat.forPattern("yyyyMMdd");// 字符串转时间
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	OrderGoodsDetailDao orderGoodsDetailDao;
	@Resource
	OrderService orderService;
	@Resource
	OrderMainDao orderMainDao;
	@Resource
	OrderSubDao orderSubDao;
	@Resource
	GoodsService goodsService;
	@Resource
	RestItemService restItemService;
	@Resource
	ItemService itemService;
	@Resource
	OrderVirtualDao orderVirtualDao;
	@Resource
	OrderTransDao orderTransDao;
	@Resource
	SaleRankDao saleRankDao;
	@Resource
	OrderMainManager orderMainManager;
	@Resource
	OrderTradeManager orderTradeManager;

	@Override
	public Response<Pager<OrderMainModel>> findByUserId(String userid) {

		Response<Pager<OrderMainModel>> resp = new Response<Pager<OrderMainModel>>();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("createOper", userid);
		// TODO:支付状态未加
		// params.put("curStatusId", value);
		// params.put(key, value)
		try {
			Pager<OrderMainModel> orders = orderMainDao.findByPage(params, 0, 1);
			resp.setResult(orders);
		} catch (RuntimeException ex) {
			log.error(" 【mal119 通过用户ID查找主订单异常】  用户ID " + userid, ex);
			resp.setError("findByUserId error ,userid " + userid);
		}
		return resp;
	}

	@Override
	public Response<List<OrderSubModel>> findBySubOrderMainId(String orderMainId) {
		Response<List<OrderSubModel>> resp = new Response<List<OrderSubModel>>();
		try {

			List<OrderSubModel> orderSubs = orderSubDao.findByOrderMainId(orderMainId);
			resp.setResult(orderSubs);
		} catch (RuntimeException ex) {
			resp.setError("findBySubOrderMainId error ,orderMainId " + orderMainId);
			log.error("【通过主订单ID查找订单异常】主订单ID" + orderMainId, ex);
		}
		return resp;
	}

	@Override
	public Response<OrderGoodsDetailModel> findOrderGoodsDetailBySubOrderId(String subOrderId) {

		Response<OrderGoodsDetailModel> result = new Response<OrderGoodsDetailModel>();
		try {
			if (subOrderId != null && !subOrderId.isEmpty()) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orderNo", subOrderId);

				Pager<OrderGoodsDetailModel> orderGoodsDetailModelPager = orderGoodsDetailDao.findByPage(params, 0, 1);
				if (orderGoodsDetailModelPager != null && orderGoodsDetailModelPager.getData() != null
						&& orderGoodsDetailModelPager.getData().size() > 0) {
					result.setResult(orderGoodsDetailModelPager.getData().get(0));
				}

			}
		} catch (RuntimeException ex) {
			log.error("子订单号查找商品快照信息(MAL109用) 异常 子订单为" + subOrderId, ex);
		}
		return result;
	}
	
	@Override
	public Response<GoodsModel> findGoodsByUserId(String userId) {
		Response<GoodsModel> resp = new Response<>();

		// 获取主表单ID
		Response<Pager<OrderMainModel>> orderMainResp = this.findByUserId(userId);
		if(!orderMainResp.isSuccess()){
			log.error("Response.error,error code: {}", orderMainResp.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		try {
			if (orderMainResp.getResult() != null) {
				List<OrderMainModel> orderMainModels = orderMainResp.getResult().getData();
				if (orderMainModels != null && !orderMainModels.isEmpty()) {
					// 获取子订单列表 ，一个子订单对应一个商品
					String orderMainId = orderMainModels.get(0).getOrdermainId();
					Response<List<OrderSubModel>> orderSubModelResp = this.findBySubOrderMainId(orderMainId);
					if(!orderSubModelResp.isSuccess()){
						log.error("Response.error,error code: {}", orderSubModelResp.getError());
						throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
					}
					if (orderSubModelResp.getResult() != null) {
						List<OrderSubModel> OrderSubModels = orderSubModelResp.getResult();
						if (OrderSubModels != null && !OrderSubModels.isEmpty()) {
							// 获取 子订单的ID
							String subOrderId = OrderSubModels.get(0).getGoodsCode();
							
							Response<GoodsModel> goodsInfo = goodsService.findById(subOrderId);
							if(!goodsInfo.isSuccess()){
								log.error("Response.error,error code: {}", goodsInfo.getError());
								throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
							}
							if (goodsInfo != null && goodsInfo.getResult() != null) {
								// 商品快照信息
								resp.setResult(goodsInfo.getResult());
							}
						}
					}
				}
			}
		} catch (RuntimeException ex) {
			log.error("【 通过用户ID查找最近一张订单里面的商品快照信息(MAL119用)异常】 用户ID " + userId, ex);
		}
		return resp;
	}

	@Override
	public Response<OrderDetailDtoExtend> findOrderDetailbyOrderMainId(String orderMainId) {
		Response<OrderDetailDtoExtend> response = new Response<OrderDetailDtoExtend>();
		OrderDetailDtoExtend result = new OrderDetailDtoExtend();
		// 获取主订单信息
		OrderMainModel orderMainModel = null;
		orderMainModel = orderMainDao.findById(orderMainId);

		if (orderMainModel != null) {
			result.setOrderMainModel(orderMainModel);
		} else {
			response.setError("找不到订单相关信息 订单号为" + orderMainId);
			log.info("找不到订单相关信息 订单号为" + orderMainId);
			return response;
		}

		// 子订单信息
		Response<List<OrderSubModel>> orderSubModelsResp = this.findBySubOrderMainId(orderMainId);
		if (orderSubModelsResp.isSuccess()) {
			// 虚拟物品扩展表(包括子订单信息和虚拟 物品扩展信息)
			List<OrderSubModelVirtualExtend> orderSubModelVirtualExtends = new ArrayList<OrderSubModelVirtualExtend>();
			List<OrderSubModel> orderSubs = orderSubModelsResp.getResult();
			// 根据订单ID ，查找 虚拟礼品订单扩展表
			List<String> subOrderIds = new ArrayList<String>();// 子订单合集
			for (OrderSubModel orderSubModel : orderSubs) {
				// 子订单基础信息
				OrderSubModelVirtualExtend extend = BeanUtils.copy(orderSubModel, OrderSubModelVirtualExtend.class);
				subOrderIds.add(orderSubModel.getOrderId());
				orderSubModelVirtualExtends.add(extend);
			}
			List<OrderVirtualModel> orderVirtualModels = orderVirtualDao.findVirualByOrderIds(subOrderIds);// 虚拟物品扩展表
			List<OrderTransModel> orderTransModels = orderTransDao.findByOrderIds(subOrderIds);// 物流信息

			for (OrderSubModelVirtualExtend ext : orderSubModelVirtualExtends) {
				if (orderVirtualModels != null && !orderVirtualModels.isEmpty()) {
					for (OrderVirtualModel orderVirtualModel : orderVirtualModels) {
						if (ext.getOrderId().equals(orderVirtualModel.getOrderId())) {
							// 子订单虚拟扩展信息
							ext.setOrderVirtualModel(orderVirtualModel);
							break;
						}
					}
				} else {
					ext.setOrderVirtualModel(new OrderVirtualModel());
				}
				if (orderTransModels != null && !orderTransModels.isEmpty()) {
					for (OrderTransModel trans : orderTransModels) {
						if (trans.getOrderId().equals(ext.getOrderId())) {
							// 子订单的 物流信息
							ext.setOrderTransModel(trans);
						}
					}
				} else {
					ext.setOrderTransModel(new OrderTransModel());
				}
			}
			// 接口只需要返回一条物流信息
			if (orderTransModels != null && orderTransModels.size() > 0) {
				result.setOrderTransModel(orderTransModels.get(0));
			}
			result.makeBonusTotalFlag();
			result.makeVoucherFlag();
			result.setOrderSubModelVirtualExtends(orderSubModelVirtualExtends);

		} else {
			result.setOrderSubModelVirtualExtends(new ArrayList<OrderSubModelVirtualExtend>());
		}
		response.setResult(result);

		return response;
	}

	@Override
	public Response<List<OrderGoodsDetailModel>> findOrderGoodsDetailBySubOrderId(List<String> subOrderIds) {
		Response<List<OrderGoodsDetailModel>> result = new Response<List<OrderGoodsDetailModel>>();
		try {
			if (subOrderIds != null && !subOrderIds.isEmpty()) {
				result.setResult(orderGoodsDetailDao.findBySubOrderIds(subOrderIds));
			}
		} catch (RuntimeException ex) {
			log.error("通过子订单号列表查找商品快照信息列表  子订单为" + subOrderIds, ex);
			result.setError("通过子订单号列表查找商品快照信息列表 异常");
		}
		return result;
	}

	@Override
	public Response<List<GoodsItemDto>> findSaleRankByjfType(String jfType) {
		Response<List<GoodsItemDto>> response = new Response<List<GoodsItemDto>>();
		if (jfType != null && !jfType.isEmpty()) {
			// 根据积分类型获取排行对象
			List<SaleRankModel> saleRanks = saleRankDao.findByJfType(jfType);
			List<String> itemCodes = new ArrayList<String>();
			if (saleRanks != null && !saleRanks.isEmpty()) {
				for (SaleRankModel saleRankModel : saleRanks) {
					itemCodes.add(saleRankModel.getGoodsId());
				}
				// 根据单品编号获取单品列表
				response = restItemService.findIVRRankGoodsInfoByGoodsCodes(itemCodes);

			}

		}
		return response;
	}

	@Override
	public Response<List<OrderSubDto>> queryBoughtOrder(String cardNo, String goodsId, boolean isLXSYX) {
		Response<List<OrderSubDto>> response = new Response<List<OrderSubDto>>();
		try {
			List<OrderSubDto> orderSubDtos = new ArrayList<OrderSubDto>();
			List<OrderSubModel> orderSubModels = orderSubDao.findByGoodsId(goodsId);
			if (isLXSYX) {// 留学生旅行意外险订单
				List<String> orderIds = new ArrayList<String>();
				for (OrderSubModel orderSubModel : orderSubModels) {
					orderIds.add(orderSubModel.getOrderId());
				}
				// 虚拟礼品订单
				List<OrderVirtualModel> orderVirtualModels = orderVirtualDao.findVirualByOrderIds(orderIds);

				for (OrderVirtualModel orderVirtualModel : orderVirtualModels) {
					if (cardNo.equals(orderVirtualModel.getAttachIdentityCard())) {
						for (OrderSubModel orderSubModel : orderSubModels) {
							if (orderSubModel.getOrderId().equals(orderVirtualModel.getOrderId())) {
								OrderSubDto orderSubDto = new OrderSubDto();
								orderSubDto.setOrderId(orderSubModel.getOrderId());
								orderSubDto.setCreateTime(orderSubModel.getCreateTime());
								orderSubDtos.add(orderSubDto);
								break;
							}
						}
					}
				}
			} else {// 其他订单
				for (OrderSubModel orderSubModel : orderSubModels) {
					if (cardNo.equals(orderSubModel.getCardno())) {
						OrderSubDto orderSubDto = new OrderSubDto();

						orderSubDto.setOrderId(orderSubModel.getOrderId());
						orderSubDto.setCreateTime(orderSubModel.getCreateTime());
						orderSubDtos.add(orderSubDto);
						break;
					}
				}
			}
			response.setResult(orderSubDtos);
		} catch (Exception e) {
			log.error("【queryBoughtOrder.error】MAL201 CC积分商城预判接口 已购买订单查询失败", e);
			response.setError("RestOrderServiceImpl.queryBoughtOrder.error");
		}
		return response;
	}
	
	@Override
	public Response<Boolean> dealNoSureOrderswithTX(List<String> orderIds, String cardNo, String cardType,
			String errCode, String doDesc) {
		Response<Boolean> response = new Response<Boolean>();
		try{
			orderTradeManager.dealNoSureOrders(orderIds, cardNo, cardType, errCode, doDesc);
			response.setResult(true);
		}catch(Exception e){
			log.error("处理积分加优惠券支付状态未明订单出错：", e);
			response.setResult(false);
		}
		return response;
	}

	@Override
	public Response<Boolean> dealFailOrderswithTx(List<String> orderIds, String orderMainId, String cardNo,
			String doDesc, User user) {
		Response<Boolean> response = new Response<Boolean>();
		try{
			orderTradeManager.dealFailOrders(orderIds, orderMainId, cardNo, doDesc, user);
			response.setResult(true);
		}catch(Exception e){
			log.error("处理积分加优惠券支付状态未明订单出错：", e);
			response.setResult(false);
		}
		return response;
	}

	@Override
	public Response<Boolean> saveYGOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModels,
			List<OrderDoDetailModel> orderDoDetailModels, OrderMainDto orderMainDto, User user) {
		Response<Boolean> response = new Response<Boolean>();
		try{
			orderMainManager.createOrder_new(orderMainModel, orderSubModels, orderDoDetailModels, 
					orderMainDto.getStockRestMap(),orderMainDto.getPointPoolModel(),orderMainDto.getPromItemMap(),user);
			response.setResult(true);
		}catch(Exception e){
			log.error("渠道广发订单登入数据库出错：", e);
			response.setError("RestOrderService.saveYGOrder.error:" + Throwables.getStackTraceAsString(e));
		}
		return response;
	}

	@Override
	public Response<Boolean> saveJFOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList,
			List<OrderDoDetailModel> orderDoDetailModelList, Map<String, Long> stockMap) {
		Response<Boolean> response = new Response<Boolean>();
		try{
			orderMainManager.createJfOrder_new(orderMainModel, orderSubModelList, orderDoDetailModelList,
					null, stockMap, null, null);
			response.setResult(true);
		}catch(Exception e){
			log.error("渠道积分订单登入数据库出错：", e);
			response.setError("RestOrderService.saveJFOrder.error:" + Throwables.getStackTraceAsString(e));
		}
		return response;
	}

	@Override
	public Response<Boolean> updateOrders(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModels,
			List<OrderDoDetailModel> orderDoDetailModels, Map<String, Integer> itemStockMap, Integer birthDayCount, User user) {
		Response<Boolean> response = new Response<Boolean>();
		try{
			orderTradeManager.dealOrdersJF(orderMainModel, orderSubModels, orderDoDetailModels,
					itemStockMap, birthDayCount, user);
			response.setResult(true);
		}catch(Exception e){
			log.error("渠道积分订单登入数据库出错：", e);
			response.setError("RestOrderService.saveJFOrder.error:" + Throwables.getStackTraceAsString(e));
		}
		return response;
	}
}
