package cn.com.cgbchina.web.controller;

import static cn.com.cgbchina.web.utils.SafeHtmlValidator.checkScriptAndEvent;
import static com.google.common.base.Preconditions.checkArgument;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.annotation.Resource;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.utils.SpringContextUtils;
import cn.com.cgbchina.restful.provider.service.order.OrderCreateMainAndSubService;
import cn.com.cgbchina.scheduler.model.TaskScheduled;
import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.service.*;
import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.spirit.jms.mq.QueueSender;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.KeyReader;
import cn.com.cgbchina.common.utils.SignManager;
import cn.com.cgbchina.common.utils.SignUtil;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.log.model.MessageLogModel;
import cn.com.cgbchina.log.service.MessageLogService;
import cn.com.cgbchina.trade.dto.OrderCommitSubmitDto;
import cn.com.cgbchina.trade.dto.OrderMallManageDto;
import cn.com.cgbchina.trade.dto.OrderReturnDetailDto;
import cn.com.cgbchina.trade.dto.PagePaymentReqDto;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.service.OrderPartBackService;
import cn.com.cgbchina.trade.service.OrderService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11140721050130 on 2016/4/3.
 */
@Controller
@RequestMapping("/api/mall/myOrders")
@Slf4j
public class Orders {
	@Resource
	OrderPartBackService orderPartBackService;
	@Resource
	MessageSources messageSources;
	@Resource
	private OrderService orderService;
	@Value("#{app.expressUrl}")
	private String expressUrl;
	@Resource
	PointsPoolService pointsPoolService;
	@Resource
	private OrderFQMainService orderFQMainService;
	@Resource
	private OrderJFMainService orderJFMainService;
	@Resource
	private IdGenarator idGenarator;
	@Resource
	private OrderCreateMainAndSubService orderCreateMainAndSubService;
	private ExecutorService threadPool=Executors.newFixedThreadPool(5);
	@Resource
	private MessageLogService messageLogService;
	@Autowired
	private JedisTemplate jedisTemplate;
	@Autowired
	@Qualifier("queueSender")
	private QueueSender queueSender;


