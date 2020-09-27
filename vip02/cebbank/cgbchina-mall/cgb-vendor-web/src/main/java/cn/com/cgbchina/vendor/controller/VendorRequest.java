package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dto.RequestOrderDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spirit.web.MessageSources;

import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.RequestMoneyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Map;

/**
 * Created by 11150721040343 on 16-4-29.
 */
@Controller
@RequestMapping("/api/vendor/requestMoney")
@Slf4j
public class VendorRequest {
	@Autowired
	private RequestMoneyService requestMoneyService;
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private OrderService orderService;

	/**
	 * 供应商请款申请
	 * 
	 * @param list
	 * @return
	 */
	@RequestMapping(method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer startRequest(@RequestBody @Valid @NotNull List<String> list,BindingResult bindingResult) {
		if (bindingResult.hasErrors()) {
			StringBuilder error = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				error.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, error.toString());
		}

		Map<String, Object> dataMap = Maps.newHashMap();
		List<OrderDoDetailModel> orderDoDetailModelList = Lists.newArrayList();
		String userId = UserUtil.getUserId();
		User user = UserUtil.getUser();
		String userName = user.getName();
		for (String orderId : list) {
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderId);
			orderDoDetailModel.setCreateOper(userName);
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
			orderDoDetailModel.setDoUserid(userId);
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_2);
			String curStatusId = orderService.findOrderId(orderId).getCurStatusId();
			String curStatusNm = orderService.findOrderId(orderId).getCurStatusNm();
			orderDoDetailModel.setStatusId(curStatusId);
			orderDoDetailModel.setStatusNm(curStatusNm);
			orderDoDetailModelList.add(orderDoDetailModel);
		}
		dataMap.put("list", list);
		dataMap.put("orderDoDetailModelList", orderDoDetailModelList);
		// 申请请款，更新请款状态
		Response<Integer> result = requestMoneyService.updateById(dataMap);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("request.error,error code: {}",list,result.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));

	}

	/**
	 * 请款批量导出
	 * @param flag
	 * @param orderSubModel
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	@RequestMapping(value = "/exportAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean requestExport(String flag,OrderSubModel orderSubModel,String startTime,String endTime){
		User user = UserUtil.getUser();
		//查询条件
		Pager<RequestOrderDto> pager = requestMoneyService.findOrderQuest(null,null,orderSubModel.getOrderId(),orderSubModel.getGoodssendFlag(),orderSubModel.getSinStatusId(),orderSubModel.getGoodsNm()
																				,flag,startTime,Contants.BUSINESS_TYPE_JF,endTime,user).getResult();
		List<RequestOrderDto> requestOrderDtoList = pager.getData();
		//TODO 调用工具类
    	return null;
	}
}
