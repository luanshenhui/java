package cn.com.cgbchina.restful.provider.impl.order;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailChildren;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailQuery;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailReturn;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrderDetailService;
import cn.com.cgbchina.trade.model.OrderDetailDtoExtend;
import cn.com.cgbchina.trade.model.OrderGoodsDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModelVirtualExtend;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import cn.com.cgbchina.trade.service.RestOrderService;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;

import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;

/**
 * @author Lizy MAL108 CC积分商城订单详细信息查询
 */
@Service
@Slf4j
public class CCIntergralOrderDetailServiceImpl implements CCIntergralOrderDetailService {
	@Resource
	RestOrderService restOrderService;
	@Resource
	VendorService vendorService;
	@Resource
	ItemService itemService;

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Override
	public CCIntergralOrderDetailReturn detail(CCIntergralOrderDetailQuery query) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		CCIntergralOrderDetailReturn detail = new CCIntergralOrderDetailReturn();
		List<CCIntergralOrderDetailChildren> childOrders = new ArrayList<CCIntergralOrderDetailChildren>();
		detail.setChildOrders(childOrders);
		try {
			detail.setChannelSN(MallReturnCode.CHANNELCN_CCAG);
			detail.setSuccessCode("01");
			detail.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
			detail.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);

			detail.setLoopTag("0000");
			// 查找 订单详细信息

			Response<OrderDetailDtoExtend> orderInfoResp = restOrderService.findOrderDetailbyOrderMainId(query
					.getOrderMainId());
			if (orderInfoResp.isSuccess()) {
				OrderDetailDtoExtend order = orderInfoResp.getResult();
				OrderMainModel orderMain = order.getOrderMainModel();
				detail.setOrderMainId(orderMain.getOrdermainId());// 大订单号
				detail.setOrderDate(orderMain.getCommDate());// 订单日期
				// 收货人信息
				detail.setPostCode(orderMain.getCsgPostcode());// 邮编
				detail.setCsgProvince(orderMain.getCsgProvince());// 收货省份
				detail.setCsgCity(orderMain.getCsgCity());// 收货城市
				detail.setDeliveryAddr(orderMain.getCsgAddress());// 送货地址
				detail.setDeliveryName(orderMain.getCsgName());// 收货人姓名
				detail.setDeliveryMobile(orderMain.getCsgPhone1());// 收货人手机
				detail.setDeliveryPhone(orderMain.getCsgPhone2());// 收货人固话
				// 物流信息
				OrderTransModel orderTrans = order.getOrderTransModel();
				if (orderTrans != null) {
					detail.setDoDate(sdf.format(orderTrans.getDoTime()));// 发货日期
					detail.setTranscorpNm(orderTrans.getTranscorpNm());// 快递单号
					detail.setServicePhone(orderTrans.getServicePhone());// 快递公司联系电话
				}
				// 子订单信息

				List<OrderSubModelVirtualExtend> orderSubModels = order.getOrderSubModelVirtualExtends();

				if (orderSubModels != null) {
					detail.setLoopCount(orderSubModels.size() + "");
					List<String> orderSubIds = new ArrayList<String>();
					List<String> vendorIds = new ArrayList<String>();

					for (OrderSubModelVirtualExtend orderSubModel : orderSubModels) {
						orderSubIds.add(orderSubModel.getOrderId());// 记录OrderId
						vendorIds.add(orderSubModel.getVendorId());// 供应商ID
					}
					// 供应商列表
					Response<List<VendorInfoModel>> vendorResp = vendorService.findByVendorIds(vendorIds);
					Response<List<OrderGoodsDetailModel>> goodsDetailsResp = restOrderService
							.findOrderGoodsDetailBySubOrderId(orderSubIds);

					List<VendorInfoModel> vendors = new ArrayList<VendorInfoModel>();
					List<OrderGoodsDetailModel> orderGoodsDetailModels = new ArrayList<OrderGoodsDetailModel>();
					if (vendorResp.isSuccess()) {
						vendors = vendorResp.getResult();
					}
					if (goodsDetailsResp.isSuccess()) {
						orderGoodsDetailModels = goodsDetailsResp.getResult();
					}

					for (OrderSubModelVirtualExtend orderSubModel : orderSubModels) {
						CCIntergralOrderDetailChildren childrenOrder = new CCIntergralOrderDetailChildren();
						childrenOrder.setOrderId(orderSubModel.getOrderId());// 子订单号
						childrenOrder.setOrderName(orderSubModel.getCurStatusId());// 子订单状态中文名称

						childrenOrder.setGoodsNo(orderSubModel.getGoodsNum() + "");// 商品数量
						// 积分信息
						if (orderSubModel.getTotalMoney().doubleValue() > 0) {
							childrenOrder.setConsumeType("1");// 消费类型 纯积分=0/积分+现金=1
						} else {
							childrenOrder.setConsumeType("0");
						}
						childrenOrder.setIntergralNo(orderSubModel.getSingleBonus() + "");// 积分值
						childrenOrder.setJfType(orderSubModel.getBonusType());// 积分类型编码
						childrenOrder.setJfTypeName(orderSubModel.getBonusTypeNm());// 积分类型名称

						if (orderSubModel.getSinglePrice() != null) {
							childrenOrder.setGoodsPrice(orderSubModel.getSinglePrice().floatValue() + "");// 现金值
						}
						if (orderSubModel.getOrderVirtualModel() != null) {
							OrderVirtualModel virualModel = orderSubModel.getOrderVirtualModel();
							childrenOrder.setVirtualAllMileage(virualModel.getVirtualAllMileage() + "");// 里程
							if (virualModel.getVirtualAllPrice() != null) {
								childrenOrder.setVirtualAllPrice(virualModel.getVirtualAllPrice().doubleValue() + "");// 兑换金额
							} else {
								childrenOrder.setVirtualAllPrice("0");// 兑换金额
							}
							childrenOrder.setVirtualMemberId(virualModel.getVirtualMemberId());// 会员号
							childrenOrder.setVirtualMemberNm(virualModel.getVirtualMemberNm());// 会员姓名
							childrenOrder.setVAviationType(virualModel.getVirtualAviationType());// 航空类型
						} else {
							orderSubModel.setOrderVirtualModel(new OrderVirtualModel());
						}
						if (vendors != null && !vendors.isEmpty()) {
							for (VendorInfoModel vendor : vendors) {
								if (vendor.getVendorId().equals(orderSubModel.getVendorId())) {
									childrenOrder.setVendorFnm(vendor.getFullName());// 供应 商名称
									break;
								}
							}
						}
						if (orderGoodsDetailModels != null && orderGoodsDetailModels.isEmpty()) {
							for (OrderGoodsDetailModel orderGoodsDetailModel : orderGoodsDetailModels) {
								if (orderGoodsDetailModel.getGoodsCode().equals(orderSubModel.getGoodsId())) {
									childrenOrder.setGoodsName(orderGoodsDetailModel.getGoodsName());// 商品名称
									break;
								}
							}
						}
						childrenOrder.setGoodsType(orderSubModel.getGoodsType());// 礼品类型
						childOrders.add(childrenOrder);
					}

				}

			} else {
				// 找不到相关信息
				childOrders.add(new CCIntergralOrderDetailChildren());
				detail.setLoopCount("0");
				detail.setReturnCode(MallReturnCode.NotFound_Code);
				detail.setReturnDes(MallReturnCode.NotFound_Des);
			}

		} catch (Exception ex) {
			log.error("MAL108 CC积分商城订单详细信息查询 异常\n" + jsonMapper.toJson(query), ex);
			detail.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			detail.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
		}
		return detail;
	}
}