	/**
	 * 确认订单方法
	 */
	@RequestMapping(value = "/affirm_new", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public PagePaymentReqDto affirmOrder_new(@RequestBody OrderCommitSubmitDto orderCommitSubmitDto) {
		log.debug("**********************确认订单 start");
		// 获取用户信息
		User user = UserUtil.getUser();
		UserAccount selectedCardInfo = new UserAccount();
		PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
		try {
			String cardNo = orderCommitSubmitDto.getCardNo();
			checkArgument(!StringUtils.isEmpty(cardNo), "cardNo.can.not.empty");
			KeyReader keyReader = new KeyReader();
			boolean cardNoflag = false;
			for (UserAccount userAccount : user.getAccountList()) {
				String cardSign = SignUtil.sign(userAccount.getCardNo(), keyReader
						.readPrivateKey(SignManager.DEFAULT_RSA_PRI_KEY, true, SignManager.RSA_ALGORITHM_NAME));
				if (cardNo.equals(cardSign)) {
					selectedCardInfo = userAccount;
					orderCommitSubmitDto.setCardNo(userAccount.getCardNo());
					cardNoflag = true;
					break;
				}
			}
			if (!cardNoflag) {
				pagePaymentReqDto.setErrorMsg("卡号信息不正确");
				return pagePaymentReqDto;
			}
		} catch (IllegalArgumentException e) {
			log.error("create.error,error code: {}", Throwables.getStackTraceAsString(e));
			pagePaymentReqDto.setErrorMsg(messageSources.get(e.getMessage()));
			return pagePaymentReqDto;
		} catch (Exception e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("order.create.error"));
		}
		log.debug("**********************测试时间2 获取用户和卡信息");
		/* 校验下单信息 */
		Response<OrderMainDto> checkResult = null;
		if (orderCommitSubmitDto.getBusiType().equals("0")) {
			checkResult = orderFQMainService.checkCreateOrderArgumentAndGetInfos_new(orderCommitSubmitDto, selectedCardInfo, user);
			// 积分商城
		} else if (orderCommitSubmitDto.getBusiType().equals("1")) {
			checkResult = orderJFMainService.checkCreateJfOrderArgumentAndGetInfos_new(orderCommitSubmitDto, selectedCardInfo, user);
		}
		if (checkResult!=null&&!checkResult.isSuccess()) {
			pagePaymentReqDto.setErrorMsg(checkResult.getError());
			return pagePaymentReqDto;
		}
		log.debug("**********************测试时间3 校验下单信息");
		OrderMainDto orderMainDto = checkResult.getResult();
		/* 构建大订单和小订单 */
		// 构建大订单
		Response<OrderMainModel> orderMainModelRsp = Response.newResponse();
		orderMainDto.setSourceId(Contants.ORDER_SOURCE_ID_MALL);// 订单来源渠道id00: 商城01: callcenter02: ivr渠道03: 手机商城
		orderMainDto.setSourceNm("商城");
		// 广发商城
		if (orderCommitSubmitDto.getBusiType().equals("0")) {
			orderMainModelRsp = orderCreateMainAndSubService.createOrderMain_new(orderMainDto, orderCommitSubmitDto, user);
			// 积分商城
		} else if (orderCommitSubmitDto.getBusiType().equals("1")) {
			orderMainModelRsp = orderCreateMainAndSubService.createJfOrderMain_new(orderMainDto, orderCommitSubmitDto, user);
		}
		if (!orderMainModelRsp.isSuccess()) {
			pagePaymentReqDto.setErrorMsg(orderMainModelRsp.getError());
			return pagePaymentReqDto;
		}
		OrderMainModel orderMainModel = orderMainModelRsp.getResult();
		log.debug("**********************测试时间4 构建大订单");
		String orderMainId = idGenarator.orderMainId(orderMainModel.getSourceId());
		orderMainModel.setOrdermainId(orderMainId);
		orderMainModel.setSerialNo(idGenarator.orderSerialNo());

		if (!Strings.isNullOrEmpty(orderCommitSubmitDto.getUserName())) {
			orderMainModel.setCsgName(orderCommitSubmitDto.getUserName());
		}
		if (!Strings.isNullOrEmpty(orderCommitSubmitDto.getPhoneNo())) {
			orderMainModel.setCsgPhone1(orderCommitSubmitDto.getPhoneNo());
		}
		/* 构建小订单和订单处理历史明细表 */
		// 构建小订单
		Response<OrderSubDetailDto> orderSubDetailRsp = Response.newResponse();
		// 广发商城
		if (orderCommitSubmitDto.getBusiType().equals("0")) {
			orderSubDetailRsp = orderCreateMainAndSubService.createOrderSubDoDetail_new(orderMainDto, user,
					orderMainModel);
			// 积分商城
		} else if (orderCommitSubmitDto.getBusiType().equals("1")) {
			orderSubDetailRsp = orderCreateMainAndSubService.createJfOrderSubDoDetail_new(orderCommitSubmitDto, orderMainDto,
					user, orderMainModel);
		}
		if (!orderSubDetailRsp.isSuccess()) {
			pagePaymentReqDto.setErrorMsg(orderSubDetailRsp.getError());
			return pagePaymentReqDto;
		}
		List<OrderSubModel> orderSubModelList = orderSubDetailRsp.getResult().getOrderSubModelList();
		List<OrderDoDetailModel> orderDoDetailModelList = orderSubDetailRsp.getResult().getOrderDoDetailModelList();
		List<OrderVirtualModel> orderVirtualList = orderSubDetailRsp.getResult().getOrderVirtualModelList();
		log.debug("**********************测试时间5 构建小订单和订单处理历史明细表");
		// 登入数据库
		Response creadOrderRsp = Response.newResponse();
		// 广发商城
		if (orderCommitSubmitDto.getBusiType().equals("0")) {
			creadOrderRsp = orderService.createOrder_new(orderCommitSubmitDto, user, orderMainModel,
					orderSubModelList, orderDoDetailModelList, orderVirtualList, orderMainDto);
			// 积分商城
		} else if (orderCommitSubmitDto.getBusiType().equals("1")) {
			creadOrderRsp = orderService.createOrder_new(orderCommitSubmitDto, user, orderMainModel, orderSubModelList,
					orderDoDetailModelList, orderVirtualList, checkResult.getResult());
		}
		if (!creadOrderRsp.isSuccess()) {
			pagePaymentReqDto.setErrorMsg(creadOrderRsp.getError());
			return pagePaymentReqDto;
		}
		log.debug("**********************测试时间6 登入数据库");
		// 荷兰拍库存释放MQ
		sendQuery(orderSubModelList);
		/* 根据订单返回值,构建支付信息 */
		Response<PagePaymentReqDto> result = Response.newResponse();
		if (orderCommitSubmitDto.getMiaoFlag().equals("1")) {
			pagePaymentReqDto.setMiaoFlag("1");
			// 准备支付用数据
			// 广发
		} else if(orderCommitSubmitDto.getBusiType().equals("0")) {
			result = orderFQMainService.getReturnObjForPay_new(orderMainModel, orderSubModelList);
			// 积分
		} else if(orderCommitSubmitDto.getBusiType().equals("1")) {
			result = orderJFMainService.getReturnObjForPay_new(orderMainModel, orderSubModelList, orderVirtualList);
		}
		log.debug("**********************测试时间7 构建支付信息");
		PagePaymentReqDto resultModel=null;
		if (result.isSuccess()) {
			resultModel=result.getResult();
		} else {
			pagePaymentReqDto.setErrorMsg(result.getError());
			resultModel=pagePaymentReqDto;
		}
		
		final MessageLogModel model=new MessageLogModel();
		model.setSendersn(orderMainModel.getOrdermainId());
		model.setTradecode(Contants.ONLINE_PAY_MARK);
		model.setReceiverid(Contants.ONLINE_PAY_MARK);
		model.setOrderid(orderMainModel.getOrdermainId());
		model.setOpertime(new Date());
		model.setSendflag(Constant.SEND_FLG);
		model.setMessagecontent(jsonMapper.toJson(resultModel));
		threadPool.execute(new Runnable() {
			public void run() {
				messageLogService.insertMessageLog(model);
			}
		});
		return resultModel;
	}

