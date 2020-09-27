package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.PayReturnCode;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.EspAreaInfService;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.related.service.CfgProCodeService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.PriceLevelVo;
import cn.com.cgbchina.rest.provider.vo.order.WXOrderAddByIntergralQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.WXOrderAddByIntergralReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.WeChatVo;
import cn.com.cgbchina.rest.visit.model.payment.CCPointResult;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPay;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPayBaseInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import cn.com.cgbchina.trade.service.*;
import cn.com.cgbchina.trade.vo.CustLevelInfo;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.xmlbeans.SystemProperties;
import org.elasticsearch.common.base.Strings;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.*;

/**
 * MAL501 微信生成订单接口（积分） 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL501")
@Slf4j
public class WXOrderAddByIntergralProvideServiceImpl
		implements SoapProvideService<WXOrderAddByIntergralQueryVO, WXOrderAddByIntergralReturnVO> {

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Resource
	BusinessService businessService;
	@Resource
	ItemService itemService;
	@Resource
	GoodsService goodsService;
	@Resource
	EspAreaInfService espAreaInfService;
	@Resource
	VendorService vendorService;
	@Resource
	PriceSystemService priceSystemService;
	@Resource
	CfgProCodeService cfgProCodeService;
	@Resource
	LocalCardRelateService localCardRelateService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	UserService userService;
	@Resource
	IdGenarator idGenarator;
	@Resource
	OrderService orderService;
	@Resource
	TblOrderMainService tblOrderMainService;
	@Resource
	PointService pointService;
	@Resource
	OrderCheckService orderCheckService;
	@Resource
	OrderOutSystemService orderOutSystemService;
	@Resource
	PaymentService paymentService;
	@Resource
	private PriorJudgeService priorJudgeService;

	@Value("#{app.merchId}")
	private String merId;

	@Override
	public WXOrderAddByIntergralReturnVO process(SoapModel<WXOrderAddByIntergralQueryVO> model,
			WXOrderAddByIntergralQueryVO content) {
		WXOrderAddByIntergralReturnVO wXOrderAddByIntergralReturnVO = new WXOrderAddByIntergralReturnVO();
		WXOrderAddByIntergralReturnVO wXOrderAddByIntergralReturnError = new WXOrderAddByIntergralReturnVO();

		log.info("【MAL501】流水：" + model.getSenderSN() + "，进入微信下单接口");

		/********* 支付起停控制begin *********/
		if (!isQT("YG", Contants.PROMOTION_SOURCE_ID_05)) {
			log.info("【MAL501】流水：" + model.getSenderSN() + "该渠道不允许支付");
			return commonErrorMsg("000076", "该渠道不允许支付");
		}
		/********* 支付起停控制end *********/

		String curDate = DateHelper.getyyyyMMdd();
		String curTime = DateHelper.getHHmmss();
		// Y必填 N可空
		// 报文内容vo
		WeChatVo weChatVo = new WeChatVo();
		// Y 渠道 微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS
		weChatVo.setChannelSN(StringUtils.dealNull(content.getChannelSN()));
		// Y 客户姓名
		weChatVo.setCustName(StringUtils.dealNull(content.getCustName()));
		// Y 证件号码
		weChatVo.setContIdCard(StringUtils.dealNull(content.getContIdCard()));
		// Y 证件类型
		weChatVo.setContIdType(StringUtils.dealNull(content.getContIdType()));
		// N 收货人姓名
		weChatVo.setCsgName(StringUtils.dealNull(content.getCsgName()));
		// N 收货人手机
		weChatVo.setCsgMoblie(StringUtils.dealNull(content.getCsgMoblie()));
		// N 收货人固话
		weChatVo.setCsgPhone(StringUtils.dealNull(content.getCsgPhone()));
		// N 省
		weChatVo.setCsgProvince(StringUtils.dealNull(content.getCsgProvince()));
		// N 市
		weChatVo.setCsgCity(StringUtils.dealNull(content.getCsgCity()));
		// N 区
		weChatVo.setCsgBorough(StringUtils.dealNull(content.getCsgBorough()));
		// N 街道详细地址
		weChatVo.setCsgAddress(StringUtils.dealNull(content.getCsgAddress()));
		// N 邮政编码
		weChatVo.setDeliveryPost(StringUtils.dealNull(content.getDeliveryPost()));
		// Y 卡号
		weChatVo.setCardNo(StringUtils.dealNull(content.getCardNo()));
		// N 卡板
		weChatVo.setFormatId(StringUtils.dealNull(content.getFormatId()));
		// N 积分类型
		weChatVo.setIntergralType(StringUtils.dealNull(content.getIntergralType()));
		// N 积分类型中文名称
		weChatVo.setJfTypeName(StringUtils.dealNull(content.getJfTypeName()));
		// Y 卡有效期
		weChatVo.setValidDate(StringUtils.dealNull(content.getValidDate()));
		// Y 送货时间(默认选取01) 01: 工作日、双休日与假日均可送货 02: 只有工作日送货（双休日、假日不用送） 03: 只有双休日、假日送货（工作日不用送货）
		weChatVo.setSendTime(StringUtils.dealNull(content.getSendTime()));
		// N 备注
		weChatVo.setOrdermainDesc(StringUtils.dealNull(content.getOrdermainDesc()));
		// Y 是否积分+现金支付 0:是 1:否
		weChatVo.setIs_money(StringUtils.dealNull(content.getIsMoney()));
		// Y 是否合并支付 0:合并 1:非合并（默认）
		weChatVo.setIs_merge(StringUtils.dealNull(content.getIsMerge()));
		// Y 商品编码 5位
		weChatVo.setGoods_xid(StringUtils.dealNull(content.getGoodsId()));
		// Y 商品数量 2位
		weChatVo.setGoodsNm(StringUtils.dealNull(content.getGoodsNm()));

		log.info("channelSN:" + weChatVo.getChannelSN() + ",goodsId:" + weChatVo.getGoods_xid() + ",custName:"
				+ weChatVo.getCustName() + ",carNo:" + weChatVo.getCardNo());

		// WX 广发微信，
		// WS广发信用卡微信,
		// 03手机--增加手机渠道，广发EASY GO APP信用卡积分扣减相关需求
		if (Contants.CHANNEL_SN_WX.equals(weChatVo.getChannelSN())
				|| Contants.CHANNEL_SN_WS.equals(weChatVo.getChannelSN())
				|| Contants.SOURCE_ID_CELL.equals(weChatVo.getChannelSN())) {
			// 对应上架状态
			try {
				// 检查/设置默认值
				if (0 == weChatVo.getIs_merge().length()) {
					log.info("'是否合并支付'为空，设置默认值1");
					weChatVo.setIs_merge(Contants.IS_MERGE_NO);// 1 非合并
				}
				if (0 == weChatVo.getSendTime().length()) {
					log.info("送货时间为空，设置默认值01");
					weChatVo.setSendTime("01");// (默认选取01) 01: 工作日、双休日与假日均可送货
				}
				Response<ItemModel> itemModelResponse = itemService.findItemByXid(weChatVo.getGoods_xid());
				if (!itemModelResponse.isSuccess()) {
					throw new RuntimeException(itemModelResponse.getError());
				}
				ItemModel itemModel = itemModelResponse.getResult();
				if (itemModel == null || itemModel.getCode() == null) {
					log.info("找不到礼品:" + weChatVo.getGoods_xid());
					return commonErrorMsg("000010", "找不到礼品");
				}
				Map<String, Object> paramaMap = Maps.newHashMap();
				Response<GoodsModel> goodsModelResponse = goodsService.findById(itemModel.getGoodsCode());
				if (!goodsModelResponse.isSuccess()) {
					throw new RuntimeException(goodsModelResponse.getError());
				}
				GoodsModel goodsModel = goodsModelResponse.getResult();
				paramaMap.put("areaId", goodsModel.getRegionType());
				Response<EspAreaInfModel> areaInfModelResponse = espAreaInfService.findByAreaId(paramaMap);
				if (!areaInfModelResponse.isSuccess()) {
					throw new RuntimeException(areaInfModelResponse.getError());
				}
				EspAreaInfModel espAreaInf = areaInfModelResponse.getResult();
				if (espAreaInf == null) {
					log.info("找不到礼品:" + weChatVo.getGoods_xid());
					return commonErrorMsg("000010", "找不到礼品");
				}
				Response<VendorInfoModel> vendorInfoModelResponse = vendorService
						.findVendorInfosByVendorId(goodsModel.getVendorId());
				if (!vendorInfoModelResponse.isSuccess()) {
					throw new RuntimeException(vendorInfoModelResponse.getError());
				}
				VendorInfoModel vendorInfo = vendorInfoModelResponse.getResult();
				if (vendorInfo == null) {
					log.info("找不到礼品:" + weChatVo.getGoods_xid());
					return commonErrorMsg("000010", "找不到礼品");
				}
				// 礼品编码
				String goods_id = StringUtils.dealNull(itemModel.getCode());
				String integral_type = StringUtils.dealNull(goodsModel.getPointsType()); // 积分类型
				// 根据卡号,礼品编码拿到ODS以及积分系统的数据VO
				PriceLevelVo priceLevelVo = getPriceFunc(weChatVo.getCardNo(), weChatVo.getGoods_xid());
				log.info("用户最优等级：" + priceLevelVo.getCustLevel());

				// 校验微信下单/手机数据
				wXOrderAddByIntergralReturnError = checkWeChat(weChatVo, goodsModel, itemModel, espAreaInf,
						integral_type, priceLevelVo);
				if (null != wXOrderAddByIntergralReturnError) {
					return wXOrderAddByIntergralReturnError;
				}

				// 判断卡片等级
				boolean checkcardLevelFlag = priceSystemService.checkCardLevel(goods_id, null, weChatVo.getCardNo());
				if (!checkcardLevelFlag) {
					log.info("【MAL501】流水：" + model.getSenderSN() + ", 客户卡片等级不满足礼品维护的卡片等级");
					return commonErrorMsg("000101", "卡片无法兑换此礼品");
				}

				// 纯积分最优支付方式
				String goodsPaywayId = priceLevelVo.getGoodsPaywayId();

				String create_oper = null;
				if (Contants.SOURCE_ID_CELL.equals(weChatVo.getChannelSN())) {
					// 手机客户端渠道用卡号代替客户号
					create_oper = weChatVo.getCardNo();
				} else {
					// 客户号查询(根据证件号调用个人网银)
					QueryUserInfo queryUserInfo = new QueryUserInfo();
					queryUserInfo.setCertNo(weChatVo.getContIdCard());
					UserInfo userInfo = userService.getCousrtomInfo(queryUserInfo);
					if (userInfo != null && !Strings.isNullOrEmpty(userInfo.getCustomerId())) {
						create_oper = userInfo.getCustomerId();
					}
					if (null == create_oper || create_oper.trim().length() == 0) {
						log.info("客户号为空。");
						create_oper = weChatVo.getContIdCard();
					}
				}

				// 支付方式
				Response<List<TblGoodsPaywayModel>> listResponse = goodsPayWayService.findJxpayway(goods_id,
						goodsPaywayId, weChatVo.getIs_money());
				if (!listResponse.isSuccess()) {
					throw new RuntimeException(listResponse.getError());
				}
				List<TblGoodsPaywayModel> jxpayway = listResponse.getResult();
				if (jxpayway == null || jxpayway.size() == 0) {
					log.info("礼品无此定价 礼品：" + goods_id);
					return commonErrorMsg("000076", "礼品无此定价");
				}
				TblGoodsPaywayModel payway = jxpayway.get(0);

				// 礼品现金定价
				BigDecimal goodsPrice = payway.getGoodsPrice();

				// 礼品积分定价
				Long goodsPoint = payway.getGoodsPoint();

				// 结算价
				BigDecimal calMoney = payway.getCalMoney();

				log.info("交易数量：" + weChatVo.getGoodsNm() + ",现金：" + goodsPrice + ",积分：" + goodsPoint + ",结算价："
						+ calMoney);

				// 最后确定支付的支付方式ID
				String goods_payway_id = StringUtils.dealNull(payway.getGoodsPaywayId());
				// 支付方式 现金，积分，积分+现金
				String payway_code = StringUtils.dealNull(payway.getPaywayCode());
				// 定价级别
				String member_level = StringUtils.dealNull(payway.getMemberLevel());
				// 发货级别
				String custType = getCustType(priceLevelVo.getCustLevel());
				log.info("获取到的 等级：" + custType);
				// 获取大订单表对象
				BigDecimal totalPrice = goodsPrice.multiply(new BigDecimal(weChatVo.getGoodsNm()));
				Long totalPoints = goodsPoint * Long.parseLong(weChatVo.getGoodsNm());
				OrderMainModel orderMain = getTblOrderMain(create_oper, integral_type, totalPrice, totalPoints,
						weChatVo);
				// 组装部分属性的tblGoodsInf供生成小订单使用
				// FIXME 这段代码有必要吗？？
				/*
				 * GoodsModel tblGoods = new GoodsModel(); tblGoods.setCode(goods_id);
				 * tblGoods.setName(StringUtils.dealNull(goodsModel.getName()));
				 * tblGoods.setVendorId(StringUtils.dealNull(goodsModel.getVendorId()));
				 * tblGoods.setCards(StringUtils.dealNull(goodsModel.getCards()));
				 * tblGoods.setAttribute(StringUtils.dealNull(goodsModel.getAttribute()));
				 * tblGoods.setPointsType(StringUtils.dealNull(goodsModel.getPointsType()));
				 */
				// 供应商全称
				String vendor_fnm = StringUtils.dealNull(vendorInfo.getFullName());
				// 供应商对应的小商户号
				String mer_id = StringUtils.dealNull(vendorInfo.getMerId());

				// 生成小订单和dodetail、虚拟礼品表
				Map<String, Object> orderMap = getVirtualOrder(orderMain, goodsModel, vendor_fnm, mer_id,
						goods_payway_id, payway_code, goodsPrice, goodsPoint, calMoney, member_level, custType,
						itemModel);
				if (orderMain == null || orderMap.isEmpty()) {
					throw new Exception("生成订单有误！");
				}
				int backlog = itemModel.getStock().intValue();
				// 是否需要扣减库存标志
				boolean subFlag = true;
				if (backlog >= 9999) {
					subFlag = false;
				}
				Response<Integer> response = orderOutSystemService.saveWXVirtualOrders(orderMain,
						(OrderSubModel) orderMap.get("tblOrder"), (OrderDoDetailModel) orderMap.get("tblOrderDodetail"),
						subFlag, backlog, (OrderVirtualModel) orderMap.get("orderVirtual"));
				if (!response.isSuccess()) {
					log.error("微信下单：{}" + response.getError());
					return commonErrorMsg("000009", "系统繁忙，请稍后再试");
				}

				// 是手机银行过来的请求，下单成功后直接发给电子支付进行支付，支付接口为NSCT016-广发EASY GO APP信用卡积分扣减相关需求
				if (Contants.SOURCE_ID_CELL.equals(weChatVo.getChannelSN())) {
					toPayCellOrder(orderMain, weChatVo, wXOrderAddByIntergralReturnVO, model.getSenderSN());
				} else {
					// 组装返回
					wXOrderAddByIntergralReturnVO.setReturnCode("000000");
					wXOrderAddByIntergralReturnVO.setReturnDes("正常");
					wXOrderAddByIntergralReturnVO.setOrderMainId(orderMain.getOrdermainId());
				}

			} catch (Exception e) {
				log.error("微信下单：" + e.getMessage(), e);
				return commonErrorMsg("000009", "系统繁忙，请稍后再试");
			}
		} else {
			log.info("【MAL501】渠道：" + weChatVo.getChannelSN() + "下单暂不支持");
			return commonErrorMsg("000008", "报文参数错误");
		}
		return wXOrderAddByIntergralReturnVO;
	}

	/**
	 * 支付起停控制
	 */
	private boolean isQT(String ordertypeId, String sourceId) {
		boolean flag = true;
		Response<List<TblParametersModel>> responselistQT = businessService.findJudgeQT(ordertypeId, sourceId);
		if (!responselistQT.isSuccess()) {
			throw new RuntimeException(responselistQT.getError());
		}
		List<TblParametersModel> listQT = responselistQT.getResult();
		if (listQT != null && listQT.size() > 0) {
			TblParametersModel tblParameters = listQT.get(0);
			Integer openCloseFlag = tblParameters.getOpenCloseFlag();
			if (openCloseFlag == 1) {
				flag = false;
			}
		}
		return flag;
	}

	/**
	 * 根据传入参数（卡号、礼品编码），获得最优价格
	 */
	private PriceLevelVo getPriceFunc(String cardNo, String goodsXid) {
		PriceLevelVo plVo = new PriceLevelVo();
		try {
			List<String> custLevelList = Lists.newArrayList();
			// 是否生日
			boolean isBrithday = false;
			// 是否VIP
			boolean isVipFlag = false;
			// 客户级别
			String custLevel = "";
			// 积分系统返回的客户等级
			List<String> bonusCustLevelList = Lists.newArrayList();
			// 积分系统的卡板，顺序与bonusCustLevelList对应
			List<String> bonusCardBroadList = Lists.newArrayList();
			// 积分系统的积分类型，顺序与bonusCustLevelList对应
			List<String> bonusCardjgidList = Lists.newArrayList();
			// 由于积分系统返回的报文包含翻页信息，有可能需要查询多个页面
			int bonusCurPage = 0;
			int bonusTotalPage = 1;
			String cardFormat = "";
			// 接口中所传的卡号对应的积分类型
			List<String> jfType = Lists.newArrayList();
			// 进行翻页查询
			while (bonusCurPage < bonusTotalPage) {
				String bonusCurPageStr;
				if (bonusCurPage < 10) {
					bonusCurPageStr = "000" + bonusCurPage;
				} else if (bonusCurPage < 100) {
					bonusCurPageStr = "00" + bonusCurPage;
				} else if (bonusCurPage < 1000) {
					bonusCurPageStr = "0" + bonusCurPage;
				} else {
					bonusCurPageStr = bonusCurPage + "";
				}
				// 等积分系统正常后读取报文
				QueryPointsInfo queryPointsInfo = new QueryPointsInfo();
				queryPointsInfo.setCardNo(cardNo);
				queryPointsInfo.setCurrentPage(bonusCurPageStr);
				QueryPointResult queryPointResult = pointService.queryPoint(queryPointsInfo);
				List<QueryPointsInfoResult> queryPointsInfoResults = queryPointResult.getQueryPointsInfoResults();
				List<String> queryPointsInfoLevelCodes = Lists.transform(queryPointsInfoResults,
						new Function<QueryPointsInfoResult, String>() {
							@Override
							@Nullable
							public String apply(@Nullable QueryPointsInfoResult i) {
								return i.getLevelCode() == null ? "" : i.getLevelCode();
							}
						});
				bonusCustLevelList.addAll(queryPointsInfoLevelCodes);
				// 大机改造 是否走新流程
				boolean isPractiseRun = orderCheckService.isPractiseRun(cardNo);
				if (isPractiseRun) {
					// 第三产品编码
					List<String> queryPointsInfoProductCodes = Lists.transform(queryPointsInfoResults,
							new Function<QueryPointsInfoResult, String>() {
								@Override
								@Nullable
								public String apply(@Nullable QueryPointsInfoResult i) {
									return i.getProductCode() == null ? "" : i.getProductCode();
								}
							});
					bonusCardBroadList.addAll(queryPointsInfoProductCodes);
				} else {
					// 卡板
					List<String> queryPointsInfoCfprCodes = Lists.transform(queryPointsInfoResults,
							new Function<QueryPointsInfoResult, String>() {
								@Override
								@Nullable
								public String apply(@Nullable QueryPointsInfoResult i) {
									return i.getProductCode() == null ? "" : i.getProductCode();
								}
							});
					bonusCardBroadList.addAll(queryPointsInfoCfprCodes);
				}
				List<String> cardjgIdArray = Lists.transform(queryPointsInfoResults,
						new Function<QueryPointsInfoResult, String>() {
							@Override
							@Nullable
							public String apply(@Nullable QueryPointsInfoResult i) {
								return i.getJgId() == null ? "" : i.getJgId();
							}
						});
				bonusCardjgidList.addAll(cardjgIdArray);
				List<String> cardNoArray = Lists.transform(queryPointsInfoResults,
						new Function<QueryPointsInfoResult, String>() {
							@Override
							@Nullable
							public String apply(@Nullable QueryPointsInfoResult i) {
								return i.getCardNo() == null ? "" : i.getCardNo();
							}
						});
				if (cardNoArray != null) {
					for (int i = 0; i < cardNoArray.size(); i++) {
						if (cardNoArray.get(i).equals(cardNo)) {// 获取当前卡号的积分类型
							jfType.add(cardjgIdArray.get(i));
							cardFormat = bonusCardBroadList.get(i);
						}
					}
				}
				bonusCurPage++;
				String totalPage = queryPointResult.getTotalPages();
				try {
					bonusTotalPage = Integer.parseInt(totalPage.trim());
				} catch (Exception e) {
					log.error("转换总页数时出现异常，积分返回总页数：" + bonusTotalPage);
					log.error(e.getMessage(), e);
				}
			}
			// 通过卡号获取客户证件号
			CustLevelInfo custInfo = priceSystemService.getCustLevelInfoByCard(cardNo);
			if (custInfo == null) {
				// 获取不了用户级别信息,使用原有的积分系统数据判断客户级别
				log.error("Can't find cust level info, cardNo=" + cardNo);
				// 取得生日信息，如果当月生日，则返回生日价
				String custBD = "";
				log.info("从积分系统返回报文中得到生日日期：" + custBD);
				if (custBD != null && !"".equals(custBD)) {
					isBrithday = DateHelper.isBrithDay(custBD);
				}
				// 等积分系统正常后读取报文
				custLevelList = getCustLevelStr(bonusCustLevelList, bonusCardBroadList);

				// VIP客户增加VIP价格
				String isVip = "";
				log.info("从积分系统返回报文中得到VIP字段：isVip =" + isVip);
				if ("0".equals(isVip)) {// 增加VIP等级
					custLevelList.add(Contants.MEMBER_LEVEL_VIP);
					isVipFlag = true;
				}
				custLevel = getMemberLevelByList(custLevelList, isVip);
			} else {
				// 使用南航白金卡那部分数据
				log.info("客户等级信息：certNbr=" + custInfo.getCertNbr() + ", memberLevel=" + custInfo.getMemberLevel()
						+ ", VipTp=" + custInfo.getVipTpCd() + ", birthDay=" + custInfo.getBirthDay() + ", cardLevel="
						+ custInfo.getCardLevelCd() + ",cardboard=" + custInfo.getCardFormatNbr() + ",custBoard="
						+ custInfo.getCustFomat());
				custLevelList = genCustLevelList(custInfo.getMemberLevel());
				custLevel = custInfo.getMemberLevel();
				isBrithday = DateHelper.isBrithDay(custInfo.getBirthDay());
				isVipFlag = custInfo.vipFlag;
				if (custInfo.getCardFormatNbr() != null) {
					cardFormat = StringUtils.dealNull(String.valueOf(custInfo.getCardFormatNbr().get(cardNo)));
				}
				bonusCardBroadList = custInfo.getCustFomat();
			}
			// 商品ID的队列
			Response<ItemModel> itemModelResponse = itemService.findItemByXid(goodsXid);
			if (!itemModelResponse.isSuccess()) {
				throw new RuntimeException(itemModelResponse.getError());
			}
			ItemModel itemModel = itemModelResponse.getResult();
			Response<List<TblGoodsPaywayModel>> listResponse = goodsPayWayService
					.findPaywayByGoodsIds(itemModel.getCode());
			if (!listResponse.isSuccess()) {
				throw new RuntimeException(listResponse.getError());
			}
			List<TblGoodsPaywayModel> paywayList = listResponse.getResult();
			Map<String, Object> jpPrice = getCustTopLevelPaywayBonusMap(paywayList, custLevelList);
			// 组装VO
			plVo.setBirth(isBrithday);
			plVo.setVip(isVipFlag);
			plVo.setCustLevel(custLevel);
			if (!jpPrice.isEmpty()) {
				TblGoodsPaywayModel payway = (TblGoodsPaywayModel) jpPrice.get(itemModel.getCode());
				plVo.setGoodsPaywayId(payway.getGoodsPaywayId());
			}
			plVo.setCardBoard(cardFormat);
			plVo.setCustBoard(bonusCardBroadList);
			plVo.setCardJfType(jfType);
			plVo.setCustJfType(bonusCardjgidList);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return plVo;
	}

	/**
	 * 将积分系统的会员等级转换成商城需要的会员等级
	 */
	private List<String> getCustLevelStr(List<String> bonusCustLevelList, List<String> bonusCardBroadList) {

		Set<String> tempSet = Sets.newHashSet();
		List<String> custLeveList = Lists.newArrayList();

		for (int bonusCount = 0; bonusCount < bonusCustLevelList.size(); bonusCount++) {
			String custLevel = bonusCustLevelList.get(bonusCount);

			if ("4".equals(custLevel)) {// 顶级卡
				tempSet.add(Contants.MEMBER_LEVEL_DJ_CODE);
				break;
			} else if ("3".equals(custLevel)) {// 白金卡
				String cardBroad = bonusCardBroadList.get(bonusCount);
				Response<LocalCardRelateModel> localCardRelateResponse = localCardRelateService
						.findByFormatId(cardBroad);// 先查询卡板信息
				if (localCardRelateResponse.isSuccess()) {
					LocalCardRelateModel localCardRelate = localCardRelateResponse.getResult();
					if (localCardRelate != null && "2".equals(localCardRelate.getProCode())) {
						tempSet.add(Contants.MEMBER_LEVEL_DJ_CODE);// 增值白金
						break;
					} else {
						tempSet.add(Contants.MEMBER_LEVEL_TJ_CODE);// 尊越/臻享白金+钛金卡
					}
				}
			} else if ("2".equals(custLevel)) {// 钛金卡
				tempSet.add(Contants.MEMBER_LEVEL_TJ_CODE);// 尊越/臻享白金+钛金卡
			}
		}

		custLeveList.add(Contants.MEMBER_LEVEL_JP_CODE);// 默认加入金普价
		if (tempSet.contains(Contants.MEMBER_LEVEL_DJ_CODE)) {// 存在顶级卡等级
			custLeveList.add(Contants.MEMBER_LEVEL_DJ_CODE);
			custLeveList.add(Contants.MEMBER_LEVEL_TJ_CODE);
		} else if (tempSet.contains(Contants.MEMBER_LEVEL_TJ_CODE)) {// 存在钛金等级价格
			custLeveList.add(Contants.MEMBER_LEVEL_TJ_CODE);
		}

		return custLeveList;
	}

	/**
	 * 客户级别
	 */
	private String getMemberLevelByList(List<String> list, String vipFlag) throws Exception {
		String custLevel = Contants.MEMBER_LEVEL_JP_CODE;
		for (String memberLevel : list) {
			if (Contants.MEMBER_LEVEL_DJ_CODE.equals(memberLevel)) {
				// 若用户名下有顶级卡,返回顶级卡等级
				return memberLevel;
			} else if (Contants.MEMBER_LEVEL_TJ_CODE.equals(memberLevel)) {
				custLevel = memberLevel;
			} else if (Contants.IS_VIP.equals(vipFlag) && !Contants.MEMBER_LEVEL_TJ_CODE.equals(custLevel)) {
				custLevel = Contants.MEMBER_LEVEL_VIP_CODE;
			}
		}
		return custLevel;
	}

	/**
	 * 根据客户最优等级获得其可享受的等级定价
	 */
	private List<String> genCustLevelList(String custLevel) {
		List<String> lt = Lists.newArrayList();
		if (Contants.MEMBER_LEVEL_DJ_CODE.equals(custLevel)) {
			lt.add(Contants.MEMBER_LEVEL_DJ_CODE);
			lt.add(Contants.MEMBER_LEVEL_TJ_CODE);
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (Contants.MEMBER_LEVEL_TJ_CODE.equals(custLevel)) {
			lt.add(Contants.MEMBER_LEVEL_TJ_CODE);
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (Contants.MEMBER_LEVEL_VIP_CODE.equals(custLevel)) {
			lt.add(Contants.MEMBER_LEVEL_VIP_CODE);
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else {
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		}
		return lt;
	}

	/**
	 * 提取出当前客户最高的客户级别对应的【纯积分】支付方式Map，返回的Map格式为Map<String,TblGoodsPayway>,以goodsId为Key
	 */
	private Map<String, Object> getCustTopLevelPaywayBonusMap(List<TblGoodsPaywayModel> paywayList,
			List<String> custLevelList) {
		Map<String, Object> paywayMap = Maps.newHashMap();
		if (paywayList != null && custLevelList != null)
			for (String memberLevel : custLevelList) {
				// 遍历客户等级集合
				for (TblGoodsPaywayModel payway : paywayList) {
					// 遍历支付信息集合
					if (memberLevel.equals(payway.getMemberLevel())
							&& Contants.PAY_WAY_CODE_JF.equals(payway.getPaywayCode())) {
						// 客户等级与支付等级相等且为纯积分支付方式
						TblGoodsPaywayModel mapPayway = (TblGoodsPaywayModel) paywayMap.get(payway.getGoodsId());
						if (mapPayway == null && memberLevel.equals(payway.getMemberLevel())) {
							// 返回结果集paywayMap里不存在该商品的支付信息
							paywayMap.put(payway.getGoodsId(), payway);
						} else if (mapPayway != null && payway.getGoodsPoint() < mapPayway.getGoodsPoint()) {
							// paywayMap里存在该商品的支付信息但新的支付方式价格更低
							paywayMap.put(payway.getGoodsId(), payway);
						}
					}
				}
			}
		return paywayMap;
	}

	/**
	 * 校验基本信息（必要字段非空，商品信息，不校验积分类型和卡板）
	 */
	public WXOrderAddByIntergralReturnVO checkWeChat(WeChatVo weChatVo, GoodsModel goodsModel, ItemModel itemModel,
			EspAreaInfModel espAreaInf, String integral_type, PriceLevelVo priceLevelVo) {
		// 必要字段空判断
		if (Contants.CHANNEL_SN_WX.equals(weChatVo.getChannelSN())
				|| Contants.CHANNEL_SN_WS.equals(weChatVo.getChannelSN())) {
			// 客户姓名(custName) 、证件号码(contIdCard)、证件类型(contIdType),微信渠道 不能为空,手机客户端渠道可以为空
			// 广发EASY GO APP信用卡积分扣减相关需求
			if (0 == weChatVo.getCustName().length()) {
				log.info("报文参数错误：客户名为空");
				return commonErrorMsg("000008", "报文参数错误：客户名为空");
			}
			if (0 == weChatVo.getContIdCard().length()) {
				log.info("报文参数错误：证件号码为空");
				return commonErrorMsg("000008", "报文参数错误：证件号码为空");
			}
			if (0 == weChatVo.getContIdType().length()) {
				log.info("报文参数错误：证件类型为空");
				return commonErrorMsg("000008", "报文参数错误：证件类型为空");
			}
		}
		if (0 == weChatVo.getCardNo().length()) {
			log.info("报文参数错误：卡号为空");
			return commonErrorMsg("000008", "报文参数错误：卡号为空");
		}
		if (0 == weChatVo.getValidDate().length()) {
			log.info("报文参数错误：卡有效期为空");
			return commonErrorMsg("000008", "报文参数错误：卡有效期为空");
		}
		if (0 == weChatVo.getIs_money().length()) {
			log.info("报文参数错误：是否积分+现金支付为空");
			return commonErrorMsg("000008", "报文参数错误：是否积分+现金支付为空");
		}
		if (0 == weChatVo.getGoods_xid().length()) {
			log.info("报文参数错误：商品编码为空");
			return commonErrorMsg("000008", "报文参数错误：商品编码为空");
		}
		if (0 == weChatVo.getGoodsNm().length()) {
			log.info("报文参数错误：商品数量为空");
			return commonErrorMsg("000008", "报文参数错误：商品数量为空");
		}
		int goods_num = 0;
		try {
			goods_num = Integer.parseInt(weChatVo.getGoodsNm());
		} catch (Exception e) {
			log.error("商品数量转换：" + weChatVo.getGoodsNm() + ",exception:" + e.getMessage(), e);
			return commonErrorMsg("000008", "报文参数错误：商品数量不是数字");
		}
		if (goods_num <= 0 || goods_num > 99) {
			log.info("商品数量异常：" + weChatVo.getGoodsNm() + ",goods_num:" + goods_num);
			return commonErrorMsg("000047", "商品数量异常：" + goods_num);
		}
		// 判断商品是不是在上架状态
		String status = null;
		switch (weChatVo.getChannelSN()) {
		// 由于积分商城没有微信是否上架 业务定为暂时使用 积分商城是否上架
		case Contants.CHANNEL_SN_WX:
			status = StringUtils.dealNull(goodsModel.getChannelPoints());
			break;
		case Contants.CHANNEL_SN_WS:
			status = StringUtils.dealNull(goodsModel.getChannelCreditWx());
			break;
		case Contants.SOURCE_ID_CELL:
			status = StringUtils.dealNull(goodsModel.getChannelPhone());
			break;
		}
		if (!Contants.CHANNEL_MALL_WX_02.equals(status)) {
			log.info("渠道：" + weChatVo.getChannelSN() + ",商品状态:" + status);
			return commonErrorMsg("000036", "商品不是上架状态");
		}
		// 只支持虚拟礼品
		String goods_type = StringUtils.dealNull(goodsModel.getGoodsType());
		if (!Contants.SUB_ORDER_TYPE_01.equals(goods_type)) {
			log.info("暂时不支持非虚拟礼品购买 商品类型：" + goods_type + "," + Contants.SUB_ORDER_TYPE_01);
			return commonErrorMsg("000100", "暂时不支持非虚拟礼品购买");
		}
		// 校验库存
		int goods_backlog = itemModel.getStock().intValue();
		if (goods_backlog - goods_num < 0) {
			log.info("礼品库存不足 商品数量：" + goods_num + ",goods_backlog:" + goods_backlog);
			return commonErrorMsg("000075", "礼品库存不足");
		}
		Date begin_date = null;
		Date end_date = null;
		switch (weChatVo.getChannelSN()) {
		case Contants.CHANNEL_SN_WX:
			begin_date = goodsModel.getOnShelfMallWxDate();
			end_date = goodsModel.getOffShelfMallWxDate();
			break;
		case Contants.CHANNEL_SN_WS:
			begin_date = goodsModel.getOnShelfCreditWxDate();
			end_date = goodsModel.getOffShelfCreditWxDate();
			break;
		case Contants.SOURCE_ID_CELL:
			begin_date = goodsModel.getOnShelfPhoneDate();
			end_date = goodsModel.getOffShelfPhoneDate();
			break;
		}
		// 校验商品有效期
		Date cur_date = new Date();
		if ((begin_date != null && cur_date.before(begin_date)) || (end_date != null && cur_date.after(end_date))) {
			log.info("现在日期不在商品有效期之内 当前日期：" + cur_date + ",商品开始日期：" + begin_date + ",商品结束日期:" + end_date);
			return commonErrorMsg("000033", "现在日期不在商品有效期之内");
		}

		// 校验积分类型（判断接口中卡号对应的积分类型与商品积分类型是否匹配--经过需求确认，与其他渠道有所不同）
		integral_type = StringUtils.dealNull(integral_type);
		List custTypeList = priceLevelVo.getCardJfType();
		if ("0".equals(weChatVo.getIs_merge())) {// 合并支付
			custTypeList = priceLevelVo.getCustJfType();
		}
		// 测试卡板
		if (custTypeList == null || !judgeCardJftype(integral_type, custTypeList)) {
			log.info("000072该客户积分类型不满足购买此礼品条件");
			return commonErrorMsg("000072", "该客户积分类型不满足购买此礼品条件");
		}
		// 校验卡板
		List custBoard = priceLevelVo.getCustBoard();// 积分系统查询到的卡板
		String cardBoard = StringUtils.dealNull(priceLevelVo.getCardBoard());
		String goodsboard = StringUtils.dealNull(goodsModel.getCards());
		String areaboard = StringUtils.dealNull(espAreaInf.getFormatId());
		log.info("cardBoard:" + cardBoard + ",goodsboard:" + goodsboard + ",areaboard:" + areaboard + ",custBoard:"
				+ custBoard);
		if ("0".equals(weChatVo.getIs_merge())) {// 合并支付
			if (!judgeCardBoard(goodsboard, areaboard, custBoard)) {
				log.info("0-000071该客户卡板不满足购买此礼品条件");
				return commonErrorMsg("000071", "该客户卡板不满足购买此礼品条件");
			}
		} else if ("1".equals(weChatVo.getIs_merge())) {// 非合并支付
			// 卡板判断(当前支付卡的卡板，一张卡)
			if (!judgeCardBoard(goodsboard, areaboard, cardBoard)) {
				log.info("1-000071该客户卡板不满足购买此礼品条件");
				return commonErrorMsg("000071", "该客户卡板不满足购买此礼品条件");
			}
		}
		return null;
	}

	/**
	 * 公共错误信息
	 */
	private WXOrderAddByIntergralReturnVO commonErrorMsg(String returnCode, String returnDesc) {
		WXOrderAddByIntergralReturnVO returnVO = new WXOrderAddByIntergralReturnVO();
		returnVO.setReturnCode(returnCode);
		returnVO.setReturnDes(returnDesc);
		return returnVO;
	}

	/**
	 * 积分类型
	 */
	private boolean judgeCardJftype(String integral_type, List custJftype) {
		log.info("进入判断积分类型方法，商品积分类型：" + integral_type + "客户积分类型：" + custJftype);
		if (custJftype != null && custJftype.contains(integral_type.trim())) {
			return true;
		}
		return false;
	}

	/**
	 * 判断卡板是否符合
	 */
	private boolean judgeCardBoard(String goodsboard, String areaboard, List custBoard) {
		log.info("进入判断卡板方法，商品卡板：" + goodsboard + "分区卡板：" + areaboard + "客户卡板：" + custBoard);
		// 如果礼品卡板不为空
		if (null != goodsboard && goodsboard.trim().length() != 0) {
			goodsboard = goodsboard.trim();
			if (goodsboard.equals(Contants.GOODS_CARDBORD_NO_LIMIT)) {// 商品卡板WWWW，没限制
				log.info("商品卡板WWWW，无卡板限制。");
				return true;
			}
			if (null == custBoard || custBoard.isEmpty()) {
				log.info("客户卡板为空。");
				return false;
			} // 判断客户卡板是否符合商品卡板
			String[] goods_board = goodsboard.split(",");
			for (int i = 0; i < goods_board.length; i++) {
				if (null == goods_board[i] || goods_board[i].trim().length() == 0) {
					continue;
				}
				if (custBoard.contains(goods_board[i].trim())) {
					log.info("符合商品卡板。");
					return true;
				}
			}
			log.info("不符合商品卡板。");
			return false;
		} else {// 如果礼品卡板为空
			if (null == areaboard || "".equals(areaboard.trim())) {// 分区卡板为空
				log.info("分区卡板为空。");
				return true;
			}
			if (null == custBoard || custBoard.size() == 0) {
				log.info("客户卡板为空。");
				return false;
			} // 判断客户卡板是否符合分区卡板
			String[] area_board = areaboard.split(",");
			for (int i = 0; i < area_board.length; i++) {
				if (null == area_board[i] || area_board[i].trim().length() == 0) {
					continue;
				}
				if (custBoard.contains(area_board[i].trim())) {// 分区卡板不为空
					log.info("符合分区卡板。");
					return true;
				}
			}
			log.info("不符合分区卡板。");
			return false;
		}
	}

	/**
	 * 校验卡板
	 */
	private boolean judgeCardBoard(String goodsboard, String areaboard, String cardBoard) {
		log.info("进入判断卡板方法，商品卡板：" + goodsboard + "分区卡板：" + areaboard + "客户卡板：" + cardBoard);
		if (null != goodsboard && goodsboard.trim().length() != 0) {
			goodsboard = goodsboard.trim();
			if (goodsboard.equals(Contants.GOODS_CARDBORD_NO_LIMIT)) {// 商品卡板WWWW，没限制
				log.info("商品卡板WWWW，无卡板限制。");
				return true;
			} // 客户卡板为空
			if (null == cardBoard || cardBoard.trim().length() == 0) {
				log.info("客户卡板为空。");
				return false;
			} // 判断客户卡板是否符合商品卡板
			String[] goods_board = goodsboard.split(",");
			for (int i = 0; i < goods_board.length; i++) {
				if (null == goods_board[i] || goods_board[i].trim().length() == 0) {
					continue;
				}
				if (cardBoard.contains(goods_board[i].trim())) {
					log.info("符合商品卡板");
					return true;
				}
			}
			log.info("不符合商品卡板");
			return false;
		} else {
			if (null == areaboard || "".equals(areaboard.trim())) {// 分区卡板为空
				return true;
			} // 客户卡板为空
			if (null == cardBoard || cardBoard.trim().length() == 0) {
				log.info("客户卡板为空。");
				return false;
			} // 判断客户卡板是否符合分区卡板
			String[] area_board = areaboard.split(",");
			for (int i = 0; i < area_board.length; i++) {
				if (null == area_board[i] || area_board[i].trim().length() == 0) {
					continue;
				}
				if (cardBoard.contains(area_board[i].trim())) {// 分区卡板不为空
					log.info("符合分区卡板");
					return true;
				}
			}
			log.info("不符合分区卡板");
			return false;
		}
	}

	/**
	 * 根据客户等级获得发货等级
	 */
	private String getCustType(String custLevel) {
		log.info("进入获取发货等级方法getCustType");
		String custType = Contants.CUST_LEVEL_CODE_A;
		if (Contants.MEMBER_LEVEL_DJ_CODE.equals(custLevel)) {
			// 若用户名下有顶级卡,返回顶级卡等级
			return Contants.CUST_LEVEL_CODE_C;
		} else if (Contants.MEMBER_LEVEL_TJ_CODE.equals(custLevel)) {
			custType = Contants.CUST_LEVEL_CODE_B;
		}
		return custType;
	}

	/**
	 * 生成大订单对象
	 */
	private OrderMainModel getTblOrderMain(String create_oper, String integral_type, BigDecimal totalPrice,
			Long totalPoint, WeChatVo weChatVo) {
		log.info("进入[MAL501]getTblOrderMain");
		OrderMainModel tblOrderMain = new OrderMainModel();
		Date nowDate = new Date();

		String source_id = null;
		String source_nm = null;
		if (Contants.CHANNEL_SN_WX.equals(weChatVo.getChannelSN())) {// 微信广发银行
			source_id = Contants.SOURCE_ID_WECHAT;
			source_nm = Contants.SOURCE_NM_WECHAT;
		} else if (Contants.CHANNEL_SN_WS.equals(weChatVo.getChannelSN())) {// 微信信用卡
			source_id = Contants.SOURCE_ID_WECHAT_A;
			source_nm = Contants.SOURCE_NM_WECHAT_A;
		} else if (Contants.SOURCE_ID_CELL.equals(weChatVo.getChannelSN())) {// 手机渠道
			source_id = Contants.SOURCE_ID_CELL;
			source_nm = Contants.SOURCE_NM_CELL;
		} else {
			source_id = weChatVo.getChannelSN();
			source_nm = "";
		}
		String orderMainid = idGenarator.orderMainId(source_id);// 大订单号
		tblOrderMain.setOrdermainId(orderMainid);
		tblOrderMain.setOrdertypeId("JF");
		tblOrderMain.setOrdertypeNm("积分业务");
		tblOrderMain.setCardno(weChatVo.getCardNo());
		tblOrderMain.setPermLimit(new BigDecimal(0));// 永久额度（默认0）
		tblOrderMain.setCashLimit(new BigDecimal(0));// 取现额度（默认0）
		tblOrderMain.setStagesLimit(new BigDecimal(0));// 分期额度（默认0）
		tblOrderMain.setSourceId(source_id);// 订购渠道（下单渠道）
		tblOrderMain.setSourceNm(source_nm);// 渠道名称
		tblOrderMain.setTotalNum(new Integer(weChatVo.getGoodsNm()));// 商品总数量
		tblOrderMain.setTotalBonus(totalPoint);// 商品总积分数量
		tblOrderMain.setTotalIncPrice(new BigDecimal(0));// 商品总手续费价格（无用）
		tblOrderMain.setLockedFlag("0");// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）
		tblOrderMain.setCreateTime(nowDate);// 创建时间
		tblOrderMain.setModifyTime(nowDate);
		tblOrderMain.setCreateOper(create_oper);// 创建操作员ID
		tblOrderMain.setContIdType(weChatVo.getContIdType());// 订货人证件类型
		tblOrderMain.setContIdcard(weChatVo.getContIdCard());// 订货人证件号码
		tblOrderMain.setContNm(weChatVo.getCustName());// 订货人姓名
		tblOrderMain.setContNmPy("");// 订货人姓名拼音
		tblOrderMain.setContPostcode(weChatVo.getDeliveryPost());// 订货人邮政编码
		tblOrderMain.setContAddress(weChatVo.getCsgAddress());// 订货人详细地址
		tblOrderMain.setContMobPhone(weChatVo.getCsgMoblie());// 订货人手机
		tblOrderMain.setContHphone(weChatVo.getCsgPhone());// 订货人家里电话
		tblOrderMain.setCsgName(weChatVo.getCsgName());// 收货人姓名
		tblOrderMain.setCsgPostcode(weChatVo.getDeliveryPost());// 收货人邮政编码
		tblOrderMain.setCsgAddress(weChatVo.getCsgAddress());// 收货人详细地址
		tblOrderMain.setCsgPhone1(weChatVo.getCsgMoblie());// 收货人电话一
		tblOrderMain.setCsgPhone2(weChatVo.getCsgPhone());// 收货人电话二
		tblOrderMain.setBpCustGrp(weChatVo.getSendTime());// 送货时间
		tblOrderMain.setOrdermainDesc(weChatVo.getOrdermainDesc());// 备注
		tblOrderMain.setCommDate(DateHelper.getyyyyMMdd(nowDate));// 业务日期
		tblOrderMain.setCommTime(DateHelper.getHHmmss(nowDate));// 业务时间
		tblOrderMain.setAcctAddFlag("1");// 收货地址是否是帐单地址
		tblOrderMain.setCustSex("");// 性别
		tblOrderMain.setCustEmail("");
		tblOrderMain.setCsgProvince(weChatVo.getCsgProvince());// 省
		tblOrderMain.setCsgCity(weChatVo.getCsgCity());// 市
		tblOrderMain.setCsgBorough(weChatVo.getCsgBorough());// 区
		tblOrderMain.setMerId(merId);// 大商户号
		tblOrderMain.setSerialNo(idGenarator.orderSerialNo());// 流水号
		tblOrderMain.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功 2：更新失败
		tblOrderMain.setTotalPrice(totalPrice);
		tblOrderMain.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态
		tblOrderMain.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);//
		tblOrderMain.setIsmerge(weChatVo.getIs_merge());
		tblOrderMain.setPsFlag("");// 空或0:vmi没同步过，1:vmi同步过
		tblOrderMain.setCheckStatus("0");// 0:初始状态 1:已经对账
		tblOrderMain.setIntegraltypeId(integral_type);
		tblOrderMain.setIsInvoice("0");
		tblOrderMain.setDelFlag(0);
		return tblOrderMain;
	}

	/**
	 * 生成虚拟订单小订单
	 */
	private Map<String, Object> getVirtualOrder(OrderMainModel orderMain, GoodsModel tblGoods, String vendor_fnm,
			String mer_id, String goods_payway_id, String payway_code, BigDecimal goods_price, long goods_point,
			BigDecimal cal_money, String member_level, String cust_type, ItemModel itemModel) {
		log.info("getVirtualOrder");
		Map<String, Object> orderMap = Maps.newHashMap();

		// 根据大订单号来获取小订单号
		String order_id = orderMain.getOrdermainId() + "01";
		// 虚拟订单小订单，小订单包含n个小订单
		OrderSubModel orderInf = new OrderSubModel();
		orderInf.setOrderId(order_id);
		orderInf.setOrdermainId(orderMain.getOrdermainId());
		orderInf.setOrderIdHost(idGenarator.orderSerialNo());
		orderInf.setOperSeq(0);// 业务订单同步序号
		orderInf.setOrdertypeId(orderMain.getOrdertypeId());
		orderInf.setOrdertypeNm(orderMain.getOrdertypeNm());
		orderInf.setPaywayCode(payway_code);// 支付方式代码 0001：现金 0002：积分 0003：积分+现金
		String paywayName = "";
		if (org.apache.commons.lang3.StringUtils.isNotEmpty(payway_code)) {
			if (payway_code.equals("0001")) {
				paywayName = "现金";
			} else if (payway_code.equals("0002")) {
				paywayName = "积分";
			} else if (payway_code.equals("0003")) {
				paywayName = "积分+现金";
			}
		}
		orderInf.setPaywayNm(paywayName);// 支付方式名称 未完成
		orderInf.setCardno(orderMain.getCardno());// 卡号
		orderInf.setVerifyFlag("");// 下单验证标记
		orderInf.setVendorId(tblGoods.getVendorId());// 供应商代码
		orderInf.setVendorSnm(vendor_fnm);// 供应商名称简写
		orderInf.setSourceId(orderMain.getSourceId());// 渠道代码
		orderInf.setSourceNm(orderMain.getSourceNm());// 渠道名称
		orderInf.setGoodsId(itemModel.getCode());// 单品代码
		orderInf.setGoodsCode(itemModel.getGoodsCode());// 商品code
		orderInf.setGoodsPaywayId(goods_payway_id);// 商品支付编码
		orderInf.setGoodsNum(orderMain.getTotalNum());// 商品数量
		orderInf.setGoodsNm(tblGoods.getName());// 商品名称
		orderInf.setCurrType("156");// 商品币种
		orderInf.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
		orderInf.setGoodssendFlag("0");// 发货标记
		orderInf.setGoodsaskforFlag("0");// 请款标记
		orderInf.setSpecShopnoType("");// 特店类型
		orderInf.setPayTypeNm("");// 佣金代码名称
		orderInf.setIncCode("");// 手续费率代码
		orderInf.setIncCodeNm("");// 手续费名称
		orderInf.setStagesNum(1);// 现金[或积分]分期数
		orderInf.setCommissionType("");// 佣金计算类别
		orderInf.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
		orderInf.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
		orderInf.setBonusTotalvalue(goods_point * orderMain.getTotalNum());// 积分总数
		orderInf.setCalMoney(cal_money.multiply(new BigDecimal(orderMain.getTotalNum())));// 清算总金额
		orderInf.setOrigMoney(new BigDecimal(0));// 原始现金总金额
		orderInf.setTotalMoney(goods_price.multiply(new BigDecimal(orderMain.getTotalNum())));// 现金总金额
		orderInf.setIncWay("00");// 手续费获取方式
		orderInf.setIncRate(new BigDecimal(0));// 手续费率(不包含%)
		orderInf.setIncMoney(new BigDecimal(0));// 手续费总金额
		orderInf.setUitfeeflg(0);// 手续费减免期数
		orderInf.setUitfeedam(new BigDecimal(0));// 手续费减免金额
		orderInf.setUitdrtuit(0);// 本金减免期数
		orderInf.setUitdrtamt(new BigDecimal(0));// 本金减免金额
		orderInf.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
		orderInf.setIncTakePrice(new BigDecimal(0));// 退单时收取指定金额手续费
		orderInf.setVoucherPrice(new BigDecimal(0));// 优惠金额
		orderInf.setCreditFlag("");// 授权额度不足处理方式
		orderInf.setCalWay("");// 退货方式
		orderInf.setLockedFlag("0");// 订单锁标记
		orderInf.setVendorOperFlag("0");// 供应商操作标记
		orderInf.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态
		orderInf.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);//
		orderInf.setCreateOper(orderMain.getCreateOper());// 创建操作员ID
		orderInf.setCreateTime(orderMain.getCreateTime());// 创建时间
		orderInf.setVersionNum(0);// 记录更新控制版本号
		String goodsTypeItem = tblGoods.getGoodsType();
		if (goodsTypeItem != null) {
			orderInf.setGoodsType(goodsTypeItem);// 商品类型（00实物01虚拟02O2O）
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsTypeItem)) {
				orderInf.setGoodsTypeName(Contants.GOODS_TYPE_NM_00);
			}
			if (Contants.SUB_ORDER_TYPE_01.equals(goodsTypeItem)) {
				orderInf.setGoodsTypeName(Contants.GOODS_TYPE_NM_01);
			}
			if (Contants.SUB_ORDER_TYPE_02.equals(goodsTypeItem)) {
				orderInf.setGoodsTypeName(Contants.GOODS_TYPE_NM_02);
			}
		} else {
			orderInf.setGoodsType(Contants.GOODS_TYPE_ID_00);// 商品类型（00实物01虚拟02O2O）
			orderInf.setGoodsTypeName(Contants.GOODS_TYPE_NM_00);
		}
		// 数据库非必输字段
		orderInf.setMerId(mer_id);// 小商户号
		// 后台类目
		Long backCategoryId = null;
		Response<List<Pair>> pairResponse = goodsService.findCategoryByGoodsCode(itemModel.getGoodsCode());
		if (pairResponse.isSuccess() && pairResponse.getResult() != null) {
			List<Pair> pairList = pairResponse.getResult();
			backCategoryId = pairList.get(3).getId();
		}
		orderInf.setTypeId(backCategoryId == null ? "" : backCategoryId.toString()); // 三级后台类目
		orderInf.setLevelNm("");// 商品类别名称 未完成
		orderInf.setGoodsBrand(tblGoods.getGoodsBrandName());// 品牌
		orderInf.setGoodsModel(itemModel.getAttributeName2());// 型号
		orderInf.setGoodsColor(itemModel.getAttributeName1());// 商品颜色
		orderInf.setActType("");// 活动类型
		orderInf.setBonusTrnDate(DateHelper.getyyyyMMdd(orderMain.getCreateTime()));// 支付日期
		orderInf.setBonusTrnTime(DateHelper.getHHmmss(orderMain.getCreateTime()));// 支付时间
		orderInf.setModifyTime(orderMain.getCreateTime());// 修改时间
		orderInf.setTmpStatusId("0000");// 临时状态代码
		orderInf.setCommDate(DateHelper.getyyyyMMdd(orderMain.getCreateTime()));// 业务日期
		orderInf.setCommTime(DateHelper.getHHmmss(orderMain.getCreateTime()));// 业务时间
		orderInf.setBonusType(tblGoods.getPointsType());// 积分类型
		orderInf.setSingleBonus(goods_point);// 积分
		orderInf.setSinglePrice(goods_price);// 单价
		orderInf.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
		orderInf.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功 2：更新失败
		orderInf.setIntegraltypeId(tblGoods.getPointsType());// 积分类型
		orderInf.setMemberLevel(member_level);// 价格等级
		orderInf.setCardtype("C");// 借记卡信用卡标识 C：信用卡 Y：借记卡
		orderInf.setCustCartId("0");// 购物车id
		orderInf.setCustType(cust_type);// vip优先发货客户等级
		orderInf.setVoucherNo("");
		orderInf.setDelFlag("0");
		orderInf.setGoodsAttr1(itemModel.getAttributeValue1());
		orderInf.setGoodsAttr2(itemModel.getAttributeValue2());
		orderInf.setRemindeFlag(0);
		orderInf.setO2oExpireFlag(0);
		orderInf.setFenefit(new BigDecimal(0.00));
		orderInf.setMiaoshaActionFlag(0);
		// orderInf.setOrder_succ_time(orderMain.getCreateTime());

		// 手机渠道订单备注“EASY GO APP”
		if (Contants.SOURCE_ID_CELL.equals(orderMain.getSourceId())) {
			orderInf.setOrderDesc("EASY GO APP下单");
		}

		orderMap.put("tblOrder", orderInf);

		// 如果是虚拟礼品，构建虚拟订单model
		OrderVirtualModel orderVirtual = null;
		if (tblGoods.getGoodsType().equals("01")) {
			orderVirtual = new OrderVirtualModel();
			orderVirtual.setOrderId(orderInf.getOrderId());// 小订单号
			orderVirtual.setGoodsXid(itemModel.getXid());// 礼品编码
			orderVirtual.setGoodsMid(itemModel.getMid());// 商品ID(分期唯一值用于外系统)
			orderVirtual.setGoodsOid(itemModel.getOid());// 商品ID(一次性唯一值用于外系统)
			orderVirtual.setGoodsBid(itemModel.getBid());// 礼品代号
			orderVirtual.setEntryCard(orderMain.getCardno());// 支付卡号

			orderVirtual.setVirtualCardType(orderMain.getCardtypeId());// 卡类
			orderVirtual.setExtend2(orderMain.getFormatId());// 记录卡板

			orderVirtual.setGoodsType(tblGoods.getGoodsType());// 礼品类别（此处为虚拟礼品）
			orderVirtual.setVirtualLimit(tblGoods.getLimitCount());// 限购次数
			orderVirtual.setVirtualSingleMileage(itemModel.getVirtualMileage());// 里程
			int mileage = 0;
			BigDecimal goods_mun = new BigDecimal(orderInf.getGoodsNum().intValue());
			BigDecimal virtual_price = new BigDecimal(itemModel.getVirtualPrice().doubleValue());
			BigDecimal price_result = goods_mun.multiply(virtual_price).setScale(2, BigDecimal.ROUND_HALF_UP);// 商品价格乘以商品数量，保留两位小数
			if (itemModel.getVirtualMileage() != null) {
				mileage = itemModel.getVirtualMileage().intValue();
			}
			orderVirtual.setVirtualAllMileage(new Integer(orderInf.getGoodsNum().intValue() * mileage));
			orderVirtual.setVirtualSinglePrice(itemModel.getVirtualPrice());// 兑换金额
			orderVirtual.setVirtualAllPrice(new BigDecimal(price_result.doubleValue()));
			orderVirtual.setVirtualMemberId(orderInf.getCreateOper());// 会员id
			orderVirtual.setVirtualMemberNm(orderInf.getMemberName());// 会员姓名
			orderVirtual.setSerialno(""); // 客户所输入的保单号
			orderVirtual.setVirtualAviationType("");// 航空类型
			orderVirtual.setPrepaidMob("");// 充值卡的电话号码
			orderVirtual.setTradedesc("");
			// tradeCode是用来给支付平台出对账文件
			String tradeCode = "";
			if (priorJudgeService.isNianFee(itemModel.getXid())) {// 积分换年费交易码
				tradeCode = "3400";
			} else if (priorJudgeService.isQianzhane(itemModel.getXid())) {// 红利卡兑换免签帐额调整交易码
				tradeCode = "8200";
			}
			orderVirtual.setTradecode(tradeCode);
			orderVirtual.setAttachName("");
			orderVirtual.setAttachIdentityCard("");
		}

		orderMap.put("orderVirtual", orderVirtual);

		// 处理订单历史表
		OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
		orderDodetail.setOrderId(orderInf.getOrderId());
		orderDodetail.setDoTime(orderInf.getCreateTime());
		orderDodetail.setDoUserid(orderInf.getCreateOper());
		orderDodetail.setUserType("4");
		orderDodetail.setStatusId(orderInf.getCurStatusId());
		orderDodetail.setStatusNm(orderInf.getCurStatusNm());
		orderDodetail.setMsgContent("");
		if (Contants.SOURCE_ID_CELL.equals(orderMain.getSourceId())) {
			orderDodetail.setDoDesc("EASY GO APP下单");
		} else {
			orderDodetail.setDoDesc("微信下单");
		}
		orderDodetail.setCreateOper(orderInf.getCreateOper());
		orderDodetail.setDelFlag(0);

		orderMap.put("tblOrderDodetail", orderDodetail);

		return orderMap;
	}

	/**
	 * 手机渠道支付
	 */
	private WXOrderAddByIntergralReturnVO toPayCellOrder(OrderMainModel orderMain, WeChatVo weChatVo,
			WXOrderAddByIntergralReturnVO retVo, String sourceSenderSN) {
		// 电子支付返回码以及说明map
		Map<String, String> retMap = null;
		// 电子支付返回码
		String retCode = "";
		// 电子支付返回码说明，可空
		String retErrMsg = "";
		String payTime = "";
		try {
			// 支付
			retMap = doPay(orderMain, weChatVo.getValidDate(), sourceSenderSN);
		} catch (Exception e) {
			log.error("【MAL503】调用电子支付接口异常，订单置为状态未明:" + e.getMessage(), e);
			retMap = Maps.newHashMap();
			retMap.put("retCode", "");// 状态未明；
			retMap.put("retErrMsg", "");
		}
		try {
			// 更新支付状态、是否需要回滚库存需要做事务控制
			if (retMap != null && !retMap.isEmpty()) {
				retCode = retMap.get("retCode");
				retErrMsg = retMap.get("retErrMsg");
				payTime = retMap.get("payTime");
				//已经做旧版的兼容
				updateVirtualOrders(orderMain, "手机支付", retCode, payTime);
			}
		} catch (Exception e) {
			log.error("【MAL501】手机渠道支付:" + e.getMessage(), e);
		}
		// 组装报文返回
		if ("".equals(retCode))
			retCode = "000000";// 如果支付或者更新数据出现异常默认返回000000，以保证非空
		retVo.setReturnCode(retCode);
		if ((null == retErrMsg || "".equals(retErrMsg)) && !"000000".equals(retCode)) {
			retErrMsg = getReturnCode(retCode);
		}
		retVo.setReturnDes(retErrMsg);
		retVo.setPayTime(payTime);
		Response<OrderMainModel> responseMainOrder = orderService.findOrderMainById(orderMain.getOrdermainId());// 查询大订单信息
		if (!responseMainOrder.isSuccess()) {
			throw new RuntimeException(responseMainOrder.getError());
		}
		OrderMainModel retMain = responseMainOrder.getResult();
		retVo.setOrderMainId(retMain.getOrdermainId());
		retVo.setCurStatusId(retMain.getCurStatusId());
		return retVo;
	}

	private String getReturnCode(String error_code) {
		String error_code_text = "";
		Properties prop = new Properties();
		try {
			InputStream in = SystemProperties.class.getClassLoader().getResourceAsStream("returnCode.properties");
			prop.load(in);
			error_code_text = prop.getProperty(error_code);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return error_code_text;
	}

	/**
	 * 去电子支付平台支付
	 */
	// bug-305197 fixed by ldk
	private Map<String, String> doPay(OrderMainModel orderMain, String validDate, String sourceSenderSN)
			throws Exception {
		BigDecimal amountB = null;
		String amount = orderMain.getTotalPrice().toString();
		String accountNo = orderMain.getCardno();
		try {
			amountB = new BigDecimal(amount);
		} catch (Exception e) {
			log.error("价格转换失败：" + e.getMessage(), e);
			throw e;
		}
		if (0 == new BigDecimal("0").compareTo(amountB)) {// 纯积分支付
			amount = "0";
			accountNo = "";
		}
		if ("0.00".equals(amount) || "0".equals(amount)) {// 纯积分支付
			amount = "0";
			accountNo = "";
		}
		CCPointsPay ccPointPay = new CCPointsPay();
		ccPointPay.setTradeChannel(Contants.TRADECHANNEL);// 交易渠道
		ccPointPay.setTradeSource(Contants.TRADESOURCE);// 交易来源
		ccPointPay.setBizSight(Contants.BIZSIGHT);// 业务场景
		ccPointPay.setSorceSenderNo(sourceSenderSN + "");// 源发起方流水
		ccPointPay.setOperatorId("");// 操作员代码
		ccPointPay.setTradeSeqNo(orderMain.getSerialNo());// 20|交易流水号|Y
		ccPointPay.setOrderId(orderMain.getOrdermainId());// 30|订单号|Y
		ccPointPay.setAccountNo(accountNo);// 20|卡号|N
		ccPointPay.setAmount(amount);// 12|支付金额|##########.##|Y
		ccPointPay.setCurType("CNY");// 3|交易币种|Y
		ccPointPay.setCvv2("");// 5|CVV2|N
		ccPointPay.setValidDate(validDate);// 10|有效期|YYMM|N 短信渠道可为空
		ccPointPay.setMerId(orderMain.getMerId());// 20|商城商户号|Y
		ccPointPay.setTradeStatus("0");// 1|交易状态|Y
		ccPointPay.setIsMerger(orderMain.getIsmerge());// 1|是否合并支付|Y
		ccPointPay.setTradeDate(DateHelper.date2string(orderMain.getCreateTime(), "yyyyMMdd"));// 8|交易日期|Y
		ccPointPay.setTradeTime(DateHelper.date2string(orderMain.getCreateTime(), "HHmmss"));// 6|交易时间|Y
		ccPointPay.setRemark("");// 200|备注|N
		ccPointPay.setChannelID("WX");// 渠道标识为“WX”（积分系统界面优化修改）
		ccPointPay.setFracCardCount(1 + "");// 2|积分卡数量|Y
		ccPointPay.setTerminalCode("02");// 终端编号 01-广发商城，02-积分商城（积分系统界面优化增加）
		CCPointsPayBaseInfo ccPointPayBaseInfo = new CCPointsPayBaseInfo();
		ccPointPayBaseInfo.setFracCardNo(orderMain.getCardno());// 积分信用卡卡号|N
		ccPointPayBaseInfo.setFracAmount(orderMain.getTotalBonus().toString());// 扣除积分数|正整数|N 15
		ccPointPayBaseInfo.setFracType(orderMain.getIntegraltypeId());// 3|积分类型
		ccPointPayBaseInfo.setFracValidDate(validDate);// 4|积分信用卡有效期|YYMM|N
		ArrayList<CCPointsPayBaseInfo> infos = Lists.newArrayList(ccPointPayBaseInfo);
		ccPointPay.setCcPointsPayBaseInfos(infos);
		String retCode = "";
		String retErrMsg = "";
		String payTime = "";
		Map<String, String> map = Maps.newHashMap();
		try {
			CCPointResult baseResult = paymentService.ccPointsPay(ccPointPay);
			retCode = baseResult.getRetCode();
			retErrMsg = baseResult.getRetErrMsg();
			payTime = baseResult.getPayTime();
		} catch (Exception e) {
			throw new Exception();
		}
		if (Strings.isNullOrEmpty(payTime)){
			payTime = DateHelper.date2string(orderMain.getCreateTime(),DateHelper.YYYYMMDDHHMMSS);
		}
		map.put("retCode", retCode);
		map.put("retErrMsg", retErrMsg);
		map.put("payTime", payTime);
		return map;
	}

	/**
	 * 更新支付状态
	 */
	private void updateVirtualOrders(OrderMainModel orderMain, String oper_nm, String retCode, String payTime) {
		String payState = "";// 订单最终状态 1:支付成功 2:支付失败 3:状态未明
		if ("000000".equals(retCode)) {// 支付成功
			payState = "1";
		} else if (PayReturnCode.isStateNoSure(retCode) || retCode == null || "".equals(retCode)) {// 如果支付时状态未明
			// 电子支付返回“EBLN2000”，小订单状态需要置为“状态未明”
			payState = "3";
		} else {// 支付失败
			payState = "2";
		}
		updateVirtualOrdersWithTX(orderMain.getOrdermainId(), payState, oper_nm, retCode, orderMain.getCreateTime(),
				payTime);
	}

	/**
	 * 更新虚拟礼品状态
	 * 
	 * @param date
	 */
	// bug-305197 fixed by ldk
	private void updateVirtualOrdersWithTX(String orderMainId, String payState, String oper_nm, String retCode,
			Date date, String payTime) {

		log.info("进入更新虚拟订单相关updateVirtualOrdersWithTX");
		Response<List<OrderSubModel>> responseList = orderService.findByOrderMainId(orderMainId); // 根据主订单号查询子订单表数据
		if (!responseList.isSuccess()) {
			throw new RuntimeException(responseList.getError());
		}
		List<OrderSubModel> orders = responseList.getResult();
		// 订单状态ID
		String cur_status_id = "";
		// 订单状态说明
		String cur_status_nm = "";
		if ("1".equals(payState)) {// 支付成功
			cur_status_id = Contants.SUB_ORDER_STATUS_0308;
			cur_status_nm = Contants.SUB_ORDER_PAYMENT_SUCCEED;
		} else if ("3".equals(payState)) {// 状态未明
			cur_status_id = Contants.SUB_ORDER_STATUS_0316;
			cur_status_nm = Contants.SUB_ORDER_UNCLEAR;
		} else {// 支付失败
			cur_status_id = Contants.SUB_ORDER_STATUS_0307;
			cur_status_nm = Contants.SUB_ORDER_PAYMENT_FAILED;
		}
		OrderMainModel updateMainModel = new OrderMainModel();
		updateMainModel.setOrdermainId(orderMainId);
		updateMainModel.setCurStatusId(cur_status_id);
		updateMainModel.setCurStatusNm(cur_status_nm);
		updateMainModel.setModifyTime(new Date());
		updateMainModel.setModifyOper(oper_nm);
		updateMainModel.setErrorCode(retCode);
		updateMainModel.setPayResultTime(DateHelper.getyyyyMMdd() + DateHelper.getHHmmss());
		tblOrderMainService.updateTblOrderMain(updateMainModel);
		OrderSubModel updateSubModel = new OrderSubModel();
		updateSubModel.setOrdermainId(orderMainId);
		updateSubModel.setCurStatusId(cur_status_id);
		updateSubModel.setCurStatusNm(cur_status_nm);
		updateSubModel.setModifyTime(new Date());
		updateSubModel.setModifyOper(oper_nm);
		updateSubModel.setErrorCode(retCode);
		updateSubModel.setOrder_succ_time(DateHelper.string2Date(payTime, DateHelper.YYYYMMDDHHMMSS));
		// bug-305197 fixed by ldk
		// updateSubModel.setOrder_succ_time(date);
		orderService.updateTblOrderSub(updateSubModel);
		if (null != orders && orders.size() > 0) {
			OrderSubModel order = orders.get(0);
			OrderDoDetailModel tblOrderDodetail = new OrderDoDetailModel();
			tblOrderDodetail.setOrderId(order.getOrderId());
			tblOrderDodetail.setDoTime(new Date());
			tblOrderDodetail.setDoUserid("电子支付");
			tblOrderDodetail.setDoDesc(retCode);
			tblOrderDodetail.setStatusId(cur_status_id);
			tblOrderDodetail.setStatusNm(cur_status_nm);
			tblOrderDodetail.setUserType("0");
			tblOrderDodetail.setCreateOper("电子支付");
			tblOrderDodetail.setDelFlag(0);

			orderService.insertOrderDoDetail(tblOrderDodetail);
			if (Contants.SUB_ORDER_STATUS_0307.equals(cur_status_id)) {
				// 支付失败回滚库存(9999无限库存)
				goodsService.updateGoodsJF(order.getGoodsId(), order.getGoodsNum().longValue());
			}
		}
	}
}
