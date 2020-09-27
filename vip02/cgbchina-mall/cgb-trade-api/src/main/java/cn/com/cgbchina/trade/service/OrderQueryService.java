package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.OrderCCInfoDto;
import cn.com.cgbchina.trade.dto.OrderQueryDto;
import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.TblOrderMainHisModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * Created by guixin1.ma on 16-8-3.
 */
public interface OrderQueryService {
	public Response<Pager<OrderQueryDto>> findByWx(@Param("pageNo") Integer pageNo,
											   @Param("size") Integer size,
											   @Param("custId") List<String> custId,
											   @Param("curStatusId") String curStatusId,
											   @Param("isPayOn") String isPayOn) ;
	public Response<Pager<OrderQueryDto>> findByApp(@Param("pageNo") Integer pageNo,
											   @Param("size") Integer size,
											   @Param("custId") List<String> custId,
											   @Param("curStatusId") String curStatusId,
											   @Param("isPayOn") String isPayOn,
											   @Param("orderType") String orderType,
											   @Param("statusIds") String statusIds) ;
	public Response<Pager<OrderQueryDto>> find(@Param("pageNo") Integer pageNo,
											   @Param("size") Integer size,
											   @Param("custId") List<String> custId,
											   @Param("curStatusId") String curStatusId);

	public Response<List<String>> findOrderMainIdByAcceptedNo(String acceptedNo);

	public Response<Integer> updateOrderSerialNo(String orderId,String orderIdHost);

	/**
	 * MAL109 更新投递方式信息
	 * @param orderMainModel
	 * @param orderMainHis
	 * @return
	 */
	public Response<Integer> orderPostChangewithTX(OrderMainModel orderMainModel, TblOrderMainHisModel orderMainHis);

	/**
	 * Description : MAL114 订单历史地址信息查询
	 * @author xiewl
	 * @since 2016/09/03
	 * @param orderMainId
	 * @return
	 */
	public Response<List<TblOrderMainHisModel>> findOrderMainHisByOrderMainId(String orderMainId);
	
	/**
	 * MAL113 查询订单信息
	 * @return
	 */
	public Response<Pager<OrderCCInfoDto>> queryOrderInfo(Integer startPage, Integer limit, String orderId, String cardNo, String cont_idcard, String acceptedNo, String betweenDate, String bankOrderId);

	public Response<Boolean> updateOpsOrderChangewithTX(String curStatusId, String curStatusNm, String order_id, OrderDoDetailModel orderDodetail, Map<String, String> runTime, String cust_cart_id, String act_type, String goods_id, String orderNbr, OrderCheckModel orderCheck);
	/**
	 * MAL308使用  根据证件号查询客户号
	 * @param certNo 
	 * @return create_oper  客户号
	 * */
	public Response<List<String>> findCreteOperByCertNo(String certNo);
	/**
	 * 用来查询大订单下 子订单数量的
	 * @param orderMainIds
	 * @return
	 */
	Response<List<OrderQueryDto>> findSubOrderNum(List<String> orderMainIds);
}
