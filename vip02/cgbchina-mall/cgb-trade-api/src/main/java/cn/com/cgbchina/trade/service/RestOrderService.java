package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.dto.GoodsItemDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderSubDto;
import cn.com.cgbchina.trade.model.OrderDetailDtoExtend;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderGoodsDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;

import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * 日期 : 2016-7-5<br>
 * 作者 : lizeyuan<br>
 * 项目 : cgb-trade-api<br>
 * 功能 : 接口调用
 */
public interface RestOrderService {

	/**
	 * Description : 通过用户ID查找主订单 (MAL119用)
	 * 
	 * @param userId 用户ID
	 * @return
	 */
	Response<Pager<OrderMainModel>> findByUserId(String userId);

	/**
	 * Description : 通过主订单ID查找订单(MAL119用)
	 * 
	 * @param orderMainId 主订单ID
	 * @return
	 */
	Response<List<OrderSubModel>> findBySubOrderMainId(String orderMainId);

	/**
	 * Description : 通过子订单号查找商品快照信息(MAL119用)
	 * 
	 * @param subOrderId 子订单ID
	 * @return
	 */
	Response<OrderGoodsDetailModel> findOrderGoodsDetailBySubOrderId(String subOrderId);

	/**
	 * Description : 通过用户ID查找最近一张订单里面的商品快照信息(MAL119用)
	 * 
	 * @param userId 用户ID
	 * @return
	 */
	Response<GoodsModel> findGoodsByUserId(String userId);

	/**
	 * Description : MAL108 CC积分商城订单详细信息查询 通过主订单号列表查找订单详细 信息，包括主订单信息，物流信息
	 * 
	 * @param orderMainId 主订单ID
	 * @return
	 */
	Response<OrderDetailDtoExtend> findOrderDetailbyOrderMainId(String orderMainId);

	/**
	 * Description : 通过子订单号列表查找商品快照信息列表
	 * 
	 * @param subOrderIds 子订单s
	 * @return
	 */
	Response<List<OrderGoodsDetailModel>> findOrderGoodsDetailBySubOrderId(List<String> subOrderIds);

	/**
	 * Description : 根据积分类型获取排行对象
	 * 
	 * @param jfType 积分类型
	 * @return
	 */
	Response<List<GoodsItemDto>> findSaleRankByjfType(String jfType);

	/**
	 * 查询购买记录
	 * 
	 * @param cardNo 证件号或者卡号，留学生旅行意外险订单为证件号，否则为卡号
	 * @param goodsId 单品id
	 * @param isLXSYX 是否为留学生旅行意外险订单
	 * @return
	 */
	Response<List<OrderSubDto>> queryBoughtOrder(String cardNo, String goodsId, boolean isLXSYX);
	
	/**
	 * 保存渠道广发下单订单信息
	 * @param orderMainModel
	 * @param orderSubModels
	 * @param orderDoDetailModels
	 * @param orderMainDto
	 * @return
	 */
	Response<Boolean> saveYGOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModels, 
			List<OrderDoDetailModel> orderDoDetailModels, OrderMainDto orderMainDto, User user);
	
	/**
	 * 保存渠道积分下单订单信息
	 * @param orderMainModel
	 * @param orderSubModels
	 * @param orderDoDetailModels
	 * @param stockMap
	 * @return
	 */
	Response<Boolean> saveJFOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList,
		    List<OrderDoDetailModel> orderDoDetailModelList, Map<String, Long> stockMap);

	/**
	 *  处理支付返回状态未明的订单,小订单状态置为“状态未明”
	 * @param orderIds
	 * @param cardNo
	 * @param cardType
	 * @param errCode
	 * @param doDesc
	 * @return
	 */
	Response<Boolean> dealNoSureOrderswithTX(List<String> orderIds, String cardNo, String cardType, String errCode,String doDesc);
	
	/**
	 * 处理支付失败、异常的订单,直接置为支付失败
	 * @param orderIds
	 * @param orderMainId
	 * @param cardNo
	 * @param doDesc
	 * @param user 
	 * @return
	 */
	Response<Boolean> dealFailOrderswithTx(List<String> orderIds, String orderMainId, String cardNo, String doDesc, User user);

	/**
	 * 积分订单支付结果处理
	 * @param orderMainModel
	 * @param orderSubModels
	 * @param orderDoDetailModels 
	 * @param itemStockMap
	 * @param birthDayCount
	 * @param user 
	 * @return
	 */
	Response<Boolean> updateOrders(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModels,
			List<OrderDoDetailModel> orderDoDetailModels, Map<String, Integer> itemStockMap, Integer birthDayCount, User user);
}
