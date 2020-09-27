package cn.com.cgbchina.restful.provider.service.order;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.CompletionService;
import java.util.concurrent.ExecutorCompletionService;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.GoodsInfo;
import cn.com.cgbchina.rest.provider.model.order.IntergralAddOrder;
import cn.com.cgbchina.rest.provider.model.order.IntergralAddOrderReturn;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.GoodsInfoVo;
import cn.com.cgbchina.rest.provider.vo.order.IntergralAddOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.IntergralAddOrderVO;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderMainSingleCheckDto;
import cn.com.cgbchina.trade.dto.OrderSubDetailDto;
import cn.com.cgbchina.trade.dto.PagePaymentReqDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import cn.com.cgbchina.web.utils.Tools;

import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;

/**
 * MAL324 积分商城下单 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL324")
@Slf4j
public class IntergralAddOrderProvideServiceImpl implements
	SoapProvideService<IntergralAddOrderVO, IntergralAddOrderReturnVO> {

    @Value("#{app.merchId}")
    private String merchId;
    @Resource
    private OrderService orderService;
    @Resource
    private GoodsService goodsService;
    @Resource
    private ItemService itemService;
    @Resource
    private GoodsPayWayService goodsPayWayService;
    @Resource
    private VendorService vendorService;
    @Resource
    private IdGenarator idGenarator;
    @Resource
    private BusinessService businessService;

    @Override
    public IntergralAddOrderReturnVO process(
	    SoapModel<IntergralAddOrderVO> model, IntergralAddOrderVO content) {
	IntergralAddOrder intergralAddOrder = BeanUtils.copy(content,
		IntergralAddOrder.class);
	//xiewl 20161015
	// 判断启停
	boolean judgmentResult =  judgmentQT();
	if (!judgmentResult) {//停止该渠道支付
		IntergralAddOrderReturnVO intergralAddOrderReturnVO = new IntergralAddOrderReturnVO();
		intergralAddOrderReturnVO.setReturnDes("000049");
	    intergralAddOrderReturnVO.setReturnCode(MallReturnCode.getReturnDes("000049"));
	    return intergralAddOrderReturnVO;
	}
	// 校验
	OrderMainDto orderMainDto = check(intergralAddOrder);
	if (orderMainDto != null
		&& !Strings.isNullOrEmpty(orderMainDto.getReturnCode())) {
	    log.info("mail324验证失败");
	    IntergralAddOrderReturnVO intergralAddOrderReturnVO = new IntergralAddOrderReturnVO();
	    intergralAddOrderReturnVO.setReturnDes(orderMainDto.getReturnDes());
	    intergralAddOrderReturnVO.setReturnCode(orderMainDto
		    .getReturnCode());
	    return intergralAddOrderReturnVO;
	}
	log.info("mail324验证成功");
	// 构建订单
	OrderMainModel orderMainModel = createOrderMainModel(intergralAddOrder,
		orderMainDto);
	OrderSubDetailDto subDetailDto = createSubDetail(intergralAddOrder,
		orderMainDto, orderMainModel);
	// 登录数据库 生成订单
	log.info("mail324保存开始");

	Response response = orderService.saveOrder(orderMainModel,
		subDetailDto.getOrderSubModelList(),
		subDetailDto.getOrderDoDetailModelList(),
		orderMainDto.getStockRestMap());
	if (!response.isSuccess()) {
	    IntergralAddOrderReturnVO intergralAddOrderReturnVO = new IntergralAddOrderReturnVO();
	    intergralAddOrderReturnVO.setReturnDes((String) response
		    .getResult());
	    intergralAddOrderReturnVO.setReturnCode("000009");
	    return intergralAddOrderReturnVO;
	}
	/* 根据订单返回值,构建支付信息 */
	Response<PagePaymentReqDto> rs = orderService.getReturnObjForAppPay(
		orderMainModel, subDetailDto.getOrderSubModelList());
	PagePaymentReqDto pagePaymentReqDto = null;
	// 准备支付用数据
	log.info("mail324准备支付用数据");
	IntergralAddOrderReturn intergralAddOrderReturn = new IntergralAddOrderReturn();
	if (rs.isSuccess()) {
	    if (rs.getResult() != null) {
		pagePaymentReqDto = rs.getResult();
	    } else {
		intergralAddOrderReturn.setReturnCode("构建支付数据失败");
		intergralAddOrderReturn.setReturnDes("000009");
	    }

	}

	if (!Strings.isNullOrEmpty(pagePaymentReqDto.getReturnCode())) {
	    log.info("mail324下单失败");
	    intergralAddOrderReturn.setReturnCode(pagePaymentReqDto
		    .getReturnCode());
	    intergralAddOrderReturn.setReturnDes(pagePaymentReqDto
		    .getErrorMsg());
	} else {
	    log.info("mail324下单成功");
	    
	  //Begin Bug修改 积分商城下单成功后删除购物车
	    List<GoodsInfoVo> goodsInfoList=content.getGoodsInfo();
	    if(goodsInfoList!=null&&goodsInfoList.size()>0){
	    	List<String>cartIdList =new ArrayList<>();
	    	for (GoodsInfoVo goodsInfoVo : goodsInfoList) {
	    		if(goodsInfoVo.getCustCartId()!=null&&!goodsInfoVo.getCustCartId().equals("")){
	    			cartIdList.add(goodsInfoVo.getCustCartId());
	    		}
			}
	    	//删除购物车
	    	if(!cartIdList.isEmpty()){
	    		orderService.updateShopCartByOrderSuccess(cartIdList);
	    	}
	    }
	    //end Bug修改 积分商城下单成功后删除购物车
	    
	    intergralAddOrderReturn.setReturnCode("000000");
	    intergralAddOrderReturn.setReturnDes("成功");
	    intergralAddOrderReturn.setOrdermainId(pagePaymentReqDto
		    .getOrderid());
	    intergralAddOrderReturn
		    .setSerialNo(pagePaymentReqDto.getSerialNo());
	    intergralAddOrderReturn.setJfType(pagePaymentReqDto.getPointType());
	    intergralAddOrderReturn.setAmountMoney(pagePaymentReqDto
		    .getAmount());
	    intergralAddOrderReturn.setAmountPoint(pagePaymentReqDto
		    .getPointSum());
	    intergralAddOrderReturn.setMerchId(pagePaymentReqDto.getMerchId());
	    intergralAddOrderReturn.setIsMerge(pagePaymentReqDto.getIsMerge());
	    intergralAddOrderReturn.setPayType(pagePaymentReqDto.getPayType());
	    intergralAddOrderReturn.setTradeDate(pagePaymentReqDto
		    .getTradeDate());
	    intergralAddOrderReturn.setTradeTime(pagePaymentReqDto
		    .getTradeTime());
	    intergralAddOrderReturn.setOrders(pagePaymentReqDto.getOrders());
	    intergralAddOrderReturn.setSign(pagePaymentReqDto.getSign());
	}

	IntergralAddOrderReturnVO intergralAddOrderReturnVO = BeanUtils.copy(
		intergralAddOrderReturn, IntergralAddOrderReturnVO.class);
	return intergralAddOrderReturnVO;
    }

	/**
     * 构建大订单
     * 
     * @param intergralAddOrder
     * @param orderMainDto
     * @return
     */
    private OrderMainModel createOrderMainModel(
	    IntergralAddOrder intergralAddOrder, OrderMainDto orderMainDto) {
	String origin = dealNull(intergralAddOrder.getOrigin());// 发起方
								// 调用方标识:如手机商城:03，微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS；APP：09
	String ordertype_id = dealNull(intergralAddOrder.getOrdertypeId()); // 订单类型
									    // YG:一次性支付(借记卡)
									    // FQ：分期支付（信用卡）

	String total_num = dealNull(intergralAddOrder.getTotalNum());// 商品总数量
	String total_bonus = dealNull(intergralAddOrder.getTotalBonus());// 积分总数
	String total_price = dealNull(intergralAddOrder.getTotalPrice());// 价格总数

	String create_oper = dealNull(intergralAddOrder.getCreateOper()); // 登录客户号
	String cont_id_type = dealNull(intergralAddOrder.getContIdType());// 订货人证件类型
	String cont_idcard = dealNull(intergralAddOrder.getContIdcard()); // 订货人证件号码
	String cont_nm = dealNull(intergralAddOrder.getContNm());// 订货人姓名
	String cont_postcode = dealNull(intergralAddOrder.getContPostcode());// 订货人邮政编码
	String cont_address = dealNull(intergralAddOrder.getContAddress());// 订货人详细地址
	String cont_mob_phone = dealNull(intergralAddOrder.getContMobPhone());// 订货人手机
	String cont_hphone = dealNull(intergralAddOrder.getContHphone());// 订货人家里电话
	String csg_name = dealNull(intergralAddOrder.getCsgName()); // 收货人姓名
	String csg_postcode = dealNull(intergralAddOrder.getCsgPostcode());// 收货人邮政编码
	String csg_address = dealNull(intergralAddOrder.getCsgAddress());// 收货人详细地址
	String csg_phone1 = dealNull(intergralAddOrder.getCsgPhone1());// 收货人手机
	String csg_phone2 = dealNull(intergralAddOrder.getCsgPhone2());// 收货人家里电话
	String bp_cust_grp = dealNull(intergralAddOrder.getSendTime());// 送货时间
								       // 送货时间
	// 01: 工作日、双休日与假日均可送货
	// 02: 只有工作日送货（双休日、假日不用送）
	// 03: 只有双休日、假日送货（工作日不用送货）
	String ordermain_desc = dealNull(intergralAddOrder.getOrdermainDesc());// 备注
	String acct_add_flag = dealNull(intergralAddOrder.getAcctAddFlag());// 收货地址是否是帐单地址0:否
									    // 1:是
	String cust_sex = dealNull(intergralAddOrder.getCustSex()); // 性别
								    // 0：男；1：女
	String cust_email = dealNull(intergralAddOrder.getCustEmail());// 邮箱
	String csg_province = dealNull(intergralAddOrder.getCsgProvince()); // 省
	String csg_city = dealNull(intergralAddOrder.getCsgCity());// 市
	String csg_borough = dealNull(intergralAddOrder.getCsgBorough());// 区
	String isMerge = dealNull(intergralAddOrder.getIsMerge());

	// APP渠道包含中文字段需要解码
	if (Contants.ORDER_SOURCE_ID_09.equals(origin)) {
	    cont_nm = decode(cont_nm);// 订货人姓名
	    cont_address = decode(cont_address);// 订货人详细地址
	    csg_name = decode(csg_name);// 收货人姓名
	    csg_address = decode(csg_address);// 收货人详细地址
	    ordermain_desc = decode(ordermain_desc);// 备注
	    csg_province = decode(csg_province);// 省
	    csg_city = decode(csg_city);// 市
	    csg_borough = decode(csg_borough);// 区
	}
	log.info("mail324转换参数结束");
	OrderMainModel orderMainModel = new OrderMainModel();
	orderMainModel.setOrdertypeId(ordertype_id);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
	orderMainModel.setOrdertypeNm(getBusinessName(ordertype_id));// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
	orderMainModel.setIsmerge(isMerge);// 是否合并支付0是1否
	orderMainModel.setCardno("");// 卡号
	orderMainModel.setSourceId(origin);// 订单来源渠道id00: 商城01: callcenter02:
					   // ivr渠道03: 手机商城
	orderMainModel.setSourceNm(getOriginName(origin));
	orderMainModel.setTotalNum(Integer.parseInt(total_num));// 商品总数量
	orderMainModel.setTotalPrice(new BigDecimal(total_price));// 现金总金额
	orderMainModel.setBonusDiscount(new BigDecimal(0));// 积分抵扣金额
	orderMainModel.setVoucherDiscount(new BigDecimal(0));// 优惠券金额
	orderMainModel.setTotalBonus(Long.parseLong(total_bonus));// 商品总积分数量
	orderMainModel.setLockedFlag("0");// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）
	orderMainModel.setIsInvoice("0");// 是否开发票0-否，1-是
	orderMainModel.setInvoice("");// 发票抬头
	orderMainModel.setOrdermainDesc(ordermain_desc);// 订单主表备注
	orderMainModel.setContIdType(cont_id_type);// change 订货人证件类型
	orderMainModel.setContIdcard(cont_idcard);// change 订货人证件号码
	orderMainModel.setContNm(cont_nm);// change 订货人姓名
	orderMainModel.setContPostcode(cont_postcode);// change 订货人邮政编码
	orderMainModel.setContAddress(cont_address);// change 订货人详细地址
	orderMainModel.setContMobPhone(cont_mob_phone);// change 订货人手机
	orderMainModel.setContHphone(cont_hphone);// change 订货人家里电话
	orderMainModel.setMerId(merchId);// 大商户号
		Date d = DateTime.now().toDate();
	orderMainModel.setCommDate(DateHelper.getyyyyMMdd(d));// 业务日期
	orderMainModel.setCommTime(DateHelper.getHHmmss(d));// 业务时间
	orderMainModel.setCustSex(cust_sex);// change性别
	orderMainModel.setCustEmail(cust_email); // change
	orderMainModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功
					     // 2：更新失败
	// 有收货地址的场合（实物，实物＋Ｏ２Ｏ）
	orderMainModel.setBpCustGrp(bp_cust_grp);// 送货时间01:
						 // 工作日、双休日与假日均可送货02:只有工作日送货（双休日、假日不用送）03:只有双休日、假日送货（工作日不用送货）
	orderMainModel.setCsgName(csg_name);// 收货人姓名
	orderMainModel.setCsgPostcode(csg_postcode);// 收货人邮政编码
	orderMainModel.setCsgAddress(csg_address);// 收货人详细地址
	orderMainModel.setCsgPhone1(csg_phone1);// 收货人电话一
	orderMainModel.setCsgPhone2(csg_phone2);// 收货人电话二
	orderMainModel.setCsgProvince(csg_province);// 省
	orderMainModel.setCsgCity(csg_city);// 市
	orderMainModel.setCsgBorough(csg_borough);// 区
	orderMainModel.setAcctAddFlag(acct_add_flag);// 收货地址是否是帐单地址0-否1-是

	orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
	orderMainModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
	orderMainModel.setCreateOper(create_oper);// 创建操作员id
	orderMainModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
	// 数据库不为空项
	orderMainModel.setPermLimit(new BigDecimal(0));
	orderMainModel.setCashLimit(new BigDecimal(0));
	orderMainModel.setStagesLimit(new BigDecimal(0));
	orderMainModel.setCreateTime(d);

	String orderMainId = idGenarator.orderMainId(orderMainModel
		.getSourceId());
	orderMainModel.setOrdermainId(orderMainId);
	orderMainModel.setSerialNo(idGenarator.orderSerialNo());
	return orderMainModel;
    }

    private OrderSubDetailDto createSubDetail(
	    IntergralAddOrder intergralAddOrder, OrderMainDto orderMainDto,
	    OrderMainModel orderMainModel) {
	OrderSubDetailDto orderSubDetailDto = new OrderSubDetailDto();
	log.info("mail324大订单设置成功");
	int subCnt = 0;
	for (int i = 0; i < intergralAddOrder.getGoodsInfo().size(); i++) {
	    GoodsInfo goodsInfo = intergralAddOrder.getGoodsInfo().get(i);
	    String goods_id = goodsInfo.getGoodsId(); // 商品编码
	    String goods_num = goodsInfo.getGoodsNum(); // 商品数量
	    int goods_numi = Integer.parseInt(goods_num);
	    String goods_payway_id = goodsInfo.getGoodsPaywayId();// 支付方式id
	    String custCartId = dealNull(goodsInfo.getCustCartId()); // 购物车id
	    ItemModel itemModel = orderMainDto.getItemModelMap().get(goods_id);
	    GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(
		    itemModel.getGoodsCode());
	    TblGoodsPaywayModel goodsPaywayModel = orderMainDto
		    .getGoodsPaywayModelMap().get(goods_payway_id);
	    VendorInfoDto vendorInfoDto = orderMainDto.getVendorInfoDtoMap()
		    .get(goodsModel.getVendorId());
	    for (int index = 0; index < goods_numi; index++) {
		log.info("mail324小订单设置开始");
		OrderSubModel orderSubModel = new OrderSubModel();
		orderSubModel.setOrdermainId(orderMainModel.getOrdermainId());
		subCnt++;
		orderSubModel.setOrderId(orderMainModel.getOrdermainId()
			+ StringUtils.leftPad(String.valueOf(subCnt), 2, "0"));
		orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
		orderSubModel.setOperSeq(new Integer(0));
		orderSubModel.setOrdertypeId(orderMainModel.getOrdertypeId());// 业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
		orderSubModel.setOrdertypeNm(orderMainModel.getOrdertypeNm());// 业务类型名称
		Integer stagesNum = goodsPaywayModel.getStagesCode() == null ? 1
			: goodsPaywayModel.getStagesCode();
		orderSubModel.setGoodsPaywayId(goodsPaywayModel
			.getGoodsPaywayId());// 商品支付编码
		orderSubModel.setSpecShopno(goodsPaywayModel.getCategoryNo());// 邮购分期类别码
		orderSubModel.setCalMoney(goodsPaywayModel.getCalMoney());// 清算总金额
		orderSubModel.setPaywayCode(goodsPaywayModel.getPaywayCode());// 支付方式代码0001:
									      // 现金0002:
									      // 积分0003:
									      // 积分+现金0004:手续费0005:
									      // 现金+手续费0006:
									      // 积分+手续费0007:积分+现金+手续费
		String paywayName = "";
		if (goodsPaywayModel.getPaywayCode().equals("0001")) {
		    paywayName = "现金";
		} else if (goodsPaywayModel.getPaywayCode().equals("0002")) {
		    paywayName = "积分";
		} else if (goodsPaywayModel.getPaywayCode().equals("0003")) {
		    paywayName = "积分+现金";
		} else if (goodsPaywayModel.getPaywayCode().equals("0004")) {
		    paywayName = "手续费";
		} else if (goodsPaywayModel.getPaywayCode().equals("0005")) {
		    paywayName = "现金+手续费";
		} else if (goodsPaywayModel.getPaywayCode().equals("0006")) {
		    paywayName = "积分+手续费";
		} else if (goodsPaywayModel.getPaywayCode().equals("0007")) {
		    paywayName = "积分+现金+手续费";
		}
		orderSubModel.setPaywayNm(paywayName);
		// 商品代码
		orderSubModel.setCardno(orderMainModel.getCardno());// 卡号
		String vendorId = goodsModel.getVendorId();
		orderSubModel.setVendorId(vendorId);// 供应商代码
		orderSubModel.setVendorSnm(vendorInfoDto.getFullName());// 供应商简称
		orderSubModel.setSourceId(orderMainModel.getSourceId());// 渠道代码00:
									// 商城01:
									// CallCenter02:
									// IVR渠道03:
		// 手机商城04: 短信渠道05: 微信广发银行06：微信广发信用卡
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
		orderSubModel.setUitdrtamt(new BigDecimal(0));// 本金减免金额
		orderSubModel.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
		orderSubModel.setIncTakePrice(new BigDecimal(0));// 退单时收取指定金额手续费
		orderSubModel.setVoucherPrice(new BigDecimal(0));// 优惠金额
		orderSubModel.setCreditFlag("");// 授权额度不足处理方式
		orderSubModel.setCalWay("");// 退货方式
		orderSubModel.setLockedFlag("0");// 订单锁标记
		orderSubModel.setVendorOperFlag("0");// 供应商操作标记
		orderSubModel.setCurStatusId(orderMainModel.getCurStatusId());// 当前状态代码
		orderSubModel.setCurStatusNm(orderMainModel.getCurStatusNm());// 当前状态名称
		orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员id
		orderSubModel.setTypeId(goodsModel.getGoodsType());// 商品类别ID
		orderSubModel.setLevelNm(goodsModel.getGoodsType());// 商品类别名称
		orderSubModel.setGoodsBrand("");// 品牌
		orderSubModel.setGoodsModel("");// 型号
		orderSubModel.setGoodsColor("");// 商品颜色
		orderSubModel.setActType(null);// 活动类型
		orderSubModel.setPeriodId(null);// 活动场次
		orderSubModel.setMerId(vendorInfoDto.getMerId());// 商户号
		orderSubModel.setReserved1(vendorInfoDto.getUnionPayNo());// 保存银联商户号
		orderSubModel.setGoodsAttr1(itemModel.getAttributeKey1());// 销售属性（json串）
		orderSubModel.setGoodsAttr2(itemModel.getAttributeKey2());
		orderSubModel.setGoodsPresent("");// 赠品 未完成
		orderSubModel.setBonusTrnDate(orderMainModel.getCommDate());// 支付日期
		orderSubModel.setBonusTrnTime(orderMainModel.getCommTime());// 支付时间
		orderSubModel.setTmpStatusId("0000");// 临时状态代码
		orderSubModel.setCommDate(orderMainModel.getCommDate());// 业务日期
		orderSubModel.setCommTime(orderMainModel.getCommTime());// 业务时间
		orderSubModel.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货
						    // 2－已签收
		orderSubModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化
		orderSubModel.setCardtype("W");// 借记卡信用卡标识 未明
		orderSubModel.setCustCartId(custCartId);// 此订单对应的购物车id
		orderSubModel.setMiaoshaActionFlag(new Integer(0));
		orderSubModel.setCreateTime(orderMainModel.getCreateTime());
		orderSubModel.setOrder_succ_time(orderMainModel.getCreateTime());
		String goodsTypeItem = goodsModel.getGoodsType();
		orderSubModel.setGoodsType(goodsTypeItem);// 商品类型（00实物01虚拟02O2O）
		if (Contants.SUB_ORDER_TYPE_00.equals(goodsTypeItem)) {
		    orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_00);
		}
		if (Contants.SUB_ORDER_TYPE_01.equals(goodsTypeItem)) {
		    orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_01);
		}
		if (Contants.SUB_ORDER_TYPE_02.equals(goodsTypeItem)) {
		    orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_02);
		}
		orderSubModel.setMemberName("");// 会员名称
		orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
		orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删
		// 数据库不为空项
		orderSubModel.setVerifyFlag("");
		orderSubModel.setVoucherId("");
		orderSubModel.setVoucherNo("");
		orderSubModel.setVoucherNm("");
		orderSubModel.setVoucherPrice(new BigDecimal(0));
		BigDecimal totalMoney = goodsPaywayModel.getGoodsPrice() == null ? new BigDecimal(
			0) : goodsPaywayModel.getGoodsPrice();
		Long goodsPoint = goodsPaywayModel.getGoodsPoint() == null ? new Long(
			0) : goodsPaywayModel.getGoodsPoint();

		orderSubModel.setTotalMoney(totalMoney);// 现金总金额
		orderSubModel.setSinglePrice(totalMoney);// 单个商品对应的价格
		orderSubModel.setInstallmentPrice(new BigDecimal(0));
		orderSubModel.setIncTakePrice(new BigDecimal(0));// 退单时收取指定金额手续费(未用)
		orderSubModel.setBonusType(goodsModel.getPointsType());
		orderSubModel.setSingleBonus(goodsPoint);
		orderSubModel.setBonusTotalvalue(goodsPoint);
		orderSubModel.setFenefit(new BigDecimal(0));
		orderSubModel.setO2oExpireFlag(0);
		orderSubModel.setIntegraltypeId(goodsModel.getPointsType());
		OrderSubModel orderSubModelNew = new OrderSubModel();
		org.springframework.beans.BeanUtils.copyProperties(
			orderSubModel, orderSubModelNew);
		orderSubDetailDto.addOrderSubModel(orderSubModelNew);
		OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
		orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
		orderDoDetailModel.setDoTime(new Date());
		orderDoDetailModel.setDoUserid(orderSubModel.getCreateOper());// 处理用户
		orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
		orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
		orderDoDetailModel
			.setStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 状态名称
		orderDoDetailModel.setMsgContent("");
		orderDoDetailModel.setDoDesc("手机商城下单");
		orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());// 创建人
		orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
		orderSubDetailDto.addOrderDoDetailModel(orderDoDetailModel);
		log.info("mail324小订单设置结束");
	    }
	}
	return orderSubDetailDto;
    }

    /**
     * 校验
     * 
     * @param intergralAddOrder
     * @return
     */
    private OrderMainDto check(IntergralAddOrder intergralAddOrder) {
	OrderMainDto orderMainDto = new OrderMainDto();
	String origin = dealNull(intergralAddOrder.getOrigin());// 发起方
								// 调用方标识:如手机商城:03，微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS；APP：09
	String total_num = dealNull(intergralAddOrder.getTotalNum());// 商品总数量
	String total_bonus = dealNull(intergralAddOrder.getTotalBonus());// 积分总数
	String total_price = dealNull(intergralAddOrder.getTotalPrice());// 价格总数
	String create_oper = dealNull(intergralAddOrder.getCreateOper()); // 登录客户号
	String cont_nm = dealNull(intergralAddOrder.getContNm());// 订货人姓名
	String cont_address = dealNull(intergralAddOrder.getContAddress());// 订货人详细地址
	String csg_name = dealNull(intergralAddOrder.getCsgName()); // 收货人姓名
	String csg_address = dealNull(intergralAddOrder.getCsgAddress());// 收货人详细地址
	String ordermain_desc = dealNull(intergralAddOrder.getOrdermainDesc());// 备注
	String csg_province = dealNull(intergralAddOrder.getCsgProvince()); // 省
	String csg_city = dealNull(intergralAddOrder.getCsgCity());// 市
	String csg_borough = dealNull(intergralAddOrder.getCsgBorough());// 区

	origin = changeOrigin(origin);
	// APP渠道包含中文字段需要解码
	if (Contants.ORDER_SOURCE_ID_09.equals(origin)) {
	    cont_nm = decode(cont_nm);// 订货人姓名
	    cont_address = decode(cont_address);// 订货人详细地址
	    csg_name = decode(csg_name);// 收货人姓名
	    csg_address = decode(csg_address);// 收货人详细地址
	    ordermain_desc = decode(ordermain_desc);// 备注
	    csg_province = decode(csg_province);// 省
	    csg_city = decode(csg_city);// 市
	    csg_borough = decode(csg_borough);// 区
	}
	// 由于APP渠道包含中文字段需要解码，I表中APP渠道包含中文字段的长度会扩大5倍，解码之后需要校验长度
	String checkStr = checkLength(cont_nm, cont_address, csg_name,
		csg_address, ordermain_desc, csg_province, csg_city,
		csg_borough);
	// 释放资源
	if (checkStr != null) {
	    orderMainDto.setReturnCode("000008");
	    orderMainDto.setReturnDes(checkStr);
	    return orderMainDto;
	}

	if ("".equals(create_oper)) {// 登录客户号create_oper：手机和APP渠道必填；微信渠道可不填
	    orderMainDto.setReturnCode("000008");
	    orderMainDto.setReturnDes("报文参数错误:客户号必填");
	    return orderMainDto;
	}

	// 检验商品数量是否大于99
	try {
	    OrderMainSingleCheckDto input = new OrderMainSingleCheckDto();
	    input.setOrigin(origin);
	    orderMainDto = execOrderSubmit(intergralAddOrder, input);
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
	if (orderMainDto.getTotalPrice().compareTo(new BigDecimal(total_price)) != 0) {// 小订单总价格与报文中总价格不一致
	    orderMainDto.setReturnCode("000051");
	    orderMainDto.setReturnDes("商品总价格不相等");
	    return orderMainDto;
	}
	if (orderMainDto.getJfTotalNum().compareTo(new Long(total_bonus)) != 0) {// 小订单总积分与报文中的总积分不一致
	    orderMainDto.setReturnCode("000052");
	    orderMainDto.setReturnDes("商品总积分不相等");
	    return orderMainDto;
	}

	return orderMainDto;
    }

    private OrderMainSingleCheckDto singleCommitCheck(
	    GoodsInfo appIntergralAddOrderPrivilege,
	    OrderMainSingleCheckDto input) {
	OrderMainSingleCheckDto retDto = new OrderMainSingleCheckDto();
	String goods_id = appIntergralAddOrderPrivilege.getGoodsId();
	String goods_num = appIntergralAddOrderPrivilege.getGoodsNum();
	String goods_payway_id = appIntergralAddOrderPrivilege
		.getGoodsPaywayId();
	int goods_numi = Integer.parseInt(goods_num);
	ItemModel itemModel = itemService.findById(goods_id);
	// 如果找不到商品
	if (itemModel == null) {// 如果找不到商品
	    retDto.setReturnCode("000031");
	    retDto.setReturnDes("找不到该商品");
	    return retDto;
	}
	GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode())
		.getResult();
	Response<TblGoodsPaywayModel> goodsPaywayModelResponse = goodsPayWayService
		.findGoodsPayWayInfo(goods_payway_id);
	TblGoodsPaywayModel goodsPaywayModel = goodsPaywayModelResponse
		.getResult();
	Response<VendorInfoDto> vendorInfoDtoResponse = vendorService
		.findById(goodsModel.getVendorId());
	VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();
	// 如果找不到商品
	if (goodsModel == null || vendorInfoDtoResponse == null
		|| vendorInfoDto == null || goodsPaywayModelResponse == null
		|| goodsPaywayModel == null) {// 如果找不到商品
	    retDto.setReturnCode("000031");
	    retDto.setReturnDes("找不到该商品");
	    return retDto;
	}
	if (vendorInfoDtoResponse == null || vendorInfoDto == null) {// 如果不存在相应的合作商
	    retDto.setReturnCode("000034");
	    retDto.setReturnDes("对应合作商不存在");
	    return retDto;
	}

	if (Contants.ORDER_SOURCE_ID_MOBILE.equals(input.getOrigin())) {// APP
									// 未完成
	    if (!"02".equals(goodsModel.getChannelPhone())) {
		retDto.setReturnCode("000036");
		retDto.setReturnDes("该商品不是上架状态");
		return retDto;
	    }
	}
	if ("d".equalsIgnoreCase(goodsPaywayModel.getIscheck())) {// 如果支付方式已被删除
	    retDto.setReturnCode("000016");
	    retDto.setReturnDes("该支付方式已经删除");
	    return retDto;
	}
	// 检测商品数量
	int goods_backlog = itemModel.getStock().intValue();
	int goods_backlogI = goods_backlog - goods_numi;// 扣减后的商品数量
	if (goods_backlogI <= 0) {// 如果扣除商品数量后实际库存小于0
	    retDto.setReturnCode("000038");
	    retDto.setReturnDes("产品已售罄，请您挑选其他的产品。");
	    return retDto;
	}
	retDto.setItemModel(itemModel);
	retDto.setGoodsModel(goodsModel);

	retDto.setTblGoodsPaywayModel(goodsPaywayModel);
	retDto.setPayWayId(goods_payway_id);
	retDto.setVendorInfoDto(vendorInfoDto);
	retDto.setVendorId(goodsModel.getVendorId());
	retDto.setTotalPrice(goodsPaywayModel.getGoodsPrice().multiply(
		new BigDecimal(goods_numi)));
	retDto.setJfTotalNum(new Long(goodsPaywayModel.getGoodsPoint()
		* goods_numi));
	retDto.setGoodsCount(goods_numi);
	return retDto;
    }

    /**
     * 解码包含中文的字段
     * 
     * @param str
     * @return
     * @throws UnsupportedEncodingException
     */
    private static String decode(String str) {
	if (!Tools.isEmpty(str)) {
	    try {
		str = URLDecoder.decode(str, "utf-8");
	    } catch (UnsupportedEncodingException e) {
		log.error(Throwables.getStackTraceAsString(e));
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
    private static String checkLength(String... fieldContext) {
	String[] fieldName = { "cont_nm", "cont_address", "csg_name",
		"csg_address", "ordermain_desc", "csg_province", "csg_city",
		"csg_borough" };
	int[] fieldLen = { 30, 200, 30, 200, 400, 50, 50, 50 };
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
    private static String getOriginName(String origin) {
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
    private static String changeOrigin(String origin) {
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

    private static String getBusinessName(String key) {
	String name = "";
	if ("YG".equals(key)) {
	    name = "广发商城(一期)";
	} else if ("JF".equals(key)) {
	    name = "积分商城";
	} else if ("FQ".equals(key)) {
	    name = "广发商城(分期)";
	}
	return name;
    }

    private OrderMainDto execOrderSubmit(IntergralAddOrder orderDto,
	    OrderMainSingleCheckDto input) throws Exception {
	OrderMainDto orderMainDto = new OrderMainDto();
	List<GoodsInfo> dtos = orderDto.getGoodsInfo();
	if (dtos.size() == 1) {
	    OrderMainSingleCheckDto ret = singleCommitCheck(dtos.get(0), input);
	    orderMainDto.addOrderMainData(ret);
	} else {
	    // 多线程执行
	    ExecutorService executorService = Executors.newFixedThreadPool(dtos
		    .size());
	    CompletionService completionService = new ExecutorCompletionService(
		    executorService);
	    for (int i = 0; i < dtos.size(); i++) {
		completionService.submit(callSingleCommitCheck(dtos.get(i),
			input));
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
	return orderMainDto;
    }

    /**
     * 异步执行处理
     */
    private Callable<OrderMainSingleCheckDto> callSingleCommitCheck(
	    final GoodsInfo dto, final OrderMainSingleCheckDto input) {
	Callable<OrderMainSingleCheckDto> ret = new Callable<OrderMainSingleCheckDto>() {
	    @Override
	    public OrderMainSingleCheckDto call() throws Exception {
		return singleCommitCheck(dto, input);
	    }
	};
	return ret;
    }
    

    /**
     * Description : 判断启停控制
     * @author xiewl
     * @time 20161015
     * @return
     */
    private boolean judgmentQT() {
		boolean flag = true;
		Response<List<TblParametersModel>> response = businessService.findJudgeQT("JF", "03");
		List<TblParametersModel> list = response.getResult();
		if (list != null && list.size() > 0) {
			TblParametersModel tblParameters = list.get(0);
			String openCloseFlag = String.valueOf(tblParameters.getOpenCloseFlag());
			if (openCloseFlag != null && "1".equals(openCloseFlag)) {// 如果停止支付
				flag = false;
			}
		}
		return flag;
	}
}
