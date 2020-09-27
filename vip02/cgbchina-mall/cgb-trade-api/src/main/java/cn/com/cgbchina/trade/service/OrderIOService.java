package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.trade.dto.OrderQueryConditionDto;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.trade.dto.OrderInputDto;
import cn.com.cgbchina.trade.dto.OrderOutputDto;

/**
 * 订单的导入导出 Created by zhoupeng on 2016/7/20.
 */
public interface OrderIOService {

	/**
	 * 根据条件 导出交易成功的订单
	 * 
	 * @param mapQuery
	 * @param user
	 * @return
	 */
	Response<List<OrderOutputDto>> exportOrderInfo(Map<String, Object> mapQuery, User user);

	/**
	 * 批量导入发货信息
	 *
	 * @param dtos
	 * @param user
	 * @return
	 */
	Response<Object> importOrderInfo(List<OrderInputDto> dtos, User user);

	/**
	 * 批量签收
	 *
	 * @param dtos
	 * @param user
	 * @return
	 */
	Response<Object> importOrdersign(List<OrderInputDto> dtos, User user);

	/**
	 * 批量导出签收信息
	 *
	 * @param mapQuery
	 * @param user
	 * @return
	 */
	Response<List<OrderOutputDto>> exportOrderSign(Map<String, Object> mapQuery, User user);

	/**
	 * 根据条件检出订单 -- 内官 订单管理
	 *
	 * @param mapQuery 查询条件
	 * @return OrderSubModel
	 */
	Response<List<OrderSubModel>> exportOrderView(Map<String, Object> mapQuery);

	/**
	 * 物流信息查询
	 *
	 * @param orderIds 订单id集合
	 * @return OrderTransModels
     */
	Response<List<OrderTransModel>> findOrderTrans(List<String> orderIds);
	/**
	 * 主订单信息查询
	 *
	 * @param orderMainIds 主订单id集合
	 * @return OrderTransModels
	 */
	Response<List<OrderMainModel>> findOrderMains(List<String> orderMainIds);

	public Response<Boolean> creatOrderServiceExcel(OrderQueryConditionDto conditionDto, String orderTypeId);

	public String getUserExport(String userId, String orderTypeId);

	public Response<Boolean> deleteOrderExport(User user, String fileName);
}
