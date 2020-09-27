package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PromotionModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.PromotionService;
import cn.com.cgbchina.trade.dto.OrderDetailDto;
import cn.com.cgbchina.trade.dto.OrderOutputAdminDto;
import cn.com.cgbchina.trade.dto.OrderQueryConditionDto;
import cn.com.cgbchina.trade.dto.OrderReturnDetailDto;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.service.OrderIOService;
import cn.com.cgbchina.trade.service.OrderService;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.LocalDateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.*;
import java.util.concurrent.*;

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
	ItemService itemService;
	@Resource
	GoodsService goodsService;
	@Resource
	PromotionService promotionService;
	@Resource
	MessageSources messageSources;
	@Autowired
	OrderIOService orderIOService;// 导入导出

	@Value("#{app.expressUrl}")
	private String expressUrl;

	private static final int dayBetween = 31;// 开始结束日期只差不能超过200天

	private String rootFilePath;
	public OrderManage() {
		this.rootFilePath = this.getClass().getResource("/upload").getPath();
	}


	/**
	 * 查询物流信息
	 *
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/logistics", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public OrderDetailDto logistics(String orderId) {
		User user = UserUtil.getUser();
		Response<OrderDetailDto> result = orderService.findOrderInfo(orderId, user);
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
	@RequestMapping(value = "/backGoods", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public OrderReturnDetailDto backGoods(String orderId) {
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

	/**
	 * 订单--批量导出
     */
	@RequestMapping(value = "/exportOrderUndelivered", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean exportOrderUndelivered(@RequestParam("orders") @NotNull String json) {
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		OrderQueryConditionDto conditionDto = jsonMapper.fromJson(json, OrderQueryConditionDto.class);
		String endTime = conditionDto.getEndTime();
		if(endTime != null && !endTime.isEmpty()){
			Date date2Temp = DateHelper.string2Date(endTime, DateHelper.YYYY_MM_DD);// 结束
			String dataEnd = LocalDateTime.fromDateFields(date2Temp).plusDays(1).toString(DateHelper.YYYY_MM_DD);
			conditionDto.setEndTime(dataEnd);
		}
		User user = UserUtil.getUser();
		conditionDto.setFindUserId(user.getId());
		String orderTypeId;
		if (Contants.BUSINESS_TYPE_JF.equals(conditionDto.getOrdertypeId())){
			orderTypeId = Contants.BUSINESS_TYPE_JF;
		}else{
			orderTypeId = Contants.BUSINESS_TYPE_YG;
		}
		Response<Boolean> result = orderIOService.creatOrderServiceExcel(conditionDto,orderTypeId);
		if (result.isSuccess()){
			return result.getResult();
		}else{
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
	}

	/**
	 * 检查redis中是否存在要下载的文件
	 */
	@RequestMapping(value = "/getUserOrderExport", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String getUserOrderExport(@RequestParam(value ="orderTypeId") @NotNull String orderTypeId){
		User user = UserUtil.getUser();
		String url = orderIOService.getUserExport(user.getId(),orderTypeId);
		return url;
	}

}
