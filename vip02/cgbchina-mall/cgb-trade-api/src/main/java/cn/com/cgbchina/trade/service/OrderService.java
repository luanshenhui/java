package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.rest.visit.model.order.O2OOrderInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.trade.dto.OrderAndOutSystemDto;
import cn.com.cgbchina.trade.dto.OrderCCAndIVRAddDto;
import cn.com.cgbchina.trade.dto.OrderCommitSubmit314Dto;
import cn.com.cgbchina.trade.dto.OrderCommitSubmitDto;
import cn.com.cgbchina.trade.dto.OrderDetailDto;
import cn.com.cgbchina.trade.dto.OrderInfoDto;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderMallManageDto;
import cn.com.cgbchina.trade.dto.OrderReturnDetailDto;
import cn.com.cgbchina.trade.dto.PagePaymentReqDto;
import cn.com.cgbchina.trade.model.OrderBackupModel;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import cn.com.cgbchina.trade.model.TblOrderHistoryModel;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by 11141021040453 on 16-4-25.
 */
public interface OrderService {
    /**
     * @param pageNo
     * @param size
     * @param orderId
     *            订单编号
     * @param goodsType
     *            订单类型
     * @param sourceId
     *            渠道
     * @param startTime
     *            开始时间
     * @param endTime
     *            中支时间
     * @param goodsNm
     *            商品名称
     * @param memberName
     *            客户
     * @param vendorSnm
     *            供应商
     * @param curStatusId
     *            订单状态
     * @param ordertypeId
     *            分期数
     * @return
     */

    public Response<Pager<OrderInfoDto>> find(@Param("pageNo") Integer pageNo,
	    @Param("size") Integer size, @Param("orderId") String orderId,
	    @Param("goodsType") String goodsType,
	    @Param("sourceId") String sourceId,
	    @Param("startTime") String startTime,
	    @Param("endTime") String endTime, @Param("goodsNm") String goodsNm,
	    @Param("goodsId") String goodsId, @Param("cardno") String cardno,
	    @Param("memberName") String memberName,
	    @Param("vendorSnm") String vendorSnm,
	    @Param("curStatusId") String curStatusId,
	    @Param("ordertypeId") String ordertypeId,
	    @Param("ordermainId") String ordermainId,
	    @Param("limitFlag") String limitFlag, @Param("type") String type,
	    @Param("") User user, @Param("searchType")String searchType);

    /**
     * 商城获取订单列表
     * 
     * @param pageNo
     * @param size
     * @param ordermainId
     *            主订单号
     * @param curStatusId
     *            订单状态
     * @param startTime
     *            开始时间
     * @param endTime
     *            结束时间
     * @param limitFlag
     *            查询六月flag
     * @param user
     *            用户信息
     * @return
     */

    public Response<Pager<OrderMallManageDto>> findMall(
	    @Param("pageNo") Integer pageNo, @Param("size") Integer size,
	    @Param("ordermainId") String ordermainId,
	    @Param("curStatusId") String curStatusId,
	    @Param("startTime") String startTime,
	    @Param("endTime") String endTime,
	    @Param("limitFlag") String limitFlag, @Param("") User user,
	    @Param("mallType") String mallType);

    /**
     * 查看订单详情
     * 
     * @param orderId
     * @return
     */

    public Response<OrderDetailDto> findOrderInfo(@Param("id") String orderId,
	    @Param("") User user);

    /**
     * 查看订单详情（接口用）
     * 
     * @param orderId
     * @return
     */

    public Response<OrderDetailDto> findOrderInfoByRestFull(
	    @Param("id") String orderId);

    /**
     * 更新订单状态提醒发货
     * 
     * @Param orderId 子订单Id
     * @Param id 用户id return
     */
    public Response<Map<String, Boolean>> updateOrderRemind(String orderId,
	    String id);

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
     * @param paramMap
     *            orderId 子订单Id typeFlag 区分标识 vendorId 供应商Id season 原因
     *            supplement 补充说明
     * @return
     */

    public Response<Map<String, Object>> revokeOrder(
	    Map<String, String> paramMap);

    /**
     * 商城退货申请
     * 
     * @param paramMap
     *            orderId 子订单Id typeFlag 区分标识 vendorId 供应商Id season 原因
     *            supplement 补充说明
     * @return
     */

    public Response<Map<String, Object>> returnOrderMall(
	    Map<String, Object> paramMap);

