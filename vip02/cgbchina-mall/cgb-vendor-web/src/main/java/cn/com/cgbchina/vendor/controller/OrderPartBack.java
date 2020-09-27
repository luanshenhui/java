package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.trade.dto.OrderPartDto;
import cn.com.cgbchina.trade.dto.OrderQueryConditionDto;
import cn.com.cgbchina.trade.dto.RevocationOrderDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderReturnTrackDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderPartBackService;
import cn.com.cgbchina.trade.service.OrderReturnService;
import cn.com.cgbchina.trade.service.OrderService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static cn.com.cgbchina.web.utils.SafeHtmlValidator.checkScriptAndEvent;
import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by yuxinxin on 16-5-10.
 */
@Controller
@Slf4j
@RequestMapping("/api/vendor/reviewed")
public class OrderPartBack {
	@Autowired
	OrderReturnService orderReturnService;
	@Autowired
	OrderPartBackService orderPartBackService;
	@Autowired
	OrderService orderService;
	@Autowired
	MessageSources messageSources;
	@Autowired
	private JedisTemplate jedisTemplate;


	private String rootFilePath;

	public OrderPartBack() {
		this.rootFilePath = this.getClass().getResource("/upload").getPath();
	}

	/**
	 * 根据orderID查询退货履历表
	 *
	 * @param orderId 订单id
	 * @return
	 */
	@RequestMapping(value = "/watch", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<OrderReturnTrackDetailModel> watchOrders(String orderId) {
		Response<List<OrderReturnTrackDetailModel>> response = orderReturnService.findReturnTrackByOrderId(orderId);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to find {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 审核退货, 供应商同意退货
	 *
	 * @param curStatusId
	 * @return
	 */
	@RequestMapping(value = "/agree", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean agreeReturn(String orderId, String reason, String memoExt, String curStatusId, String orderTypeId) {
		User user = UserUtil.getUser();
		Map<String, String> paramMap = new HashMap<>();
		paramMap.put("orderId", orderId);
		paramMap.put("season", reason);
		paramMap.put("supplement", memoExt);
		Response result = orderReturnService.agreeReturn(paramMap, user);
		if (!result.isSuccess()) {
			log.error("failed to returnOrder{},error code:{}", orderId, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
		if (!Contants.BUSINESS_TYPE_JF.equals(orderTypeId)) {
			Response<Boolean> response = orderService.sendMsg(orderId);
			if (response.isSuccess()) {
				log.info("短信发送成功！");
			} else {
				log.info("短信发送失败：" + response.getError());
			}
			return true;
		} else {
			return true;
		}
	}

	/**
	 * 审核退货, 供应商拒绝退货
	 *
	 * @param orderPartDto
	 * @return
	 */
	@RequestMapping(value = "/refuse", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> refuseReturn(@RequestBody OrderPartDto orderPartDto) {
		Response<Map<String, Object>> result = new Response<>();
		OrderReturnTrackDetailModel orderReturnTrackDetailModelNew = new OrderReturnTrackDetailModel();
		OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
		if (checkScriptAndEvent(orderPartDto.getDoDesc())) {
			throw new ResponseException(500, messageSources.get("orderPartBack.checkScriptAndEvent.error"));
		}
		User user = UserUtil.getUser();
		String vendorId = user.getId();
		OrderReturnTrackDetailModel orderReturnTrackDetailModel = orderPartDto.getData();
		OrderSubModel orderSubModel = orderPartDto.getOrderSubModel();
		String doDesc = orderPartDto.getDoDesc();
		// 插入订单退货履历表
		orderReturnTrackDetailModelNew = BeanUtils.copy(orderReturnTrackDetailModel,
				orderReturnTrackDetailModelNew.getClass());
		orderReturnTrackDetailModelNew.setCreateOper(vendorId);
		orderReturnTrackDetailModelNew.setCurStatusId(Contants.SUB_ORDER_STATUS_0335);
		orderReturnTrackDetailModelNew.setCurStatusNm(Contants.SUB_ORDER__RETURN_APPLICATION_REFUSED);
		orderReturnTrackDetailModelNew.setDoDesc(doDesc);
		// 更新订单子表
		orderSubModel.setCurStatusNm(Contants.SUB_ORDER__RETURN_APPLICATION_REFUSED);
		orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0335);
		orderSubModel.setModifyOper(vendorId);
		orderSubModel.setVendorOperFlag(Contants.DEL_FLAG_1);// 供应商操作标记0－未操作1－操作过
		orderSubModel.setReferenceNo(Contants.DEL_FLAG_0);// 是否已做同意退货操作
		// 插入订单历史表
		orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0335);
		orderDoDetailModel.setStatusNm(Contants.SUB_ORDER__RETURN_APPLICATION_REFUSED);
		orderDoDetailModel.setDoUserid(vendorId);
		orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);
		orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
		orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
		orderDoDetailModel.setModifyOper(vendorId);
		orderDoDetailModel.setCreateOper(vendorId);

		result = orderReturnService.refuseReturn(orderSubModel, orderReturnTrackDetailModelNew, orderDoDetailModel,
				user);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to returnOrder{},error code:{}", doDesc, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 批量更新退货状态
	 *
	 * @param array
	 * @return
	 */
	@RequestMapping(value = "/updateAllRejectGoods", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updateAllGoodsStatus(@RequestParam(value = "array[]") Long[] array) {
		Response<Integer> response = new Response<Integer>();
		Boolean updateFlag = false;
		List<Long> rejectGoodsList = Lists.newArrayList();
		// 循环取出退货单id
		for (Long id : array) {
			rejectGoodsList.add(id);
		}
		// 调用批量更新方法
		response = orderPartBackService.updateAllRejectGoods(rejectGoodsList);
		if (response.isSuccess()) {
			updateFlag = true;
			return updateFlag;
		}
		log.error("failed to update all {},errco code:{}");
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 审核撤单, 供应商端使用此方法
	 *
	 * @param orderSubModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response <Boolean> updateRevocation(OrderSubModel orderSubModel, String memo, String memoExt) {
		// 参数校验
		if (Strings.isNullOrEmpty(memo) || Strings.isNullOrEmpty(orderSubModel.getOrderId())) {
			log.error("updateRevocation error,cause:{}", "orderSubModel.is.null");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("orderSubModel.is.null"));
		}
		// 更新操作
		User user = UserUtil.getUser();
		orderSubModel.setModifyOper(user.getId());
		Response<Boolean> response = Response.newResponse();
		String orderId = orderSubModel.getOrderId();
		Response<OrderSubModel> orderSubModelResponse = orderPartBackService.findbyOrderId(orderId);
		if (orderSubModelResponse.isSuccess()) {
			// 撤单操作
			response = backOrder(orderSubModelResponse.getResult(), memo, memoExt, user);
		} else {
			log.error("updateRevocation error,cause:{}", "orderSubModel.is.null");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("orderSubModel.is.null"));
		}
		return response;
	}

	/**
	 * 单条数据撤单
	 * 
	 * @param orderSubModel 订单数据
	 * @param memo 原因
	 * @param memoExt 信息
	 * @param user 用户信息
	 * @return 是否成功
	 */
	private Response <Boolean> backOrder(OrderSubModel orderSubModel, String memo, String memoExt, User user) {
		Response <Boolean> result=Response.newResponse();
		String orderId=orderSubModel.getOrderId();
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "VBOL" + orderId, 50, 10000);
		if (lockId == null) {
			result.setResult(Boolean.FALSE);
			return result;
		}
		// 积分商城撤单
		if (Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())) {
			result = orderPartBackService.updatePointRevocation(orderSubModel, memo, memoExt, user);
			if (!result.isSuccess()) {
				// 更新失败
				DistributedLocks.releaseLock(jedisTemplate, "VBOL" + orderId,lockId);
				log.error("update.error, error:{},{},{}", memo, memoExt, result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			DistributedLocks.releaseLock(jedisTemplate, "VBOL" + orderId,lockId);
			return result;
		} else {
			// 广发商城撤单
			 result = orderPartBackService.updateRevocation(orderSubModel, memo, memoExt, user);
			if (!result.isSuccess()) {
				DistributedLocks.releaseLock(jedisTemplate, "VBOL" + orderId,lockId);
				// 更新失败
				log.error("update.error, error:{},{},{}", memo, memoExt, result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			if (result.getResult()) {
				Response<Boolean> response = Response.newResponse();
				response = orderService.sendMsg(orderSubModel.getOrderId());
				if (response.isSuccess()) {
					log.info("短信发送成功！");
				} else {
					log.info("短信发送失败：" + response.getError());
				}
			}
			DistributedLocks.releaseLock(jedisTemplate, "VBOL" + orderId,lockId);
			return result;
		}
	}

	/**
	 * 批量撤单
	 *
	 * @param array
	 * @return
	 */
	@RequestMapping(value = "/updateAllRevocation", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updateAllRevocation(@RequestParam(value = "array[]") String[] array, String memo, String memoExt) {
		// 校验参数
		if (array.length == 0) {
			log.error("orderSubModel is null");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("orderSubModel.is.null"));
		}
		User user = UserUtil.getUser();
		// 获取订单数据，循环调用单条数据撤单
		for (String orderId : array) {
			Response<OrderSubModel> orderSubModelResponse = orderPartBackService.findbyOrderId(orderId);
			if (orderSubModelResponse.isSuccess()) {
				OrderSubModel orderSubModel = orderSubModelResponse.getResult();
				orderSubModel.setModifyOper(user.getId());
				// 单条撤单
				backOrder(orderSubModel, memo, memoExt, user);
			} else {
				log.error("orderSubModel is null");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("orderSubModel.is.null"));
			}
		}
		// 全部订单成功
		return true;
	}

	/**
	 * 供应商平台撤单批量导出
	 * 
	 * @param conditionDto
	 * @param httpServletResponse
	 */
	@RequestMapping(value = "/exportOrder", method = RequestMethod.POST)
	public void exportOrder(OrderQueryConditionDto conditionDto, HttpServletResponse httpServletResponse) {
		User user = UserUtil.getUser();

		String fileName = "OrderRevocationExport" + UUID.randomUUID().toString() + ".xls";
		String filePath = rootFilePath + "/template/orderRevocationExport.xls";
		try {
			String startTime = conditionDto.getStartTime();
			String endTime = conditionDto.getEndTime();
			// 判读日期不允许为空
			if (StringUtils.isEmpty(startTime)) {
				throw new ResponseException("开始日期不能为空");
			}
			if (StringUtils.isEmpty(endTime)) {
				throw new ResponseException("结束日期不能为空");
			}

			Response<List<RevocationOrderDto>> response = orderPartBackService.exportRevocation(conditionDto.toMap(),
					user);
			if (response.isSuccess()) {
				List<RevocationOrderDto> list = response.getResult();
				for (int i = 0; i < list.size(); i++) {
					list.get(i).setId(i + 1);
				}
				Map<String, Object> paramMap = Maps.newHashMap();
				paramMap.put("orders", list);
				paramMap.put("vendorNm", user.getName());
				paramMap.put("vendorId", user.getId());
				paramMap.put("startTime", startTime);
				paramMap.put("endTime", endTime);
				ExportUtils.exportTemplate(httpServletResponse, fileName, filePath, paramMap);
			} else {
				log.error("failed to jsonQuery {},error code:{}", conditionDto.toString(), response.getError());
				throw new ResponseException(500, messageSources.get(response.getError()));
			}
		} catch (Exception e) {
			log.error("fail to export revocationOrder data, bad code{}", Throwables.getStackTraceAsString(e));
			// 如果前台检验不住 用户恶意更改get请求参数 校验日期格式校验信息 而不是抛500异常
			if (e instanceof ResponseException) {
				try {
					httpServletResponse.setCharacterEncoding("UTF-8");
					httpServletResponse.setContentType("text/html");
					httpServletResponse.getWriter().write(e.getMessage());
					httpServletResponse.getWriter().close();
				} catch (IOException e1) {
					log.error("fail to get response write or close ,cause by:{}", Throwables.getStackTraceAsString(e1));
					throw e;
				}
			}else {
				//不是自定义异常 抛500
				throw e;
			}
		}
	}
}