	private void sendQuery(List<OrderSubModel> orderSubModelList) {
		for (OrderSubModel orderSubModel : orderSubModelList) {
			if ("50".equals(orderSubModel.getActType())) {
				TaskScheduled taskScheduled = new TaskScheduled();
				taskScheduled.setTaskGroup("cn.com.cgbchina.batch.service.PromotionSyncService");
				taskScheduled.setTaskName("batchAuctionStockRelease");
				taskScheduled.setDesc("荷兰拍十五分钟后自动释放库存");
				taskScheduled.setTaskType("promotion");
				taskScheduled.setPromotionId(orderSubModel.getOrderId());
				taskScheduled.setPromotionStartDate(new DateTime().plusMinutes(15).toDate());
				taskScheduled.setStatus("1");
				// 拍卖ID
				String[] argsEnd = {orderSubModel.getOrderId()};
				taskScheduled.setParamArgs(argsEnd);
				queueSender.send("shop.cgb.scheduler.notify", taskScheduled);
			}
		}
	}
	
	private JsonMapper jsonMapper=JsonMapper.nonDefaultMapper();

	/**
	 * 支付临时使用 add by wujiao
	 */
	@RequestMapping(value = "/demoPay", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String demoPay(@RequestBody OrderCommitSubmitDto orderCommitSubmitDto) {
		try {
			orderService.demoPay(orderCommitSubmitDto.getOrderId(), orderCommitSubmitDto.getPayFlag(),
					UserUtil.getUser());
			switch (orderCommitSubmitDto.getPayFlag()) {
			case "0":
				return Contants.SUB_ORDER_STATUS_0308;
			case "1":
				return Contants.SUB_ORDER_STATUS_0307;
			case "2":
				return Contants.SUB_ORDER_STATUS_0305;
			default:
				return Contants.SUB_ORDER_STATUS_0308;
			}
		} catch (IllegalArgumentException e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("order.create.error"));
		}
	}

