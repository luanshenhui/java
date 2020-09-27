package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.trade.dto.OrderDetailDto;
import cn.com.cgbchina.trade.dto.OrderInfoDto;
import cn.com.cgbchina.trade.dto.OrderReturnDetailDto;
import cn.com.cgbchina.trade.dto.OrderReturnTrackDto;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.service.OrderService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * Created by 11141021040453 on 2016/5/30.
 */
@Controller
@RequestMapping("/api/admin/OrderManage")
@Slf4j
public class OrderManage {
	@Resource
	OrderService orderService;
	@Resource
	MessageSources messageSources;
	@Value("#{app.expressUrl}")
	private String expressUrl;
	/**
	 * 查询物流信息
	 *
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/watchTrans", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public OrderDetailDto watchTrans(String orderId) {
		Response<OrderDetailDto> result = orderService.findOrderInfo(orderId);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to remind{},error code:{}", orderId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询撤单信息或退货详情
	 *
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/watchRevoke", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public OrderReturnDetailDto watchRevoke(String orderId) {
		Response<OrderReturnDetailDto> result = orderService.findOrderReturnDetail(orderId);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to remind{},error code:{}", orderId, result.getError());
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
