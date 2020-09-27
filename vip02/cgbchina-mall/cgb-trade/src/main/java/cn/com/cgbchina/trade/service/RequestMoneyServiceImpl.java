package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.OrderQueryConditionDto;
import cn.com.cgbchina.trade.dto.RequestOrderDto;
import cn.com.cgbchina.trade.manager.OrderDodetailManger;
import cn.com.cgbchina.trade.manager.RequestMoneyManager;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.user.service.NewMessageService;
import com.google.common.base.Stopwatch;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.jms.mq.QueueSender;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by 11150721040343 on 16-4-12.
 */
@Service
@Slf4j
public class RequestMoneyServiceImpl implements RequestMoneyService {
	@Autowired
	RequestMoneyManager requestMoneyManager;
	@Autowired
	OrderDodetailManger orderDodetailManger;
	@Autowired
	OrderService orderService;
	@Autowired
	OrderSubDao orderSubDao;
	@Autowired
	OrderMainDao orderMainDao;
	@Autowired
	TblOrderHistoryDao tblOrderHistoryDao;
	@Autowired
	TblOrdermainHistoryDao tblOrdermainHistoryDao;
	@Autowired
	OrderClearDao orderClearDao;
	@Autowired
	TblOrderExtend1Dao tblOrderExtend1Dao;
	@Autowired
	ItemService itemService;
	@Autowired
	NewMessageService newMessageService;
	@Autowired
	private RedisService redisService;
	@Autowired
	@Qualifier("orderSender")
	private QueueSender queueSender;

	// 判断非空
	private Boolean isNotBlank(String str) {
		if (StringUtils.isNotBlank(str) && StringUtils.isNotBlank(str.trim().replace(" ", "")))
			return Boolean.TRUE;
		return Boolean.FALSE;
	}

