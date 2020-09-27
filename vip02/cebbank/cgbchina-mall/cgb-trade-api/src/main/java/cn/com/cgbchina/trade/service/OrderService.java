package cn.com.cgbchina.trade.service;

import java.util.Map;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserAccount;

import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderTransModel;

/**
 * Created by 11141021040453 on 16-4-25.
 */
public interface OrderService {
	/**
	 * @param pageNo
	 * @param size
	 * @param orderId 订单编号
	 * @param goodsType 订单类型
	 * @param sourceId 渠道
	 * @param startTime 开始时间
	 * @param endTime 中支时间
	 * @param goodsNm 商品名称
	 * @param memberName 客户
	 * @param vendorSnm 供应商
	 * @param curStatusId 订单状态
	 * @param ordertypeId 分期数
	 * @return
	 */

	public Response<Pager<OrderInfoDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("orderId") String orderId, @Param("goodsType") String goodsType, @Param("sourceId") String sourceId,
			@Param("startTime") String startTime, @Param("endTime") String endTime, @Param("goodsNm") String goodsNm,
			@Param("goodsId") String goodsId, @Param("cardno") String cardno, @Param("memberName") String memberName,
			@Param("vendorSnm") String vendorSnm, @Param("curStatusId") String curStatusId,
			@Param("ordertypeId") String ordertypeId, @Param("ordermainId") String ordermainId,
			@Param("limitFlag") String limitFlag, @Param("type") String type, @Param("mallType") String mallType,
			@Param("") User user);


	/**
	 *  商城获取订单列表
	 * @param pageNo
	 * @param size
	 * @param ordermainId 主订单号
	 * @param curStatusId 订单状态
	 * @param startTime 开始时间
	 * @param endTime 结束时间
	 * @param limitFlag 查询六月flag
	 * @param user 用户信息
	 * @return
	 */

	public Response<Pager<OrderMallManageDto>>findMall(@Param("pageNo") Integer pageNo,
												   @Param("size") Integer size,
												   @Param("ordermainId") String ordermainId,
	                                               @Param("curStatusId") String curStatusId,
	                                               @Param("startTime") String startTime,
	                                               @Param("endTime") String endTime,
												   @Param("limitFlag") String limitFlag,
	                                               @Param("") User user);

	/**
	 * 查看订单详情
	 *
	 * @param orderId
	 * @return
	 */

	public Response<OrderDetailDto> findOrderInfo(@Param("id") String orderId);

	/**
	 * 更新订单状态提醒发货
	 *
	 * @Param orderId 子订单Id
	 * @Param id 用户id return
	 */
	public Response<Map<String, Boolean>> updateOrderRemind(String orderId, String id);

	/**
	 * 通过订单id查询订单状态
	 *
	 * @param orderId
	 * @return
	 * @Add by Liuhan
	 */
	public OrderSubModel findOrderId(String orderId);

	/**
	 * 供应商退货
	 *
	 * @param paramMap orderId 子订单Id typeFlag 区分标识 vendorId 供应商Id season 原因 supplement 补充说明
	 * @return
	 */

	public Response<Map<String, Object>> revokeOrder(Map<String, String> paramMap);

	/**
	 * 商城撤单及退货申请
	 *
	 * @param paramMap orderId 子订单Id typeFlag 区分标识 vendorId 供应商Id season 原因 supplement 补充说明
	 * @return
	 */

	public Response<Map<String, Object>> returnOrderMall(Map<String, String> paramMap);

	/**
	 * 商城撤单
	 * @param paramMap
	 * @return
	 */
	public Response<Map<String, Object>> revokeOrderMall(Map<String, String> paramMap);

	/**
	 * 代发货订单批量置为发货处理中
	 *
	 * @param paramMap vendorId *
	 * @return
	 */

	public Response<Map<String, Boolean>> export(Map<String, String> paramMap);

	/**
	 * 提交订单处理
	 *
	 * @param orderCommitSubmitDto
	 * @param user
	 * @return
	 * @Add by Wujiao
	 */
	public Response<Map<String, PagePaymentReqDto>> createOrder(OrderCommitSubmitDto orderCommitSubmitDto,
			UserAccount selectedCardInfo, User user);

	public Response<Map<String, Boolean>> demoPay(String orderMainId, String payFlag, User user);

	/**
	 * 通过订单id查询物流状态
	 *
	 * @param orderId
	 * @return
	 *
	 */
	public Response<OrderTransModel> findOrderTrans(String orderId);

	/**
	 * 通过订单id查询退货信息或撤单信息
	 * @param orderId
	 * @return
	 */
	public Response<OrderReturnDetailDto> findOrderReturnDetail(String orderId);

	/**
	 * 供应商更新订单状态 包括 签收，拒绝签收，无人签收
	 *
	 * @Param orderId 子订单Id
	 * @Param curStatusId 订单类型
	 */
	public Response<Map<String, Boolean>> updateOrderSignVendor(Map<String, Object> paramMap);


	/**
	 * 广发商城前台 取消订单
	 * @param paramMap
	 * @return
	 */
	public Response<Map<String, Object>> updateOrderMall(Map<String, Object> paramMap);


	/**
	 * 搭销订单
	 *
	 * @Param id 用户id return
	 */
	public Response<Map<String, Boolean>> createTieinSaleOrder(String itemCode, String orderMainId, User user)
			throws Exception;

	/**
	 * 提交订单画面显示
	 * 
	 * @param itemKeys 购物车中对应的单品情报key
	 * @param user 用户
	 * @return
	 */
	public Response<Map<String, Object>> findOrderInfoForCommitOrder(@Param("itemKeys") String itemKeys,
			@Param("") User user);

	/**
	 * 发货
	 *
	 * @Param orderId 子订单Id
	 * @Param transcorpNm 物流公司
	 * @Param mailingNum 物流单号
	 * @Param transRemark 备注 return
	 */
	public Response<Map<String, Boolean>> deliverGoods(OrderTransModel orderTransModel, User user);

	/**
	 * 获取单品已购买的件数
	 * @param paramMap
	 * @return
	 *
	 * geshuo 20160707
	 */
	public Response<Map<String,Long>> findItemBuyCount(Map<String, Object> paramMap);
}
