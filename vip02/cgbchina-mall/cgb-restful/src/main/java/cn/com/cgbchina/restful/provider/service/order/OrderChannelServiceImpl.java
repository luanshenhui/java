package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.BpsReturnCode;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.PayReturnCode;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.service.GoodsDetailService;
import cn.com.cgbchina.related.model.CouponInfModel;
import cn.com.cgbchina.related.service.CouPonInfService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfoResult;
import cn.com.cgbchina.rest.visit.model.payment.*;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.PayService;
import cn.com.cgbchina.trade.service.RestOrderService;
import cn.com.cgbchina.trade.service.TblOrderMainService;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.model.BackCategory;
import com.spirit.category.model.Spu;
import com.spirit.category.service.BackCategoryHierarchy;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.user.UserAccount.CardType;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

@Service
@Slf4j
public class OrderChannelServiceImpl implements OrderChannelService {
	@Resource
	private CouponService couponService;
	@Resource
	private CouPonInfService couPonInfService;
	@Resource
	private IdGenarator idGenarator;
	@Resource
	private TblOrderMainService tblOrderMainService;
	@Resource
	private PayService payService;
	@Resource
	private PaymentService paymentService;
	@Resource
	private OrderService orderService;
	@Resource
	private RestOrderService restOrderService;
	@Resource
	private UserService userService;
	@Resource
	private GoodsDetailService goodsDetailService;
	@Autowired
    private SpuService spuService;
	@Autowired
    private BackCategoryHierarchy backCategoryHierarchy;

    @Override
    public UserInfo getUserByCertNo(String certNo) {
		QueryUserInfo info = new QueryUserInfo();
		info.setCertNo(certNo);
		UserInfo userInfo = userService.getCousrtomInfo(info);
		return userInfo;
    }

    @Override
    public Boolean checkThreeCard(String goodsCode, String cardNo){
    	User user = new User();
    	if("C".equalsIgnoreCase(getCardType(cardNo))){
    		UserAccount userAccount = new UserAccount();
    		userAccount.setCardNo(cardNo);
    		userAccount.setCardType(CardType.CREDIT_CARD);
    		user.setAccountList(Lists.newArrayList(userAccount));
    	}
    	Response<Boolean> response = goodsDetailService.checkThreeCard(goodsCode, user);
    	if(response.isSuccess() && response.getResult()){//卡板符合
    		return true;
    	}
    	return false;
    }
    
	@Override
	public List<CouponInfo> queryCouponInfo(String couponId, UserInfo user, GoodsModel goodsModel, BigDecimal couponPrice,
			boolean isNearPastDueFlag) {
		List<CouponInfo> couponInfoList = new ArrayList<>();
		int totalCount = 1;// 总页数
		QueryCouponInfo info = new QueryCouponInfo();
		for (int curPage = 0; curPage < totalCount; curPage++) {
			info.setChannel(Contants.CHANNEL_BC);
			info.setRowsPage("10");// 10条数据
			info.setCurrentPage(String.valueOf(curPage));// 请求页数
			info.setQryType("01");
			info.setContIdType(user.getCertType());
			info.setContIdCard(user.getCertNo());
			if (!Strings.isNullOrEmpty(couponId)) {
				info.setProjectNO(couponId);
			}
			info.setUseState(Byte.valueOf("2"));
			info.setPastDueState(Byte.valueOf("1"));
			try {
				QueryCouponInfoResult queryCouponInfoResult = couponService.queryCouponInfo(info);
				List<CouponInfo> couponInfos = queryCouponInfoResult.getCouponInfos();
				// couponInfoList.addAll(couponInfos);
				String projectNo = "";// 优惠券项目编号 优惠券大类
				String privilegeMoney = "";// 优惠券金额
				String limitMoney = "";// 订单下限金额
				if (null != couponInfos && couponInfos.size() > 0) {
					for (int index = 0; index < couponInfos.size(); index++) {
						CouponInfo couponInfo = couponInfos.get(index);
						projectNo = couponInfo.getProjectNO();
						privilegeMoney = String.valueOf(couponInfo.getPrivilegeMoney());
						limitMoney = String.valueOf(couponInfo.getLimitMoney());
						if (0 == index) {
							if (Integer.parseInt(queryCouponInfoResult.getTotalPages()) % 10 != 0) {// 计算总页数
								totalCount = Integer.parseInt(queryCouponInfoResult.getTotalPages()) / 10 + 1;
							} else {
								totalCount = Integer.parseInt(queryCouponInfoResult.getTotalPages()) / 10;
							}
						}

						// 筛选优惠券金额，couponPrice不为null
						if (isNearPastDueFlag) {
							// 优惠券金额为空 或 优惠券金额不符
							if (Strings.isNullOrEmpty(privilegeMoney)
									|| 0 != couponPrice.compareTo(new BigDecimal(privilegeMoney))) {
								continue;
							}
						}
						// 过滤 “限额小于优惠券金额”的优惠券
						try {
							// 订单下限金额 小于 优惠券金额
							if (Strings.isNullOrEmpty(privilegeMoney) || Strings.isNullOrEmpty(limitMoney)
									|| new BigDecimal(limitMoney).compareTo(new BigDecimal(privilegeMoney)) < 0) {
								continue;
							}
						} catch (Exception e) {
							log.error("比较 订单下限金额 优惠券金额 异常:" + e.getMessage(), e);
							continue;
						}

						if (!Strings.isNullOrEmpty(projectNo)) {
							if (isAvilable(goodsModel, projectNo)) {// 优惠券符合当前项目
								if (isNearPastDueFlag && null != couponPrice) {// 最近过期优惠券
									if (dealNearPastDueCoupon(couponInfoList, couponInfo)) {
										couponInfoList.clear();
										couponInfoList.add(couponInfo);
									}
								} else {
									couponInfoList.add(couponInfo);
								}
							}
						}
					}
				}
			} catch (Exception e) {
				log.error("queryCoupon fail:", e);
			}
		}
		return couponInfoList;
	}