	private String insensitiveCardNo(String cardNo){
		int length = cardNo.length();
		String mass=StringUtils.repeat("*",length-8);
		return StringUtils.overlay(cardNo,mass,4,length-4);
	}
	@Override
	public Response<Integer> updateById(Map<String, Object> dataMap) {
		Response<Integer> response = Response.newResponse();
		try {
			// 校验list是否为空
			checkArgument(dataMap.get("list") != null, "list is null");
			// 校验orderDoDetailModel是否为空
			checkArgument(dataMap.get("orderDoDetailModelList") != null, "orderDoDetailModel is null");
			List<String> orderIds = (List) dataMap.get("list");
			List<OrderDoDetailModel> orderDoDetailModelList = (List) dataMap.get("orderDoDetailModelList");
			// 根据orderId更新请款状态,插入历史表
			response.setResult(requestMoneyManager.updateById(orderIds, orderDoDetailModelList));
			return response;
		} catch (IllegalArgumentException e) {
			log.error("request.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("request.error");
			return response;
		} catch (Exception e) {
			log.error("request.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("request.error");
			return response;
		}

	}

	/**
	 * 运营商同意请款
	 *
	 * @param dataMap
	 * @return
	 */
	@Override
	public Response<Integer> updatePassById(HashMap<String, Object> dataMap) {
		Response<Integer> response = Response.newResponse();
		List<OrderClearModel> orderClearModelList = Lists.newArrayList();
		try {
			// 校验list是否为空
			checkArgument(dataMap != null, "list is null");
			// 校验orderDoDetailModelList是否为空
			checkArgument(dataMap.get("orderDoDetailModelList") != null, "orderDoDetailModel is null");
			String orderTypeId=(String) dataMap.get("orderTypeId");
			checkArgument(StringUtils.isNoneBlank(orderTypeId),"业务类型参数不允许为空");
			if (!Contants.BUSINESS_TYPE_JF.equals(orderTypeId)&&!Contants.BUSINESS_TYPE_FQ.equals(orderTypeId)){
				log.error("updatePassById.error,error orderTypeId be wrong");
				response.setError("业务类型参数错误");
				return response;
			}
			// 查询清算表是否存在订单数据
			// 如果存在，则不做插入处理
			// 如果不存在，则插入清算表
			List<String> orderIds = (List) dataMap.get("arr");
			for (String orderId : orderIds) {
				OrderClearModel orderClearModels = orderClearDao.findByOrderId(orderId);
				if (orderClearModels == null) {
					OrderClearModel orderClearModel = new OrderClearModel();
					orderClearModel.setOrderId(orderId);
					orderClearModel.setStatusId(Contants.SUB_SIN_STATUS_0350);
					orderClearModel.setClearflag(Contants.CREATE_TYPE_0);
					orderClearModel.setOrdertypeId(orderTypeId);
					orderClearModelList.add(orderClearModel);
				}
			}
			dataMap.put("orderClearModelList", orderClearModelList);
			response.setResult(requestMoneyManager.updatePassById(dataMap));
			return response;
		} catch (IllegalArgumentException e) {
			log.error("request.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("request.error");
			return response;
		} catch (Exception e) {
			log.error("request.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("request.error");
			return response;
		}
	}

	/**
	 * 运营商拒绝请款
	 *
	 * @param dataMap
	 * @return
	 */
	@Override
	public Response<Integer> updateRefuseById(HashMap<String, Object> dataMap) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 校验list是否为空
			checkArgument(dataMap != null, "list is null");
			// 校验orderDoDetailModelList是否为空
			checkArgument(dataMap.get("orderDoDetailModelList") != null, "orderDoDetailModel is null");
			// 根据orderId更新请款状态
			response.setResult(requestMoneyManager.updateRefuseById(dataMap));
			return response;
		} catch (IllegalArgumentException e) {
			log.error("request.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("request.error");
			return response;
		} catch (Exception e) {
			log.error("request.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("request.error");
			return response;
		}
	}

	/**
	 * 供应商查询请款订单
	 * 
	 * @param pageNo
	 * @param size
	 * @param orderId
	 * @param goodssendFlag
	 * @param sinStatusId
	 * @param goodsNm
	 * @param tblFlag
	 * @param startTime
	 * @param endTime
	 * @param user
	 * @return
	 */
	@Override
	public Response<Pager<RequestOrderDto>> findOrderQuest(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("orderId") String orderId, @Param("goodssendFlag") String goodssendFlag,
			@Param("sinStatusId") String sinStatusId, @Param("goodsNm") String goodsNm,
			@Param("tblFlag") String tblFlag, @Param("startTime") String startTime,
			@Param("orderType") String orderType, @Param("endTime") String endTime, User user) {
		// 获取供应商Id
		String id = user.getVendorId();
		// 构造返回值及参数
		Response<Pager<RequestOrderDto>> response = new Response<Pager<RequestOrderDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		List<OrderSubModel> orderSubModelList = Lists.newArrayList();
		List<TblOrderHistoryModel> tblOrderHistoryModels = Lists.newArrayList();
		List<RequestOrderDto> requestOrderDtos = Lists.newArrayList();
		// 供应商Id
		paramMap.put("vendorId", id);
		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		// 不搜索0元秒杀订单
		paramMap.put("miaoshaActionFlag", Contants.DEL_INTEGER_FLAG_0);
		// 业务类型=FQ:广发商城（分期）JF:积分商城
		if (Contants.BUSINESS_TYPE_JF.equals(orderType)) {
			paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
		} else {
			paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_FQ);
		}
		// 判断订单号是否为空
		if (isNotBlank(orderId)) {
			paramMap.put("orderId", orderId);
		}
		// 判断发货标志是否为空
		if (isNotBlank(goodssendFlag)) {
			paramMap.put("goodssendFlag", goodssendFlag);
		}
		// 判断请款状态是否为空
		if (isNotBlank(sinStatusId)) {
			paramMap.put("sinStatusId", sinStatusId);
		}
		// 判断商品名称是否为空
		if (isNotBlank(goodsNm)) {
			paramMap.put("goodsNm", goodsNm);
		}
		if (isNotBlank(startTime)) {
			paramMap.put("startTime", startTime);
		}
		if (isNotBlank(endTime)) {
			paramMap.put("endTime", endTime);
		}
		try {
			// 如果查的是六个月之前的数据，则查历史表
			if ("1".equals(tblFlag)) {
				// 获取历史子订单列表数据
				Pager<TblOrderHistoryModel> pager1 = tblOrderHistoryDao.findLikeByPageForReq(paramMap,
						pageInfo.getOffset(), pageInfo.getLimit());
				List<TblOrderHistoryModel> tblOrderHistoryModelList = pager1.getData();
				// 遍历TblOrderHistoryModelList,构造返回值
				for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList) {
					OrderSubModel orderSubModelOld = new OrderSubModel();
					BeanMapper.copy(tblOrderHistoryModel, orderSubModelOld);
					RequestOrderDto requestOrderDto = new RequestOrderDto();
					requestOrderDto.setOrderSubModel(orderSubModelOld);
					// 银行订单号
					TblOrderExtend1Model tblOrderExtend1Model = tblOrderExtend1Dao
							.findByOrderId(orderSubModelOld.getOrderId());
					if (tblOrderExtend1Model != null) {
						requestOrderDto.setOrdernbr(tblOrderExtend1Model.getOrdernbr());
					}
					TblOrdermainHistoryModel tblOrdermainHistoryModel = new TblOrdermainHistoryModel();
					OrderMainModel orderMainModelOld = new OrderMainModel();
					if (isNotBlank(tblOrderHistoryModel.getOrdermainId())) {
						tblOrdermainHistoryModel = tblOrdermainHistoryDao
								.findById(tblOrderHistoryModel.getOrdermainId());
						if (tblOrdermainHistoryModel == null) {
							response.setError("tblOrdermainHistoryModel.can.not.be.null");
							return response;
						}
						BeanMapper.copy(tblOrdermainHistoryModel, orderMainModelOld);
						requestOrderDto.setOrderMainModel(orderMainModelOld);
					}
					requestOrderDtos.add(requestOrderDto);
				}
				response.setResult(new Pager<RequestOrderDto>(pager1.getTotal(), requestOrderDtos));
				return response;
			} else {
				// 获取子订单列表数据
				Pager<OrderSubModel> pager = orderSubDao.findLikeByPageForReq(paramMap, pageInfo.getOffset(),
						pageInfo.getLimit());
				orderSubModelList = pager.getData();
				// 遍历orderSubModel，构造返回值
				for (OrderSubModel orderSubModel : orderSubModelList) {
					RequestOrderDto requestOrderDto = new RequestOrderDto();
					requestOrderDto.setOrderSubModel(orderSubModel);
					// 银行订单号
					TblOrderExtend1Model tblOrderExtend1Model = tblOrderExtend1Dao
							.findByOrderId(orderSubModel.getOrderId());
					if (tblOrderExtend1Model != null) {
						requestOrderDto.setOrdernbr(tblOrderExtend1Model.getOrdernbr());
					}
					OrderMainModel orderMainModel = null;
					if (isNotBlank(orderSubModel.getOrdermainId())) {
						orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId());
						if (orderMainModel == null) {
							response.setError("tblOrdermainHistoryModel.can.not.be.null");
							return response;
						}
						requestOrderDto.setOrderMainModel(orderMainModel);
					}
					requestOrderDtos.add(requestOrderDto);
				}
				response.setResult(new Pager<RequestOrderDto>(pager.getTotal(), requestOrderDtos));
				return response;
			}
		} catch (Exception e) {
			log.error("RequestMoneyServiceImpl.findOrderQuest.qury.error", Throwables.getStackTraceAsString(e));
			response.setError("RequestMoneyServiceImpl.findOrderQuest.qury.error");
			return response;
		}
	}

	/**
	 * 运营商查找请款审核订单
	 * 
	 * @param pageNo
	 * @param size
	 * @param vendorSnm
	 * @param orderId
	 * @param cardno
	 * @param startTime
	 * @param endTime
	 * @param sinStatusId
	 * @param tblFlag
	 * @param orderType
	 * @param tabNumber
	 * @return
	 */
	@Override
	public Response<Pager<RequestOrderDto>> findOrderQuestAdmin(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("ordermainId") String ordermainId, @Param("orderId") String orderId,
			@Param("cardno") String cardno, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("sinStatusId") String sinStatusId, @Param("tblFlag") String tblFlag,
			@Param("orderType") String orderType, @Param("vendorSnm") String vendorSnm,
			@Param("tabNumber") String tabNumber) {
		Stopwatch stopwatch=Stopwatch.createStarted();
		// 构造返回值及参数
		Response<Pager<RequestOrderDto>> response = new Response<Pager<RequestOrderDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		List<OrderSubModel> orderSubModelList = Lists.newArrayList();
		List<RequestOrderDto> requestOrderDtos = Lists.newArrayList();
		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		// 业务类型=FQ:广发商城（分期）JF:积分商城
		if (Contants.BUSINESS_TYPE_JF.equals(orderType)) {
			paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
		} else {
			paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_FQ);
		}
		// 判断订单号是否为空
		if (isNotBlank(orderId)) {
			paramMap.put("orderId", orderId);
		}
		// 判断请款状态是否为空
		if (isNotBlank(sinStatusId)) {
			paramMap.put("sinStatusId", sinStatusId);
		}
		// 判断时间是否为空
		if (isNotBlank(startTime)) {
			paramMap.put("startTime", startTime);
		}
		if (isNotBlank(endTime)) {
			paramMap.put("endTime", endTime);
		}
		// 判断供应商名称是否为空
		if (isNotBlank(vendorSnm)) {
			paramMap.put("vendorSnm", vendorSnm);
		}
		// 判断主订单ID是否为空
		if (isNotBlank(ordermainId)) {
			paramMap.put("ordermainId", ordermainId);
		}
		// 判断卡号是否为空
		if (isNotBlank(cardno)) {
			paramMap.put("cardno", cardno);
		}
		// 判断tab页
		if ("2".equals(tabNumber)) {
			paramMap.put("sinStatusId", Contants.SUB_SIN_STATUS_0332);
		} else {
			paramMap.put("tabNumber", Contants.SUB_ORDER_STATUS_0310);
		}
		try {
			// 如果查的是六个月之前的数据,则查询历史表
			if ("1".equals(tblFlag)) {
				// 获取历史子订单列表数据
				Pager<TblOrderHistoryModel> pager1 = tblOrderHistoryDao.findByPage(paramMap, pageInfo.getOffset(),
						pageInfo.getLimit());
				List<TblOrderHistoryModel> tblOrderHistoryModelList = pager1.getData();
				// 遍历TblOrderHistoryModelList,构造返回值
				for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList) {
					OrderSubModel orderSubModelOld = new OrderSubModel();
					BeanMapper.copy(tblOrderHistoryModel, orderSubModelOld);
					orderSubModelOld.setCardno(insensitiveCardNo(orderSubModelOld.getCardno()));//银行卡号脱敏
					RequestOrderDto requestOrderDto = new RequestOrderDto();
					requestOrderDto.setOrderSubModel(orderSubModelOld);
					// 单品编码
					String goodsId = tblOrderHistoryModel.getGoodsId();
					ItemModel itemModel = itemService.findById(goodsId);
					if (itemModel != null) {
						requestOrderDto.setMid(itemModel.getMid());
						requestOrderDto.setXid(itemModel.getXid());
					}
					requestOrderDtos.add(requestOrderDto);
				}
				response.setResult(new Pager<>(pager1.getTotal(), requestOrderDtos));
				return response;
			} else {
				// 获取子订单列表数据
				Pager<OrderSubModel> pager = orderSubDao.findLikeByPage(paramMap, pageInfo.getOffset(),
						pageInfo.getLimit());
				orderSubModelList = pager.getData();
				// 遍历orderSubModel，构造返回值
				for (OrderSubModel orderSubModel : orderSubModelList) {
					orderSubModel.setCardno(insensitiveCardNo(orderSubModel.getCardno()));//银行卡号脱敏
					RequestOrderDto requestOrderDto = new RequestOrderDto();
					requestOrderDto.setOrderSubModel(orderSubModel);
					// 单品编码
					String goodsId = orderSubModel.getGoodsId();
					ItemModel itemModel = itemService.findById(goodsId);
					if (itemModel != null) {
						requestOrderDto.setMid(itemModel.getMid());
						requestOrderDto.setXid(itemModel.getXid());
					}
					requestOrderDtos.add(requestOrderDto);
				}
				response.setResult(new Pager<RequestOrderDto>(pager.getTotal(), requestOrderDtos));
				log.info("请款管理执行时间{}秒",stopwatch.stop().elapsed(TimeUnit.SECONDS));
				return response;
			}
		} catch (Exception e) {
			log.error("RequestMoneyServiceImpl.findOrderQuestAdmin.qury.error", Throwables.getStackTraceAsString(e));
			response.setError("RequestMoneyServiceImpl.findOrderQuest.qury.error");
			return response;
		}
	}

	/**
	 * 供应商请款导出报表
	 * 
	 * @param user
	 * @return
	 */
	@Override
	public Response<Boolean> exportRequest(OrderQueryConditionDto conditionDto, String systemType, User user, String roleFlag) {
		// 构造返回值及参数
		Response<Boolean> response = Response.newResponse();
		conditionDto.setRoleFlag(roleFlag);
		if (Contants.USEING_COMMON_STATUS_0.equals(roleFlag)) {
			// 获取供应商ID
			String vendorId = user.getVendorId();
			checkArgument(StringUtils.isNotBlank(vendorId), "vendorId.can.not.be.empty");
			conditionDto.setVendorId(vendorId);
		}
		conditionDto.setFindUserId(user.getId());
		conditionDto.setSystemType(systemType);
		// 业务类型=FQ:广发商城（分期）JF:积分商城
		conditionDto.setOrdertypeId(Contants.BUSINESS_TYPE_JF);
		String orderType = Contants.BUSINESS_TYPE_JF;
		try {
			String startTime = conditionDto.getStartTime();
			String endTime = conditionDto.getEndTime();
			if (StringUtils.isNotEmpty(startTime)){
				conditionDto.setStartTime(DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
			}
			if (StringUtils.isNotEmpty(endTime)){
				conditionDto.setEndTime(DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
			}
			try {
				redisService.createApplayPaymentExportUrl(conditionDto.getFindUserId(),systemType,orderType,"01");
				queueSender.send("shop.cgb.order.applypayment.notify", conditionDto);
				response.setResult(true);
			}catch (Exception e){
				response.setError("shop.applaypayment.error");
			}
			return response;
		} catch (Exception e) {
			log.error("OrderPartBackServiceImpl.exportRequest.error{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderPartBackServiceImpl.exportRequest.error");
			return response;
		}
	}

	/**
	 * @param userId
	 * @param systemType 内管 admin 供应商 vendor
     * @return
     */
	@Override
	public String getApplayPayExport(String userId,String systemType,String orderType){
		Response<String> urlResponse = redisService.getApplayPaymentExportUrl(userId,systemType,orderType);
		if(urlResponse.isSuccess()){
			String url = urlResponse.getResult();
			if (url == null){
				return "00";
			}else {
				return url;
			}
		}else {
			return "99";
		}
	}

}
