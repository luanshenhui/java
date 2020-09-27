package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.trade.dto.OrderPartBackDto;
import cn.com.cgbchina.trade.dto.RevocationOrderDto;
import cn.com.cgbchina.trade.model.OrderSubModel;

/**
 * Created by yuxinxin on 16-4-29.
 */

public interface OrderPartBackService {
	/**
	 * 审核撤单 供应商(广发)端使用此方法
	 *
	 * @param orderSubModel
	 * @return
	 */
	Response<Boolean> updateRevocation(OrderSubModel orderSubModel, String memo, String memoExt, User user);

	/**
	 * 审核撤单 供应商(积分)端使用此方法
	 * @param orderSubModel 订单信息
	 * @param memo 撤单原因
	 * @param memoExt 撤单说明
	 * @return 撤单是否成功
	 */
	Response <Boolean>updatePointRevocation(OrderSubModel orderSubModel, String memo, String memoExt, User user);

	/**
	 * 供应商撤单 新更改后的撤单查询
	 * @param pageNo 页面数
	 * @param size 页面条数
	 * @param startTime 开始时间
	 * @param endTime 结束时间
	 * @param orderId 子订单号
	 * @param sourceId 渠道
	 * @param ordertypeId 业务类型
	 * @param tblFlag 是否查询历史数据：1查询历史数据
	 * @param ordermainId 主订单号
	 * @param user 供应商信息
	 * @return 列表数据
	 */
	public Response<Pager<OrderPartBackDto>> findRevocationAll(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("orderId") String orderId, @Param("sourceId") String sourceId,
			@Param("ordertypeId") String ordertypeId, @Param("tblFlag") String tblFlag,
			@Param("ordermainId") String ordermainId, @Param("_USER_") User user);

	/**
	 * 批量撤单
	 *
	 * @param updateAll
	 * @return
	 */
	public Response<Integer> updateAllRevocation(List<String> updateAll);

	/**
	 * 批量更新退货状态
	 * 
	 * @param rejectGoodsList
	 * @return
	 */
	Response<Integer> updateAllRejectGoods(List<Long> rejectGoodsList);

	/**
	 * 撤单导出
	 * 
	 * @param dataMap
	 * @param user
	 * @return
	 */
	Response<List<RevocationOrderDto>> exportRevocation(Map<String, Object> dataMap, User user);

	/**
	 * 根据订单ID查询订单信息
	 *
	 * @param orderId 订单ID
	 * @return 订单信息
	 */
	Response<OrderSubModel> findbyOrderId(String orderId);
}
