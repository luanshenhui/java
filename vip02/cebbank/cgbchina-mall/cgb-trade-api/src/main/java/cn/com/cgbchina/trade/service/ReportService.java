package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.trade.dto.MemberCountBatchDto;
import cn.com.cgbchina.trade.dto.ClearingDto;
import cn.com.cgbchina.trade.dto.ExchangeStatisticsDto;
import cn.com.cgbchina.trade.dto.MemberNumDto;
import cn.com.cgbchina.trade.dto.MemberSearchDto;
import cn.com.cgbchina.trade.dto.MemberShopCarDto;
import cn.com.cgbchina.trade.dto.OrderSubBatchDto;
import cn.com.cgbchina.trade.dto.OrderVirtualBatchDto;
import cn.com.cgbchina.trade.dto.VendorExchangeStatDto;
import cn.com.cgbchina.trade.dto.SevenDaysInnDto;

import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

/**
 * 报表接口
 * 
 * @author huangcy on 2016年6月22日
 */
public interface ReportService {
	/**
	 * 根据业务时间获取分期请款(广发商城)
	 * 
	 * @author xiewl
	 * @param startDate 业务起始时间
	 * @param endDate 业务结束时间
	 * @return
	 */
	Response<Pager<OrderSubBatchDto>> findStageReqCash(int pageNo, int size, Map<String, Object> params);

	/**
	 * 根据业务时间获取分期退货统计信息(广发商城)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	Response<Pager<OrderSubBatchDto>> findStageReturnGoods(int pageNo, int size, Map<String, Object> params);

	/**
	 * 根据业务时间获取商户退货详细(供应商平台)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	Response<Pager<OrderSubBatchDto>> findVendorGoodsBack(int pageNo, int size, Map<String, Object> params);

	/**
	 * 获取指定时间段商品销售明细(广发商城)
	 * 
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<Pager<OrderSubBatchDto>> findGoodsSaleDetail(int pageNo, int size, Map<String, Object> params);

	/**
	 * Description : 获取指定时间段商户销售明细(广发商城)
	 * 
	 * @param params 查询参数(日期精确到天) : 1)startDate 开始日期; 2)endDate 结束日期
	 * @return
	 * @rule  当前订单状态不为(待付款, 订单状态未明, 支付失败, 处理中, 已废单)；<br/>
	 *        以支付成功时间作为统计时间；<br/>
	 *        业务创建时间正顺序排序；<br/>
	 *        订单业务类型为一期和分期订单
	 */
	public Response<Pager<OrderSubBatchDto>> findVendorSaleDetail(int pageNo, int size, Map<String, Object> params);

	/**
	 * 获取指定时间段普通礼品销售明细(积分商城)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @param vendorId 指定供应商ID 为空则获取全部销售数据
	 * @return
	 */
	public Response<Pager<OrderSubBatchDto>> findCommonGiftSale(int pageNo, int size, Map<String, Object> params);

	/**
	 * 获取指定时间段退货详细(积分商城)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @param vendorId 指定供应商ID 为空则获取全部销售数据
	 * @return
	 */
	public Response<Pager<OrderSubBatchDto>> findGoodBack(int pageNo, int size, Map<String, Object> params);

	/**
	 * 获取指定时间段结算详细(积分商城)
	 * 
	 * @author xiewl
	 * @param startCommDate
	 * @param endCommDate
	 * @return
	 */
	public Response<List<ClearingDto>> findClearingDetail(Map<String, Object> params);

	/**
	 * 获取指定时间段兑换统计细节(积分商城)
	 * 
	 * @author xiewl
	 * @param startCommDate
	 * @param endCommDate
	 * @return
	 */
	public Response<List<ExchangeStatisticsDto>> findExchangeStatistics(Map<String, Object> params);

	/**
	 * 根据时间段获取7天联名卡住宿券报表数据(积分商城)
	 * 
	 * @author xiewl
	 * @param startCommDate
	 * @param endCommDate
	 * @return
	 */
	public Response<Pager<SevenDaysInnDto>> findSevenDaysInnDtos(int pageNo, int size, Map<String, Object> params);

