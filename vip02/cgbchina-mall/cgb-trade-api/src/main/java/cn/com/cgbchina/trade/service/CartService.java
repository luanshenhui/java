package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.rest.provider.model.user.*;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.trade.dto.*;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface CartService {

	/**
	 * 取得个人积分
	 * @param user
	 * @return
	 *
	 */
	Response<Map<String,BigDecimal>> getUserScore(@Param("User") User user);

	/**
	 * 添加购物车
	 * 广发商城自用接口
	 * @param cartAddDto
	 * @return
	 * @author Congzy
	 * @describe 变更DB存储
	 */
	Response<Integer> createCartInfo(CartAddDto cartAddDto);

	/**
	 * 添加购物车
	 * 商城提供接口(MAL304)
	 * @param custCarAdd
	 * @return
	 * @author Congzy
	 * @describe 变更DB存储
	 */
	CustCarAddReturn createCartInfoForOut(CustCarAdd custCarAdd);

    /**
     * 删除购物车
     * 商城提供接口(MAL307)
     * @param custCarDel
     * @return
     * @author Congzy
     * @describe 变更DB存储
     */
    Response<CustCarDelReturn> deleteCartInfo(CustCarDel custCarDel);

    /**
     * 修改购物车
     * 商城提供接口(MAL306)
     * @param custCarUpdate
     * @return
     * @author Congzy
     * @describe 变更DB存储
     */
    Response<CustCarUpdateReturn> updateCartInfo(CustCarUpdate custCarUpdate);

	/**
	 * 查询购物车
	 * 广发商城自用接口
	 * @param user
	 * @return
	 * @author Congzy
	 * @describe 变更DB存储
	 */
	Response<CartDbResultDto> selectCartInfo(@Param("User") User user);

    /**
     * 查询购物车
     * 商城提供接口(MAL305)
     * @param custCarQuery
     * @return
     * @author Congzy
     * @describe 变更DB存储
     */
    Response<CustCarQueryReturn> selectPhoneCartInfo(CustCarQuery custCarQuery);

	/**
	 * 获取优惠卷信息
	 *
	 * @param couponInfoList 用户的优惠券列表  所有包括已使用的
	 * @param goodsModel 商品信息
	 * @param use 用途  0：领取优惠券 1：选择使用优惠券 2: 前两种都要获得
	 * @return 所传商品ID/单品ID对应使用状态的优惠卷列表
	 */
	Response<Map<String, List<VoucherInfoDto>>> getCouponInfo(List<CouponInfo> couponInfoList, GoodsModel goodsModel, int use);

	/**
	 * 获取用户荷兰拍信息
 	 * @param user
	 * @return
	 */
	Response<AuctionRecordDto> findAutionRecordInfo(@Param("User") User user);

	/**
	 * check 用户是否可兑换该商品
	 * @param goodsPoint
	 * @param goodsNum
	 * @param user
	 * @return
	 */
	Response<Boolean> checkUsedBonus(ItemModel itemModel,BigDecimal goodsPoint,BigDecimal goodsNum,User user);

	/**
	 * 根据用户卡号获取积分数
	 * @param pointsType
	 * @param user
	 * @return “null”为无此种积分
	 */
	Response<BigDecimal> checkHavePointType(User user, String pointsType);
	/**
	 * 限购的虚拟商品购物车内是否存在
	 */
	Response<Boolean> checkOnlyLimitInCart(Map<String,Object> custInfoJFParam,String goodsId);

	/**
	 * 删除购物车 订单提交成功后
	 *
	 * @param orderCommitInfoList
	 * @return
	 */
	Response<Boolean> deleteCartInfoFromOrder(List<OrderCommitInfoDto> orderCommitInfoList);

	/**
	 * 取得用户名下购物车内商品总数（按条数，不区分失效）
	 */
	Response<Integer> findCustCartNumByUser(User user);

	/**
	 * 根据用户，itemCode获得购物车该单品的数量
	 */
	public Response<Integer> findCustCartNumByUserItem(User user, String itemCode);
}
