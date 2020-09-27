package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.dto.OrderTieinSaleItemDto;
import cn.com.cgbchina.item.service.OrderTieinSaleService;
import cn.com.cgbchina.item.service.VendorPromotionService;
import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.trade.exception.TradeException;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.service.*;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.io.Files;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.elasticsearch.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.*;

import static cn.com.cgbchina.web.utils.SafeHtmlValidator.checkScriptAndEvent;

/**
 * Created by 11141021040453 on 2016/5/12.
 */
@Controller
@RequestMapping("/api/vendor")
@Slf4j
public class VendorOrder {

	private final static Set<String> allowed_types = ImmutableSet.of("xlsx", "xls");
	@Autowired
	private MessageSources messageSources;
	@Resource
	OrderService orderService;
	@Resource
	OrderReturnService orderReturnService;
	@Resource
	RequestMoneyService requestMoneyService;
	@Resource
	OrderTieinSaleService orderTieinSaleService;
	@Resource
	VendorPromotionService vendorPromotionService;
	@Autowired
	OrderIOService orderIOService;// 导入导出
	@Resource
	OrderDealService orderDealService;
	@Autowired
	private JedisTemplate jedisTemplate;


	@Value("#{app.expressUrl}")
	private String expressUrl;

	private String rootFilePath;

	public VendorOrder() {
		this.rootFilePath = this.getClass().getResource("/upload").getPath();
	}

	private JsonMapper jsonMapper = JsonMapper.JSON_NON_EMPTY_MAPPER;

	private static final int dayBetween = 200;// 开始结束日期只差不能超过200天
	public static final String YGoutportConsign = "YGoutportConsign";// 广发发货导出
	public static final String YGimportConsign = "YGimportConsign";// 广发发货导入
	public static final String YGoutportOrdersign = "YGoutportOrdersign";// 广发签收导出
	public static final String YGimportOrdersign = "YGimportOrdersign";// 广发签收导入
	public static final String JFoutportConsign = "JFoutportConsign";// 积分发货导出
	public static final String JFimportConsign = "JFimportConsign";// 积分发货导入
	public static final String JFoutportOrdersign = "JFoutportOrdersign";// 积分签收导出
	public static final String YGOrderRevokeExport = "YGOrderRevokeExport";// 广发（一期）撤单导出
	public static final String JFimportOrdersign = "JFimportOrdersign";// 积分签收导入