    /**
     * 商城撤单
     * 
     * @param paramMap
     * @return
     */
    public Response<Map<String, Object>> revokeOrderMall(
	    Map<String, Object> paramMap);

    /**
     * 代发货订单批量置为发货处理中
     * 
     * @param paramMap
     *            vendorId *
     * @return
     */

    public Response<Map<String, Boolean>> export(Map<String, String> paramMap);

    Response createOrder_new(OrderCommitSubmitDto orderCommitSubmitDto,
	    User user, OrderMainModel orderMainModel,
	    List<OrderSubModel> orderSubModelList,
	    List<OrderDoDetailModel> orderDoDetailModelList,
	    List<OrderVirtualModel> orderVirtualList, OrderMainDto orderMainDto);

    public Response<Map<String, Boolean>> demoPay(String orderMainId,
	    String payFlag, User user);

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
     * 
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
    public Response<Map<String, Boolean>> updateOrderSignVendor(
	    Map<String, Object> paramMap);

    /**
     * 广发商城前台 取消订单
     * 
     * @param paramMap
     * @return
     */
    public Response<Map<String, Object>> updateOrderMall(
	    Map<String, Object> paramMap);

    /**
     * 搭销订单
     * 
     * @param paramMap
     *            String itemCode 单品id String orderId 搭销子订单 String curStatusId
     *            搭销子订单状态 List <String> promotionItemCodes 供应商活动单品List User user
     *            用户
     * 
     */
    public Response<Map<String, Object>> createTieinSaleOrder(
	    Map<String, Object> paramMap);

    /**
     * 提交订单画面显示
     * 
     * @param skus
     *            购物车信息
     * @param user
     *            用户
     * @return
     */
    public Response<Map<String, Object>> findOrderInfoForCommitOrder(
	    @Param("skus") String skus, @Param("user") User user);

    /**
     * 积分提交订单画面显示
     * 
     * @param skus
     *            购物车信息
     * @param user
     *            用户
     * @return
     */
    public Response<Map<String, Object>> jfFindOrderInfoForCommitOrder(
	    @Param("skus") String skus, @Param("user") User user);

    /**
     * 发货
     * 
     * @Param orderId 子订单Id
     * @Param transcorpNm 物流公司
     * @Param mailingNum 物流单号
     * @Param transRemark 备注 return
     */
    public Response<Map<String, Object>> deliverGoods(
	    OrderTransModel orderTransModel, User user);

    /**
     * 获取单品已购买的件数
     * 
     * @param paramMap
     * @return
     * 
     *         geshuo 20160707
     */
    public Response<Map<String, Long>> findItemBuyCount(
	    Map<String, Object> paramMap);

    public Response<OrderSubModel> validateOrderInf(String subOrderNo);

    public Response<Integer> updateStatues(OrderSubModel orderSubModel);

    public Response<OrderSubModel> validateBackMsg(String orderNo);

    /**
     * 查询主订单下的所有子订单（用于手动推送O2O订单接口调用）
     * 
     * @param orderId
     * @return
     */
    Response<List<O2OOrderInfo>> findpushOrder(String orderId);

    /**
     * 商城 我的订单 支付
     * 
     * @param orderMainId
     * @param user
     * @return
     * @Add by yanjie.cao
     */
    public Response<PagePaymentReqDto> payoffOrder(String orderMainId, User user);

    /**
     * 供应商平台（ 广发商城）订单管理 （020）已过期操作
     * 
     * @param orderId
     * @param vendorId
     * @return
     */
    public Response<Map<String, Object>> expiredCode(String orderId,
	    String vendorId);

    /***
     * 发送短信
     * 
     * @param orderId
     * @return
     */
    public Response<Boolean> sendMsg(String orderId);

    /**
     * 获取主订单信息
     * 
     * @param orderMainId
     * @return
     */
    public Response<OrderMainModel> findOrderMainById(String orderMainId);

    public Response<List<OrderSubModel>> findByOrderMainId(String orderMainId);

    Response saveOrder(OrderMainModel orderMainModel,
	    List<OrderSubModel> orderSubModelList,
	    List<OrderDoDetailModel> orderDoDetailModelList,
	    Map<String, Long> stockMap );
    
    Response saveGfOrder(OrderMainModel orderMainModel,
	    List<OrderSubModel> orderSubModelList,
	    List<OrderDoDetailModel> orderDoDetailModelList,
	    OrderMainDto orderMainDto,User user);

