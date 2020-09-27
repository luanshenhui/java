package cn.com.cgbchina.vendor.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.item.dto.OrderTieinSaleItemDto;
import cn.com.cgbchina.item.service.OrderTieinSaleService;
import cn.com.cgbchina.promotion.service.VendorPromotionService;
import cn.com.cgbchina.trade.dto.OrderDetailDto;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.RequestMoneyService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11141021040453 on 2016/5/12.
 */
@Controller
@RequestMapping("/api/vendor")
@Slf4j
public class VendorOrder {
	@Autowired
	private MessageSources messageSources;
	@Resource
	OrderService orderService;
	@Resource
	RequestMoneyService requestMoneyService;
	@Resource
	OrderTieinSaleService orderTieinSaleService;
	@Resource
	VendorPromotionService vendorPromotionService;
	@Value("#{app.expressUrl}")
	private String expressUrl;

	/**
	 * 更新订单状态 包括，拒绝签收，无人签收
	 *
	 * @param orderId
	 * @param curStatusId
	 * @return
	 */
	@RequestMapping(value = "/updateOrder", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean cancelOrder(String orderId, String curStatusId) {
		User user = UserUtil.getUser();
		String vendorId = user.getId();
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("orderId", orderId);
		paramMap.put("curStatusId", curStatusId);
		paramMap.put("id", vendorId);
		Response<Map<String, Boolean>> result = orderService.updateOrderSignVendor(paramMap);
		if (result.isSuccess()) {
			if (result.getResult().get("result")) {
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
	public Boolean orderDeliverGoods(@RequestBody OrderTransModel orderTransModel) {

		Response<Map<String, Boolean>> result = orderService.deliverGoods(orderTransModel, UserUtil.getUser());
		if (result.isSuccess()) {
			if (result.getResult().get("result")) {
				return Boolean.TRUE;
			} else {
				return Boolean.FALSE;
			}
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

	@RequestMapping(value = "/revoke", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> revoke(String orderId, String season, String supplement, String typeFlag) {
		User user = UserUtil.getUser();
		String vendorId = user.getVendorId();
		Response<Map<String, Object>> result = new Response<>();
		Map<String, String> paramMap = new HashMap<>();
		paramMap.put("orderId", orderId);
		paramMap.put("season", season);
		paramMap.put("supplement", supplement);
		paramMap.put("typeFlag", typeFlag);
		paramMap.put("vendorId", vendorId);
		result = orderService.revokeOrder(paramMap);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to cancelOrder{},error code:{}", orderId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查看订单详情
	 *
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/findDetail", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public OrderDetailDto findDetail(String orderId) {
		Response<OrderDetailDto> response = new Response<>();
		response = orderService.findOrderInfo(orderId);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to cancelOrder{},error code:{}", orderId, response.getError());
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
	@RequestMapping(value = "/sign", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean sign(String orderId, String receiver, String receiveTime, String curStatusId) {
		User user = UserUtil.getUser();
		String vendorId = user.getVendorId();
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("orderId", orderId);
		paramMap.put("receiver", receiver);
		paramMap.put("id", vendorId);
		paramMap.put("curStatusId", curStatusId);
		paramMap.put("receiveTime", receiveTime);

		Response<Map<String, Boolean>> response = new Response<>();
		response = orderService.updateOrderSignVendor(paramMap);
		if (response.isSuccess()) {
			return response.getResult().get("result");
		}
		log.error("failed to sign{},error code:{}", orderId, response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));

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
		Response<Map<String, Boolean>> response = new Response<>();
		response = orderService.export(paramMap);
		if (response.isSuccess()) {
			return response.getResult().get("result");
		}
		log.error("failed to cancelOrder{},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
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
		Response<List<String>> listResponse = new Response<>();
		listResponse = vendorPromotionService.findItemCodesByVendorId(vendorId);
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
	@RequestMapping(value = "/tieinSale", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean tieinSale(@RequestParam(value = "itemCode", required = false) String itemCode,
			@RequestParam(value = "orderMainId", required = false) String orderMainId) throws Exception {
		User user = UserUtil.getUser();

		Response<Map<String, Boolean>> result = orderService.createTieinSaleOrder(itemCode, orderMainId, user);
		if (result.isSuccess()) {
			if (result.getResult().get("result")) {
				return Boolean.TRUE;
			} else {
				return Boolean.FALSE;
			}
		}
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
}
