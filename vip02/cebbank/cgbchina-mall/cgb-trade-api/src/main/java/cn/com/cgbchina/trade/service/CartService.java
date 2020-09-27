package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.CartResultDto;
import cn.com.cgbchina.trade.model.CartItem;
import cn.com.cgbchina.trade.model.UserCart;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

public interface CartService {

	/**
	 * 获取永久购物车中的物品
	 *
	 * @param user 系统自动注入的用户
	 * @return 永久购物车中的物品
	 */
	Response<CartResultDto> getPermanent(@Param("User") User user);

	/**
	 * 获取永久购物车中的物品(redis中未编辑Map直接返回)
	 *
	 * @param user 系统自动注入的用户
	 * @return 永久购物车中的物品(redis中未编辑Map直接返回)
	 */
	Response<Map<String, String>> getMapPermanent(@Param("User") User user);

	/**
	 * 获取永久购物车中的sku的种类个数
	 *
	 * @return sku的种类个数
	 */
	Response<Integer> getPermanentCount(@Param("User") User user);

	/**
	 * 增减永久购物车中的物品
	 *
	 * @param userId userId
	 * @param skuId sku id
	 * @param quantity 变化数量
	 */
	Response<Integer> changePermanentCart(String userId, String skuId, String payType, String instalments, String price,
			int quantity);

	/**
	 * 批量删除用户购物车中的skuIds
	 *
	 * @param userId 用户id
	 * @param skuIds 待删除skuId列表,删空
	 */
	Response<Boolean> batchDeletePermanent(String userId, Iterable<String> skuIds);

	/**
	 * 清空用户的购物车
	 *
	 * @param key cookie中的key，或者用户id
	 */
	Response<Boolean> empty(String key);
}
