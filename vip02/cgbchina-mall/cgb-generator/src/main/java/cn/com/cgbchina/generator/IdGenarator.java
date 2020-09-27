package cn.com.cgbchina.generator;

import javax.annotation.Nonnull;

/**
 * Created by 11140721050130 on 2016/4/30.
 */
public interface IdGenarator {

	/**
	 * 默认ID生成
	 *
	 * @param type 类型
	 * @param userId model类
	 * @return id字符串
	 */
	public String id(IdEnum type, @Nonnull String userId);

	/**
	 * 商品支付方式主键生成
	 * 
	 * @param orderTypeId 业务类型
	 * @return
	 */
	public String goodsPayWayId(@Nonnull String orderTypeId);

	public String itemMid();

	/**
	 * 生成订单号(日期+用户Id+渠道+编号)
	 * 并行期(9+yyyMMdd+用户Id+渠道+编号)
	 * 
	 * @param chanel 渠道编码
	 * @return 主订单号
	 */
	public String orderMainId(@Nonnull String chanel);

	/**
	 * 生成子订单号(主订单+子订单序列)
	 * 并行期(9+yyyMMdd+用户Id+渠道+编号)
	 * 
	 * @param orderId
	 * @param userId
	 * @return
	 */
	public String orderSubId(@Nonnull String orderId, @Nonnull String userId);

	/**
	 * 生成订单交易流水号
	 *
	 * @return
	 */
	public String orderSerialNo();

	/**
	 * 生成积分退款流水号
	 *
	 * @return
	 */
	public String jfRefundSerialNo();

	/**
	 * 
	 * Description : 生成接口 用的流水号
	 * 
	 * @return
	 */
	public String genarateSenderSN();
}
