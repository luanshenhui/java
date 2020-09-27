package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dto.OrderQueryConditionDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.RequestMoneyService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

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

	private String rootFilePath;

	public VendorRequest() {
		this.rootFilePath = this.getClass().getResource("/upload").getPath();
	}

	/**
	 * 供应商请款申请
	 * 
	 * @param list
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer startRequest(@RequestBody @Valid @NotNull List<String> list, BindingResult bindingResult) {
		//校验订单状态确认是否可以请款,只要有不可以请款的就返回
		Response<List<OrderSubModel>> orderResponse =  orderService.findForRequest(list);
		List<OrderSubModel> orderSubModelList = orderResponse.getResult();
		for(OrderSubModel orderSubModel : orderSubModelList){
			String sinStatusId = orderSubModel.getSinStatusId();
			if(Contants.SUB_SIN_STATUS_0332.equals(sinStatusId)){
				return 9999;
			}
		}
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
		for (String orderId : list) {
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderId);
			orderDoDetailModel.setCreateOper(userId);
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
			orderDoDetailModel.setDoUserid(userId);
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_2);
			orderDoDetailModel.setStatusId(Contants.SUB_SIN_STATUS_0332);
			orderDoDetailModel.setStatusNm(Contants.SUB_SIN_STATUS_Nm_0332);
			orderDoDetailModelList.add(orderDoDetailModel);
		}
		dataMap.put("list", list);
		dataMap.put("orderDoDetailModelList", orderDoDetailModelList);
		// 申请请款，更新请款状态
		Response<Integer> result = requestMoneyService.updateById(dataMap);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("request.error,error code: {}", list, result.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));

	}

	/**
	 * 请款批量导出
	 * @return
	 */
	@RequestMapping(value = "/exportAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean requestExport(@RequestParam("conditionDto") @NotNull String json) {
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		OrderQueryConditionDto conditionDto = jsonMapper.fromJson(json, OrderQueryConditionDto.class);
		User user = UserUtil.getUser();
		// 不搜索0元秒杀订单
		conditionDto.setMiaoshaActionFlag(String.valueOf(Contants.DEL_INTEGER_FLAG_0));
		// 查询条件
		try {
			//区分是供应商导出报表还是内管导出报表
			String roleFlag = "0";
			Response<Boolean> response = requestMoneyService.exportRequest(conditionDto,Contants.VENDOR_SYSTEM , user,roleFlag);
			if (response.isSuccess()){
				return response.getResult();
			}else{
				return false;
			}
		} catch (Exception e) {
			log.error("fail to export vendorAskMoney data, bad code{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, e.getMessage());
		}
	}


	/**
	 * 请款批量导出查询
	 * @return
	 */
	@RequestMapping(value = "/findAskExport", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String requestExport() {
		User user = UserUtil.getUser();
		String request= requestMoneyService.getApplayPayExport(user.getId(),Contants.VENDOR_SYSTEM,Contants.BUSINESS_TYPE_JF);
		return request;
	}

}
