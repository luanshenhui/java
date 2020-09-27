package cn.com.cgbchina.restful.provider.service.order;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.Callable;
import java.util.concurrent.CompletionService;
import java.util.concurrent.ExecutorCompletionService;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.elasticsearch.common.base.Strings;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.AppIntergralAddOrder;
import cn.com.cgbchina.rest.provider.model.order.AppIntergralAddOrderPrivilege;
import cn.com.cgbchina.rest.provider.model.order.AppIntergralAddOrderReturn;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.AppIntergralAddOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.AppIntergralAddOrderVO;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderMainSingleCheckDto;
import cn.com.cgbchina.trade.dto.OrderSubDetailDto;
import cn.com.cgbchina.trade.dto.PagePaymentReqDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.CartService;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import cn.com.cgbchina.web.utils.Tools;

import com.spirit.common.model.Response;
import com.spirit.user.User;

@Service
@TradeCode(value = "MAL314")
@Slf4j
public class AppIntergralAddOrderProvideServiceImpl
		implements
		SoapProvideService<AppIntergralAddOrderVO, AppIntergralAddOrderReturnVO> {

	private final static String ZERO_FLAG = "1";//0元秒杀标志
	@Value("#{app.merchId}")
	private String merchId;
	@Resource
	OrderService orderService;
	@Resource
	GoodsService goodsService;
	@Resource
	ItemService itemService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	VendorService vendorService;
	@Resource
	PointsPoolService pointsPoolService;
	@Resource
	MallPromotionService mallPromotionService;
	@Resource
	UserService userService;
	@Resource
	private IdGenarator idGenarator;
	@Resource
	PromotionPayWayService promotionPayWayService;
	@Resource
	CartService cartService;
	@Resource
	private PointService pointService;

	@Override
	public AppIntergralAddOrderReturnVO process(
			SoapModel<AppIntergralAddOrderVO> model,
			AppIntergralAddOrderVO content) {

		AppIntergralAddOrder appIntergralAddOrder = BeanUtils.copy(content,
				AppIntergralAddOrder.class);
		// 返回对象
		AppIntergralAddOrderReturnVO appIntergralAddOrderReturnVO = new AppIntergralAddOrderReturnVO();
		AppIntergralAddOrderReturn appIntergralAddOrderReturn = new AppIntergralAddOrderReturn();
		// 校验订单数据
		OrderMainModel orderMainModel = null;
		OrderMainDto orderMainDto = null;
		try {
			User user = new User();
			user.setId(appIntergralAddOrder.getCreateOper());
			user.setCustId(appIntergralAddOrder.getCreateOper());
			// 校验和数据拼装
			orderMainDto = check(appIntergralAddOrder,user);
			if (orderMainDto.getReturnCode() != null && !orderMainDto.getReturnCode().equals("")) {
				log.info("mail314验证失败");
				appIntergralAddOrderReturnVO.setReturnCode(orderMainDto
						.getReturnCode());
				appIntergralAddOrderReturnVO.setReturnDes(orderMainDto
						.getReturnDes());
				return appIntergralAddOrderReturnVO;
			}
			log.info("mail314验证成功");
			// 组装订单数据
			orderMainModel = createOrderMainModel(appIntergralAddOrder,
					orderMainDto);
			// 组装小订单
			OrderSubDetailDto subDetailDto = createSubDetail(
					appIntergralAddOrder, orderMainDto, orderMainModel);
			log.info(appIntergralAddOrderReturn.getReturnCode());
			log.info("mail314订单拼装完成");
			Response response = orderService.saveGfOrder(orderMainModel,
					subDetailDto.getOrderSubModelList(),
					subDetailDto.getOrderDoDetailModelList(),
					orderMainDto,user);
			if (!response.isSuccess()) {
				appIntergralAddOrderReturnVO.setReturnDes((String)response.getResult());
				appIntergralAddOrderReturnVO.setReturnCode("000009");
				return appIntergralAddOrderReturnVO;
			}
			List<String> cartIdList = new ArrayList<String>();
			if (orderMainDto.getCartIdMap() != null) {
				Map map = orderMainDto.getCartIdMap();
				Iterator it = map.entrySet().iterator();
				while (it.hasNext()) {
					Entry<String, String> entry = (Entry) it.next();
					cartIdList.add(entry.getValue());
				}
				orderService.updateShopCartByOrderSuccess(cartIdList);
			}
			// 3.准备支付用数据
			Response<PagePaymentReqDto> responseResult = orderService
					.getPaymentReqData(orderMainModel,
							subDetailDto.getOrderSubModelList());
			if (responseResult.isSuccess() && responseResult.getResult() != null) {
				appIntergralAddOrderReturn = BeanUtils.copy(
						responseResult.getResult(),
						AppIntergralAddOrderReturn.class);
				appIntergralAddOrderReturn.setOrdermainId(orderMainModel
						.getOrdermainId());
			}else{
				appIntergralAddOrderReturn.setReturnCode("000042");
				appIntergralAddOrderReturn.setReturnDes("验签异常");
				appIntergralAddOrderReturnVO = BeanUtils.copy(
						appIntergralAddOrderReturn,
						AppIntergralAddOrderReturnVO.class);
				return appIntergralAddOrderReturnVO;
			}

		} catch (Exception e) {
			log.error("MAL314",e);
			appIntergralAddOrderReturn.setReturnCode("000009");
			appIntergralAddOrderReturn.setReturnDes("系统异常！");
			appIntergralAddOrderReturnVO = BeanUtils.copy(
					appIntergralAddOrderReturn,
					AppIntergralAddOrderReturnVO.class);
			return appIntergralAddOrderReturnVO;
		}
		appIntergralAddOrderReturnVO = BeanUtils.copy(
				appIntergralAddOrderReturn, AppIntergralAddOrderReturnVO.class);
		//返回0000为0元秒杀成功，后续不需要支付；返回000000为订单创建成功
		if(ZERO_FLAG.equals(orderMainDto.getMiaoshaFlag())){
			appIntergralAddOrderReturnVO.setReturnCode("0000");
		}else{
			appIntergralAddOrderReturnVO.setReturnCode("000000");
		}
		appIntergralAddOrderReturnVO.setReturnDes("成功");
		return appIntergralAddOrderReturnVO;
	}

	private OrderMainDto check(AppIntergralAddOrder appIntergralAddOrder,User user) {
		OrderMainDto orderMainDto = new OrderMainDto();
		String origin = dealNull(appIntergralAddOrder.getOrigin());// 发起方
		// 调用方标识:如手机商城:03，微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS；APP：09
		String ordertype_id = dealNull(appIntergralAddOrder.getOrdertypeId()); // 订单类型
		// YG:一次性支付(借记卡)
		// FQ：分期支付（信用卡）
		String totvalueYG = dealNull(appIntergralAddOrder.getTotvalueYG()); // 一次性的商品总价
		String totvalueFQ = dealNull(appIntergralAddOrder.getTotvalueFQ()); // 分期的商品总价
		String total_num = dealNull(appIntergralAddOrder.getTotalNum());// 商品总数量
		String create_oper = dealNull(appIntergralAddOrder.getCreateOper()); // 登录客户号
		String cont_idcard = dealNull(appIntergralAddOrder.getContIdcard()); // 订货人证件号码
		String cont_nm = dealNull(appIntergralAddOrder.getContNm());// 订货人姓名
		String cont_address = dealNull(appIntergralAddOrder.getContAddress());// 订货人详细地址
		String csg_name = dealNull(appIntergralAddOrder.getCsgName()); // 收货人姓名
		String csg_address = dealNull(appIntergralAddOrder.getCsgAddress());// 收货人详细地址
		// 01: 工作日、双休日与假日均可送货
		// 02: 只有工作日送货（双休日、假日不用送）
		// 03: 只有双休日、假日送货（工作日不用送货）
		String is_invoice = dealNull(appIntergralAddOrder.getIsInvoice());// 是否发票
		String invoice = dealNull(appIntergralAddOrder.getInvoice());// 发票抬头
		String invoice_type = dealNull(appIntergralAddOrder.getInvoiceType());// 发票类型
		String invoice_content = dealNull(appIntergralAddOrder
				.getInvoiceContent());// 发票内容
		String ordermain_desc = dealNull(appIntergralAddOrder
				.getOrdermainDesc());// 备注
		String csg_province = dealNull(appIntergralAddOrder.getCsgProvince()); // 省
		String csg_city = dealNull(appIntergralAddOrder.getCsgCity());// 市
		String csg_borough = dealNull(appIntergralAddOrder.getCsgBorough());// 区
		origin = changeOrigin(origin);
		// 如果APP渠道设置用来做check的变量为true
		boolean appSource = false;// 是否APP渠道
		if (Contants.ORDER_SOURCE_ID_09
				.equals(appIntergralAddOrder.getOrigin())) {
			appSource = true;
		}
		// 设置手机号 用来做O2O商品必须
		String mobilePhone = appIntergralAddOrder.getCsgPhone1();
		// 如果是微信渠道则设置渠道为true 用来做商品校验 微信商品判断限购数量
		boolean WXFlag = false;// 微信标识:判断是否是微信渠道
		if (Contants.SOURCE_ID_WECHAT.equals(origin)
				|| Contants.SOURCE_ID_WECHAT_A.equals(origin)
				|| Contants.SOURCE_ID_YIXIN.equals(origin)
				|| Contants.SOURCE_ID_YIXIN_A.equals(origin)) {
			WXFlag = true;
		}
		if (!WXFlag && "".equals(create_oper)) {// 登录客户号create_oper：手机和APP渠道必填；微信渠道可不填
			orderMainDto.setReturnCode("000008");
			orderMainDto.setReturnDes("报文参数错误:客户号必填");
			return orderMainDto;
		}
		if (WXFlag && "".equals(create_oper)) {
			create_oper = cont_idcard; // 微信渠道，如果客户号为空 则取证件号码
		}
		// 微信渠道暂时不支持一次性支付 yg:广发商城(一期)jf:积分商城fq:广发商城(分期)
		if (WXFlag && "YG".equals(ordertype_id)) {
			orderMainDto.setReturnCode("000081");
			orderMainDto.setReturnDes("微信渠道不支持YG支付");
			return orderMainDto;
		}
		// APP渠道包含中文字段需要解码
		if (Contants.ORDER_SOURCE_ID_09.equals(origin)) {
			cont_nm = decode(cont_nm);// 订货人姓名
			cont_address = decode(cont_address);// 订货人详细地址
			csg_name = decode(csg_name);// 收货人姓名
			csg_address = decode(csg_address);// 收货人详细地址
			invoice = decode(invoice);// 发票抬头
			invoice_type = decode(invoice_type);// 发票类型
			invoice_content = decode(invoice_content);// 发票内容
			ordermain_desc = decode(ordermain_desc);// 备注
			csg_province = decode(csg_province);// 省
			csg_city = decode(csg_city);// 市
			csg_borough = decode(csg_borough);// 区
		}
		String[] fieldName = { "cont_nm", "cont_address", "csg_name",
				"csg_address", "invoice", "invoice_type", "invoice_content",
				"ordermain_desc", "csg_province", "csg_city", "csg_borough" };
		String[] fieldCont = { cont_nm, cont_address, csg_name, csg_address,
				invoice, invoice_type, invoice_content, ordermain_desc,
				csg_province, csg_city, csg_borough };
		int[] fieldLen = { 30, 200, 30, 200, 200, 30, 200, 400, 50, 50, 50 };
		// 由于APP渠道包含中文字段需要解码，I表中APP渠道包含中文字段的长度会扩大5倍，解码之后需要校验长度
		String checkStr = checkLength(fieldName, fieldCont, fieldLen);
		// 释放资源
		fieldName = null;
		fieldCont = null;
		fieldLen = null;
		if (checkStr != null) {
			orderMainDto.setReturnCode("000008");
			orderMainDto.setReturnDes(checkStr);
			return orderMainDto;
		}
		// 没有商品不能下单
		if (appIntergralAddOrder.getAppIntergralAddOrderPrivileges().size() == 0) {
			orderMainDto.setReturnCode("000009");
			orderMainDto.setReturnDes("商品发生了变化请重新下单");
			return orderMainDto;
		}
		// 检验商品数量是否大于99
		try {
			OrderMainSingleCheckDto input = new OrderMainSingleCheckDto();
			input.setOrigin(origin);// 渠道
			input.setWXFlag(WXFlag);// 是否为微信渠道
			input.setAppSource(appSource);// 是否APP渠道
			input.setMobilePhone(mobilePhone);// 手机号
			orderMainDto = execOrderSubmit(appIntergralAddOrder, input);
			if (orderMainDto.getReturnCode() != null) {
				return orderMainDto;
			}
		} catch (Exception e) {
			orderMainDto.setReturnCode("000009");
			orderMainDto.setReturnDes("系统异常!");
			return orderMainDto;
		}

		if (orderMainDto.getGoodsCount() > 99) {// 如果大于99
			orderMainDto.setReturnCode("000047");
			orderMainDto.setReturnDes("商品数目不能大于99");
			return orderMainDto;
		}
		int total_numi = Integer.parseInt(total_num.trim());
		if (total_numi != orderMainDto.getGoodsCount()) {// 如果商品总数不相等
			orderMainDto.setReturnCode("000048");
			orderMainDto.setReturnDes("商品总数不相等");
			return orderMainDto;
		}

		if (is_invoice != null && "1".equals(is_invoice.trim())) {// 如果需要发票，发票抬头不能为空
			if (invoice == null || "".equals(invoice.trim())) {
				orderMainDto.setReturnCode("000046");
				orderMainDto.setReturnDes("发票抬头不能为空");
				return orderMainDto;
			}
		}
		String total_price = "";
		if ("YG".equals(ordertype_id)) {// 一期 检验总一期价格YG
			total_price = totvalueYG;
			if (totvalueYG == null || "".equals(totvalueYG.trim())) {
				orderMainDto.setReturnCode("000008");
				orderMainDto.setReturnDes("一期总价为空");
				return orderMainDto;
			}
		} else if ("FQ".equals(ordertype_id)) {// 分期 检验总分期价格 FQ
			total_price = totvalueFQ;
			if (totvalueFQ == null || "".equals(totvalueFQ.trim())) {
				orderMainDto.setReturnCode("000008");
				orderMainDto.setReturnDes("分期价格为空");
				return orderMainDto;
			}
		} else {
			orderMainDto.setReturnCode("000081");
			orderMainDto.setReturnDes("未知的支付类型");
			return orderMainDto;
		}
		if (orderMainDto.getTotalPrice().compareTo(new BigDecimal(total_price)) != 0) {// 小订单总价格与报文中总价格不一致
			orderMainDto.setReturnCode("000051");
			orderMainDto.setReturnDes("商品总价格不相等");
			return orderMainDto;
		}


		//校验积分是否足够 APP 端添加
		if(orderMainDto.getJfTotalNum()!=null&&orderMainDto.getJfTotalNum()>0l){
			if(!Strings.isNullOrEmpty(appIntergralAddOrder.getCardNo())){
				BigDecimal bunusum =new BigDecimal(this.getCustTotalBonus(appIntergralAddOrder.getCardNo()));
				// add checkreturn
				if (!(bunusum.compareTo(new BigDecimal(orderMainDto.getJfTotalNum())) >= 0)) {
					orderMainDto.setReturnCode("000047");
					orderMainDto.setReturnDes("您当前的剩余积分不足");
					return orderMainDto;
				}
			}
			if(orderMainDto.getJfTotalNumNoFix()!=null && orderMainDto.getJfTotalNumNoFix()>0){
				// 固定积分不占用积分池
				Response<PointPoolModel> pointResult = pointsPoolService.getCurMonthInfo();
				// add checkreturn
				if (!(pointResult.isSuccess() && pointResult.getResult() != null)) {
					orderMainDto.setReturnCode("000047");
					orderMainDto.setReturnDes("取得积分池失败");
					return orderMainDto;
				}
				// add end
				PointPoolModel pointPoolModel = pointResult.getResult();
				Long maxPoint = pointPoolModel.getMaxPoint();
				Long usedPoint = pointPoolModel.getUsedPoint();

				// add checkreturn
				if (!(orderMainDto.getJfTotalNumNoFix() <= maxPoint - usedPoint)) {
					orderMainDto.setReturnCode("000047");
					orderMainDto.setReturnDes("本月广发商城积分抵现活动已结束，下月1日起可继续参与。");
					return orderMainDto;
				}
				//使用的非固定积分
				pointPoolModel.setUsedPoint(orderMainDto.getJfTotalNumNoFix());
				pointPoolModel.setModifyOper(user.getId());
				orderMainDto.setPointPoolModel(pointPoolModel);
			}


		}

		Map<String, Integer> goodsCountMap = orderMainDto.getGoodsCountMap();
		Map<String, ItemModel> itemModelMap = orderMainDto.getItemModelMap();
		Map<String, MallPromotionResultDto> promotionMap = new HashMap<>();
		if(orderMainDto.getPromotionMap() != null){
			promotionMap = orderMainDto.getPromotionMap();
		}

		for(String itemCode : orderMainDto.getItemModelMap().keySet()){
			int count = goodsCountMap.get(itemCode);
			ItemModel itemModel = itemModelMap.get(itemCode);
			MallPromotionResultDto mallPromotionResultDto = promotionMap.get(itemCode);
			if (mallPromotionResultDto != null) {
				// 荷兰拍 满减
				if (mallPromotionResultDto.getPromType().intValue() != 50) {
					// 活动购买数量校验promotionLimitMap
					Response<Boolean> checkPromBuyCountResponse = mallPromotionService.checkPromBuyCount(mallPromotionResultDto.getId().toString(),
							mallPromotionResultDto.getPeriodId(),
							String.valueOf(count), user, itemCode);
					if(!checkPromBuyCountResponse.isSuccess() || !checkPromBuyCountResponse.getResult()){
						orderMainDto.setReturnCode("000059");
						orderMainDto.setReturnDes("您所购买的活动商品数量已达到上限，无法继续参加活动");
					}
				}

				// 活动商品数量校验
				Response<Boolean> checkPromItemStockResponse = mallPromotionService.checkPromItemStock(mallPromotionResultDto.getId().toString(),
						mallPromotionResultDto.getPeriodId(), itemCode, String.valueOf(count));
				if(!checkPromItemStockResponse.isSuccess() || !checkPromItemStockResponse.getResult()){
					orderMainDto.setReturnCode("000038");
					orderMainDto.setReturnDes("您所选中的活动商品库存数量不足，无法继续参加活动");
				}
				Map<String,String> itemMap=new HashMap<String, String>();
				itemMap.put("promId", mallPromotionResultDto.getId().toString());
				itemMap.put("periodId", mallPromotionResultDto.getPeriodId());
				itemMap.put("itemCode", itemCode);
				itemMap.put("itemCount", String.valueOf(count));
				itemMap.put("promotionType", mallPromotionResultDto.getPromType().toString());
				//设置 活动单品库存
				orderMainDto.addProItemMap(itemMap);
			}else{//普通商品库存
				orderMainDto.putStock(itemModel.getCode(), (long)count);
			}
		}

		return orderMainDto;
	}

	private OrderMainDto execOrderSubmit(AppIntergralAddOrder orderDto,
										 OrderMainSingleCheckDto input) throws Exception {
		OrderMainDto orderMainDto = new OrderMainDto();
		List<AppIntergralAddOrderPrivilege> dtos = orderDto
				.getAppIntergralAddOrderPrivileges();
		StringBuilder miaoshaFlag = new StringBuilder();
		if (dtos.size() == 1) {
			OrderMainSingleCheckDto ret = singleCommitCheck(dtos.get(0), input, miaoshaFlag);
			if(!Strings.isNullOrEmpty(ret.getReturnCode())){
				orderMainDto.setReturnCode(ret.getReturnCode());
				orderMainDto.setReturnDes(ret.getReturnDes());
				return orderMainDto;
			}
			orderMainDto.addOrderMainData(ret);
		} else {
			// 多线程执行
			ExecutorService executorService = Executors.newFixedThreadPool(dtos
					.size());
			CompletionService completionService = new ExecutorCompletionService(
					executorService);
			for (int i = 0; i < dtos.size(); i++) {
				completionService.submit(callSingleCommitCheck(dtos.get(i),
						input, miaoshaFlag));
			}
			for (int j = 0; j < dtos.size(); j++) {
				OrderMainSingleCheckDto ret = (OrderMainSingleCheckDto) completionService
						.take().get();
				if (ret.getReturnCode() != null) {
					orderMainDto.setReturnCode(ret.getReturnCode());
					orderMainDto.setReturnDes(ret.getReturnDes());
					return orderMainDto;
				}
				orderMainDto.addOrderMainData(ret);
			}
			executorService.shutdown();
		}
		orderMainDto.setMiaoshaFlag(miaoshaFlag.toString());
		return orderMainDto;
	}

	/**
	 * 解码包含中文的字段
	 *
	 * @param str
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	private String decode(String str) {
		if (!Tools.isEmpty(str)) {
			try {
				str = URLDecoder.decode(str, "utf-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return str;
	}

	/**
	 * 检查字段长度
	 *
	 * @paramstr
	 * @paramlen
	 * @return
	 */
	private String checkLength(String[] fieldName, String[] fieldContext,
							   int[] fieldLen) {
		for (int i = 0; i < fieldName.length; i++) {
			if (!Tools.isEmpty(fieldContext[i])) {
				if (fieldContext[i].getBytes().length > fieldLen[i]) {
					return "报文参数错误:" + fieldName[i] + "长度必须小于等于" + fieldLen[i];
				}
			}
		}
		return null;
	}

	/**
	 * 校验活动
	 */
	/**
	 * 将double转换成字符串(xxx.xx),保留两位小数
	 *
	 * @param dou
	 * @return String
	 */
	public static String formatDouble(Double dou) {
		if (dou == null) {
			return "";
		}
		DecimalFormat format = new DecimalFormat("0.00");
		return format.format(dou);
	}

	/**
	 * 判断date是否处在beginDate和endDate之间 用于微信易信接口，解决多线程调用出现的异常
	 * SimpleDateFormat是非线程安全，多线程调用同一个SimpleDateFormat对象会报NumberFormatException:
	 * multiple points异常
	 *
	 * @param date
	 * @param beginDate
	 * @param endDate
	 * @return
	 * @throws ParseException
	 */
	public static boolean isBetweenTimeForWX(Date date, String beginDate,
											 String endDate) throws ParseException {
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
		Date theBeginDate = format.parse(beginDate);
		Date theEndDate = format.parse(endDate);
		if (date.compareTo(theBeginDate) < 0) {// 如果在beginDate之前
			return false;
		}
		if (date.compareTo(theEndDate) > 0) {// 如果在theEndDate之后
			return false;
		}
		return true;
	}

	/**
	 * 判断date是否处在beginDate和endDate之间, 用于微信易信接口，解决多线程调用出现的异常
	 * SimpleDateFormat是非线程安全，多线程调用同一个SimpleDateFormat对象会报NumberFormatException:
	 * multiple points异常
	 *
	 * @param date
	 * @param beginDate
	 * @param endDate
	 * @return
	 * @throws ParseException
	 */
	public boolean isBetweenForWX(Date date, String beginDate, String endDate) {
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		Date theBeginDate = null;
		try {
			theBeginDate = format.parse(beginDate);
			Date theEndDate = format.parse(endDate);
			Calendar cal = Calendar.getInstance();// 使用默认时区和语言环境获得一个日历。
			cal.setTime(theEndDate);
			cal.add(Calendar.DAY_OF_MONTH, +1);// 取当前日期的前一天.
			theEndDate = cal.getTime();
			if (date.compareTo(theBeginDate) < 0) {// 如果在beginDate之前
				return false;
			}
			if (date.compareTo(theEndDate) > 0) {// 如果在theEndDate之后
				return false;
			}
		} catch (ParseException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public static int dayForWeek(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		return cal.get(Calendar.DAY_OF_WEEK);
	}

	public static boolean isBetweenTime(String nowTime, String beginTime,
										String endTime) throws ParseException {
		if (Tools.isEmpty(nowTime) || Tools.isEmpty(beginTime)
				|| Tools.isEmpty(endTime)) {
			return false;
		}
		int nowTimeInt = Integer.parseInt(nowTime);
		int beginTimeInt = Integer.parseInt(beginTime);
		int endTimeInt = Integer.parseInt(endTime);

		if (nowTimeInt >= beginTimeInt && nowTimeInt <= endTimeInt) {
			return true;
		}
		return false;
	}

	// private String getMaxEndTime(String endTime, String endTime2) {
	// if (!Tools.isEmpty(endTime) && !Tools.isEmpty(endTime2)) {
	// int endTimeInt = Integer.parseInt(endTime);
	// int endTime2Int = Integer.parseInt(endTime2);
	// if (endTime2Int >= endTimeInt) {
	// return endTime2;
	// }
	// }
	// return endTime;
	// }

	public boolean jugWeek(String weekDay, String actFrequency) {
		return StringUtils.contains(actFrequency, weekDay);
	}

	/**
	 * 去null操作
	 *
	 * @param str
	 * @return
	 */
	public static String dealNull(String str) {
		if (str == null) {
			return "";
		}
		return str;
	}

	/**
	 * 转换微信渠道的”发起方“ 发起方 微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS 对应数据库
	 * 微信广发银行：05；微信信用卡中心：06；易信广发银行：07；易信信用卡中心：08
	 */
	private String getOriginName(String origin) {
		String originNm = "APP";
		if (Contants.SOURCE_ID_WECHAT.equals(origin)) {// 微信广发银行
			originNm = Contants.ORDER_SOURCE_NM_WX;
		}
		if (Contants.SOURCE_ID_WECHAT_A.equals(origin)) {// 微信信用卡中心
			originNm = Contants.ORDER_SOURCE_NM_WS;
		}
		if (Contants.SOURCE_ID_YIXIN.equals(origin)) {// 易信广发银行
			originNm = Contants.ORDER_SOURCE_NM_YX;
		}
		if (Contants.SOURCE_ID_YIXIN_A.equals(origin)) {// 易信信用卡中心
			originNm = Contants.ORDER_SOURCE_NM_YS;
		}
		if (Contants.ORDER_SOURCE_ID_09.equals(origin)) {// APP
			originNm = Contants.ORDER_SOURCE_NM_09;
		}
		if (Contants.ORDER_SOURCE_ID_MOBILE.equals(origin)) {// APP
			originNm = Contants.ORDER_SOURCE_NM_MOBILE;
		}
		if (Contants.ORDER_SOURCE_ID_CC.equals(origin)) {// APP
			originNm = Contants.ORDER_SOURCE_NM_CC;
		}
		if (Contants.ORDER_SOURCE_ID_IVR.equals(origin)) {// APP
			originNm = Contants.ORDER_SOURCE_NM_IVR;
		}
		return originNm;
	}

	/**
	 * 转换微信渠道的”发起方“ 发起方 微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS 对应数据库
	 * 微信广发银行：05；微信信用卡中心：06；易信广发银行：07；易信信用卡中心：08
	 */
	private String changeOrigin(String origin) {
		if (Contants.CHANNEL_SN_WX.equals(origin)) {
			return Contants.SOURCE_ID_WECHAT;
		}
		if (Contants.CHANNEL_SN_WS.equals(origin)) {
			return Contants.SOURCE_ID_WECHAT_A;
		}
		if (Contants.CHANNEL_SN_YX.equals(origin)) {
			return Contants.SOURCE_ID_YIXIN;
		}
		if (Contants.CHANNEL_SN_YS.equals(origin)) {
			return Contants.SOURCE_ID_YIXIN_A;
		}
		return origin;
	}

	/**
	 * 异步执行处理
	 */
	private Callable<OrderMainSingleCheckDto> callSingleCommitCheck(
			final AppIntergralAddOrderPrivilege dto,
			final OrderMainSingleCheckDto input, final StringBuilder miaoshaFlag) {
		Callable<OrderMainSingleCheckDto> ret = new Callable<OrderMainSingleCheckDto>() {
			@Override
			public OrderMainSingleCheckDto call() throws Exception {
				return singleCommitCheck(dto, input, miaoshaFlag);
			}
		};
		return ret;
	}

	private OrderMainSingleCheckDto singleCommitCheck(
			AppIntergralAddOrderPrivilege appIntergralAddOrderPrivilege,
			OrderMainSingleCheckDto input, StringBuilder miaoshaFlag) {
		OrderMainSingleCheckDto retDto = new OrderMainSingleCheckDto();
		String goods_id = appIntergralAddOrderPrivilege.getGoodsId();// 商品ID
		String goods_num = appIntergralAddOrderPrivilege.getGoodsNum();
		String goods_payway_id = appIntergralAddOrderPrivilege
				.getGoodsPaywayId();// 支付方式ID

		String privilegeName = appIntergralAddOrderPrivilege.getPrivilegeName();// 优惠券名称
		String deduction = appIntergralAddOrderPrivilege.getDiscountPrivMon();// 积分抵扣金额
		BigDecimal deductionB = BigDecimal.valueOf(0);
		if (deduction != null && !deduction.equals("")) {
			deductionB = new BigDecimal(deduction);
		}
		// APP 渠道需要中文转码
		if (input.getAppSource()) {
			privilegeName = decode(privilegeName);
		}
		String privilegeId = appIntergralAddOrderPrivilege.getPrivilegeId();// 优惠券ID
		String privilegeMoney = appIntergralAddOrderPrivilege
				.getPrivilegeMoney();// 优惠券金额
		BigDecimal discountPrivMonB = new BigDecimal(0);
		String pointType = appIntergralAddOrderPrivilege.getPointType();
		String discountPrivMon = dealNull(appIntergralAddOrderPrivilege
				.getDiscountPrivMon());// 抵扣积分金额
		if (!discountPrivMon.equals("")) {
			discountPrivMonB = new BigDecimal(discountPrivMon);
		}
		String discountPrivilege = dealNull(appIntergralAddOrderPrivilege
				.getDiscountPrivilege()); // 抵扣积分
		if (!Tools.isEmpty(privilegeName)
				&& privilegeName.getBytes().length > 40) {
			retDto.setReturnCode("000008");
			retDto.setReturnDes("报文参数错误:privilegeName长度必须小于等于40");
			return retDto;
		}
		// 积分值判断类型 如果抵扣积分和抵扣金额为空则没有使用积分
		if ("".equals(discountPrivilege) && ("".equals(deduction) || "0".equals(deduction))) {
			// 没有使用积分
			retDto.setJfCount(0l);
			// 积分抵扣金额
			retDto.setFixFlag(true);
			// todo orderCommitInfo314Dto.setDiscountPercent();
		} else if (!"".equals(discountPrivilege) && ("".equals(deduction) || "0".equals(deduction))) {
			// 积分不为空，积分金额为空 判断为固定积分
			retDto.setJfCount(Long.parseLong(discountPrivilege)
					* Integer.parseInt(goods_num));
			// 积分抵扣金额
			retDto.setFixFlag(true);
		} else if (!"".equals(discountPrivilege) && !"".equals(deduction)
				&& 0 != new BigDecimal(0).compareTo(deductionB)) {
			// 都不为空判断为不固定积分
			retDto.setJfCount(Long.parseLong(discountPrivilege)
					* Integer.parseInt(goods_num));
			retDto.setFixFlag(false);
			retDto.setJfTotalNumNoFix(Long.valueOf(discountPrivilege));
		}
		//

		int goods_numi = Integer.parseInt(goods_num);
		ItemModel itemModel = itemService.findById(goods_id);
		// 如果找不到商品
		if (itemModel == null) {// 如果找不到商品
			retDto.setReturnCode("000031");
			retDto.setReturnDes("找不到该商品");
			return retDto;
		}
		// 判断商品有没有活动 如果有活动从 promotionPayway中获取价格 否则获取goodsPayway中的价格
		Response<MallPromotionResultDto> result = mallPromotionService
				.findPromByItemCodes("1", itemModel.getCode(),// 活动进行中
						input.getOrigin());
		boolean isPromotion = false;// 是否活动
		// 如果是活动则获取promotionPayWay 否则获取 goodsPayway
		PromotionPayWayModel promotionPaywayModel = new PromotionPayWayModel();// 活动的PayWay
		TblGoodsPaywayModel goodsPayWayModel = new TblGoodsPaywayModel();// 普通PayWay
		int count = appIntergralAddOrderPrivilege.getGoodsNum().equals("") ? 0
				: Integer.valueOf(appIntergralAddOrderPrivilege.getGoodsNum());
		if (!(count > 0)) {// 购买数量必须大于0
			retDto.setReturnCode("000031");
			retDto.setReturnDes("购买数量不能小于1");
			return retDto;
		}
		Response<TblGoodsPaywayModel> goodsPaywayResult = goodsPayWayService
				.findGoodsPayWayInfo(goods_payway_id);
		if (goodsPaywayResult.isSuccess()) {
			if (goodsPaywayResult.getResult() != null) {
				goodsPayWayModel = goodsPaywayResult.getResult();
				//设置原价
				retDto.setOriPrice(goodsPayWayModel.getGoodsPrice());
			}
		}
		MallPromotionResultDto mallPromotionResultDto = null;
		if (result.isSuccess()) {
			if (result.getResult() != null) {
				// 活动对象扔到map中 拼装小订单使用
				mallPromotionResultDto = result.getResult();
				if(50==mallPromotionResultDto.getPromType()){
					retDto.setReturnCode("000031");
					retDto.setReturnDes("该渠道不能购买荷兰拍活动的商品！");
					return retDto;
				}
				isPromotion = true;// 商品存在活动
				Integer promotionId = mallPromotionResultDto.getId();
				Map<String, Object> param = new HashMap<>();
				param.put("goodsPaywayId", goods_payway_id);
				param.put("promId", promotionId);
				Response<PromotionPayWayModel> resultResponse = promotionPayWayService
						.findPomotionPayWayInfoByParam(param);
				if (resultResponse.isSuccess() && resultResponse.getResult() != null) {
					promotionPaywayModel = resultResponse.getResult();
					if (promotionPaywayModel == null) {
						retDto.setReturnCode("000031");
						retDto.setReturnDes("找不到该商品价格信息");
						return retDto;
					}
					// 将活动payway赋值到普通payway两个VO完全一样 最后使用普通payway进行处理
					goodsPayWayModel = BeanUtils.copy(promotionPaywayModel,TblGoodsPaywayModel.class);

					//0元秒杀只能购买一件
					if(mallPromotionResultDto.getPromType() == (int)Contants.PROMOTION_PROM_TYPE_3 &&
							new BigDecimal(0).compareTo(promotionPaywayModel.getGoodsPrice()) == 0){
						if( count > 1){
							retDto.setReturnCode("000060");
							retDto.setReturnDes("限购产品一次只能购买一件");
							return retDto;
						}
						miaoshaFlag.append(ZERO_FLAG);
					}
				}
			}
		}
		if (isPromotion) {// 存在活动payway判断
			if ("d".equalsIgnoreCase(promotionPaywayModel.getIscheck())) {// 如果支付方式已被删除
				retDto.setReturnCode("000016");
				retDto.setReturnDes("该支付方式已经删除");
				return retDto;
			}
		} else {// 没有活动payway
			if ("d".equalsIgnoreCase(goodsPayWayModel.getIscheck())) {// 如果支付方式已被删除
				retDto.setReturnCode("000016");
				retDto.setReturnDes("该支付方式已经删除");
				return retDto;
			}
		}

		GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode())
				.getResult();

		Response<VendorInfoDto> vendorInfoDtoResponse = vendorService
				.findById(goodsModel.getVendorId());
		VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();
		// 如果找不到商品
		if (goodsModel == null || vendorInfoDtoResponse == null
				|| vendorInfoDto == null) {
			retDto.setReturnCode("000031");
			retDto.setReturnDes("找不到该商品");
			return retDto;
		}
		if (vendorInfoDtoResponse == null || vendorInfoDto == null) {// 如果不存在相应的合作商
			retDto.setReturnCode("000034");
			retDto.setReturnDes("对应合作商不存在");
			return retDto;
		}
		// 判断是否为O2O商品，若为O2O商品，并且手机上送的收货人手机号（csg_phone1）为空，则拒绝下单，返回“000098：交易中包含特殊商品，送货地址的手机号码必须填写”
		if (vendorInfoDto.getVendorRole() != null
				&& "3".equals(vendorInfoDto.getVendorRole())) {
			if (input.getMobilePhone() == null||"".equals(input.getMobilePhone())) {
				retDto.setReturnCode("000098");
				retDto.setReturnDes("交易中包含特殊商品，送货地址的手机号码必须填写");
				return retDto;
			}
		}
		// 对于微信渠道，如果是有限购，需要判断购买的数量不能超过限购的数量
		if (input.getWXFlag()) {
			if (goodsModel.getLimitCount() != null
					&& goods_numi > 9) {
				retDto.setReturnCode("000030");
				retDto.setReturnDes("商品" + goodsModel.getName() + "限购"
						+ goodsModel.getLimitCount() + "件");
				return retDto;
			}
		}
		if (Contants.SOURCE_ID_WECHAT.equals(input.getOrigin())) {// 微信广发银行
			if (!"02".equals(goodsModel.getChannelMallWx())) {
				retDto.setReturnCode("000036");
				retDto.setReturnDes("该商品不是上架状态");
				return retDto;
			}
		}
		if (Contants.SOURCE_ID_WECHAT_A.equals(input.getOrigin())) {// 微信信用卡中心
			if (!"02".equals(goodsModel.getChannelCreditWx())) {
				retDto.setReturnCode("000036");
				retDto.setReturnDes("该商品不是上架状态");
				return retDto;
			}
		}

		if (Contants.ORDER_SOURCE_ID_MOBILE.equals(input.getOrigin())) {// APP
			// 未完成
			if (!"02".equals(goodsModel.getChannelPhone())) {
				retDto.setReturnCode("000036");
				retDto.setReturnDes("该商品不是上架状态");
				return retDto;
			}
		}
		// 校验最大抵扣积分
		// 最大积分校验
		// 不用效验固定积分 活动加
//		if (itemModel.getMaxPoint() != null) {
//			// add checkReturn
//			Long maxPoint = Strings.isNullOrEmpty(appIntergralAddOrderPrivilege
//					.getDiscountPrivilege()) ? 0 : Long
//					.valueOf(appIntergralAddOrderPrivilege
//							.getDiscountPrivilege());
//			if (itemModel.getMaxPoint() < maxPoint) {
//				retDto.setReturnCode("000070");
//				retDto.setReturnDes("所用积分不能大于商品最大抵扣积分");
//				return retDto;
//			}
//		}
		
		// 检测商品数量
		int goods_backlog = itemModel.getStock().intValue();
		int goods_backlogI = goods_backlog - goods_numi;// 扣减后的商品数量
		if (goods_backlogI < 0) {// 如果扣除商品数量后实际库存小于0
			retDto.setReturnCode("000038");
			retDto.setReturnDes("产品已售罄，请您挑选其他的产品。");
			return retDto;
		}
		retDto.setPayWayId(goods_payway_id);
		retDto.setPointType(pointType);// 积分类型
		retDto.setDiscountPrivMon(discountPrivMonB);// 积分抵扣金额
		retDto.setCustCartId(appIntergralAddOrderPrivilege.getCustCartId());// 购物车ID
		retDto.setMallPromotionResultDto(mallPromotionResultDto);// 活动
		retDto.setPrivilegeId(privilegeId);// 优惠劵id
		retDto.setPrivilegeName(privilegeName);// 优惠劵名称
		BigDecimal privilegeMoneyBd = Strings.isNullOrEmpty(privilegeMoney) ? new BigDecimal(0l) : new BigDecimal(privilegeMoney);
		retDto.setVoucherPriceTotal(privilegeMoneyBd);
		retDto.setPrivilegeMoney(privilegeMoneyBd);// 优惠劵金额
		retDto.setDeduction(deductionB);// 积分抵扣金额
		retDto.setItemModel(itemModel);
		retDto.setGoodsModel(goodsModel);
		retDto.setTblGoodsPaywayModel(goodsPayWayModel);
		retDto.setPayWayId(goods_payway_id);
		retDto.setVendorInfoDto(vendorInfoDto);
		retDto.setVendorId(goodsModel.getVendorId());
		retDto.setTotalPrice(goodsPayWayModel.getGoodsPrice().multiply(
				new BigDecimal(goods_numi)).subtract(discountPrivMonB).subtract(privilegeMoneyBd));
		discountPrivilege = Strings.isNullOrEmpty(discountPrivilege) ? "0" : discountPrivilege;
		retDto.setJfTotalNum(Long.parseLong(discountPrivilege));
		// APP渠道特殊处理 需要将  使用积分x数量   和  积分抵扣金额x数量
		if (input.getAppSource() || input.getWXFlag()) {
		//使用积分*数量 只有APP 需特殊处理
		retDto.setJfTotalNum(new BigDecimal(goods_numi).multiply(new BigDecimal(discountPrivilege)).longValue());	
		//积分抵扣金额x数量
		retDto.setTotalPrice(goodsPayWayModel.getGoodsPrice().multiply(
		new BigDecimal(goods_numi)).subtract(discountPrivMonB.multiply(new BigDecimal(goods_numi))).subtract(privilegeMoneyBd));
		}
		retDto.setGoodsCount(goods_numi);
		return retDto;
	}

	/**
	 * 构建大订单
	 *
	 * @param appIntergralAddOrder
	 * @param orderMainDto
	 * @return
	 */
	private OrderMainModel createOrderMainModel(
			AppIntergralAddOrder appIntergralAddOrder, OrderMainDto orderMainDto) {
		String origin = dealNull(appIntergralAddOrder.getOrigin());// 发起方
		// 调用方标识:如手机商城:03，微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS；APP：09

		String ordertype_id = dealNull(appIntergralAddOrder.getOrdertypeId()); // 订单类型
		// YG:一次性支付(借记卡)
		// FQ：分期支付（信用卡）
		String cont_id_type = dealNull(appIntergralAddOrder.getContIdType());// 订货人证件类型
		String cont_idcard = dealNull(appIntergralAddOrder.getContIdcard()); // 订货人证件号码
		String cont_nm = dealNull(appIntergralAddOrder.getContNm());// 订货人姓名
		String cont_postcode = dealNull(appIntergralAddOrder.getContPostcode());// 订货人邮政编码
		String cont_address = dealNull(appIntergralAddOrder.getContAddress());// 订货人详细地址
		String cont_mob_phone = dealNull(appIntergralAddOrder.getContMobPhone());// 订货人手机
		String cont_hphone = dealNull(appIntergralAddOrder.getContHphone());// 订货人家里电话
		String csg_name = dealNull(appIntergralAddOrder.getCsgName()); // 收货人姓名
		String csg_postcode = dealNull(appIntergralAddOrder.getCsgPostcode());// 收货人邮政编码
		String csg_address = dealNull(appIntergralAddOrder.getCsgAddress());// 收货人详细地址
		String csg_phone1 = dealNull(appIntergralAddOrder.getCsgPhone1());// 收货人手机
		String csg_phone2 = dealNull(appIntergralAddOrder.getCsgPhone2());// 收货人家里电话
		String bp_cust_grp = StringUtils.isEmpty(appIntergralAddOrder
				.getSendTime()) ? "01" : appIntergralAddOrder.getSendTime();// 送货时间
		// 01: 工作日、双休日与假日均可送货
		// 02: 只有工作日送货（双休日、假日不用送）
		// 03: 只有双休日、假日送货（工作日不用送货）
		String is_invoice = dealNull(appIntergralAddOrder.getIsInvoice());// 是否发票
		String invoice = dealNull(appIntergralAddOrder.getInvoice());// 发票抬头
		String invoice_type = dealNull(appIntergralAddOrder.getInvoiceType());// 发票类型
		String invoice_content = dealNull(appIntergralAddOrder
				.getInvoiceContent());// 发票内容
		String ordermain_desc = dealNull(appIntergralAddOrder
				.getOrdermainDesc());// 备注
		String cust_sex = dealNull(appIntergralAddOrder.getCustSex()); // 性别0：男；1：女
		String cust_email = dealNull(appIntergralAddOrder.getCustEmail());// 邮箱
		String csg_province = dealNull(appIntergralAddOrder.getCsgProvince()); // 省
		String csg_city = dealNull(appIntergralAddOrder.getCsgCity());// 市
		String csg_borough = dealNull(appIntergralAddOrder.getCsgBorough());// 区
		String cardNo = dealNull(appIntergralAddOrder.getCardNo());// 卡号
		// APP渠道包含中文字段需要解码
		if (Contants.ORDER_SOURCE_ID_09.equals(origin)) {
			cont_nm = decode(cont_nm);// 订货人姓名
			cont_address = decode(cont_address);// 订货人详细地址
			csg_name = decode(csg_name);// 收货人姓名
			csg_address = decode(csg_address);// 收货人详细地址
			invoice = decode(invoice);// 发票抬头
			invoice_type = decode(invoice_type);// 发票类型
			invoice_content = decode(invoice_content);// 发票内容
			ordermain_desc = decode(ordermain_desc);// 备注
			csg_province = decode(csg_province);// 省
			csg_city = decode(csg_city);// 市
			csg_borough = decode(csg_borough);// 区
		}
		log.info("mail314转换参数结束");
		OrderMainModel orderMainModel = new OrderMainModel();
		// orderMainModel.setAddressId(); 源代码没有收货地址ID
		orderMainModel.setBpCustGrp(bp_cust_grp);
		orderMainModel.setCardno(cardNo);
		orderMainModel.setIsInvoice(is_invoice);
		orderMainModel.setInvoice(invoice);
		orderMainModel.setOrdermainDesc(ordermain_desc);
		String payType = Contants.CART_PAY_TYPE_1;
		if (Contants.BUSINESS_TYPE_YG.equals(ordertype_id)) {
			payType = Contants.CART_PAY_TYPE_1;
		} else if (Contants.BUSINESS_TYPE_FQ.equals(ordertype_id)) {
			payType = Contants.CART_PAY_TYPE_2;
		} else {
			payType = Contants.CART_PAY_TYPE_3;
		}
		origin = changeOrigin(origin);
		String originNm = getOriginName(origin);
		// orderMainModel.setOrigin(origin);
		// orderMainModel.setOriginNm(originNm);
		// orderMainModel.setMiaoFlag();
		// orderMainModel.setOrderId();
		// orderMainModel.setPayFlag();
		// 单品总数量
		Integer totalNum = orderMainDto.getGoodsCount();
		// 积分总数
		Long jfTotalNum = orderMainDto.getJfTotalNum();
		// 总金额
		BigDecimal totalPrice = orderMainDto.getTotalPrice();
		// 总积分抵扣金额
		BigDecimal deduction = orderMainDto.getDeduction();
		// 总优惠券金额
		BigDecimal voucherPriceTotal = orderMainDto.getVoucherPriceTotal();
		// 商品类型实物o2o
		String goodsType = orderMainDto.getGoodsType();
		// 根据支付方式判断
		if (Contants.CART_PAY_TYPE_1.equals(payType) || ZERO_FLAG.equals(orderMainDto.getMiaoshaFlag())) {//0元秒杀订单类型也为YG
			orderMainModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			orderMainModel.setOrdertypeNm(Contants.BUSINESS_TYPE_NM_YG);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			orderMainModel.setIsmerge("1");// 是否合并支付0是1否
		}
		if (Contants.CART_PAY_TYPE_2.equals(payType)) {
			orderMainModel.setOrdertypeId(Contants.BUSINESS_TYPE_FQ);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			orderMainModel.setOrdertypeNm(Contants.BUSINESS_TYPE_NM_FQ);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			orderMainModel.setIsmerge("0");// 是否合并支付0是1否
		}
		orderMainModel.setCardno(cardNo);// 卡号
		// change
		orderMainModel.setSourceId(origin);
		orderMainModel.setSourceNm(originNm);
		// change end
		orderMainModel.setTotalNum(totalNum);// 商品总数量

		//FIXME 优惠券和积分抵扣金额不是已经减了吗
//	orderMainModel.setTotalPrice(totalPrice.subtract(voucherPriceTotal)
//		.subtract(deduction));// 现金总金额
		orderMainModel.setTotalPrice(totalPrice);// 现金总金额
		orderMainModel.setBonusDiscount(deduction);// 积分抵扣金额
		orderMainModel.setVoucherDiscount(voucherPriceTotal);// 优惠券金额
		orderMainModel.setTotalBonus(jfTotalNum);// 商品总积分数量
		orderMainModel.setLockedFlag("0");// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）
		if (orderMainModel.getTotalPrice().compareTo(new BigDecimal(0)) > 0) {
			orderMainModel.setIsInvoice(is_invoice.equals("1") ? "1" : "0");// 是否开发票0-否，1-是
			orderMainModel.setInvoice(invoice);// 发票抬头
		} else {// add 20160922 零元秒杀默认不开发票
			orderMainModel.setIsInvoice("0");// 是否开发票0-否，1-是
			orderMainModel.setInvoice("");// 发票抬头
		}
		orderMainModel.setOrdermainDesc(ordermain_desc);// 订单主表备注
		orderMainModel.setContIdType(cont_id_type);// change订货人证件类型
		orderMainModel.setContIdcard(cont_idcard);// change订货人证件号码
		orderMainModel.setContNm(cont_nm);// change订货人姓名
		orderMainModel.setContPostcode(cont_postcode);// change订货人邮政编码
		orderMainModel.setContAddress(cont_address);// change订货人详细地址
		orderMainModel.setContMobPhone(cont_mob_phone);// change 订货人手机
		orderMainModel.setContHphone(cont_hphone);// change订货人家里电话
		orderMainModel.setMerId(merchId);// 大商户号
		Date d = DateTime.now().toDate();
		orderMainModel.setCommDate(DateHelper.getyyyyMMdd(d));// 业务日期
		orderMainModel.setCommTime(DateHelper.getHHmmss(d));// 业务时间
		orderMainModel.setCustSex(cust_sex);// change性别
		orderMainModel.setCustEmail(cust_email); // change
		orderMainModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功2：更新失败
		if (Contants.SUB_ORDER_TYPE_00.equals(goodsType)) {
			orderMainModel.setBpCustGrp(bp_cust_grp);// 送货时间01:
			orderMainModel.setCsgName(csg_name);// 收货人姓名
			orderMainModel.setCsgPostcode(csg_postcode);// 收货人邮政编码
			orderMainModel.setCsgAddress(csg_address);// 收货人详细地址
			orderMainModel.setCsgPhone1(csg_phone1);// 收货人电话一
			orderMainModel.setCsgPhone2(csg_phone2);// 收货人电话二
			orderMainModel.setCsgProvince(csg_province);// 省
			orderMainModel.setCsgCity(csg_city);// 市
			orderMainModel.setCsgBorough(csg_borough);// 区
			orderMainModel.setAcctAddFlag("1");// 收货地址是否是帐单地址0-否1-是
		} else {
			if (Contants.SUB_ORDER_TYPE_02.equals(goodsType)) {
				orderMainModel.setCsgName(cont_nm);// 客户姓名
				orderMainModel.setCsgPhone1(cont_mob_phone);// 收码电话
			}
		}
		if(ZERO_FLAG.equals(orderMainDto.getMiaoshaFlag())){//0元秒杀直接支付成功
			orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0308);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
			orderMainModel.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
		}else{
			orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
			orderMainModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
		}
		orderMainModel.setCreateOper(appIntergralAddOrder.getCreateOper());// 创建操作员id
		orderMainModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
		// 数据库不为空项
		orderMainModel.setPermLimit(new BigDecimal(0));
		orderMainModel.setCashLimit(new BigDecimal(0));
		orderMainModel.setStagesLimit(new BigDecimal(0));
		String orderMainId = idGenarator.orderMainId(orderMainModel
				.getSourceId());
		orderMainModel.setOrdermainId(orderMainId);
		orderMainModel.setSerialNo(idGenarator.orderSerialNo());
		orderMainModel.setCreateTime(d);
		orderMainModel.setModifyTime(d);
		return orderMainModel;
	}

	private OrderSubDetailDto createSubDetail(
			AppIntergralAddOrder appIntergralAddOrder,
			OrderMainDto orderMainDto, OrderMainModel orderMainModel) {
		OrderSubDetailDto orderSubDetailDto = new OrderSubDetailDto();
		// 单品信息
		if (!Contants.BUSINESS_TYPE_JF.equals(orderMainModel.getOrdertypeId())) {
			int orderIndex = 1;//所有子订单用同一个变量计算，否则会重复
			for (int i = 0; i < appIntergralAddOrder
					.getAppIntergralAddOrderPrivileges().size(); i++) {
				AppIntergralAddOrderPrivilege goodsInfo = appIntergralAddOrder
						.getAppIntergralAddOrderPrivileges().get(i);
				String goods_num = goodsInfo.getGoodsNum(); // 商品数量
				int goods_numi = Integer.parseInt(goods_num);
				for (int index = 0; index < goods_numi; index++) {
					OrderSubModel orderSubModel = new OrderSubModel();
					orderSubModel
							.setOrderId(orderMainModel.getOrdermainId()
									+ StringUtils.leftPad(
									String.valueOf(orderIndex++), 2, "0"));
					orderSubModel.setOrdermainId(orderMainModel
							.getOrdermainId());
					orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
					orderSubModel.setOperSeq(new Integer(0));
					orderSubModel.setOrdertypeId(orderMainModel
							.getOrdertypeId());// 业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
					orderSubModel.setOrdertypeNm(orderMainModel
							.getOrdertypeNm());// 业务类型名称
					orderSubModel
							.setGoodsPaywayId(goodsInfo.getGoodsPaywayId());// 商品支付编码
					TblGoodsPaywayModel tblGoodsPaywayModel = orderMainDto
							.getGoodsPaywayModelMap().get(
									goodsInfo.getGoodsPaywayId());
					orderSubModel.setSpecShopno(tblGoodsPaywayModel
							.getCategoryNo());// 邮购分期类别码
					orderSubModel
							.setCalMoney(tblGoodsPaywayModel.getCalMoney());// 清算总金额
					orderSubModel.setPaywayCode(tblGoodsPaywayModel
							.getPaywayCode());// 支付方式代码0001: 现金0002:
					// 积分0003:
					// 积分+现金0004:手续费0005:
					// 现金+手续费0006:
					// 积分+手续费0007:积分+现金+手续费
					Integer stagesNum = tblGoodsPaywayModel.getStagesCode() == null ? 1
							: tblGoodsPaywayModel.getStagesCode(); // change
					// 不在接口在数据库里取得分期数在
					String PaywayName = "";
					if (tblGoodsPaywayModel.getPaywayCode().equals("0001")) {
						PaywayName = "现金";
					} else if (tblGoodsPaywayModel.getPaywayCode().equals(
							"0002")) {
						PaywayName = "积分";
					} else if (tblGoodsPaywayModel.getPaywayCode().equals(
							"0003")) {
						PaywayName = "积分+现金";
					} else if (tblGoodsPaywayModel.getPaywayCode().equals(
							"0004")) {
						PaywayName = " 手续费";
					} else if (tblGoodsPaywayModel.getPaywayCode().equals(
							"0005")) {
						PaywayName = "现金+手续费";
					} else if (tblGoodsPaywayModel.getPaywayCode().equals(
							"0006")) {
						PaywayName = "积分+手续费";
					} else if (tblGoodsPaywayModel.getPaywayCode().equals(
							"0007")) {
						PaywayName = "积分+现金+手续费";
					}
					orderSubModel.setPaywayNm(PaywayName);
					// 商品代码
					ItemModel itemModel = orderMainDto.getItemModelMap().get(
							tblGoodsPaywayModel.getGoodsId());
					GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(
							itemModel.getGoodsCode());

					orderSubModel.setCardno(orderMainModel.getCardno());// 卡号
					String vendorId = goodsModel.getVendorId();

					orderSubModel.setVendorId(vendorId);// 供应商代码
					orderSubModel.setVendorSnm(orderMainDto
							.getVendorInfoDtoMap().get(vendorId)
							.getSimpleName());// 供应商简称
					orderSubModel.setSourceId(orderMainModel.getSourceId());
					orderSubModel.setSourceNm(orderMainModel.getSourceNm());
					orderSubModel.setGoodsCode(itemModel.getGoodsCode());// 商品code
					orderSubModel.setGoodsId(itemModel.getCode());// 商（单）品代码
					orderSubModel.setGoodsNum(1);// 商品数量
					orderSubModel.setGoodsNm(goodsModel.getName());
					orderSubModel.setCurrType("156");// 商品币种
					orderSubModel.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
					orderSubModel.setGoodssendFlag("0");// 发货标记0－未发货[默认]1－已发货2－已签收
					orderSubModel.setGoodsaskforFlag("0");// 请款标记0－未请款[默认]1－已请款
					orderSubModel.setSpecShopnoType("");// 特店类型
					orderSubModel.setPayTypeNm("");// 佣金代码名称
					orderSubModel.setIncCode("");// 手续费率代码
					orderSubModel.setIncCodeNm("");// 手续费名称
					orderSubModel.setStagesNum(stagesNum);// 现金[或积分]分期数
					orderSubModel.setCommissionType("");// 佣金计算类别
					orderSubModel.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
					orderSubModel.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
					orderSubModel.setOrigMoney(new BigDecimal(0));// 原始现金总金额
					orderSubModel.setIncWay("00");// 手续费获取方式
					orderSubModel.setIncRate(new BigDecimal(0));// 手续费率(不包含%)
					orderSubModel.setIncMoney(new BigDecimal(0));// 手续费总金额
					orderSubModel.setUitfeeflg(new Integer("0"));// 手续费减免期数
					orderSubModel.setUitfeedam(new BigDecimal(0));// 手续费减免金额
					orderSubModel.setUitdrtuit(new Integer("0"));// 本金减免期数
					orderSubModel.setMiaoshaActionFlag(Strings.isNullOrEmpty(orderMainDto.getMiaoshaFlag())?0:1);
					orderSubModel.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
					orderSubModel.setIncTakePrice(new BigDecimal(0));// 退单时收取指定金额手续费
					orderSubModel.setVoucherPrice(new BigDecimal(0));// 优惠金额
					orderSubModel.setCreditFlag("");// 授权额度不足处理方式
					orderSubModel.setCalWay("");// 退货方式
					orderSubModel.setLockedFlag("0");// 订单锁标记
					orderSubModel.setVendorOperFlag("0");// 供应商操作标记
					orderSubModel.setCurStatusId(orderMainModel
							.getCurStatusId());// 当前状态代码
					orderSubModel.setCurStatusNm(orderMainModel
							.getCurStatusNm());// 当前状态名称
					orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员id
					orderSubModel.setTypeId("");// 商品类别ID
					orderSubModel.setLevelNm(goodsModel.getGoodsType());// 商品类别名称
					orderSubModel.setGoodsBrand(goodsModel.getGoodsBrandName());// 品牌
					orderSubModel.setGoodsModel(itemModel.getAttributeName2());// 型号
					orderSubModel.setGoodsColor(itemModel.getAttributeName1());// 商品颜色
					MallPromotionResultDto promotion = null;
					if (orderMainDto.getPromotionMap() != null) {
						promotion = orderMainDto.getPromotionMap().get(
								itemModel.getCode());
					}
					orderSubModel.setActType(promotion == null ? "" : promotion.getPromType().toString());// 活动类型
					orderSubModel.setActId(promotion == null ? "" : promotion.getId().toString());
					orderSubModel.setMerId(orderMainDto.getVendorInfoDtoMap()
							.get(vendorId).getMerId());// 商户号
					orderSubModel.setReserved1(orderMainDto
							.getVendorInfoDtoMap().get(vendorId).getUnionPayNo());// 保存银联商户号
					orderSubModel.setGoodsAttr1(itemModel.getAttributeKey1());// 销售属性（json串）
					orderSubModel.setGoodsAttr2(itemModel.getAttributeKey2());
					orderSubModel.setGoodsPresent("");// 赠品 未完成
					orderSubModel.setBonusTrnDate(orderMainModel.getCommDate());// 支付日期
					orderSubModel.setBonusTrnTime(orderMainModel.getCommTime());// 支付时间
					orderSubModel.setTmpStatusId("0000");// 临时状态代码
					orderSubModel.setCommDate(orderMainModel.getCommDate());// 业务日期
					orderSubModel.setCommTime(orderMainModel.getCommTime());// 业务时间
					orderSubModel.setGoodssendFlag("0");// 发货标记
					// 0－未发货[默认]
					// 1－已发货 2－已签收
					orderSubModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位
					// 0:初始化
					orderSubModel.setCardtype("W");// 借记卡信用卡标识 未明
					// 购物车ＩＤ为itemCode+":"+支付方式（１或者２）
					// FIXME 现场修改 购物车ID 老代码是错的
					// String custCartId = "";
					// if (Contants.CART_PAY_TYPE_1.equals(payType)) {
					// custCartId = itemModel.getCode() + ":" +
					// Contants.CART_PAY_TYPE_1;
					// } else if
					// (Contants.CART_PAY_TYPE_2.equals(payType)) {
					// custCartId = itemModel.getCode() + ":" +
					// Contants.CART_PAY_TYPE_2;
					// }
					if (orderMainDto.getCartIdMap() != null) {
						orderSubModel.setCustCartId(orderMainDto.getCartIdMap().get(itemModel.getCode()));// 此订单对应的购物车id
					}
					if (ZERO_FLAG.equals(orderMainDto.getMiaoshaFlag())){
						orderSubModel.setMiaoshaActionFlag(new Integer(1));
					} else {
						orderSubModel.setMiaoshaActionFlag(new Integer(0));
					}
					String goodsTypeItem = goodsModel.getGoodsType();
					orderSubModel.setGoodsType(goodsTypeItem);// 商品类型（00实物01虚拟02O2O）
					if (Contants.SUB_ORDER_TYPE_00.equals(goodsTypeItem)) {
						orderSubModel
								.setGoodsTypeName(Contants.GOODS_TYPE_NM_00);
					}
					if (Contants.SUB_ORDER_TYPE_01.equals(goodsTypeItem)) {
						orderSubModel
								.setGoodsTypeName(Contants.GOODS_TYPE_NM_01);
					}
					if (Contants.SUB_ORDER_TYPE_02.equals(goodsTypeItem)) {
						orderSubModel
								.setGoodsTypeName(Contants.GOODS_TYPE_NM_02);
					}
					orderSubModel.setMemberName(appIntergralAddOrder
							.getCsgName());// 会员名称
					orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
					orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删
					orderSubModel.setOrder_succ_time(orderMainModel.getCreateTime());
					orderSubModel.setCreateTime(orderMainModel.getCreateTime());
					orderSubModel.setModifyTime(orderMainModel.getCreateTime());
					// 数据库不为空项
					orderSubModel.setVerifyFlag("");
					String voucherId = "";
					String voucherNo = "";
					String voucherNm = "";
					BigDecimal voucherPrice = new BigDecimal(0);
					if (index == 0) {// 同一个商品中优惠券只放在第一个小订单
						if (orderMainDto.getPrivilegeIdMap() != null) {
							voucherNo = orderMainDto.getPrivilegeIdMap().get(
									itemModel.getCode());// 优惠券ID
						}
						if (orderMainDto.getPrivilegeNameMap() != null) {
							voucherNm = orderMainDto.getPrivilegeNameMap().get(
									itemModel.getCode());// 优惠券名称
						}
						if (orderMainDto.getPrivilegeMoneyMap() != null) {
							voucherPrice = orderMainDto.getPrivilegeMoneyMap()
									.get(itemModel.getCode());// 优惠券金额
						}

					}
					orderSubModel.setVoucherId(voucherId);
					orderSubModel.setVoucherNo(voucherNo);
					orderSubModel.setVoucherNm(voucherNm);
					orderSubModel.setVoucherPrice(voucherPrice);
					// 不用 接口没有orderCommitInfoDto.getPrice()
					// BigDecimal totalMoney =
					// orderCommitInfoDto.getPrice();
					// add
					BigDecimal totalMoney = new BigDecimal(0);
					if (promotion != null) {
						TblGoodsPaywayModel goodsPaywayModel = orderMainDto
								.getGoodsPaywayModelMap().get(goodsInfo.getGoodsPaywayId());//
						totalMoney =goodsPaywayModel.getGoodsPrice();
						//原价
						BigDecimal goodsPrice = orderMainDto.getOriPriceMap().get(itemModel.getCode());
						//计算差额  原价 - 活动价
						orderSubModel.setFenefit(goodsPrice
								.subtract(totalMoney));
					} else {
						TblGoodsPaywayModel goodsPaywayModel = orderMainDto
								.getGoodsPaywayModelMap().get(
										goodsInfo.getGoodsPaywayId());
						totalMoney = goodsPaywayModel.getGoodsPrice();
						orderSubModel.setFenefit(new BigDecimal(0));
					}

					long bonusTotalvalue = 0l;
					BigDecimal bonusProvMon = new BigDecimal(0);
					if(orderMainDto.getJfCountMap() != null && orderMainDto.getJfCountMap().get(itemModel.getCode()) != null){
						bonusTotalvalue = orderMainDto.getJfCountMap().get(itemModel.getCode()) / orderMainDto.getGoodsCountMap().get(itemModel.getCode());// 总积分总数
					}
					// 积分抵扣金额
					if (orderMainDto.getFixFlagMap() != null && orderMainDto.getFixFlagMap().get(itemModel.getCode()) == false){
						bonusProvMon = orderMainDto.getDiscountPrivMonMap().get(itemModel.getCode())
								.divide(new BigDecimal(orderMainDto.getGoodsCountMap().get(itemModel.getCode())), 2, BigDecimal.ROUND_DOWN);//积分抵扣金额
						totalMoney = totalMoney.subtract(bonusProvMon);
					}

					orderSubModel.setSingleBonus(bonusTotalvalue);
					orderSubModel.setBonusTotalvalue(bonusTotalvalue);
					orderSubModel.setUitdrtamt(bonusProvMon);// 本金减免金额

					if (!"".equals(voucherNo) && voucherPrice != null) {
						// - 优惠券
						totalMoney = totalMoney.subtract(voucherPrice);
					}
					// 积分类型
					if (orderMainDto.getPointTypeMap() != null) {
						orderSubModel.setIntegraltypeId(StringUtils.isEmpty(orderMainDto.getPointTypeMap().get(itemModel.getCode())) ? "1" : orderMainDto.getPointTypeMap().get(itemModel.getCode()));// 广发商城积分类型默认1
					} else {
						orderSubModel.setIntegraltypeId("1");
					}
					orderSubModel.setTotalMoney(totalMoney);// 现金总金额
					orderSubModel.setSinglePrice(totalMoney);// 单个商品对应的价格
					// change orderCommitInfoDto.getInstalments() 改用
					// stagesNum
					if (stagesNum != null && stagesNum != 0) {
						orderSubModel.setInstallmentPrice(totalMoney.divide(
								new BigDecimal(stagesNum), 2,
								BigDecimal.ROUND_DOWN));// 分期价格
					} else {
						orderSubModel.setInstallmentPrice(new BigDecimal(0));
					}
					orderSubModel.setIncTakePrice(orderSubModel.getInstallmentPrice());// 退单时收取指定金额手续费(未用)

					// undo 没有 orderCommitInfoDto.getOriPrice()
					// orderCommitInfoDto.getPrice() 已在上面处理
					// orderSubModel.setFenefit(orderCommitInfoDto.getOriPrice()
					// == null ? new BigDecimal(0)
					// :
					// orderCommitInfoDto.getOriPrice().subtract(orderCommitInfoDto.getPrice()));
					orderSubModel.setCostBy(0);
					orderSubModel.setO2oExpireFlag(0);
					orderSubDetailDto.addOrderSubModel(orderSubModel);
					OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
					orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
					orderDoDetailModel.setDoTime(new Date());
					orderDoDetailModel.setDoUserid(orderSubModel
							.getCreateOper());// 处理用户
					orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
					orderDoDetailModel
							.setStatusId(orderSubModel.getCurStatusId());// 状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
					orderDoDetailModel
							.setStatusNm(orderSubModel.getCurStatusNm());// 状态名称
					orderDoDetailModel.setMsgContent("");
					orderDoDetailModel.setDoDesc("乐购下单");
					orderDoDetailModel.setCreateOper(orderSubModel
							.getCreateOper());// 创建人
					orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
					orderSubDetailDto.addOrderDoDetailModel(orderDoDetailModel);
				}

			}
		}
		return orderSubDetailDto;
	}


	/**
	 * 调用积分系统获取客户总积分
	 *
	 * @param cardNo
	 * @return
	 */
	private long getCustTotalBonus(String cardNo) {
		long custTotalBonus = 0;

		// 由于积分系统返回的报文包含翻页信息，有可能需要查询多个页面
		int bonusCurPage = 0;
		int bonusTotalPage = 1;
		QueryPointsInfo queryPointsInfo = null;
		QueryPointResult queryPointResult = null;
		try {
			// 进行翻页查询
			while (bonusCurPage < bonusTotalPage) {
				queryPointsInfo = new QueryPointsInfo();
				queryPointsInfo.setChannelID("MALL");
				queryPointsInfo.setCurrentPage(String.valueOf(bonusCurPage));
				queryPointsInfo.setCardNo(cardNo);
				// 调用积分查询接口B=bms011
				queryPointResult = pointService.queryPoint(queryPointsInfo);

				List<QueryPointsInfoResult> queryPointsInfoResults = queryPointResult.getQueryPointsInfoResults();
				for (QueryPointsInfoResult queryPointsInfoResult : queryPointsInfoResults) {
					Long account = Long.valueOf(0);
					if (queryPointsInfoResult.getAccount() != null) {
						account = Long.valueOf(queryPointsInfoResult.getAccount().toString());
					}
					custTotalBonus = custTotalBonus + account;
				}
				bonusCurPage++;
				String totalPage = queryPointResult.getTotalPages();
				try {
					bonusTotalPage = Integer.parseInt(totalPage.trim());
				} catch (Exception e) {
					log.error("【DXZF01】流水：转换总页数时出现异常，积分返回总页数："+bonusTotalPage, e);
					throw new Exception(e.getMessage());
				}
			}
		} catch (Exception e) {
			log.error("查询积分系统异常", e);
		}

		return custTotalBonus;
	}
}