    /**
     * 提交订单处理(314接口使用下单订单)
     * 
     * @param orderCommitSubmitDto
     * @param user
     * @return
     * @Add by zzl
     */
    public Response<Map<String, PagePaymentReqDto>> createOrder314(
	    OrderCommitSubmit314Dto orderCommitSubmitDto, User user);

    public Response<OrderSubModel> findInfoByCurStatusId(
	    Map<String, Object> paramMap);

    public Response<Integer> insertOrderDoDetail(
	    OrderDoDetailModel orderDoDetailModel);

    public Response<Integer> updateTblOrderHistory(
	    TblOrderHistoryModel tblOrderHistory);

    public Response<Integer> updateTblOrderExtend1(
	    TblOrderExtend1Model tblOrderExtend1);

    public Response<TblOrderExtend1Model> queryTblOrderExtend1(String orderId);

    public Response<TblOrderHistoryModel> findTblOrderHistoryById(String orderId);

    public Response<OrderBackupModel> findOrderBackupById(String orderId);

    /**
     * 根据主订单号查询所有子订单(未删除) niufw
     * 
     * @param orderMainId
     * @return
     */
    public Response<List<OrderSubModel>> findByorderMainId(String orderMainId);

    /**
     * MAL502 微信退积分接口的支付成功的订单退款 niufw
     * 
     * @param orderMainId
     * @param orderSubModel
     * @param new_status_id
     * @param new_status_nm
     * @param cur_status_id
     * @param backPointNum
     * @param backNum
     * @param partlyRefund
     * @param oper_nm
     * @param subFlag
     */
    public void updateVirtualOrderRefundWithTX(String orderMainId,
	    OrderSubModel orderSubModel, String new_status_id,
	    String new_status_nm, String cur_status_id, long backPointNum,
	    int backNum, String partlyRefund, String oper_nm, boolean subFlag);

    /**
     * MAL MAL422分页查询接口 niufw
     * 
     * @param beginDate
     * @param endDate
     * @param createOper
     * @return
     */
    public Response<Pager<OrderAndOutSystemDto>> findFor422(
	    Integer rowsPageInt, int currentPageInt, String beginDate,
	    String endDate, String createOper, String goodsNm);

    /**
     * inser订单 接口MAL501
     */
    public Response<Integer> insertTblOrderSub(OrderSubModel orderSubModel);

    /**
     * update订单 接口MAL501
     */
    public Response<Integer> updateTblOrderSub(OrderSubModel orderSubModel);

    /**
     * 通过订单Id获取订单类型ID｛YG，JF，FQ｝
     * 
     * @param orderId
     * @return
     */
    public Response<String> findOrderTypeIdByOrderId(String orderId);

    /**
     * 根据主订单号查询tblorder_history所有子订单(未删除) niufw
     * 
     * @param orderMainId
     * @return
     */
    public Response<List<TblOrderHistoryModel>> findHistoryByorderMainId(
	    String orderMainId);

    /**
     * 根据主订单号查询tblorder_backup所有子订单(未删除) niufw
     * 
     * @param orderMainId
     * @return
     */
    public Response<List<OrderBackupModel>> findBackupByorderMainId(
	    String orderMainId);

    /**
     * 虚拟商品获取其他信息 niufw
     * 
     * @param orderId
     * @return
     */
    public Response<List<OrderVirtualModel>> findVirtualByOrderId(String orderId);

    /**
     * 更新广发商城小订单流水号
     * 
     * @param orderSubModel
     */
    public void updateOrderSerialNo(OrderSubModel orderSubModel);

    /**
     * 取得子订单
     * 
     * @param orderId
     */
    public Response<OrderSubModel> selectOrderSub(String orderId);

    /**
     * 取得订单扩展表
     * 
     * @param orderId
     */
    public Response<TblOrderExtend1Model> selectOrderExtend(String orderId);

    /**
     * 保存订单扩展表
     * 
     * @param tblOrderExtend
     */
    public void insertOrderExtend(TblOrderExtend1Model tblOrderExtend);

    /**
     * 通过订单id查询订单
     * 
     * @param orderId
     */
    public Response<OrderSubModel> findOrderSubById(String orderId);

    /**
     * 通过订单id查询订单处理历史明细
     * 
     * @param orderId
     */
    public Response<List<OrderDoDetailModel>> findOrderDoDetailByOrderStatusId(
	    String orderId);

