/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import java.util.List;
import java.util.Map;

import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.item.model.PromotionPayWayModel;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/7/26.
 */

public interface PromotionPayWayService {

	/**
	 * 新增活动支付方式
	 */
	public Response<Integer> createPromotionPayWay(List<PromotionPayWayModel> promotionPayWayModelList, User user);

	/**
	 * 查询支付方式（商品详情页使用）
	 */
	public Response<List<PromotionPayWayModel>> findPromotionByItemCode(String itemCode, Integer id);

	/**
	 * 返回支付方式信息
	 *
	 * @return
	 */
	public Response<PromotionPayWayModel> findPomotionPayWayInfo(String goodsPaywayId);

	/**
	 * 返回支付方式信息
	 * by goodsPaywayId promotionId
	 *
	 * @return
	 */
	public Response<PromotionPayWayModel> findPomotionPayWayInfoByParam(Map<String,Object> param);

	/**
	 * 根据单品id返回最大分期数的支付方式
	 */
	public Response<PromotionPayWayModel> findMaxPromotionPayway(String itemCode, String promId);

	/**
	 * 根据商品id查询商品活动支付方式（MAL313）
	 * @param goodsId
	 * @return
	 */
	public Response<List<PromotionPayWayModel>> findPromotionPayWayByGoodsIdAndPromType(String goodsId,String promType);
}
