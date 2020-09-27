package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface RedisService {

	/**
	 * 删除redis的优惠券（所有）
	 *
	 * @param userid userId
	 * @return
	 */
	Response<Boolean> deleteCoupons(final String userid);

	/**
	 * 取得redis的优惠券信息（包括已经使用的）
	 *
	 * @param userid 用户id
	 * @return  用户拥有的优惠券信息
	 * @return
	 */
	Response<List<CouponInfo>> getCoupons(final String userid, final String contIdType, final String certNo);

	/**
	 * 删除redis的积分
	 *
	 * @param userid userId
	 * @return
	 */
	Response<Boolean> deleteScores(final String userid);

	/**
	 * 取得redis的积分信息
	 *
	 * @param user 用户信息
	 * @return  用户拥有的积分信息
	 * @return
	 */
	Response<Map<String,BigDecimal>> getScores(final User user);

	/**
	 * 获取优惠卷信息
	 *
	 * @param contIdType 证件类型
	 * @param certNo 证件号码
	 * @param useState 使用状态  0：全部 / 1：已使用 /	2：未使用
	 * @return 用户的优惠卷列表
	 */
	Response<List<CouponInfo>> getNewCouponInfos(String contIdType, String certNo, Byte useState);


	/**
	 * 订单导出信息创建
	 * @param userId 用户id
	 * @param dlUrl 导出文件路径
     * @return
     */
	public Response<Boolean> createOrderExportUrl(String userId, String dlUrl,String orderTypeId);


	/**
	 * 订单导出信息获得
	 * @param userId 用户id
	 * @return
     */
	public Response<String> getOrderExportUrl(String userId,String orderTypeId);


	public Response<Boolean> createApplayPaymentExportUrl(String userId,String systemType,String orderType,String dlUrl);

	public Response<String> getApplayPaymentExportUrl(String userId, String type, String orderType);
}