    /**
     * 存储大订单，小订单，订单历史 shangqinbin
     * 
     * @param orderMainModel
     * @param orderMap
     * @param subFlag
     * @param businessType
     */
    public void saveOrdersWithTX(OrderMainModel orderMainModel, Map orderMap,
	    boolean subFlag, String businessType);

    /**
     * 积分商城下单-虚拟商品(外部接口 MAL104 调用)
     * 
     * @param orderCCAndIVRAddDto
     *            添加参数
     * 
     *            geshuo 20160825
     */
    Response<Boolean> createCCAndIVRVirtualOrder(
	    OrderCCAndIVRAddDto orderCCAndIVRAddDto);

    /**
     * 积分商城下单-实物商品(外部接口 MAL104 调用)
     * 
     * @param orderCCAndIVRAddDto
     *            添加参数
     * 
     *            geshuo 20160825
     */
    Response<Map<String, Object>> createCCAndIVRRealOrder(
	    OrderCCAndIVRAddDto orderCCAndIVRAddDto);

    /**
     * 通过订单id查询订单
     * 
     * @param orderId
     */
    public Response<OrderSubModel> findJfOrderById(String orderId);

    /**
     * 通过订单id查询订单
     */
    public Response<OrderSubModel> findByOrderMainIdAndOrderId(String orderId,
	    String orderMainId);

    public void updateOrdersWithTX(String orderMainId, String payState,
	    String retCode, boolean subFlag);

    /**
     * 通过订单id查询状态为0307或0308订单处理历史明细
     * 
     * @param orderId
     */
    public Response<OrderDoDetailModel> findByStatusAndOrderId(String orderId);

    /**
     * 积分商城下单-实物商品(外部接口 MAL104 调用) 更新订单状态(支付成功)
     * 
     * @param uOrderMain
     *            主订单信息
     * @param orderList
     *            子订单列表
     * @return
     */
    Response updateCCAndIVRTureOrder(OrderMainModel uOrderMain,
	    List<OrderSubModel> orderList);

    /**
     * 积分商城下单-实物商品(外部接口 MAL104 调用) 更新订单状态(支付不成功)
     * 
     * @param uOrderMain
     *            主订单信息
     * @param orderList
     *            子订单列表
     * @return
     */
    Response updateCCAndIVRFalseOrder(OrderMainModel uOrderMain,
	    List<OrderSubModel> orderList, String payState, String senderSN,
	    List<String> birthList, String retCode, String message);

    /**
     * 查询银行卡积分
     * 
     * @param mergeFlag
     * @param cardNo
     * @return
     */
    public List<QueryPointsInfoResult> getAmount(String cardNo, String mergeFlag, boolean flag);

    /**
     * 供应商平台请款管理查询
     * 
     * @param list
     * @return
     */
    public Response<List<OrderSubModel>> findForRequest(List<String> list);

    /**
     * 更新大小订单里的银行卡号
     * 
     * @param ordermain_id
     * @param payAccountNo
     * @return
     */
    Response<Integer> updateOrderCardNoForAll(String ordermain_id,
	    String payAccountNo);

    /**
     * 下单完毕删除购物车
     * 
     * @param cartIds 购物车ids
     * */
    Response<Boolean> updateShopCartByOrderSuccess(List<String> cartIds);

    /**
     * gf构建支付数据
     * 
     * @param ordermainModel 大订单
     * @param orderSubModelList 小订单列表
     * */
    Response<PagePaymentReqDto> getPaymentReqData(
	    OrderMainModel ordermainModel, List<OrderSubModel> orderSubModelList);

    /**
     * jf构建App支付数据
     *
     * @param ordermainModel 大订单
     * @param orderSubModelList 小订单列表
     * */
    Response<PagePaymentReqDto> getReturnObjForAppPay(
	    OrderMainModel ordermainModel, List<OrderSubModel> orderSubModelList);

    /**
     * 商城能否支付启停信息
     *
     * @param orderTypeId
     * */
    Response<Boolean> checkParametersForMall(String orderTypeId);

    /**
     * 查询订单流水
     *
     * @param orderids
     * @return
     */
    public Response<Map<String,List<OrderDoDetailModel>>> findOrderDoDetail(List<String> orderids);

    /**
     * 查询订单信息扩展表
     *
     * @param orderids
     * @return
     */
    public Response<Map<String,TblOrderExtend1Model>> findOrderExtendDetail(List<String> orderids);
}