	/**
	 * 更新订单状态 包括，拒绝签收，无人签收
	 *
	 * @param orderId
	 * @param curStatusId
	 * @return
	 */
	@RequestMapping(value = "/updateOrder", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean denySignOrder(String orderId, String curStatusId) {
		User user = UserUtil.getUser();
		String vendorId = user.getId();
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("orderId", orderId);
		paramMap.put("curStatusId", curStatusId);
		paramMap.put("id", vendorId);
		Response<Map<String, Boolean>> result = orderService.updateOrderSignVendor(paramMap);
		if (result.isSuccess()) {
			if (result.getResult().get("result")&&!Contants.VENDOR_ORDER_UPDATE_TYPE_SIGNED.equals(curStatusId)) {
				Response<Boolean> response = orderService.sendMsg(orderId);
				if (response.isSuccess()) {
					log.info("短信发送成功！");
				} else {
					log.info("短信发送失败：" + response.getError());
				}
				return Boolean.TRUE;
			} else {
				return Boolean.FALSE;
			}
		}
		log.error("failed to cancelOrder{},error code:{}", orderId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 子订单发货
	 *
	 * @param orderTransModel
	 * @return
	 */
	@RequestMapping(value = "/orderDeliverGoods", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> orderDeliverGoods(@RequestBody OrderTransModel orderTransModel) {
		Response<Map<String, Object>> result = orderService.deliverGoods(orderTransModel, UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to cancelOrder{},error code:{}", orderTransModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 供应商退货
	 * 
	 * @param orderId
	 * @param season
	 * @param supplement
	 * @param typeFlag
	 * @return
	 */

	@RequestMapping(value = "/revoke", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> revoke(String orderId, String season, String supplement, String typeFlag) {
		User user = UserUtil.getUser();
		String vendorId = user.getVendorId();
		if(StringUtils.isEmpty(season)){
			log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag);
			throw new ResponseException(500, messageSources.get("season.be.empty"));
		}
		if(checkScriptAndEvent(season)){
			log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag);
			throw new ResponseException(500, messageSources.get("season.be.illegal"));
		}
		if (!StringUtils.isEmpty(supplement)){
			if(checkScriptAndEvent(supplement)){
				log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag);
				throw new ResponseException(500, messageSources.get("supplement.be.illegal"));
			}
			int length=supplement.length();
			if (length>150){
				log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag);
				throw new ResponseException(500, messageSources.get("supplement.length.longOver"));
			}
		}

		Map<String, String> paramMap = new HashMap<>();
		paramMap.put("orderId", orderId);
		paramMap.put("season", season);
		paramMap.put("supplement", supplement);
		paramMap.put("typeFlag", typeFlag);
		paramMap.put("vendorId", vendorId);
		Response<Map<String, Object>> result=Response.newResponse();
		Response<String> orderTypeIdResponse=orderService.findOrderTypeIdByOrderId(orderId);
		if (!orderTypeIdResponse.isSuccess()|| StringUtils.isEmpty(orderTypeIdResponse.getResult())){
			log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag);
			throw new ResponseException(500, messageSources.get("ordertypeId.be.wrong"));
		}
		String ordertypeId=orderTypeIdResponse.getResult();
		if (Contants.BUSINESS_TYPE_JF.equals(ordertypeId)){
			Response response=orderReturnService.agreeReturn(paramMap,user);
			if (response.isSuccess()){
				Map<String,Object>map=Maps.newHashMap();
				map.put("result", Boolean.TRUE);
				return map;
			}
			result.setError(response.getError());
		}else if (Contants.BUSINESS_TYPE_YG.equals(ordertypeId)||Contants.BUSINESS_TYPE_FQ.equals(ordertypeId)) {
			result = orderService.revokeOrder(paramMap);
			if (result.isSuccess()) {
				if ((Boolean) result.getResult().get("result")) {
					Response<Boolean> response = orderService.sendMsg(orderId);
					if (response.isSuccess()) {
						log.info("短信发送成功！");
					} else {
						log.info("短信发送失败：" + response.getError());
					}
				}
				return result.getResult();
			}
		}else {
			result.setError("ordertypeId.be.wrong");
		}
		log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查看订单详情
	 *
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/findDetail", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public OrderDetailDto findDetail(String orderId) {
		User user = UserUtil.getUser();
		Response<OrderDetailDto> response = orderService.findOrderInfo(orderId, user);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to findDetail{},error code:{}", orderId, response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 签收订单
	 *
	 * @param orderId
	 * @param receiver
	 * @param receiveTime
	 * @param curStatusId
	 * @return
	 */
	@RequestMapping(value = "/sign", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean sign(String orderId, String receiver, String receiveTime, String curStatusId) {
		User user = UserUtil.getUser();
		String vendorId = user.getId();
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("orderId", orderId);
		paramMap.put("receiver", receiver);
		paramMap.put("id", vendorId);
		paramMap.put("curStatusId", curStatusId);
		paramMap.put("receiveTime", receiveTime);
		Response<Map<String, Boolean>> result = orderService.updateOrderSignVendor(paramMap);
		if (result.isSuccess()) {
			if (result.getResult().get("result")&&!Contants.VENDOR_ORDER_UPDATE_TYPE_SIGNED.equals(curStatusId)) {
				Response<Boolean> response = orderService.sendMsg(orderId);
				if (response.isSuccess()) {
					log.info("短信发送成功！");
				} else {
					log.info("短信发送失败：" + response.getError());
				}
			}
			return result.getResult().get("result");
		}
		log.error("failed to sign{},error code:{}", orderId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 代发货订单批量置为发货处理中
	 *
	 * @return
	 */

	@RequestMapping(value = "/export", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean export() {
		User user = UserUtil.getUser();
		String vendorId = user.getVendorId();
		Map<String, String> paramMap = new HashMap<>();
		paramMap.put("vendorId", vendorId);
		Response<Map<String, Boolean>> response;
		response = orderService.export(paramMap);
		if (response.isSuccess()) {
			return response.getResult().get("result");
		}
		log.error("failed to cancelOrder{},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 代发货 批量导出
	 *
	 * @return
	 */
	@RequestMapping(value = "/exportOrderUndelivered", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public void exportOrderUndelivered(OrderQueryConditionDto conditionDto, HttpServletResponse httpServletResponse) {
		User user = UserUtil.getUser();
		String fileName = "";
		String filePath = "";
		if (!Contants.BUSINESS_TYPE_JF.equals(conditionDto.getOrdertypeId())) {
			fileName = "OrderInfoExport" + UUID.randomUUID().toString() + ".xlsx";
 			filePath = rootFilePath + "/template/orderInfoExport.xlsx";
		}else{
			fileName = "JFoutportConsign" + UUID.randomUUID().toString() + ".xls";
 			filePath = rootFilePath + "/template/JFoutportConsign.xls";
		}
		try {

			String startTime = conditionDto.getStartTime();
			String endTime = conditionDto.getEndTime();
			checkOrderDate(startTime, endTime);
			Response<List<OrderOutputDto>> response = orderIOService.exportOrderInfo(conditionDto.toMap(), user);
			if (response.isSuccess()) {
				Map<String, Object> paramMap = Maps.newHashMap();
				List<OrderOutputDto> list = response.getResult();
				if (null != list && 0 != list.size()) {
					OrderOutputDto dto = list.get(0);
					paramMap.put("vendorName", dto.getVendorSnm());
					paramMap.put("vendorId", dto.getVendorId());
				}
				paramMap.put("startTime", startTime);
				paramMap.put("endTime", endTime);
				paramMap.put("orders", list == null ? Collections.emptyList() : list);
				ExportUtils.exportTemplate(httpServletResponse, fileName, filePath, paramMap);
			} else {
				log.error("failed to execute exportOrderUndelivered {},error code:{}", conditionDto.toString(),
						response.getError());
				throw new ResponseException(500, messageSources.get(response.getError()));
			}
		} catch (Exception e) {
			log.error("fail to export exportOrderUndelivered data, bad code{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, e.getMessage());
		}
	}

	/**
	 * 签收 批量导出
	 *
	 * @return
	 */
	@RequestMapping(value = "/exportOrderSign", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public void exportOrderSign(OrderQueryConditionDto conditionDto, HttpServletResponse httpServletResponse) {
		User user = UserUtil.getUser();
		String fileName = "";
		String filePath = "";
		// 签收导出文件路径 广发商城和积分商城两个文件路径
		if (!Contants.BUSINESS_TYPE_JF.equals(conditionDto.getOrdertypeId())) {
			fileName = "OrdersignExport" + UUID.randomUUID().toString() + ".xlsx";
			filePath = rootFilePath + "/template/ordersignExport.xlsx";
		}else{
			fileName = "JFoutportOrdersign" + UUID.randomUUID().toString() + ".xls";
			filePath = rootFilePath + "/template/JFoutportOrdersign.xls";
		}
		try {
			String startTime = conditionDto.getStartTime();
			String endTime = conditionDto.getEndTime();
			checkOrderDate(startTime, endTime);
			Response<List<OrderOutputDto>> response = orderIOService.exportOrderSign(conditionDto.toMap(), user);
			if (response.isSuccess()) {
				Map<String, Object> paramMap = Maps.newHashMap();
				List<OrderOutputDto> list = response.getResult();
				if (null != list && 0 != list.size()) {
					OrderOutputDto dto = list.get(0);
					paramMap.put("vendorName", dto.getVendorSnm());
					paramMap.put("vendorId", dto.getVendorId());
				}
				paramMap.put("startTime", startTime);
				paramMap.put("endTime", endTime);
				paramMap.put("orders", list == null ? Collections.emptyList() : list);
				ExportUtils.exportTemplate(httpServletResponse, fileName, filePath, paramMap);
			} else {
				log.error("failed to execute exportOrderSign {},error code:{}", conditionDto.toString(),
						response.getError());
				throw new ResponseException(500, messageSources.get(response.getError()));
			}
		} catch (Exception e) {
			log.error("fail to export exportOrderSign data, bad code{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, e.getMessage());
		}
	}

	/**
	 * 检查 前台条件中的日期时间 是否符合要求 时间间隔不得超过200天
	 *
	 * @param startTime
	 * @param endTime
	 */
	private void checkOrderDate(String startTime, String endTime) {

		// 判读日期不允许为空
		if (StringUtils.isEmpty(startTime)) {
			throw new ResponseException("开始日期不能为空:");
		}
		if (StringUtils.isEmpty(endTime)) {
			throw new ResponseException("结束日期不能为空: ");
		}
		Date dateTemp = DateHelper.string2Date(startTime, DateHelper.YYYY_MM_DD);// 开始
		startTime = dateTemp == null ? "" : DateHelper.getyyyyMMdd(dateTemp);
		// // 日期之差不能超过200天
		// GregorianCalendar endDateTemp = setDate(endTime, "yyyyMMdd");
		Date date2Temp = DateHelper.string2Date(endTime, DateHelper.YYYY_MM_DD);// 结束
		GregorianCalendar endDateTemp = new GregorianCalendar(TimeZone.getDefault(), Locale.CHINA);
		endDateTemp.setTime(date2Temp == null ? new Date() : date2Temp);
		endDateTemp.add(Calendar.DAY_OF_MONTH, -dayBetween);

		String dataEnd = DateHelper.getyyyyMMdd(endDateTemp.getTime());// 200天以内的订单

		if (startTime.compareTo(dataEnd) < 0) {
			throw new ResponseException("日期间隔不能超过" + dayBetween + "天");
		}
	}

	/**
	 * 搭销查询数据
	 *
	 * @param itemCode
	 * @param itemName
	 * @param pageNo
	 * @param size
	 * @return
	 */
	@RequestMapping(value = "/tieinSearch", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<OrderTieinSaleItemDto> tieinSearch(@RequestParam(value = "itemCode", required = false) String itemCode,
			@RequestParam(value = "itemName", required = false) String itemName,
			@RequestParam(value = "pageNo", required = false) Integer pageNo,
			@RequestParam(value = "size", required = false) Integer size) {
		User user = UserUtil.getUser();
		String vendorId = user.getVendorId();
		Response<List<String>> listResponse = vendorPromotionService.findItemCodesByVendorId(vendorId);
		if (!listResponse.isSuccess()) {
			log.error("failed to tieinSearch{},error code:{}", listResponse.getError());
			throw new ResponseException(500, messageSources.get(listResponse.getError()));
		}
		Response<Pager<OrderTieinSaleItemDto>> response = new Response<>();
		response = orderTieinSaleService.findItemDetail(pageNo, size, itemCode, itemName, vendorId,
				listResponse.getResult());
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to tieinSearch{},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 搭销
	 *
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/tieinSale", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> tieinSale(String itemCode, String orderId, String curStatusId) throws Exception {
		User user = UserUtil.getUser();
		String vendorId = user.getVendorId();
		if (StringUtils.isEmpty(orderId)){
			log.error("failed to tieinSale,error orderId be null");
			throw new ResponseException(500, messageSources.get("orderId.can.not.be.empty"));
		}
		if (StringUtils.isEmpty(itemCode)){
			log.error("failed to tieinSale,error itemCode be null");
			throw new ResponseException(500, messageSources.get("itemCode.can.not.be.empty"));
		}
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "OCTO" + orderId, 50, 20000);
		if (lockId == null) {
			DistributedLocks.releaseLock(jedisTemplate, "OCTO" + orderId,lockId);
			log.error("failed to tieinSale,error repeat actions，orderId："+orderId+"itemCode"+itemCode);
			throw new ResponseException(500, messageSources.get("搭销订单正在处理中，请稍后操作！"));
		}
		Response<List<String>> listResponse = vendorPromotionService.findItemCodesByVendorId(vendorId);
		if (!listResponse.isSuccess()) {
			log.error("failed to tieinSearch{},error code:{}", listResponse.getError());
			throw new ResponseException(500, messageSources.get(listResponse.getError()));
		}
		List<String> promotionItemCodes = Lists.newArrayList();
		promotionItemCodes = listResponse.getResult();
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("itemCode", itemCode);
		paramMap.put("orderId", orderId);
		paramMap.put("curStatusId", curStatusId);
		paramMap.put("promotionItemCodes", promotionItemCodes);
		paramMap.put("user", user);
		Response<Map<String, Object>> result = orderService.createTieinSaleOrder(paramMap);
		if (result.isSuccess()){
			if ((Boolean) result.getResult().get("result")){
				OrderSubModel orderSubModel=(OrderSubModel)result.getResult().get("orderSubModel");
				OrderMainModel orderMainModel=(OrderMainModel)result.getResult().get("orderMainModel");
				// OPS Bp005接口
				PayOrderInfoDto payOrderInfoDto = new PayOrderInfoDto();
				List<PayOrderSubDto> payOrderSubDtoList = Lists.newArrayList();
				PayOrderSubDto payOrderSubDto = new PayOrderSubDto();
				// 支付金额
				payOrderSubDto.setMoney(orderSubModel.getTotalMoney().toString());
				// 订单号
				payOrderSubDto.setOrder_id(orderSubModel.getOrderId());
				// 返回成功码
				payOrderSubDto.setReturnCode("RC000");
				// 供应商ID
				payOrderSubDto.setVendor_id(user.getVendorId());
				payOrderSubDtoList.add(payOrderSubDto);
				// 小订单信息
				payOrderInfoDto.setPayOrderSubDtoList(payOrderSubDtoList);
				// 卡类型 信用卡
				payOrderInfoDto.setCardType(Contants.CARD_TYPE_C);
				// 签名
				// payOrderInfoDto.setCrypt();
				// 主订单ID
				payOrderInfoDto.setOrderid(orderSubModel.getOrdermainId());
				// 手机号
				// payOrderInfoDto.setPhone();
				// 卡号
				payOrderInfoDto.setPayAccountNo(orderMainModel.getCardno());
				// 卡号
				// payOrderInfoDto.setSendTime();
				payOrderInfoDto.setIsPayment(Boolean.FALSE);
				Response<DealPayResult> orderDealDtoResponse = orderDealService.makeOrderTradeInfo(payOrderInfoDto);
				if (!orderDealDtoResponse.isSuccess()) {
					DistributedLocks.releaseLock(jedisTemplate, "OCTO" + orderId,lockId);
					log.error("failed to tieinSale,orderDealService makeFQOrderInfo error");
					throw new ResponseException(500, messageSources.get("orderDealDto.be.null"));
				}
				orderDealDtoResponse = orderDealService.dealPay(payOrderInfoDto,
						orderDealDtoResponse.getResult().getOrderMainModel(),
						orderDealDtoResponse.getResult().getPayOrderIfDtos());
				if (!orderDealDtoResponse.isSuccess()) {
					DistributedLocks.releaseLock(jedisTemplate, "OCTO" + orderId,lockId);
					log.error("failed to tieinSale,orderDealService dealPay error");
					throw new ResponseException(500, messageSources.get("orderDealDto.be.null"));
				}
				OrderDealDto orderDealDto = orderDealDtoResponse.getResult().getOrderDealDto();
				if (orderDealDto == null) {
					DistributedLocks.releaseLock(jedisTemplate, "OCTO" + orderId,lockId);
					log.error("failed to tieinSale,orderDealService dealPay error orderDealDto be null");
					throw new ResponseException(500, messageSources.get("orderDealDto.be.null"));
				}
				// 处理返回值
				Map<String,Object> responseMap=Maps.newHashMap();
				orderDealDto.setRetcode("0");
				String sucessFlag = orderDealDto.getSucessFlag();
				if (org.apache.commons.lang3.StringUtils.isBlank(sucessFlag)) {
					sucessFlag = "0";
				}
				if ("0".equals(orderDealDto.getRetcode()) && "0000".equals(orderDealDto.getErrorCode())) {
					log.info("订单处理正常");
					if ("0".equals(sucessFlag.trim())) { // 订单成功
						log.info("全部订单成功");
						responseMap.put("result", Boolean.TRUE);
						String newOrderId = orderSubModel.getOrderId();
						Response<Boolean> response = orderService.sendMsg(newOrderId);
						if (response.isSuccess()) {
							log.info("短信发送成功！");
						} else {
							log.info("短信发送失败：" + response.getError());
						}
					} else if ("1".equals(sucessFlag.trim())) { // 子订单失败
						log.info("子订单失败");
						responseMap.put("result", Boolean.FALSE);
						responseMap.put("error", "failed");
					} else if ("3".equals(sucessFlag.trim())) { // 子订单处理中
						log.info("子订单处理中");
						responseMap.put("result", Boolean.FALSE);
						responseMap.put("error", "doing");
					} else { // 状态未明
						log.info("状态未明");
						responseMap.put("result", Boolean.FALSE);
						responseMap.put("error", "unclear");
					}
				} else if ("3333".equals(orderDealDto.getErrorCode())) {
					log.info("支付网关重复返回结果");
					responseMap.put("result", Boolean.FALSE);
					responseMap.put("error", "repeat");
				} else {
					log.info("订单处理异常");
					responseMap.put("result", Boolean.FALSE);
					responseMap.put("error", "exception");
				}
				DistributedLocks.releaseLock(jedisTemplate, "OCTO" + orderId,lockId);
				return responseMap;
			}else {
				DistributedLocks.releaseLock(jedisTemplate, "OCTO" + orderId,lockId);
				return result.getResult();
			}
		}
		DistributedLocks.releaseLock(jedisTemplate, "OCTO" + orderId,lockId);
		log.error("failed to tieinSale{},error code:{}", itemCode, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/***
	 * 获取查看物流信息的url
	 *
	 * @return
	 */
	@RequestMapping(value = "/queryLogisticsUrl")
	@ResponseBody
	public String queryLogisticsUrl() {
		return expressUrl;
	}

	/***
	 * 批量发货 订单信息导入
	 *
	 * @return
	 */
	@RequestMapping(value = "/importOrderInfo", method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
	@ResponseBody
	public String importOrderInfo(MultipartFile files, HttpServletRequest request,
			HttpServletResponse httpServletResponse) {
		Map<String, Object> mapResult = Maps.newHashMap();

		String startTime = DateHelper.date2string(new Date(), "yyyy-MM-dd HH:mm:ss");

		if (null == files) {
			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "fileNotExist");
			return jsonMapper.toJson(mapResult);
		}

		// 获取上传文件名
		String fileName = files.getOriginalFilename();
		String ext = Files.getFileExtension(fileName).toLowerCase();
		if(!allowed_types.contains(ext)) {
			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "fileIllegalExt");
			return jsonMapper.toJson(mapResult);
		}
		String userAgent = request.getHeader("User-Agent");

		String relativeFilePath = rootFilePath + "/tempfile/" + fileName;
		String configPath = rootFilePath + "/config/order_info.xml";
		String resultFile = rootFilePath + "/template/uploadOrderInfo_result.xlsx";

		File file = new File(relativeFilePath);

		if (file.exists()) {
			boolean flag = file.delete();
			if (!flag) {
				mapResult.put("isSuccess", Boolean.FALSE);
				mapResult.put("errorCode", "deleteExistFile");
				return jsonMapper.toJson(mapResult);
			}
		}
		try (InputStream configInput = new FileInputStream(configPath); // 导入 配置模板
				FileInputStream OutfileInput = new FileInputStream(resultFile); // 输出模板
				FileOutputStream fileOutputStream = new FileOutputStream(relativeFilePath); // 导出路径
				InputStream uploadFile = files.getInputStream()) {

			User user = UserUtil.getUser();
			Map<String, Object> dataBeans = com.google.common.collect.Maps.newHashMap();
			List<OrderInputDto> details = Lists.newArrayList();
			dataBeans.put("items", details);
			ExcelUtil.importExcelToData(dataBeans, uploadFile, configInput);

			Response<Object> result = orderIOService.importOrderInfo(details, user);
			if (result.isSuccess()) {
				exportTempFileExcel(OutfileInput, fileOutputStream, result, startTime);

				String new_filename = URLEncoder.encode(files.getOriginalFilename(), "UTF-8");

				// 如果没有UA，则默认使用IE的方式进行编码
				String rtn = new_filename;
				if (userAgent != null) {
					userAgent = userAgent.toLowerCase();
					// IE浏览器，只能采用URLEncoder编码
					if (userAgent.contains("msie")) {
						rtn = new_filename;
					}
					// Safari浏览器，只能采用ISO编码的中文输出
					else if (userAgent.contains("safari")) {
						rtn = new String(fileName.getBytes("UTF-8"), "ISO8859-1");
					}
					// Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
					else if (userAgent.contains("applewebkit")) {
						rtn = new_filename;
					}
					// ie11
					else if (userAgent.contains("mozilla") && !userAgent.contains("firefox")) {
						rtn = new_filename;
						// 火狐
					} else if (userAgent.contains("firefox") && userAgent.contains("mozilla")) {
						rtn = new String(fileName.getBytes("UTF-8"), "ISO8859-1");
					}
				}

				mapResult.put("isImportSuccess", ((Map<String, Object>)result.getResult()).get("isImportSuccess"));
				mapResult.put("isSuccess", Boolean.TRUE);
				mapResult.put("fileName", rtn);
			} else {
				mapResult.put("isSuccess", Boolean.FALSE);
				mapResult.put("errorCode", "updateData");
				return jsonMapper.toJson(mapResult);
			}
		} catch (RuntimeException e) {
			log.error("import.orderInfo.xls.error, error:{}", Throwables.getStackTraceAsString(e));

			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "unKnownError");
			mapResult.put("errorMsg", Throwables.getStackTraceAsString(e));
			return jsonMapper.toJson(mapResult);
		} catch (Exception e) {
			log.error("import.orderInfo.xls.error, error:{}", Throwables.getStackTraceAsString(e));

			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "unKnownError");
			mapResult.put("errorMsg", Throwables.getStackTraceAsString(e));
			return jsonMapper.toJson(mapResult);
		}
		return jsonMapper.toJson(mapResult);
	}

	/***
	 * 批量签收
	 *
	 * @return
	 */
	@RequestMapping(value = "/importOrdersign", method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
	@ResponseBody
	public String importOrdersign(MultipartFile files, HttpServletRequest request,
			HttpServletResponse httpServletResponse) {
		Map<String, Object> mapResult = Maps.newHashMap();
		String startTime = DateHelper.date2string(new Date(), "yyyy-MM-dd HH:mm:ss");

		if (null == files){
			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "fileNotExist");
			return jsonMapper.toJson(mapResult);
		}
		// 获取上传文件名
		String fileName = files.getOriginalFilename();
		String ext = Files.getFileExtension(fileName).toLowerCase();
		if(!allowed_types.contains(ext)) {
			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "fileIllegalExt");
			return jsonMapper.toJson(mapResult);
		}
		String userAgent = request.getHeader("User-Agent");

		String relativeFilePath = rootFilePath + "/tempfile/" + fileName;
		String configPath = rootFilePath + "/config/order_sign.xml";
		String resultFile = rootFilePath + "/template/uploadOrdersign_result.xlsx";

		File file = new File(relativeFilePath);

		if (file.exists()) {
			boolean flag = file.delete();
			if (!flag) {
				mapResult.put("isSuccess", Boolean.FALSE);
				mapResult.put("errorCode", "deleteExistFile");
				return jsonMapper.toJson(mapResult);
			}
		}
		try (InputStream configInput = new FileInputStream(configPath); // 导入 配置模板
				FileInputStream OutfileInput = new FileInputStream(resultFile); // 输出模板
				FileOutputStream fileOutputStream = new FileOutputStream(relativeFilePath); // 导出路径
				InputStream uploadFile = files.getInputStream()) {

			User user = UserUtil.getUser();
			Map<String, Object> dataBeans = com.google.common.collect.Maps.newHashMap();
			List<OrderInputDto> details = Lists.newArrayList();
			dataBeans.put("items", details);
			ExcelUtil.importExcelToData(dataBeans, uploadFile, configInput);

			Response<Object> result = orderIOService.importOrdersign(details, user);
			if (result.isSuccess()) {
				exportTempFileExcel(OutfileInput, fileOutputStream, result, startTime);

				String new_filename = URLEncoder.encode(files.getOriginalFilename(), "UTF-8");

				// 如果没有UA，则默认使用IE的方式进行编码
				String rtn = new_filename;
				if (userAgent != null) {
					userAgent = userAgent.toLowerCase();
					// IE浏览器，只能采用URLEncoder编码
					if (userAgent.contains("msie")) {
						rtn = new_filename;
					}
					// Safari浏览器，只能采用ISO编码的中文输出
					else if (userAgent.contains("safari")) {
						rtn = new String(fileName.getBytes("UTF-8"), "ISO8859-1");
					}
					// Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
					else if (userAgent.contains("applewebkit")) {
						rtn = new_filename;
					}
					// ie11
					else if (userAgent.contains("mozilla") && !userAgent.contains("firefox")) {
						rtn = new_filename;
						// 火狐
					} else if (userAgent.contains("firefox") && userAgent.contains("mozilla")) {
						rtn = new String(fileName.getBytes("UTF-8"), "ISO8859-1");
					}
				}

				mapResult.put("isImportSuccess", ((Map<String, Object>)result.getResult()).get("isImportSuccess"));
				mapResult.put("isSuccess", Boolean.TRUE);
				mapResult.put("fileName", rtn);
			} else {
				mapResult.put("isSuccess", Boolean.FALSE);
				mapResult.put("errorCode", "updateData");
				return jsonMapper.toJson(mapResult);
			}
		} catch (RuntimeException e) {
			log.error("import.vendorOrder.order.xls.error, error:{}", Throwables.getStackTraceAsString(e));

			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "unKnownError");
			mapResult.put("errorMsg", Throwables.getStackTraceAsString(e));
			return jsonMapper.toJson(mapResult);
		} catch (Exception e) {
			log.error("import.vendorOrder.order.xls.error, error:{}", Throwables.getStackTraceAsString(e));

			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "unKnownError");
			mapResult.put("errorMsg", Throwables.getStackTraceAsString(e));
			return jsonMapper.toJson(mapResult);
		}
		return jsonMapper.toJson(mapResult);
	}

	/**
	 * 导出模板
	 *
	 * @param response
	 * @author zhoupeng
	 */
	@RequestMapping(value = "/import-exportTemplate", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public void exportTemplateExcel(HttpServletResponse response, final String orderType) {

		try {
			String fileName = "";
			String filePath = "";
			switch (orderType) {
				case YGimportConsign:
				case JFimportConsign:
					fileName = "订单批量发货导入模板.xlsx"; // 输出给前台显示的文件名
					fileName = URLEncoder.encode(fileName, "UTF-8");
					filePath = rootFilePath + "/template/uploadOrderInfo.xlsx";
					break;
				case YGimportOrdersign:
				case JFimportOrdersign:
					fileName = "订单批量签收导入模板.xlsx"; // 输出给前台显示的文件名
					fileName = URLEncoder.encode(fileName, "UTF-8");
					filePath = rootFilePath + "/template/uploadOrdersign.xlsx";
					break;
				default:
					break;
			}

			Map<String, Object> map = com.google.common.collect.Maps.newHashMap();
			map.put("orders", Collections.emptyList());
			ExportUtils.exportTemplate(response, fileName, filePath, map);
		} catch (Exception e) {
			log.error("fail to download excel", e);
			response.reset();
			throw new ResponseException(500, messageSources.get("export.excel.error"));
		}
	}

	/**
	 *
	 * 生成临时文件
	 *
	 * @param fileInputStream
	 * @param fileOutputStream
	 * @param response
	 * @throws IOException
	 * @throws InvalidFormatException
	 *
	 * @author zhoupeng
	 */
	private void exportTempFileExcel(FileInputStream fileInputStream, FileOutputStream fileOutputStream,
			Response<Object> response, String startTime) throws IOException, InvalidFormatException {
		if(!response.isSuccess()){
			log.error("Response.error,error code: {}", response.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		Map<String, Object> map = (Map<String, Object>) response.getResult();
		paramMap.put("vendorName", map.get("vendorNm"));
		paramMap.put("vendorId", map.get("vendorId"));
		paramMap.put("orders", map.get("orderInputDtos"));
		paramMap.put("startTime", startTime);
		Workbook workbook = WorkbookFactory.create(fileInputStream);
		ExportUtils.exportTemplate(workbook, paramMap);
		workbook.write(fileOutputStream);
		fileOutputStream.flush();
	}

	/**
	 * 导出文件
	 *
	 * @param response
	 * @author zhoupeng
	 */
	@RequestMapping(value = "/import-exportFile", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public void exportExcel(HttpServletRequest request, HttpServletResponse response, String fileName) {
		InputStream inputStream = null;
		OutputStream outputStream = null;
		try {
			String userAgent = request.getHeader("User-Agent");
			String rtn = "";

			String new_filename = URLEncoder.encode(fileName, "UTF-8");
			// 如果没有UA，则默认使用IE的方式进行编码
			rtn = "filename=\"" + new_filename + "\"";
			if(userAgent != null) {
				userAgent = userAgent.toLowerCase();
				// IE浏览器，只能采用URLEncoder编码
				if(userAgent.contains("msie")) {
					rtn = "filename=\"" + new_filename + "\"";
				}
				// Opera浏览器只能采用filename*
				else if(userAgent.contains("opera")) {
					rtn = "filename*=UTF-8''" + new_filename;
				}
				// Safari浏览器，只能采用ISO编码的中文输出
				else if(userAgent.contains("safari")) {
					rtn = "filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + "\"";
				}
				// Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
				else if(userAgent.contains("applewebkit")) {
					rtn = "filename=\"" + new_filename + "\"";
				}
				// ie11
				else if(userAgent.contains("mozilla") && !userAgent.contains("firefox")) {
					rtn = "filename=\"" + new_filename + "\"";
					//火狐
				} else if(userAgent.contains("firefox") && userAgent.contains("mozilla")) {
					rtn = "filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + "\"";
				}
			}
			response.reset();
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition",
					"attachment;" + rtn + ";target=_blank");

			String relativeFilePath = rootFilePath + "/tempfile/" + fileName;
			inputStream = new FileInputStream(relativeFilePath);
			outputStream = response.getOutputStream();
			byte b[] = new byte[1024 * 1024 * 1];// 1M
			int read = 0;
			while ((read = inputStream.read(b)) != -1) {
				outputStream.write(b, 0, read);// 每次写1M
			}
			outputStream.flush();
			outputStream.close();
		} catch (UnsupportedEncodingException e) {
			log.error("export excel template, error:{}", e);
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			log.error("export excel template, error:{}", e);
			e.printStackTrace();
		} catch (IOException e) {
			log.error("export excel template, error:{}", e);
			e.printStackTrace();
		} finally {
			try {
				if (inputStream != null) {
					inputStream.close();
				}
				if (outputStream != null) {
					outputStream.close();
				}
			} catch (IOException e) {
				log.error("fail to close inputstream , error:{}", Throwables.getStackTraceAsString(e));
			}
		}
	}

	/**
	 * o2o 订单已过期
	 *
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/expiredCode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> expiredCode(String orderId) {
		User user = UserUtil.getUser();
		String vendorId = user.getVendorId();
		Response<Map<String, Object>> result = orderService.expiredCode(orderId, vendorId);
		if (result.isSuccess()) {
			if ((Boolean) result.getResult().get("result")) {
				Response<String> orderTypeIdResponse = orderService.findOrderTypeIdByOrderId(orderId);
				if (!orderTypeIdResponse.isSuccess() || StringUtils.isEmpty(orderTypeIdResponse.getResult())) {
					log.error("failed to expiredCode{},error code:{}", orderId, result.getError());
					throw new ResponseException(500, messageSources.get("ordertypeId.be.wrong"));
				}
				String ordertypeId = orderTypeIdResponse.getResult();
				//非积分商城发送短信
				if (!Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
					Response<Boolean> response = orderService.sendMsg(orderId);
					if (response.isSuccess()) {
						log.info("短信发送成功！");
					} else {
						log.info("短信发送失败：" + response.getError());
					}
				}
			}
			return result.getResult();
		}
		log.error("failed to expiredCode{},error code:{}", orderId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