	/**
	 * 根据时间段获取商户销售统计报表数据(广发商城)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<List<OrderSubBatchDto>> findVendorSaleStatistics(Map<String, Object> params);

	/**
	 * 根据时间段获取商户销售明细报表(供应商平台)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<Pager<OrderSubBatchDto>> findVendorSellDetail(int pageNo, int size, Map<String, Object> params);

	/**
	 * 根据时间段获取会员数量(会员报表)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<List<MemberNumDto>> findMemberNumModel(Map<String, Object> params);

	/**
	 * 
	 * Description : 根据时间段获取商户兑换统计报表记录
	 * 
	 * @param params 查询参数(日期精确到天) : 1)startDate 开始日期; 2)endDate 结束日期
	 * @return
	 * @Rule 订单类型为积分订单；<br/>
	 *       订单状态不为“待付款\订单状态未明\支付失败\已废单”；<br/>
	 *       以支付成功的时间作为统计时间；<br/>
	 *       以订单的生成时间升序排序；
	 */
	public Response<List<VendorExchangeStatDto>> findVendorExchangeStat(Map<String, Object> params);

	/**
	 * 根据时间段获取信用卡请款报表记录(供应商平台)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<Pager<OrderSubBatchDto>> findCreditCardReqMoney(int pageNo, int size, Map<String, Object> params);

	/**
	 * Description : 通过虚拟礼品编号查询相应礼品的订单信息(积分商城)
	 * 
	 * @param pageNo 页码
	 * @param pageSize 页大小
	 * @param params 查询参数(日期精确到天) : 1)startDate 开始日期; 2)endDate 结束日期 ; 3)goodsIds 虚拟礼品清单集合; 4)aviationType 航空类型
	 *            （可能不存在,为null时不限制该条件）
	 * @return
	 * @rule 订单状态为“支付成功”的；</br> 礼品为虚拟礼品；</br> 订单类型为积分订单；</br> 以订单支付成功的时间作为统计时间；</br> 以订单生成时间升序排序；
	 */
	public Response<Pager<OrderVirtualBatchDto>> findJFOrderByGoodsIds(int pageNo, int pageSize,
			Map<String, Object> params);

	/**
	 * Description : 通过虚拟礼品编号查询相应礼品的订单信息,用于日报表(积分商城)
	 * 
	 * @param params 查询参数(日期精确到时分秒) : 1)startDate 开始日期 ; 2)endDate 结束日期 ; 3)goodsIds 虚拟礼品清单集合
	 * @return
	 * @rule 订单状态为“支付成功”的；</br> 礼品为虚拟礼品；</br> 订单类型为积分订单；</br> 以订单支付成功的时间作为统计时间；</br> 以订单生成时间升序排序；
	 */
	public Response<List<OrderVirtualBatchDto>> findJFOrderOfDayByGoodsIds(Map<String, Object> params);

	/**
	 * 根据时间段获取会员搜索记录(会员报表)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<List<MemberSearchDto>> findMemberSearchRecord(Map<String, Object> params);

	/**
	 * 根据时间段获取会员购物车报表记录(会员报表)
	 * 
	 * @author xiewl
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Response<List<MemberShopCarDto>> findMemberShopCarModel(Map<String, Object> params);

	/**
	 * Description : 根据时间段获取会员收藏夹报表记录(会员报表)
	 * 
	 * @param params 查询参数(日期精确到天) : 1)startDate 开始日期; 2)endDate 结束日期
	 * @return
	 * @rule 从会员收藏夹中统计来源于广发商城、积分商城的商品收藏次数；</br> 收藏状态为有效的（即会员自行删除收藏的不计算）；</br> 收藏次数最多的前50商品及次数；</br> 排序按照收藏次数倒序排序；</br>
	 *       以收藏时间作为时间范围统计；
	 */
	public Response<List<MemberCountBatchDto>> findMemberGoodsFavorite(Map<String, Object> params);

	/**
	 * Description : 根据时间段获取会员足迹报表记录(会员报表)
	 * 
	 * @param params 查询参数(日期精确到天) : 1)startDate 开始日期; 2)endDate 结束日期
	 * @return
	 * @rule 从会员浏览历史表中统计来源于广发商城和积分商城的商品的浏览次数；</br> 浏览数据为有效数据；</br> 业务类型为广发商城和积分商城；</br> 浏览次数最多的前50商品及次数； </br>
	 *       同一个会员一天内浏览同一件商品统计为一次；</br> 排序按照浏览次数倒序排序；</br> 以浏览时间作为时间统计范围；
	 */
	public Response<List<MemberCountBatchDto>> findMemberBrowseHistory(Map<String, Object> params);
}