	/**
	 * 分页查询，根据类型查询
	 *
	 * @param pageNo
	 * @param size
	 * @param curStatusId
	 * @return
	 */
	@RequestMapping(value = "/findOrderbyCenter", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<OrderMallManageDto> findOrderByPersonalCenter(Integer pageNo, Integer size, String curStatusId) {
		// 获取用户
		User user = UserUtil.getUser();

		// 调用接口
		Response<Pager<OrderMallManageDto>> result = orderService.findMall(pageNo, size, null, curStatusId, null, null,
				null, user,"2");

		if (result.isSuccess()) {
			return result.getResult();
		}

		log.error("insert.error, {},error code:{}", curStatusId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 广发商城更新订单状态 取消订单
	 *
	 * @param ordermainId
	 * @return
	 */
	@RequestMapping(value = "/updateOrder", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> cancelOrder(String ordermainId) {
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "ORDERID" + ordermainId, 50, 5000);
		if (lockId == null) {
			log.info("failed to cancell order,error orders be handing");
			throw new ResponseException(500, messageSources.get("订单正在执行其他操作，请稍后操作！"));
		}
		User user = UserUtil.getUser();
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("ordermainId", ordermainId);
		paramMap.put("user", user);
		Response<Map<String, Object>> result = orderService.updateOrderMall(paramMap);
		if (result.isSuccess()) {
			// 回滚积分池
			if ((Boolean) result.getResult().get("result")) {
				Response<OrderMainModel> orderMainModelResponse = orderService.findOrderMainById(ordermainId);
				if (!orderMainModelResponse.isSuccess()) {
					log.error("failed to return pointsPool in cancelOrder{},error code:{}",
							orderMainModelResponse.getError());
					DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + ordermainId,lockId);
					return result.getResult();
				}
				OrderMainModel orderMainModel = orderMainModelResponse.getResult();
				if (orderMainModel == null) {
					log.error("Orders cancelOrder return pointsPool failed,orderMainModel be null");
					DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + ordermainId,lockId);
					return result.getResult();
				}
				if (!Contants.BUSINESS_TYPE_JF.equals(orderMainModel.getOrdertypeId()) && orderMainModel.getTotalBonus() > 0l) {
					Long totalBonus = orderMainModel.getTotalBonus();
					Map<String, Object> paramPoolMap = Maps.newHashMap();
					paramPoolMap.put("used_point", totalBonus);
					if (null != orderMainModel.getCreateTime()) {
						paramPoolMap.put("cur_month", DateHelper.getyyyyMM(orderMainModel.getCreateTime()).substring(0, 6));
					} else {
						paramPoolMap.put("cur_month", "");
					}
					// 回滚积分池
					Response<Boolean> booleanResponse = pointsPoolService.dealPointPool(paramPoolMap);
					if (!booleanResponse.isSuccess()) {
						log.error("failed to return pointsPool in cancelOrder{},error code:{}", booleanResponse.getError());
					}
					if (booleanResponse.getResult()) {
						log.info("回滚积分池成功！");
					} else {
						log.info("回滚积分池失败！");
					}
				}
			}
			DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + ordermainId,lockId);
			return result.getResult();
		}
		DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + ordermainId,lockId);
		log.error("failed to cancelOrder{},error code:{}", ordermainId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 商城用户提醒订单发货
	 *
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/remind", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean remind(String orderId) {
		User user = UserUtil.getUser();
		String id = user.getId();
		Response<Map<String, Boolean>> result = orderService.updateOrderRemind(orderId, id);
		if (result.isSuccess()) {
			if (result.getResult().get("result")) {
				return Boolean.TRUE;
			} else {
				return Boolean.FALSE;
			}
		}
		log.error("failed to remind{},error code:{}", orderId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询物流信息
	 *
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/watchTrans", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public OrderTransModel watchTrans(String orderId) {
		Response<OrderTransModel> result = orderService.findOrderTrans(orderId);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to watchTrans{},error code:{}", orderId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询退货详情
	 *
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/watchRevoke", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public OrderReturnDetailDto watchRevoke(String orderId) {
		Response<OrderReturnDetailDto> result = orderService.findOrderReturnDetail(orderId);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to watchRevoke{},error code:{}", orderId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 广发商城退货撤单
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
		Response<Map<String, Object>> result = new Response<>();
		Map<String, Object> paramMap = new HashMap<>();
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "MRO" + orderId, 50, 10000);
		if (lockId == null) {
			paramMap.put("result",Boolean.FALSE);
			paramMap.put("error","doing");
			return paramMap;
		}
		try {
			User user = UserUtil.getUser();
			String userId = user.getId();
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.is.null");
			checkArgument(StringUtils.isNotBlank(season), "orderId.is.null");
			checkArgument(StringUtils.isNotBlank(typeFlag), "typeFlag.is.null");
			checkArgument(StringUtils.isNotBlank(userId), "userId.is.null");
			paramMap.put("orderId", orderId);
			paramMap.put("season", season);
			paramMap.put("supplement", supplement);
			paramMap.put("typeFlag", typeFlag);
			paramMap.put("userId", userId);
			paramMap.put("user", user);
			if(checkScriptAndEvent(season)){
				DistributedLocks.releaseLock(jedisTemplate, "MRO" + orderId,lockId);
				log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag);
				throw new ResponseException(500, messageSources.get("season.be.illegal"));
			}
			if (StringUtils.isNotEmpty(supplement)){
				if(checkScriptAndEvent(supplement)){
					DistributedLocks.releaseLock(jedisTemplate, "MRO" + orderId,lockId);
					log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag);
					throw new ResponseException(500, messageSources.get("supplement.be.illegal"));
				}
				int length=supplement.length();
				if (length>150){
					DistributedLocks.releaseLock(jedisTemplate, "MRO" + orderId,lockId);
					log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag);
					throw new ResponseException(500, messageSources.get("supplement.length.longOver"));
				}
			}

			switch (typeFlag) {
			case Contants.SUB_ORDER_STATUS_0335:
				result = orderService.returnOrderMall(paramMap);
				break;
			case Contants.SUB_ORDER_STATUS_0310:
				result = orderService.returnOrderMall(paramMap);
				break;
			case Contants.SUB_ORDER_STATUS_0308:
				result = orderService.revokeOrderMall(paramMap);
				break;
			default:
				DistributedLocks.releaseLock(jedisTemplate, "MRO" + orderId,lockId);
				throw new ResponseException(500, messageSources.get("typeFlag.be.wrong"));
			}
			if (result.isSuccess()) {
				// 撤单后发送短信
				if (Contants.SUB_ORDER_STATUS_0308.equals(typeFlag)) {
					if ((Boolean) result.getResult().get("result")) {
						Response<Boolean> response = orderService.sendMsg(orderId);
						if (response.isSuccess()) {
							log.info("短信发送成功！");
						} else {
							log.info("短信发送失败：" + response.getError());
						}
					}
				}
				DistributedLocks.releaseLock(jedisTemplate, "MRO" + orderId,lockId);
				return result.getResult();
			}
			DistributedLocks.releaseLock(jedisTemplate, "MRO" + orderId,lockId);
			log.error("failed to revoke{},error code:{}", orderId, season, supplement, typeFlag, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		} catch (IllegalArgumentException e) {
			DistributedLocks.releaseLock(jedisTemplate, "MRO" + orderId,lockId);
			log.error("failed to revoke, error code::{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
	}

	/**
	 * 通过订单id查询订单状态
	 *
	 * @param orderId
	 * @return
	 * @Add by Liuhan
	 */
	@RequestMapping(value = "/{orderId}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public OrderSubModel findBrandByName(@PathVariable String orderId) {
		try {
			// 校验
			checkArgument(StringUtils.isNotBlank(orderId), "id is null");
			OrderSubModel result = orderService.findOrderId(orderId);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("select.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("select.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("create.error"));
		}
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
	 * 广发商城我的订单 支付
	 */
	@RequestMapping(value = "/payoff", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public PagePaymentReqDto payoffOrder(String orderMainId) {
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "ORDERID" + orderMainId, 50, 5000);
		if (lockId == null) {
			log.info("failed to payoff,error orders be handing");
			throw new ResponseException(500, messageSources.get("订单正在执行其他操作，请稍后操作！"));
		}
		// 获取用户信息
		User user = UserUtil.getUser();
		Response<PagePaymentReqDto> result = orderService.payoffOrder(orderMainId, user);
		if (result.isSuccess()) {
			DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + orderMainId,lockId);
			return result.getResult();
		}
		DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + orderMainId,lockId);
		log.error("failed to payoff{},error code:{}",orderMainId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 积分商城退货撤单
	 *
	 * @param orderId
	 * @param season
	 * @param supplement
	 * @param typeFlag
	 * @return
	 */
	@RequestMapping(value = "/pointsRevoke", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> pointsRevoke(String orderId, String season, String supplement, String typeFlag) {
		Response<Map<String, Object>> result = new Response<>();
		Map<String, Object> paramMap = new HashMap<>();
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "PRO" + orderId, 50, 10000);
		if (lockId == null) {
			paramMap.put("result",Boolean.FALSE);
			paramMap.put("error","doing");
			return paramMap;
		}
		try {
			User user = UserUtil.getUser();
			String userId = user.getId();
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.is.null");
			checkArgument(StringUtils.isNotBlank(season), "orderId.is.null");
			checkArgument(StringUtils.isNotBlank(typeFlag), "typeFlag.is.null");
			checkArgument(StringUtils.isNotBlank(userId), "userId.is.null");
			paramMap.put("orderId", orderId);
			paramMap.put("season", season);
			paramMap.put("supplement", supplement);
			paramMap.put("typeFlag", typeFlag);
			paramMap.put("userId", userId);
			paramMap.put("user", user);
			if(checkScriptAndEvent(season)){
				DistributedLocks.releaseLock(jedisTemplate, "PRO" + orderId,lockId);
				log.error("failed to pointsRevoke{},error code:{}", orderId, season, supplement, typeFlag);
				throw new ResponseException(500, messageSources.get("season.be.illegal"));
			}
			if (StringUtils.isNotEmpty(supplement)){
				if(checkScriptAndEvent(supplement)){
					DistributedLocks.releaseLock(jedisTemplate, "PRO" + orderId,lockId);
					log.error("failed to pointsRevoke{},error code:{}", orderId, season, supplement, typeFlag);
					throw new ResponseException(500, messageSources.get("supplement.be.illegal"));
				}
				int length=supplement.length();
				if (length>150){
					DistributedLocks.releaseLock(jedisTemplate, "PRO" + orderId,lockId);
					log.error("failed to pointsRevoke{},error code:{}", orderId, season, supplement, typeFlag);
					throw new ResponseException(500, messageSources.get("supplement.length.longOver"));
				}
			}

			switch (typeFlag) {
				case Contants.SUB_ORDER_STATUS_0335:
					result = orderService.returnOrderMall(paramMap);
					break;
				case Contants.SUB_ORDER_STATUS_0310:
					result = orderService.returnOrderMall(paramMap);
					break;
				case Contants.SUB_ORDER_STATUS_0308:
					Map<String,Object>resultMap= Maps.newHashMap();
					Response<OrderSubModel>orderSubModelResponse=orderPartBackService.findbyOrderId(orderId);
					if (!orderSubModelResponse.isSuccess()||orderSubModelResponse.getResult()==null){
						DistributedLocks.releaseLock(jedisTemplate, "PRO" + orderId,lockId);
						log.error("failed to pointsRevoke{},error code:{}", orderId, season, supplement, typeFlag);
						throw new ResponseException(500, messageSources.get("orderSubModel.be.null"));
					}
					OrderSubModel orderSubModel=orderSubModelResponse.getResult();
					Response <Boolean> responseOrderPartBack=orderPartBackService.updatePointRevocation(orderSubModel,season,supplement,user);
					if (!responseOrderPartBack.isSuccess()){
						if ("order.status.change".equals(responseOrderPartBack.getError())){
							resultMap.put("result", Boolean.FALSE);
							resultMap.put("error", "statusChanged");
							result.setResult(resultMap);
						}else {
							result.setError(responseOrderPartBack.getError());
						}
					}else {
						if (responseOrderPartBack.getResult()) {
							resultMap.put("result", Boolean.TRUE);
						}else {
							resultMap.put("result", Boolean.FALSE);
						}
						result.setResult(resultMap);
					}
					break;
				default:
					DistributedLocks.releaseLock(jedisTemplate, "PRO" + orderId, lockId);
					throw new ResponseException(500, messageSources.get("typeFlag.be.wrong"));
			}
			if (result.isSuccess()) {
				DistributedLocks.releaseLock(jedisTemplate, "PRO" + orderId,lockId);
				return result.getResult();
			}
			DistributedLocks.releaseLock(jedisTemplate, "PRO" + orderId,lockId);
			log.error("failed to pointsRevoke{},error code:{}", orderId, season, supplement, typeFlag, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		} catch (IllegalArgumentException e) {
			DistributedLocks.releaseLock(jedisTemplate, "PRO" + orderId,lockId);
			log.error("failed to pointsRevoke, error code::{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
	}
}
