package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.RequestOrderDto;
import cn.com.cgbchina.trade.manager.OrderDodetailManger;
import cn.com.cgbchina.trade.manager.RequestMoneyManager;
import cn.com.cgbchina.trade.model.*;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	// 判断非空
	private Boolean isNotBlank(String str) {
		if (StringUtils.isNotBlank(str) && StringUtils.isNotBlank(str.trim().replace(" ", "")))
			return Boolean.TRUE;
		return Boolean.FALSE;
	}
	@Override
	public Response<Integer> updateById(Map<String,Object> dataMap) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 校验list是否为空
			checkArgument(dataMap.get("list") != null, "list is null");
			// 校验orderDoDetailModel是否为空
			checkArgument(dataMap.get("orderDoDetailModelList") != null, "orderDoDetailModel is null");
			// 根据orderId更新请款状态
			response.setResult(requestMoneyManager.updateById((List)dataMap.get("list")));
			//插入历史表
			Boolean flag = orderDodetailManger.insertForReq((List) dataMap.get("orderDoDetailModelList"));
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
		Response<Integer> response = new Response<Integer>();
		List<OrderClearModel> orderClearModelList = Lists.newArrayList();
		try {
			// 校验list是否为空
			checkArgument(dataMap != null, "list is null");
			//校验orderDoDetailModelList是否为空
			checkArgument(dataMap.get("orderDoDetailModelList") != null, "orderDoDetailModel is null");
			// 根据orderId更新请款状态
			response.setResult(requestMoneyManager.updatePassById(dataMap));
			//插入历史表
			orderDodetailManger.insertForReq((List) dataMap.get("orderDoDetailModelList"));
			//查询清算表是否存在订单数据
			//如果存在，则不做插入处理
			//如果不存在，则插入清算表
			List<String> orderIds = (List)dataMap.get("arr");
			for (String orderId : orderIds){
				if (orderClearDao.findByOrderId(orderId) == null){
					OrderClearModel orderClearModel = new OrderClearModel();
					orderClearModel.setOrderId(orderId);
					orderClearModel.setStatusId(Contants.SUB_SIN_STATUS_0350);
					orderClearModel.setClearflag(Contants.CREATE_TYPE_0);
					orderClearModel.setOrdertypeId(Contants.BUSINESS_TYPE_FQ);
					orderClearModelList.add(orderClearModel);
				}
			}
			orderClearDao.insertBatch(orderClearModelList);
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
			//校验orderDoDetailModelList是否为空
			checkArgument(dataMap.get("orderDoDetailModelList") != null, "orderDoDetailModel is null");
			// 根据orderId更新请款状态
			response.setResult(requestMoneyManager.updateRefuseById(dataMap));
			//插入历史表
			orderDodetailManger.insertForReq((List) dataMap.get("orderDoDetailModelList"));
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
			@Param("sinStatusId") String sinStatusId, @Param("goodsNm") String goodsNm,@Param("tblFlag") String tblFlag,
			@Param("startTime") String startTime,@Param("orderType") String orderType, @Param("endTime") String endTime,User user) {
		// 获取供应商Id
		String id = user.getVendorId();
		// 构造返回值及参数
		Response<Pager<RequestOrderDto>> response = new Response<Pager<RequestOrderDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		List<OrderSubModel> orderSubModelList = Lists.newArrayList();
		List<TblOrderHistoryModel> tblOrderHistoryModels = Lists.newArrayList();
		List<RequestOrderDto> requestOrderDtos = Lists.newArrayList();
		//供应商Id
		paramMap.put("vendorId",id);
		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		// 业务类型=FQ:广发商城（分期）JF:积分商城
		if (Contants.BUSINESS_TYPE_JF.equals(orderType)){
			paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
		}else {
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
			//如果查的是六个月之前的数据，则查历史表
			if ("1".equals(tblFlag)){
				//获取历史子订单列表数据
				Pager<TblOrderHistoryModel> pager1 = tblOrderHistoryDao.findLikeByPageForReq(paramMap,pageInfo.getOffset(),pageInfo.getLimit());
				List<TblOrderHistoryModel> tblOrderHistoryModelList = pager1.getData();
				//遍历TblOrderHistoryModelList,构造返回值
				for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList){
					OrderSubModel orderSubModelOld = new OrderSubModel();
					BeanMapper.copy(tblOrderHistoryModel,orderSubModelOld);
					RequestOrderDto requestOrderDto = new RequestOrderDto();
					requestOrderDto.setOrderSubModel(orderSubModelOld);
					TblOrdermainHistoryModel tblOrdermainHistoryModel = new TblOrdermainHistoryModel();
					OrderMainModel orderMainModelOld = new OrderMainModel();
					if (isNotBlank(tblOrderHistoryModel.getOrdermainId())){
						tblOrdermainHistoryModel = tblOrdermainHistoryDao.findById(tblOrderHistoryModel.getOrdermainId());
						if (tblOrdermainHistoryModel == null){
							response.setError("tblOrdermainHistoryModel.can.not.be.null");
							return response;
						}
						BeanMapper.copy(tblOrdermainHistoryModel,orderMainModelOld);
						requestOrderDto.setOrderMainModel(orderMainModelOld);
					}
					requestOrderDtos.add(requestOrderDto);
				}
				response.setResult(new Pager<RequestOrderDto>(pager1.getTotal(), requestOrderDtos));
				return response;
			}else {
				// 获取子订单列表数据
				Pager<OrderSubModel> pager = orderSubDao.findLikeByPageForReq(paramMap, pageInfo.getOffset(),
						pageInfo.getLimit());
				orderSubModelList = pager.getData();
				// 遍历orderSubModel，构造返回值
				for (OrderSubModel orderSubModel : orderSubModelList) {
					RequestOrderDto requestOrderDto = new RequestOrderDto();
					requestOrderDto.setOrderSubModel(orderSubModel);
					OrderMainModel orderMainModel = new OrderMainModel();
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
	public Response<Pager<RequestOrderDto>> findOrderQuestAdmin(@Param("pageNo") Integer pageNo,@Param("size") Integer size,
																@Param("ordermainId") String ordermainId,@Param("orderId") String orderId,
																@Param("cardno") String cardno,@Param("startTime") String startTime,
																@Param("endTime") String endTime,@Param("sinStatusId") String sinStatusId,
																@Param("tblFlag") String tblFlag,@Param("orderType") String orderType,
																@Param("vendorSnm") String vendorSnm,@Param("tabNumber") String tabNumber){
		//构造返回值及参数
		Response<Pager<RequestOrderDto>> response = new Response<Pager<RequestOrderDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		List<OrderSubModel> orderSubModelList = Lists.newArrayList();
		List<TblOrderHistoryModel> tblOrderHistoryModels = Lists.newArrayList();
		List<RequestOrderDto> requestOrderDtos = Lists.newArrayList();
		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		// 业务类型=FQ:广发商城（分期）JF:积分商城
		if (Contants.BUSINESS_TYPE_JF.equals(orderType)){
			paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
		}else {
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
		//判断供应商名称是否为空
		if (isNotBlank(vendorSnm)) {
			paramMap.put("vendorSnm", vendorSnm);
		}
		//判断主订单ID是否为空
		if (isNotBlank(ordermainId)) {
			paramMap.put("ordermainId", ordermainId);
		}
		//判断卡号是否为空
		if (isNotBlank(cardno)) {
			paramMap.put("cardno", cardno);
		}
		//判断tab页
		if ("2".equals(tabNumber)){
			paramMap.put("sinStatusId", Contants.SUB_SIN_STATUS_0332);
		}
		try {
			//如果查的是六个月之前的数据,则查询历史表
			if ("1".equals(tblFlag)){
				//获取历史子订单列表数据
				Pager<TblOrderHistoryModel> pager1 = tblOrderHistoryDao.findByPage(paramMap,pageInfo.getOffset(),pageInfo.getLimit());
				List<TblOrderHistoryModel> tblOrderHistoryModelList = pager1.getData();
				//遍历TblOrderHistoryModelList,构造返回值
				for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList){
					OrderSubModel orderSubModelOld = new OrderSubModel();
					BeanMapper.copy(tblOrderHistoryModel,orderSubModelOld);
					RequestOrderDto requestOrderDto = new RequestOrderDto();
					requestOrderDto.setOrderSubModel(orderSubModelOld);
					TblOrdermainHistoryModel tblOrdermainHistoryModel = new TblOrdermainHistoryModel();
					OrderMainModel orderMainModelOld = new OrderMainModel();
					if (isNotBlank(tblOrderHistoryModel.getOrdermainId())){
						tblOrdermainHistoryModel = tblOrdermainHistoryDao.findById(tblOrderHistoryModel.getOrdermainId());
						if (tblOrdermainHistoryModel == null){
							response.setError("tblOrdermainHistoryModel.can.not.be.null");
							return response;
						}
						BeanMapper.copy(tblOrdermainHistoryModel,orderMainModelOld);
						requestOrderDto.setOrderMainModel(orderMainModelOld);
					}
					requestOrderDtos.add(requestOrderDto);
				}
				response.setResult(new Pager<RequestOrderDto>(pager1.getTotal(), requestOrderDtos));
				return response;
			}else {
				// 获取子订单列表数据
				Pager<OrderSubModel> pager = orderSubDao.findLikeByPage(paramMap, pageInfo.getOffset(),
						pageInfo.getLimit());
				orderSubModelList = pager.getData();
				// 遍历orderSubModel，构造返回值
				for (OrderSubModel orderSubModel : orderSubModelList) {
					RequestOrderDto requestOrderDto = new RequestOrderDto();
					requestOrderDto.setOrderSubModel(orderSubModel);
					OrderMainModel orderMainModel = new OrderMainModel();
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
		}catch (Exception e){
			log.error("RequestMoneyServiceImpl.findOrderQuestAdmin.qury.error", Throwables.getStackTraceAsString(e));
			response.setError("RequestMoneyServiceImpl.findOrderQuest.qury.error");
			return response;
		}
	}
}