	/**
	 * 根据商品编码以及项目编号 判断该优惠券是否适合该商品
	 * 
	 * @param goodsModel
	 * @param projectNO
	 * @return
	 */
	private boolean isAvilable(GoodsModel goodsModel, String projectNO) {
		Response<CouponInfModel> response = couPonInfService.findByCouponId(projectNO);
		CouponInfModel couponInfModel = response.getResult();
		if (goodsModel != null && couponInfModel != null) {
			String backCategoryIds = Strings.nullToEmpty(couponInfModel.getBackCategoryId());// 后台类目ids
			String brandIds = Strings.nullToEmpty(couponInfModel.getBrandId());// 品牌ids
			String goodsIds = Strings.nullToEmpty(couponInfModel.getGoodsId());// 商品ids
			String vendor_ids = Strings.nullToEmpty(couponInfModel.getVendorId());// 供应商IDs
			
			List<BackCategory> backCategories = null;
			try{
				Response<Spu> spuR = spuService.findById(goodsModel.getProductId());
		        Long cateGoryId = spuR.getResult().getCategoryId();
		        backCategories = backCategoryHierarchy.ancestorsOf(cateGoryId);
			}catch(Exception e){
				log.error("failed to find good's categorys by spuId,spuId:{},cause:{}", goodsModel.getProductId(), Throwables.getStackTraceAsString(e));
			}
			
			String goodsBrandId = Long.toString(goodsModel.getGoodsBrandId());// 品牌id
			String code = goodsModel.getCode();// 商品id
			String vendor_id = goodsModel.getVendorId();// 合作商ID
			if (vendor_ids.indexOf(vendor_id) != -1) {// 如果供应商ID为空则表明没有限制
				return true;
			}			
			if(backCategories != null && !backCategories.isEmpty()){// 类目
				for(BackCategory backCategory : backCategories){
					if(backCategoryIds.indexOf(backCategory.getId().toString()) != -1){// 优惠券类目包含商品类目
						return true;
					}
				}
			}
			if (brandIds.indexOf(goodsBrandId) != -1) {// 优惠券品牌包含商品品牌
				return true;
			}
			if (goodsIds.indexOf(code) != -1) {// 优惠券商品id包含商品id
				return true;
			}
		} else {// 如果后台没有做大类的绑定，则全场可用
			return true;
		}
		return false;
	}

	/**
	 * 添加快过期的优惠券
	 * 
	 * @param couponList
	 * @param couponInfo
	 * @return
	 */
	private boolean dealNearPastDueCoupon(List<CouponInfo> couponList, CouponInfo couponInfo) {
		String endDay = couponInfo.getEndDate();// 优惠券结束时间
		String privilegeId = couponInfo.getPrivilegeId();// 优惠券id
		if (!Strings.isNullOrEmpty(endDay)) {
			if (couponList.isEmpty()) {// 如果优惠券列表为空
				return true;
			}

			CouponInfo tempCoupon = couponList.get(0);
			if (tempCoupon == null) {
				return true;
			}

			// 列表有优惠券
			String tempEndDay = tempCoupon.getEndDate();
			String tempPrivilegeId = tempCoupon.getPrivilegeId();
			if (!Strings.isNullOrEmpty(tempEndDay)) {
				try {
					Date tempEndDayLong = DateHelper.string2Date(tempEndDay, "yyyyMMdd");
					Date endDayLong = DateHelper.string2Date(endDay, "yyyyMMdd");
					if (tempEndDayLong.after(endDayLong)) {// 如果列表中优惠券结束时间比当前优惠券要晚，则移除优惠券
						return true;
					} else if (tempEndDayLong.equals(endDayLong)) {// 如果结束时间相等，取优惠券ID小的
						if (!Strings.isNullOrEmpty(tempPrivilegeId) && !Strings.isNullOrEmpty(privilegeId)) {
							if (privilegeId.length() == tempPrivilegeId.length()) {
								if (privilegeId.compareTo(tempPrivilegeId) < 0) {// 当前优惠券id长度小于列表里优惠券
									return true;
								}
							} else if (privilegeId.length() < tempPrivilegeId.length()) {// 当前优惠券id长度小于列表里优惠券
								return true;
							}
						}
					}
				} catch (Exception e) {
					log.error("compare coupon time fail:" + e.getMessage(), e);
				}
			}

		}

		return false;
	}

