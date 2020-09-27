package cn.com.cgbchina.restful.provider.service.order;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;

public interface OrderChannelService {
	/**
	 * 调用个人网银获取客户信息
	 * @param certNo
	 * @return
	 */
	public UserInfo getUserByCertNo(String certNo);
	
	/**
	 * 校验用户的第三级卡是否符合商品要求 借记卡没有第三级卡产品编码，商品设置设置第三级卡产品编码对借记卡不起作用 借记卡也没有卡等级，积分类型，如果礼品管理设置了该项，对借记卡也不起作用。
	 * @param goodsCode
	 * @param cardNo
	 * @return
	 */
	public Boolean checkThreeCard(String goodsCode, String cardNo);
	/**
	 * 接口查询优惠券
	 * @param couponId
	 * @param user
	 * @param goodsModel
	 * @param couponPrice
	 * @param isNearPastDueFlag
	 * @return
	 */
	List<CouponInfo> queryCouponInfo(String couponId, UserInfo user, GoodsModel goodsModel, BigDecimal couponPrice, boolean isNearPastDueFlag);

	/**
	 * 处理bps分期支付信息
	 * @param tblordermain
	 * @param ordersTemp
	 * @param tblOrderExtend1Models 
	 */
	void dealFQorderBpswithTX(OrderMainModel tblordermain, List<Map<String, Object>> ordersTemp, List<TblOrderExtend1Model> tblOrderExtend1Models);
	
	/**
	 * 优惠券加积分电子支付
	 * @param orderMainModel
	 * @param orderSubModels
	 * @param validDate
	 * @return
	 */
	List<OrderSubModel> payFQOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModels, String validDate);

	/**
	 * 去电子支付平台支付,调用接口NSCT016
	 * @param orderMainModel
	 * @param validDate
	 * @return
	 */
	BaseResult doPayJF(OrderMainModel orderMainModel, String validDate);
}
