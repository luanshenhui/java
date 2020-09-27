package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dto.RequestOrderDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderRequest;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.RequestMoneyService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import com.alibaba.dubbo.container.page.Page;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
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

	/**
	 * 内管同意请款，更新请款状态
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "pass", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer requestAccess(@RequestBody ModelMap map) {
		List<OrderDoDetailModel> orderDoDetailModelList = Lists.newArrayList();
		String userId = UserUtil.getUserId();
		User user = UserUtil.getUser();
		String userName = user.getName();
		// 校验map是否为空
		checkArgument(map != null, "list is not null");
		//订单check
		List<Integer> orderIds = (List)map.get("arr");
		for (Integer orderId : orderIds){
			OrderSubModel orderSubModel = orderService.findOrderId(String.valueOf(orderId));
			if (orderSubModel != null){
				if (!Contants.SUB_SIN_STATUS_0332.equals(orderSubModel.getSinStatusId())){
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("sinStatusId.already.deal")+orderId);
				}else if (Contants.SUB_ORDER_STATUS_0327.equals(orderSubModel.getCurStatusId())){
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("sinCurStatusId.already.back")+orderId);
				}else if (Contants.GOODS_SEND_FLAG_0.equals(orderSubModel.getGoodssendFlag())){
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("goodsSendFlag.not.send")+orderId);
				}else if (Contants.GOODS_ASKFOR_FLAG_1.equals(orderSubModel.getGoodsaskforFlag())){
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("goodsAskfor.alerady.askfor")+orderId);
				}else if (Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())){
					//积分商城判断银联商户号是否为空
					String vendorId = orderSubModel.getVendorId();
					VendorInfoDto vendorInfoDto = vendorService.findById(vendorId).getResult();
					if (vendorInfoDto != null){
						if (vendorInfoDto.getUnionPayNo() == null || "".equals(vendorInfoDto.getUnionPayNo())){
							throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("unionPayNo.empty")+orderId);
						}
					}
				}
			}else {
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("order.not.exist"+orderId));
			}
		}
		//插入历史表
		for (Integer orderId : orderIds){
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(String.valueOf(orderId));
			orderDoDetailModel.setCreateOper(userName);
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
			orderDoDetailModel.setDoUserid(userId);
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_1);
			OrderSubModel orderSubModel = orderService.findOrderId(String.valueOf(orderId));
			if (orderSubModel != null){
				String curStatusId = orderSubModel.getCurStatusId();
				String curStatusNm = orderSubModel.getCurStatusNm();
				orderDoDetailModel.setStatusId(curStatusId);
				orderDoDetailModel.setStatusNm(curStatusNm);
			}
			orderDoDetailModelList.add(orderDoDetailModel);
		}
		map.put("orderDoDetailModelList",orderDoDetailModelList);
		// 同意请款，更新请款状态
		Response<Integer> result = requestMoneyService.updatePassById(map);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("request.error,error code: {}",result.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	}

	/**
	 * 内管拒绝请款，更新请款状态
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "reject", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer requestRefuse(@RequestBody ModelMap map) {
		List<OrderDoDetailModel> orderDoDetailModelList = Lists.newArrayList();
		String userId = UserUtil.getUserId();
		User user = UserUtil.getUser();
		String userName = user.getName();
		// 校验list是否为空
		checkArgument(map != null, "list is not null");
		//插入历史表
		List<Integer> orderIds = (List)map.get("arr");
		for (Integer orderId : orderIds){
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(String.valueOf(orderId));
			orderDoDetailModel.setCreateOper(userName);
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
			orderDoDetailModel.setDoUserid(userId);
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_1);
			String curStatusId = orderService.findOrderId(String.valueOf(orderId)).getCurStatusId();
			String curStatusNm = orderService.findOrderId(String.valueOf(orderId)).getCurStatusNm();
			orderDoDetailModel.setStatusId(curStatusId);
			orderDoDetailModel.setStatusNm(curStatusNm);
			orderDoDetailModelList.add(orderDoDetailModel);
		}
		map.put("orderDoDetailModelList",orderDoDetailModelList);
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
	 * @param flag
	 * @param orderSubModel
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	@RequestMapping(value = "/exportAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean requestExport(String flag,OrderSubModel orderSubModel,String startTime,String endTime){
		// 校验orderSubModel是否为空
		checkArgument(orderSubModel != null, "orderSubModel is not null");
		//查询条件
		Pager<RequestOrderDto> pager = requestMoneyService.findOrderQuestAdmin(null,null,orderSubModel.getOrdermainId(),orderSubModel.getOrderId(),
				orderSubModel.getCardno(),startTime,endTime,orderSubModel.getSinStatusId(),flag,Contants.BUSINESS_TYPE_JF,orderSubModel.getVendorSnm(),null).getResult();
		List<RequestOrderDto> requestOrderDtoList = pager.getData();
		//TODO 调用工具类
		return null;
	}
}
