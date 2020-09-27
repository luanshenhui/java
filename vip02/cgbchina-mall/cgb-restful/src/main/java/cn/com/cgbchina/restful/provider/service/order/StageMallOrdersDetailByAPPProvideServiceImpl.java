package cn.com.cgbchina.restful.provider.service.order;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersDetailByAPPQuery;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersDetailByAPPReturn;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersDoByAPPReturn;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersDetailByAPPQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersDetailByAPPReturnVO;
import cn.com.cgbchina.trade.dto.OrderDetailDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.UserInfoModel;
import cn.com.cgbchina.user.service.UserInfoService;
import cn.com.cgbchina.user.service.VendorService;

import com.spirit.common.model.Response;

/**
 * MAL309 订单详细信息查询(分期商城)App 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL309")
@Slf4j
public class StageMallOrdersDetailByAPPProvideServiceImpl implements
		SoapProvideService<StageMallOrdersDetailByAPPQueryVO, StageMallOrdersDetailByAPPReturnVO> {

	@Override
	public StageMallOrdersDetailByAPPReturnVO process(SoapModel<StageMallOrdersDetailByAPPQueryVO> model,
			StageMallOrdersDetailByAPPQueryVO content) {
		StageMallOrdersDetailByAPPQuery stageMallOrdersDetailByAPPQuery = BeanUtils.copy(content,
				StageMallOrdersDetailByAPPQuery.class);
		StageMallOrdersDetailByAPPReturn stageMallOrdersDetailByAPPReturn = new StageMallOrdersDetailByAPPReturn();
		try {
			stageMallOrdersDetailByAPPReturn = detail(stageMallOrdersDetailByAPPQuery);

		} catch (Exception e) {
			// e.printStackTrace();
			log.info("MAL309 订单详细信息查询(分期商城)异常: ", e);
			stageMallOrdersDetailByAPPReturn.setReturnCode("000009");
			stageMallOrdersDetailByAPPReturn.setReturnDes("系统异常！");
			StageMallOrdersDetailByAPPReturnVO stageMallOrdersDetailByAPPReturnVO = BeanUtils.copy(
					stageMallOrdersDetailByAPPReturn, StageMallOrdersDetailByAPPReturnVO.class);
			return stageMallOrdersDetailByAPPReturnVO;
		}
		StageMallOrdersDetailByAPPReturnVO stageMallOrdersDetailByAPPReturnVO = BeanUtils.copy(
				stageMallOrdersDetailByAPPReturn, StageMallOrdersDetailByAPPReturnVO.class);
		return stageMallOrdersDetailByAPPReturnVO;
	}

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
	UserInfoService userInfoService;

	public StageMallOrdersDetailByAPPReturn detail(StageMallOrdersDetailByAPPQuery stageMallOrdersDetailByAPPQuery) {
		StageMallOrdersDetailByAPPReturn stageMallOrdersDetailByAPPReturn = new StageMallOrdersDetailByAPPReturn();
		String origin = stageMallOrdersDetailByAPPQuery.getOrigin();// 发起方
		String order_id = stageMallOrdersDetailByAPPQuery.getOrderId();
		Response<OrderDetailDto> orderDetailDtoResponse = orderService.findOrderInfoByRestFull(order_id);
		if (orderDetailDtoResponse.isSuccess() && orderDetailDtoResponse.getResult() != null) {
			OrderDetailDto orderDetailDto = orderDetailDtoResponse.getResult();
			OrderSubModel orderSubModel = orderDetailDto.getOrderSubModel();
			List<OrderDoDetailModel> orderDoDetailModels = orderDetailDto.getOrderDoDetailModels();
			OrderMainModel orderMainModel = orderDetailDto.getOrderMainModel();
			OrderTransModel orderTransModel = orderDetailDto.getOrderTransModel();
			ItemModel itemModel = itemService.findById(orderSubModel.getGoodsId());
			GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode()).getResult();
//			Response<TblGoodsPaywayModel> goodsPaywayModelResponse = goodsPayWayService.findGoodsPayWayInfo(orderSubModel.getGoodsPaywayId());
//			TblGoodsPaywayModel goodsPaywayModel = new TblGoodsPaywayModel();
//			if(goodsPaywayModelResponse.isSuccess() && goodsPaywayModelResponse.getResult() != null){
//				goodsPaywayModel = goodsPaywayModelResponse.getResult();
//			}			
			Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(goodsModel.getVendorId()); // List
																												// tblOrderBySqlDao.getVendorByOrderId(order_id);//需要查询合作商全称（广发微信商城需求）
			String vendorRole = "";
			String vendorFnm = "";
			String vendorPhone = "";// 20151010 APP需求 增加“供应商热线”
			if (vendorInfoDtoResponse.isSuccess() && vendorInfoDtoResponse.getResult() != null) {
				VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();
				vendorRole = vendorInfoDto.getVendorRole(); 
				vendorFnm = vendorInfoDto.getFullName(); 
				vendorPhone = vendorInfoDto.getPhone(); // APP需求 增加“供应商热线”
			}

			// TODO 确定不是取子订单表的数据吗？
			String _order_id = orderSubModel.getOrderId();// 订单号
			String cur_status_id = orderSubModel.getCurStatusId();// 订单状态
			String ordertype_id = orderSubModel.getOrdertypeId();// 订单类型
			String goodssend_flag = orderSubModel.getGoodssendFlag();// 发货标志
			Date createTime = orderSubModel.getCreateTime();
			SimpleDateFormat yyyyMMddFormat = new SimpleDateFormat("yyyyMMdd");
			SimpleDateFormat hhmmssFormat = new SimpleDateFormat("hhmmss");
			SimpleDateFormat yyyyMMddhhmmssFormat = new SimpleDateFormat("yyyyMMdd hhmmss");
			String create_date = yyyyMMddFormat.format(createTime);// 创建日期
			String create_time = hhmmssFormat.format(createTime);// 创建日期

			String goodssend_date = "";// 发货日期
			String goodssend_time = "";
			if (orderTransModel != null) {
				Date doTime = orderTransModel.getDoTime();
				goodssend_date = yyyyMMddFormat.format(doTime);
				goodssend_time = hhmmssFormat.format(doTime);
			}

			String bp_cust_grp = orderMainModel.getBpCustGrp();//送货时间
			String is_invoice = orderMainModel.getIsInvoice(); //是否开具发票
			String invoice_type = orderMainModel.getReserved1(); //发票类型
			String invoice = orderMainModel.getInvoice();//发票抬头
			String ordermain_desc = orderMainModel.getOrdermainDesc();//订单详情
			String csg_address = orderMainModel.getCsgAddress();//收货地址
			String csg_province = orderMainModel.getCsgProvince();//省
			String csg_city = orderMainModel.getCsgCity(); //市
			String csg_borough = orderMainModel.getCsgBorough(); //区
			String csg_name = orderMainModel.getCsgName(); //收货人
			String csg_postcode = orderMainModel.getCsgPostcode();//邮政编码
			String csg_phone1 = orderMainModel.getCsgPhone1();//收货人手机
			String csg_phone2 = orderMainModel.getCsgPhone2(); //收货人家里电话

			String goods_oid = itemModel.getOid(); //商品一期编码
			String goods_mid = itemModel.getMid(); //商品分期编码

			String goods_nm = orderSubModel.getGoodsNm();//商品名称
			String goods_num = orderSubModel.getGoodsNum() + "";//商品数量
			String single_price = orderSubModel.getSinglePrice() == null ? "" : orderSubModel.getSinglePrice()
					.toString();//单价
			Integer stages_num = orderSubModel.getStagesNum();//分期数
			BigDecimal totalMoney = orderSubModel.getTotalMoney();
			BigDecimal uitdrtamt = orderSubModel.getUitdrtamt();
			BigDecimal voucherPrice = orderSubModel.getVoucherPrice();
			BigDecimal price = BigDecimal.ZERO.setScale(2);
			if (totalMoney != null) {
				price = price.add(totalMoney);
			}
			if (uitdrtamt != null) {
				price = price.add(uitdrtamt);
			}
			if (voucherPrice != null) {
				price = price.add(voucherPrice);
			}
			Integer stagesNum = orderSubModel.getStagesNum();
			if (stagesNum == null || stagesNum == 0) {
				log.error("OrderService find ,orderId:" + orderSubModel.getOrderId() + ",stagesNum be wrong");
				stagesNum = 1;
			}
			// 总价%分期数
			price = price.divide(new BigDecimal(stagesNum.intValue()), 2, BigDecimal.ROUND_DOWN);
			String per_stage = price.toString();
			String goods_size = goodsModel.getFreightSize(); //尺码
			String goods_color = orderSubModel.getGoodsColor();//颜色
			String privilegeId = orderSubModel.getVoucherNo();// //优惠劵id
			String privilegeName = orderSubModel.getVoucherNm();//优惠券名称
			double privilegeMoney = orderSubModel.getVoucherPrice() == null ? 0 : orderSubModel.getVoucherPrice()
					.doubleValue(); //优惠劵金额
			String discountPrivilege = orderSubModel.getBonusTotalvalue() == null ? "0" : orderSubModel
					.getBonusTotalvalue().toString();//抵扣积分
			String discountPrivMon = orderSubModel.getUitdrtamt() == null ? "0" : orderSubModel.getUitdrtamt()
					.toString();
			String cardNo = orderSubModel.getCardno(); 
			String ordermain_id = orderSubModel.getOrdermainId();
			// 如果是积分商城订单查询，这加入相应字段
			// if(mallType.equals("02")){
			String goods_xid = itemModel.getXid(); 
			String jf_type = orderSubModel.getBonusType(); // jf_type 积分类型
			String bonusTotalvalue = orderSubModel.getBonusTotalvalue() == null ? "0" : orderSubModel
					.getBonusTotalvalue().toString(); 
			// 积分总数
			String goods_price = orderSubModel.getTotalMoney() == null ? "" : orderSubModel.getTotalMoney().toString(); // StringUtil.dealNull(map.get("goods_price"));
			// //现金总金额
			String single_bonus = orderSubModel.getSingleBonus() == null ? "" : orderSubModel.getSingleBonus().toString();
			// 单个商品对应的积分
			// TO changji：下面这个错误的代码块给主调了
			stageMallOrdersDetailByAPPReturn.setGoodsXid(dealNull(goods_xid));
			stageMallOrdersDetailByAPPReturn.setJfType(dealNull(jf_type));
			stageMallOrdersDetailByAPPReturn.setTotalPoint(dealNull(bonusTotalvalue));
			stageMallOrdersDetailByAPPReturn.setGoodsPrice(dealNull(goods_price));
			stageMallOrdersDetailByAPPReturn.setSingleBonus(dealNull(single_bonus));

			stageMallOrdersDetailByAPPReturn.setOrderId(dealNull(_order_id)); 
			stageMallOrdersDetailByAPPReturn.setCurStatusId(dealNull(cur_status_id));
			stageMallOrdersDetailByAPPReturn.setOrdertypeId(dealNull(ordertype_id));
			stageMallOrdersDetailByAPPReturn.setGoodssendFlag(dealNull(goodssend_flag));
			stageMallOrdersDetailByAPPReturn.setCreateDate(dealNull(create_date));
			stageMallOrdersDetailByAPPReturn.setCreateTime(dealNull(create_time));
			stageMallOrdersDetailByAPPReturn.setGoodsSendDate(dealNull(goodssend_date));
			stageMallOrdersDetailByAPPReturn.setGoodsSendTime(dealNull(goodssend_time));
			stageMallOrdersDetailByAPPReturn.setSendTime(dealNull(bp_cust_grp));
			stageMallOrdersDetailByAPPReturn.setIsInvoice(dealNull(is_invoice));
			stageMallOrdersDetailByAPPReturn.setInvoiceType(dealNull(invoice_type));
			stageMallOrdersDetailByAPPReturn.setInvoice(dealNull(invoice));
			stageMallOrdersDetailByAPPReturn.setOrdermainDesc(dealNull(ordermain_desc));
			stageMallOrdersDetailByAPPReturn.setCsgAddress(dealNull(csg_address));
			stageMallOrdersDetailByAPPReturn.setCsgProvince(dealNull(csg_province));
			stageMallOrdersDetailByAPPReturn.setCsgCity(dealNull(csg_city));
			stageMallOrdersDetailByAPPReturn.setCsgBorough(dealNull(csg_borough));
			stageMallOrdersDetailByAPPReturn.setCsgName(dealNull(csg_name));
			stageMallOrdersDetailByAPPReturn.setCsgPostcode(dealNull(csg_postcode));
			stageMallOrdersDetailByAPPReturn.setCsgPhone1(dealNull(csg_phone1));
			stageMallOrdersDetailByAPPReturn.setCsgPhone2(dealNull(csg_phone2));
			stageMallOrdersDetailByAPPReturn.setGoodsOid(dealNull(goods_oid));
			stageMallOrdersDetailByAPPReturn.setGoodsMid(dealNull(goods_mid));
			stageMallOrdersDetailByAPPReturn.setGoodsNm(goods_nm);
			stageMallOrdersDetailByAPPReturn.setGoodsNum(goods_num);
			stageMallOrdersDetailByAPPReturn.setSinglePrice(single_price);
			int stages_code = 1;
			if (stages_num != null) {
				stages_code = stages_num;
			}
			stageMallOrdersDetailByAPPReturn.setStagesNum(stages_code + "");
			stageMallOrdersDetailByAPPReturn.setPerStage(dealNull(per_stage));
			stageMallOrdersDetailByAPPReturn.setGoodsSize(dealNull(goods_size));
			stageMallOrdersDetailByAPPReturn.setGoodsColor(dealNull(goods_color));
			stageMallOrdersDetailByAPPReturn.setVendorRole(dealNull(vendorRole));
			/*** 广发商城改造2013需求、广发微信商城需求 改造开始 ****************************/
			stageMallOrdersDetailByAPPReturn.setVendorFnm(dealNull(vendorFnm));//新增“合作商全称”
			stageMallOrdersDetailByAPPReturn.setPrivilegeId(dealNull(privilegeId));//新增“优惠券id”
			stageMallOrdersDetailByAPPReturn.setPrivilegeName(dealNull(privilegeName));//新增“优惠券名称”
			stageMallOrdersDetailByAPPReturn.setPrivilegeMoney(privilegeMoney);//新增“优惠劵金额”
			stageMallOrdersDetailByAPPReturn.setDiscountPrivilege(dealNull(discountPrivilege));//新增“抵扣积分”
			stageMallOrdersDetailByAPPReturn.setDiscountPrivMon(dealNull(discountPrivMon));//新增“抵扣积分金额”

			stageMallOrdersDetailByAPPReturn.setCardNo(dealNull(cardNo));//新增“卡号”
			stageMallOrdersDetailByAPPReturn.setOrderMainId(ordermain_id);//新增“大订单号”
			// 20151010 APP需求增加
			stageMallOrdersDetailByAPPReturn.setVendorPhone(dealNull(vendorPhone));// APP需求增加“合作商服务热线”
			String main_mer_id = orderMainModel.getMerId(); //大商户号
			String order_id_host = orderSubModel.getOrderIdHost(); //积分流水
			String mer_id = orderSubModel.getMerId(); //小商户号
			String cardtype = orderSubModel.getCardtype(); //卡片类型
			Date receivedTime = orderSubModel.getReceivedTime();
			String received_time = "";
			if (receivedTime != null) {
				received_time = yyyyMMddhhmmssFormat.format(receivedTime); 
			};//订单签收时间

			String goods_attr1 = orderSubModel.getGoodsAttr1(); //属性一
			String goods_attr2 = orderSubModel.getGoodsAttr2(); //属性二
			String goods_model = orderSubModel.getGoodsModel(); //属性二的值

			stageMallOrdersDetailByAPPReturn.setMainmerId(dealNull(main_mer_id));
			stageMallOrdersDetailByAPPReturn.setTradeSeqNo(dealNull(order_id_host));
			stageMallOrdersDetailByAPPReturn.setMerId(dealNull(mer_id));
			stageMallOrdersDetailByAPPReturn.setCardtype(dealNull(cardtype));
			stageMallOrdersDetailByAPPReturn.setReceivedTime(dealNull(received_time));
			stageMallOrdersDetailByAPPReturn.setGoodsAttr1(dealNull(goods_attr1));
			stageMallOrdersDetailByAPPReturn.setGoodsAttr2(dealNull(goods_attr2));
			stageMallOrdersDetailByAPPReturn.setGoodsModel(dealNull(goods_model));

			stageMallOrdersDetailByAPPReturn.setPictureUrl(dealNull(itemModel.getImage1()));
			/*** 广发商城改造2013需求、广发微信商城需求 改造结束 ****************************/

			List<StageMallOrdersDoByAPPReturn> stageMallOrdersDos = new ArrayList<StageMallOrdersDoByAPPReturn>();

			for (int i = 0; i < orderDoDetailModels.size(); i++) {
				StageMallOrdersDoByAPPReturn stageMallOrdersDoByAPPReturn = new StageMallOrdersDoByAPPReturn();
				OrderDoDetailModel orderDoDetailModel = orderDoDetailModels.get(i);
				Date orderDoTime = orderDoDetailModel.getDoTime();
				String orderrDoTimeStr = yyyyMMddhhmmssFormat.format(orderDoTime);
				String statusNm = orderDoDetailModel.getStatusNm();
				String userType = orderDoDetailModel.getUserType();
				String doUserid = orderDoDetailModel.getDoUserid();
				String doUserNm = "";
				if (userType == null || "".equals(userType) || "0".equals(userType)) {
					doUserNm = "系统后台";
				} else if ("1".equals(userType)) {
					// local_user_inf
					doUserNm = "内部用户";
					Response<UserInfoModel> userInfoModelResponse = userInfoService.findUserInfoById(doUserid);
					if (userInfoModelResponse != null && userInfoModelResponse.getResult() != null) {
						doUserNm = "内部用户:" + userInfoModelResponse.getResult().getName();
					} else {
						doUserNm = "内部用户:" + doUserid;
					}
				} else if ("2".equals(userType)) {
					Response<VendorInfoDto> vendorInfoDtoResponse1 = vendorService.findById(doUserid);
					if (vendorInfoDtoResponse1 != null && vendorInfoDtoResponse1.getResult() != null) {
						doUserNm = "供应商:" + vendorInfoDtoResponse1.getResult().getFullName();
					} else {
						doUserNm = "供应商:" + doUserid;
					}
				} else if ("3".equals(userType)) {
					doUserNm = "持卡人:" + doUserid;
				}
				stageMallOrdersDoByAPPReturn.setOperateName(doUserNm);
				stageMallOrdersDoByAPPReturn.setOperTime(orderrDoTimeStr);
				stageMallOrdersDoByAPPReturn.setOrderComments(statusNm);
				stageMallOrdersDos.add(stageMallOrdersDoByAPPReturn);
			}
			stageMallOrdersDetailByAPPReturn.setStageMallOrdersDos(stageMallOrdersDos);
			stageMallOrdersDetailByAPPReturn.setReturnCode("000000");
			stageMallOrdersDetailByAPPReturn.setReturnDes("查询成功");
		} else {
			stageMallOrdersDetailByAPPReturn.setReturnCode("000009");
			stageMallOrdersDetailByAPPReturn.setReturnDes("查无订单！");
		}
		return stageMallOrdersDetailByAPPReturn;
	}

	private String dealNull(String input){
		return input == null ? "" : input;
	}
	
}
