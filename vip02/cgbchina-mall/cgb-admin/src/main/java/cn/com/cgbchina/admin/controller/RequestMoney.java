package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dto.OrderQueryConditionDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.RequestMoneyService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.validation.constraints.NotNull;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by 11150721040343 on 16-4-12.
 */
@Controller
@RequestMapping("/api/admin/requestMoney")
@Slf4j
public class RequestMoney {
	@Autowired
	private RequestMoneyService requestMoneyService;
	@Autowired
	MessageSources messageSources;
	@Autowired
	OrderService orderService;
	@Autowired
	VendorService vendorService;
	private String rootFilePath;

	public RequestMoney() {
		this.rootFilePath = this.getClass().getResource("/upload").getPath();
	}

	/**
	 * 内管同意请款，更新请款状态
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "/audit-pass", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer requestAccess(@RequestBody ModelMap map) {
		List<OrderDoDetailModel> orderDoDetailModelList = Lists.newArrayList();
		String userId = UserUtil.getUserId();
		User user = UserUtil.getUser();
		String userName = user.getName();
		// 校验map是否为空
		checkArgument(map != null, "list is not null");
		// 订单check
		List<String> orderIds = (List) map.get("arr");
		String doDesc = (String)map.get("sinApplyMemo");
		for (String orderId : orderIds) {
			OrderSubModel orderSubModel = orderService.findOrderId(orderId);
			if (orderSubModel != null) {
				if (!Contants.SUB_SIN_STATUS_0332.equals(orderSubModel.getSinStatusId())) {
					throw new ResponseException(Contants.ERROR_CODE_500,
							messageSources.get("sinStatusId.already.deal") + orderId);
				} else if (Contants.SUB_ORDER_STATUS_0327.equals(orderSubModel.getCurStatusId())) {
					throw new ResponseException(Contants.ERROR_CODE_500,
							messageSources.get("sinCurStatusId.already.back") + orderId);
				} else if (Contants.GOODS_SEND_FLAG_0.equals(orderSubModel.getGoodssendFlag())) {
					throw new ResponseException(Contants.ERROR_CODE_500,
							messageSources.get("goodsSendFlag.not.send") + orderId);
				} else if (Contants.GOODS_ASKFOR_FLAG_1.equals(orderSubModel.getGoodsaskforFlag())) {
					throw new ResponseException(Contants.ERROR_CODE_500,
							messageSources.get("goodsAskfor.alerady.askfor") + orderId);
				} else if (Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())) {
					// 积分商城判断银联商户号是否为空
					String vendorId = orderSubModel.getVendorId();
					Response<VendorInfoDto> result = vendorService.findById(vendorId);
					if(!result.isSuccess()){
						log.error("Response.error,error code: {}", result.getError());
						throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
					}
					VendorInfoDto vendorInfoDto = result.getResult();
					if (vendorInfoDto != null) {
						if (vendorInfoDto.getUnionPayNo() == null || "".equals(vendorInfoDto.getUnionPayNo())) {
							throw new ResponseException(Contants.ERROR_CODE_500,
									messageSources.get("unionPayNo.empty") + orderId);
						}
					}
				}
			} else {
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("order.not.exist") + orderId);
			}
		}
		// 插入历史表
		for (String orderId : orderIds) {
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderId);
			orderDoDetailModel.setCreateOper(userName);
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
			orderDoDetailModel.setDoUserid(userId);
			orderDoDetailModel.setDoDesc(doDesc);
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_1);
			orderDoDetailModel.setStatusId(Contants.SUB_SIN_STATUS_0350);
			orderDoDetailModel.setStatusNm(Contants.SUB_SIN_STATUS_Nm_0350);
			orderDoDetailModelList.add(orderDoDetailModel);
		}
		map.put("orderDoDetailModelList", orderDoDetailModelList);
		// 同意请款，更新请款状态
		Response<Integer> result = requestMoneyService.updatePassById(map);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("request.error,error code: {}", result.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	}

	/**
	 * 内管拒绝请款，更新请款状态
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "/audit-reject", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer requestRefuse(@RequestBody ModelMap map) {
		List<OrderDoDetailModel> orderDoDetailModelList = Lists.newArrayList();
		String userId = UserUtil.getUserId();
		User user = UserUtil.getUser();
		String userName = user.getName();
		// 校验list是否为空
		checkArgument(map != null, "list is not null");
		// 插入历史表
		List<String> orderIds = (List) map.get("arr");
		String doDesc = (String)map.get("sinApplyMemo");
		for (String orderId : orderIds) {
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(String.valueOf(orderId));
			orderDoDetailModel.setCreateOper(userName);
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
			orderDoDetailModel.setDoUserid(userId);
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_1);
			orderDoDetailModel.setDoDesc(doDesc);
			String sinStatusId = orderService.findOrderId(orderId).getSinStatusId();
			if (!Contants.SUB_SIN_STATUS_0332.equals(sinStatusId)){
				log.error("request.error,error code: {}", "orderID:"+orderId+",sinStatusId has changed");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("sinStatusId.already.deal") + orderId);
			}
			orderDoDetailModel.setStatusId(Contants.SUB_SIN_STATUS_0333);
			orderDoDetailModel.setStatusNm(Contants.SUB_SIN_STATUS_Nm_0333);
			orderDoDetailModelList.add(orderDoDetailModel);
		}
		map.put("orderDoDetailModelList", orderDoDetailModelList);
		// 拒绝请款，更新请款状态
		Response<Integer> result = requestMoneyService.updateRefuseById(map);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("request.error,error code: {}", result.getError());
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
		// 判断tab页
		if ("2".equals(conditionDto.getTabNumber())) {
			conditionDto.setSinStatusId(Contants.SUB_SIN_STATUS_0332);
			conditionDto.setTabNumber(null);
		} else {
			conditionDto.setTabNumber(Contants.SUB_ORDER_STATUS_0310);
		}
		// 查询条件
		try {
			String roleFlag = "1";
			Response<Boolean> response = requestMoneyService.exportRequest(conditionDto, Contants.ADMIN_SYSTEM, user,roleFlag);
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
		String request= requestMoneyService.getApplayPayExport(user.getId(),Contants.ADMIN_SYSTEM,Contants.BUSINESS_TYPE_JF);
		return request;
	}
}