	/**
	 * 支付（优惠券订单）
	 * 
	 * @param orderMainModel
	 * @param orderSubModels
	 * @return
	 * @throws Exception
	 */
	public List<OrderSubModel> payFQOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModels, String validDate){
		List<OrderSubModel> successOrderSubModels = Lists.newArrayList();
		List<String> failOrderIds = Lists.newArrayList();// 优惠券、积分支付失败的List
		if (null == orderSubModels || orderSubModels.isEmpty()) {
			return successOrderSubModels;
		}
		String retCode = "";
		try {
			//=============支付===============
			ChannelPayResult channelPayResult = doPayChannel(orderMainModel, orderSubModels, validDate);
			retCode = channelPayResult.getRetCode();
			String retOrders = channelPayResult.getOrders();
			String payTime = channelPayResult.getPayTime();
			
			//============处理返回结果=============
			if (!MallReturnCode.RETURN_SUCCESS_CODE.equals(retCode)) {// 如果电子支付返回的不是000000，则所有小订单均是支付失败
				for (OrderSubModel order : orderSubModels) {
					failOrderIds.add(order.getOrderId());
					if (!Strings.isNullOrEmpty(payTime)) {						
						order.setOrder_succ_time(DateHelper.string2Date(payTime, DateHelper.YYYYMMDDHHMMSS));
						order.setOrder_succ_timeStr(DateHelper.date2string(order.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
						orderMainModel.setPayResultTime(payTime);
					}else {
						if (orderMainModel != null && orderMainModel.getCreateTime() != null){
							order.setOrder_succ_time(orderMainModel.getCreateTime());
							order.setOrder_succ_timeStr(DateHelper.date2string(order.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
							orderMainModel.setPayResultTime(DateHelper.date2string(orderMainModel.getCreateTime(),DateHelper.YYYYMMDDHHMMSS));
						}else{
							order.setOrder_succ_time(new Date());
							order.setOrder_succ_timeStr(DateHelper.date2string(order.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
							orderMainModel.setPayResultTime(DateHelper.date2string(new Date(),DateHelper.YYYYMMDDHHMMSS));
						}
					}
				}
			} else {
				log.info("大订单号[" + orderMainModel.getOrdermainId() + "]电子支付返回时间：{}" , payTime);
				List<Map<String, String>> orderResults = paraOrders(retOrders);
				//将orderSubModels转换为Map，方便取值
				Map<String, OrderSubModel> orderMap = Maps.uniqueIndex(orderSubModels, new Function<OrderSubModel, String>(){
					@Override
					@Nullable
					public String apply(@Nullable OrderSubModel input) {
						return input.getOrderId();
					}
				});
				for (Map<String, String> orderResult : orderResults) {
					String orderId = orderResult.get("orderId");
					if ("01".equals(orderResult.get("result"))) {// 优惠券支付成功
						OrderSubModel orderSubModel = orderMap.get(orderId);
						if(orderSubModel.getBonusTotalvalue() != null && orderSubModel.getBonusTotalvalue() != 0){
							if (!Strings.isNullOrEmpty(payTime)) {
								orderSubModel.setOrder_succ_time(DateHelper.string2Date(payTime, DateHelper.YYYYMMDDHHMMSS));
								orderSubModel.setOrder_succ_timeStr(DateHelper.date2string(orderSubModel.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
								orderMainModel.setPayResultTime(payTime);
							}else {
								if (orderMainModel != null && orderMainModel.getCreateTime() != null){
									orderSubModel.setOrder_succ_time(orderMainModel.getCreateTime());
									orderSubModel.setOrder_succ_timeStr(DateHelper.date2string(orderSubModel.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
									orderMainModel.setPayResultTime(DateHelper.date2string(orderMainModel.getCreateTime(),DateHelper.YYYYMMDDHHMMSS));
								}else{
									orderSubModel.setOrder_succ_time(new Date());
									orderSubModel.setOrder_succ_timeStr(DateHelper.date2string(orderSubModel.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
									orderMainModel.setPayResultTime(DateHelper.date2string(new Date(),DateHelper.YYYYMMDDHHMMSS));
								}
							}
						}
						successOrderSubModels.add(orderSubModel);
					} else {
						failOrderIds.add(orderId);
					}
				}
			}
		} catch (Exception e) {
			log.error("处理电子支付支付积分、优惠券信息异常：{}", Throwables.getStackTraceAsString(e));
			for (OrderSubModel order : orderSubModels) {// 电子支付返回异常时将所有的订单置为支付失败
				failOrderIds.add(order.getOrderId());
			}
		}
		
		User user = new User(orderMainModel.getCreateOper(), orderMainModel.getContNm());
		if (failOrderIds != null && failOrderIds.size() > 0) {// 支付失败、异常的订单直接置为支付失败
			String doDesc = orderMainModel.getSourceNm() + "广发分期支付";
			if (PayReturnCode.isStateNoSure(retCode)) {// 支付返回状态未明,小订单状态置为“状态未明”
				String cardNo = orderMainModel.getCardno();
				restOrderService.dealNoSureOrderswithTX(failOrderIds, cardNo, getCardType(cardNo), retCode, doDesc);
			} else {
				restOrderService.dealFailOrderswithTx(failOrderIds, orderMainModel.getOrdermainId(),
						orderMainModel.getCardno(), doDesc, user);
			}
		}

		return successOrderSubModels;
	}

	/**
	 * 将电子支付优惠券支付结果以List返回
	 *
	 * @param orders
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, String>> paraOrders(String orders) throws Exception {
		if (orders == null || "".equals(orders)) {
			log.debug("拼xml报文时子订单为空");
			throw new Exception("orders is null");
		}
		if (orders.endsWith("|")) {// 如果最后一个域为空，则加上结束符#以方便处理
			orders = orders + "#";
		}
		log.debug("需要解析的orders:" + orders);
		String[] ordersArray = orders.split("\\|");
		log.debug("ordersArray:" + ordersArray.length);
		List<Map<String, String>> rList = new ArrayList<>();
		if (ordersArray.length % 6 == 0) {
			for (int i = 0; i < ordersArray.length; i = i + 6) {
				log.debug("ordersArray[" + i + "]:" + ordersArray[i]);
				Map<String, String> map = new HashMap<>();
				map.put("tradeSeqNo", ordersArray[i]);
				map.put("merId", ordersArray[i + 1]);
				map.put("orderId", ordersArray[i + 2]);
				map.put("result", ordersArray[i + 3]);
				map.put("errcode", ordersArray[i + 4]);
				String errdesc = ordersArray[i + 5];
				if ("#".equals(ordersArray[i + 5])) {
					errdesc = "";
				}
				map.put("errdesc", errdesc);
				rList.add(map);
			}
		}
		return rList;
	}

	/**
	 * 调用接口MMP011
	 * @param orderMainModel
	 * @param orderSubModels
	 * @param validDate
	 * @return
	 */
	private ChannelPayResult doPayChannel(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModels,
										  String validDate) {
		String orders = "";// 小订单信息串
		for (int i = 0; i < orderSubModels.size(); i++) {
			OrderSubModel order = orderSubModels.get(i);
			if (i == 0) {// 第一个小订单
				orders = order.getOrderIdHost() + "|" + order.getMerId() + "|" + order.getOrderId() + "|" + order.getTotalMoney()
						+ "|" + order.getVoucherNo() + "|" + order.getIntegraltypeId() + "|"
						+ order.getBonusTotalvalue() + "|" + order.getUitdrtamt();
			} else {
				orders = orders + "|" + order.getOrderIdHost() + "|" + order.getMerId() + "|" + order.getOrderId() + "|"
						+ order.getTotalMoney() + "|" + order.getVoucherNo() + "|" + order.getIntegraltypeId() + "|"
						+ order.getBonusTotalvalue() + "|" + order.getUitdrtamt();
			}
		}

		ChannelPayInfo channelPayInfo = new ChannelPayInfo();

		channelPayInfo.setTradeSeqNo(orderMainModel.getSerialNo());
		channelPayInfo.setMerId(orderMainModel.getMerId());
		channelPayInfo.setOrderId(orderMainModel.getOrdermainId());
		channelPayInfo.setAccountNo(orderMainModel.getCardno());
		channelPayInfo.setCertType(orderMainModel.getContIdType());
		channelPayInfo.setCertNo(orderMainModel.getContIdcard());
		channelPayInfo.setCurType("CNY");
		channelPayInfo.setCvv2("");
		if(Strings.isNullOrEmpty(validDate)){//validDate没有默认为"0000"
			validDate = "0000";
		}
		channelPayInfo.setValidDate(validDate);
		channelPayInfo.setIsMerger("0");
		channelPayInfo.setChannelID(sourceIdChangeToChannel(orderMainModel.getSourceId()));
		channelPayInfo.setTradeDate(DateHelper.getyyyyMMdd(orderMainModel.getCreateTime()));
		channelPayInfo.setTradeTime(DateHelper.getHHmmss(orderMainModel.getCreateTime()));
		channelPayInfo.setOrders(orders);
		channelPayInfo.setRemark("");
		channelPayInfo.setTerminalCode(Contants.TERMINAL_CODE_YG);
		// 调用积分+优惠券支付接口MMP011
		ChannelPayResult channelPayResult = paymentService.channelPay(channelPayInfo);
		return channelPayResult;
	}

	/**
	 * 处理bps分期支付信息
	 * 
	 * @param tblordermain
	 * @param ordersTemp
	 * @param orderExtend1ModelIns
	 */
	@Override
	public void dealFQorderBpswithTX(OrderMainModel tblordermain, List<Map<String, Object>> ordersTemp, List<TblOrderExtend1Model> orderExtend1ModelIns) {
		boolean orderMainFlag = true;
		// 短信优惠券下单 (bps订单回查根据这个标识回查，去过电子支付，只有支付成功的订单才会进来)
		String cashAuthType = "1";// 分期订单电子支付是否已经验证标识 1:电子支付平台已验证

		List<OrderCheckModel> orderCheckList = new ArrayList<OrderCheckModel>(); // 事物用，积分优惠券正交易
		List<OrderSubModel> orderSubList = new ArrayList<OrderSubModel>(); // 事物用，更新子订单
		List<String> goodsIdList = new ArrayList<String>(); // 事物用，回滚商品库存
		List<OrderSubModel> dealPointPoolList = new ArrayList<OrderSubModel>(); // 事物用，回滚积分池
		List<OrderDoDetailModel> orderDoDetailModelList = new ArrayList<OrderDoDetailModel>(); // 事物用,
																								// 订单历史明细
		List<TblOrderExtend1Model> tblOrderExtend1Modelupd = new ArrayList<TblOrderExtend1Model>(); // 事物用，订单扩展表
		for (int i = 0; i < ordersTemp.size(); i++) {
			Map<String, Object> map = (Map<String, Object>) ordersTemp.get(i);
			OrderSubModel orderSubModel = (OrderSubModel) map.get("tblOrder");
			OrderDoDetailModel orderDoDetailModel = null;
			StagingRequestResult stagingRequestResult = (StagingRequestResult) map.get("returnGateWayEnvolopeVo");
			String errorCode = null;
			if (stagingRequestResult != null) {
				errorCode = stagingRequestResult.getErrorCode();
			}
			// 短信优惠券下单,(bps订单回查根据这个标识回查，去过电子支付，只有支付成功的订单才会进来)
			orderSubModel.setCashAuthType(cashAuthType);

			/** 支付成功，插入积分正交易 start */
			String ischeck = "";
			String ispont = "";
			if (!Strings.isNullOrEmpty(orderSubModel.getVoucherNo())) {
				ischeck = "0";
			}
			if (orderSubModel.getBonusTotalvalue() != null && orderSubModel.getBonusTotalvalue().longValue() != 0) {
				ispont = "0";
			}
			if (!"".equals(ispont)) {// 插入积分正交易
				OrderCheckModel orderCheck = getObject(orderSubModel.getOrderId(), "0308", "支付成功", "", ispont);
				orderCheckList.add(orderCheck);
			}
			/** 支付成功，插入积分正交易 end */

			if (stagingRequestResult != null && errorCode != null) {// 如果能正确获取到bps的返回对象
				String approveResult = stagingRequestResult.getApproveResult();
				String followdir = stagingRequestResult.getFollowDir();
				String caseid = stagingRequestResult.getCaseId();
				String specialcust = stagingRequestResult.getSpecialCust();
				String releasetype = stagingRequestResult.getReleaseType();
				String rejectcode = stagingRequestResult.getRejectcode();
				String aprtcode = stagingRequestResult.getAprtcode();
				String ordernbr = stagingRequestResult.getOrdernbr();
				//FIXME: XIEWL:调用完电子支付后的订单，如果order_succ_time 为空，可以将订单创建时间补充,
				//一方面兼容旧支付时间，另一方面可以支持对账生成,以后需要进行代码优化
				if (orderSubModel != null && orderSubModel.getOrder_succ_time() == null) {
					orderSubModel.setOrder_succ_time(tblordermain.getCreateTime());
				}

				tblordermain.setPayResultTime(DateHelper.date2string(tblordermain.getCreateTime(),DateHelper.YYYYMMDDHHMMSS));
				if (BpsReturnCode.isBp0005Sucess(errorCode, approveResult)) {// 如果支付成功
					log.info("分期订单支付成功:{}", orderSubModel.getOrderId());
					orderSubModel.setCurStatusId("0308");
					orderSubModel.setCurStatusNm("支付成功");
					//orderSubModel.setBankNbr(ordernbr);
					/**** 支付成功时插入对账文件表end ****/
					if (!"".equals(ischeck)) {// 插入优惠券正交易
					//返回结果可能是paytime呀不一样是createtime
						OrderCheckModel orderCheck = getObject(orderSubModel.getOrderId(), "0308", "支付成功", ischeck, "");
						orderCheckList.add(orderCheck);
					}
				} else if (BpsReturnCode.isBp0005Dealing(errorCode, approveResult)) {// 如果处理中
					log.info("分期订单处理中:{}", orderSubModel.getOrderId());
					orderSubModel.setCurStatusId("0305");
					orderSubModel.setCurStatusNm("处理中");
				} else if (BpsReturnCode.isBp0005NoSure(errorCode, approveResult)) {// 如果状态未明
					log.info("分期订单状态未明:{}", orderSubModel.getOrderId());
					orderSubModel.setCurStatusId("0316");
					orderSubModel.setCurStatusNm("状态未明");
				} else {
					log.info("分期订单支付失败:{}", orderSubModel.getOrderId());
					goodsIdList.add(orderSubModel.getGoodsId());// 回滚商品数量
					if (orderSubModel.getBonusTotalvalue() != null
							&& orderSubModel.getBonusTotalvalue().longValue() != 0) {
						dealPointPoolList.add(orderSubModel);// 回滚积分池
					}
					orderSubModel.setCurStatusId("0307");
					orderSubModel.setCurStatusNm("支付失败");
					orderMainFlag = false;
					// 电子支付成功，bps失败的负交易 0307 用当前时间
					if (!"".equals(ischeck) || !"".equals(ispont)) {
						String jfRefundSerialno = "";
						if (!"".equals(ispont)) {
							jfRefundSerialno = idGenarator.jfRefundSerialNo();
						}
						OrderCheckModel orderCheck = getObject(orderSubModel.getOrderId(), "0307", "支付失败", ischeck,
								ispont);
						orderCheck.setJfRefundSerialno(jfRefundSerialno);
						orderCheckList.add(orderCheck);
						// 支付成功，bps失败 插入积分对账负交易
						if (!"".equals(ispont)) {// 如果现金支付失败，且该订单有使用积分，需要调用积分撤销接口
							// 如果BPS经过系统审核立即返回“支付失败”时，商城需要向积分系统发起积分撤销，调用积分系统接口
							// 存在积分需要发起撤销积分
							// 调用主动退积分接口
							try {
								sendNSCT009(orderSubModel, orderCheck.getDoDate(), orderCheck.getDoTime(),
										jfRefundSerialno);
							} catch (Exception se) {
								log.error("短信分期支付失败,主动退积分失败:{}", se.getMessage());
							}
						}
					}
				}
				// 插入历史记录
				orderDoDetailModel = createOrderDoDetailModel(orderSubModel);
				// 更新扩展表
				TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
				tblOrderExtend1.setOrderId(orderSubModel.getOrderId());
				tblOrderExtend1.setErrorcode(errorCode);
				tblOrderExtend1.setApproveresult(approveResult);
				tblOrderExtend1.setFollowdir(followdir);
				tblOrderExtend1.setCaseid(caseid);
				tblOrderExtend1.setSpecialcust(specialcust);
				tblOrderExtend1.setReleasetype(releasetype);
				tblOrderExtend1.setRejectcode(rejectcode);
				tblOrderExtend1.setAprtcode(aprtcode);
				tblOrderExtend1.setOrdernbr(ordernbr);
				tblOrderExtend1Modelupd.add(tblOrderExtend1);
			} else {// 如果returnGateWayEnvolopeVo==null,返回状态未明
				log.info("分期订单状态未明:{}", orderSubModel.getOrderId());
				orderSubModel.setCurStatusId("0316");
				orderSubModel.setCurStatusNm("状态未明");
				// 插入历史记录
				orderDoDetailModel = createOrderDoDetailModel(orderSubModel);
			}
			orderSubList.add(orderSubModel);
			orderDoDetailModelList.add(orderDoDetailModel);
		}

		Response<OrderMainModel> orderMainModelResponse = tblOrderMainService.findByOrderMainId(tblordermain
				.getOrdermainId());
		OrderMainModel orderMainModel = null;

		if (orderMainModelResponse.isSuccess()) {
			orderMainModel = orderMainModelResponse.getResult();
		}
		if (orderMainModel != null) {
			if (orderMainFlag && ordersTemp.size() > 0) {// 大订单成功
				orderMainModel.setCurStatusId("0308");
				orderMainModel.setCurStatusNm("支付成功");
			} else {// 大订单异常
				orderMainModel.setCurStatusId("0307");
				orderMainModel.setCurStatusNm("支付失败");
			}
		}
		try {
			payService.dealFQorderBpswithTX(orderMainModel, orderSubList, orderCheckList, goodsIdList,
					dealPointPoolList, tblOrderExtend1Modelupd, orderExtend1ModelIns, orderDoDetailModelList);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * 发起撤销积分申请
	 * 
	 * @param order
	 * @param curDate
	 *            撤销日期
	 * @param curTime
	 *            撤销时间
	 * @param jfRefundSerialno
	 *            撤销流水 jfRefundSerialno退积分流水
	 */
	private BaseResult sendNSCT009(OrderSubModel order, String curDate, String curTime, String jfRefundSerialno)
			throws Exception {
		// bsp分期失败需要调用积分撤销接口
		log.info("开始获取nTNSCT009bean");
		ReturnPointsInfo gateWayEnvolopeVo = new ReturnPointsInfo();

		gateWayEnvolopeVo.setChannelID(sourceIdChangeToChannel(order.getSourceId()));// 渠道标识
		gateWayEnvolopeVo.setMerId(order.getMerId()); // 大商户号(商城商户号)
		gateWayEnvolopeVo.setOrderId(order.getOrderId()); // 订单号(小)
		String consumeTypeStr = "1";
		if (order.getVoucherNo() != null && !"".equals(order.getVoucherNo().trim())) {
			consumeTypeStr = "2";
		}
		gateWayEnvolopeVo.setConsumeType(consumeTypeStr); // 消费类型("0":纯积分(这里不存在)\"1":积分+现金\"2":积分+现金+优惠券)
		gateWayEnvolopeVo.setCurrency("CNY"); // 币种
		gateWayEnvolopeVo.setTranDate(curDate); // 发起方日期(当前日期)
		gateWayEnvolopeVo.setTranTiem(curTime); // 发起方时间(当前时间)
		gateWayEnvolopeVo.setTradeSeqNo(jfRefundSerialno);// 发起方流水号
		gateWayEnvolopeVo.setSendDate(DateHelper.getyyyyMMdd(order.getOrder_succ_time())); // 原发起方日期
		gateWayEnvolopeVo.setSendTime(DateHelper.getHHmmss(order.getOrder_succ_time())); // 原发起方时间
		gateWayEnvolopeVo.setSerialNo(order.getOrderIdHost()); // 原发起方流水号
		gateWayEnvolopeVo.setCardNo(order.getCardno()); // 卡号
		gateWayEnvolopeVo.setExpiryDate("0000"); // 卡片有效期
		gateWayEnvolopeVo.setPayMomey(new BigDecimal(0)); // 现金支付金额(默认送0)
		gateWayEnvolopeVo.setJgId(Contants.JGID_COMMON); // 积分类型
		gateWayEnvolopeVo.setDecrementAmt(order.getBonusTotalvalue()); // 扣减积分额
		gateWayEnvolopeVo.setTerminalNo("01"); // 终端号("01"广发商城，"02"积分商城)
		BaseResult baseResult = paymentService.returnPoint(gateWayEnvolopeVo);
		return baseResult;
	}

	/**
	 * 获取优惠券对账文件表对象
	 * 
	 * @param orderId
	 * @param curStatusId
	 * @param curStatusNm
	 * @param ischeck
	 *            1代表优惠券需要出对账文件，2代表积分需要出对账文件
	 * @return
	 */
	private OrderCheckModel getObject(String orderId, String curStatusId, String curStatusNm, String ischeck,
			String ispoint) {
		OrderCheckModel orderCheck = new OrderCheckModel();
		orderCheck.setOrderId(orderId);
		orderCheck.setCurStatusId(curStatusId);
		orderCheck.setCurStatusNm(curStatusNm);
		orderCheck.setDoDate(DateHelper.getyyyyMMdd());
		orderCheck.setDoTime(DateHelper.getHHmmss());
		orderCheck.setIscheck(ischeck);
		orderCheck.setIspoint(ispoint);
		orderCheck.setDelFlag(0);
		orderCheck.setCreateOper("orderChannel");
		orderCheck.setModifyOper("orderChannel");
		return orderCheck;
	}

	/**
	 * 生成订单记录
	 * 
	 * @param orderSubModel
	 * @return
	 */
	private OrderDoDetailModel createOrderDoDetailModel(OrderSubModel orderSubModel) {
		OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
		orderDoDetailModel.setOrderId((orderSubModel.getOrderId()));
		orderDoDetailModel.setDoTime(new Date());
		orderDoDetailModel.setDoUserid("System");
		orderDoDetailModel.setUserType("0");
		orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
		orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
		orderDoDetailModel.setMsgContent("");
		orderDoDetailModel.setDoDesc(orderSubModel.getSourceNm() + "广发分期支付");
		orderDoDetailModel.setRuleId("");
		orderDoDetailModel.setRuleNm("");
		orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());
		orderDoDetailModel.setDelFlag(0);
		orderDoDetailModel.setCreateTime(new Date());
		return orderDoDetailModel;
	}

	/**
	 * <p>
	 * Description:上送积分系统渠道标志转换
	 * </p>
	 * 
	 * @param sourceId
	 * @return
	 */
	private String sourceIdChangeToChannel(String sourceId) {
		if (Contants.SOURCE_ID_MALL.equals(sourceId)) {
			return Contants.SOURCE_ID_MALL_TYPY;
		}
		if (Contants.SOURCE_ID_CC.equals(sourceId)) {
			return Contants.SOURCE_ID_CC_TYPY;
		}
		if (Contants.SOURCE_ID_IVR.equals(sourceId)) {
			return Contants.SOURCE_ID_IVR_TYPY;
		}
		if (Contants.SOURCE_ID_CELL.equals(sourceId)) {
			return Contants.SOURCE_ID_CELL_TYPY;
		}
		if (Contants.SOURCE_ID_MESSAGE.equals(sourceId)) {
			return Contants.SOURCE_ID_MESSAGE_TYPY;
		}
		if (Contants.SOURCE_ID_WX_BANK.equals(sourceId) || Contants.SOURCE_ID_WX_CARD.equals(sourceId)) {
			return Contants.SOURCE_ID_WX_TYPY;
		}
		if (Contants.SOURCE_ID_APP.equals(sourceId)){
			return Contants.SOURCE_ID_APP_TYPY;
		}
		return Contants.SOURCE_ID_MALL_TYPY;
	}
	
	/**
     * 获取帐号类型 C：信用卡  Y：借记卡 W：未明
     *
     * @param account
     * @return
     */
    private String getCardType(String account) {
        if (account == null || "".equals(account.trim())) {
            return "";
        } else if (account.trim().length() == 16) {// 信用卡
            return "C";
        } else {//未明
            return "W";
        }
    }

	@Override
	public BaseResult doPayJF(OrderMainModel orderMainModel, String validDate) {
		String amount = orderMainModel.getTotalPrice().toString();
		String accountNo = orderMainModel.getCardno();
		if ("0.00".equals(amount) || "0".equals(amount)) {// 纯积分支付
			amount = "0";
			accountNo = "";
		}

		CCPointsPay ccPointsPay = new CCPointsPay();
		ccPointsPay.setTradeSeqNo(orderMainModel.getSerialNo());
		ccPointsPay.setOrderId(orderMainModel.getOrdermainId());
		ccPointsPay.setAccountNo(accountNo);
		ccPointsPay.setAmount(amount);
		ccPointsPay.setCurType("156");
		ccPointsPay.setCvv2("");
		ccPointsPay.setValidDate(validDate);
		ccPointsPay.setMerId(orderMainModel.getMerId());
		ccPointsPay.setTradeStatus("0");
		ccPointsPay.setIsMerger(orderMainModel.getIsmerge());
		ccPointsPay.setTradeDate(DateHelper.date2string(orderMainModel.getCreateTime(), "yyyyMMdd"));
		ccPointsPay.setTradeTime(DateHelper.date2string(orderMainModel.getCreateTime(), "HHmmss"));
		ccPointsPay.setRemark("");
		ccPointsPay.setChannelID(sourceIdChangeToChannel(orderMainModel.getSourceId()));
		ccPointsPay.setFracCardCount("1");
		// ccPointsPay.setTerminalCode("02");
		List<CCPointsPayBaseInfo> ccPointsPayBaseInfos = Lists.newArrayList();
		CCPointsPayBaseInfo ccPointsPayBaseInfo = new CCPointsPayBaseInfo();
		ccPointsPayBaseInfo.setFracCardNo(orderMainModel.getCardno());
		ccPointsPayBaseInfo.setFracAmount(orderMainModel.getTotalBonus().toString());
		ccPointsPayBaseInfo.setFracType(orderMainModel.getIntegraltypeId());
		ccPointsPayBaseInfo.setFracValidDate(validDate);
		ccPointsPayBaseInfos.add(ccPointsPayBaseInfo);
		ccPointsPay.setCcPointsPayBaseInfos(ccPointsPayBaseInfos);

		BaseResult baseResult = paymentService.ccPointsPay(ccPointsPay);
		return baseResult;
	}
}
