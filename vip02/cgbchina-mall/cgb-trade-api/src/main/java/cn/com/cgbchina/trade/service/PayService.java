package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.rest.provider.vo.order.PayReturnOrderVo;
import cn.com.cgbchina.trade.model.*;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by 11141021040453 on 16-4-25.
 */
public interface PayService {
    /**
     * 返回参数 map key订单号  value 订单状态
     * */
    public Response<Map<String,String>> dealJFOrderWithTX(String ordermain_id, String payAccountNo, String cardType,
                                               List<PayReturnOrderVo> checkList, List<OrderSubModel> orderList, String custType);

    public Response<String> getCustTypeFromJF(String cardNo, String cardType);


    /**
     * 微信0元秒杀下单
     * @param orderMainModel 主订单
     * @param orderSubModel 子订单
     * @param orderDoDetailModel 订单操作历史
     * @param orderOutSystemModel 订单推送
     * @param user 用户
     * @param paramMap 其他参数
     *
     * geshuo 20160818
     */
    Response<Boolean> paywithTX(OrderMainModel orderMainModel, OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
                                OrderOutSystemModel orderOutSystemModel, User user, Map<String, String> paramMap) throws Exception;


    Response<Boolean> paywithTX(OrderMainModel tblOrderMain, List<OrderSubModel> tblOrders, List<OrderDoDetailModel> orderDodetails,
                                List<Map<String, Object>> goodsNumList, List<Map<String, Object>> actNumList, List<TblOrderExtend1Model> tblOrderExtend1List);

    /**
     *  支付返回状态未明，小单状态置为“状态未明" （接口115使用）
     *
     * @param failueList  优惠券、积分支付失败的List
     *
     */
    Response<Boolean> dealNoSureOrderswithTX115(List<Map<String,Object>> failueList,String cardNo,String cardType,String errCode,String doDesc);

    /**
     * 401短信
     * @param failueList
     * @param orderMainId
     * @param cardNo
     * @param doDesc
     * @return
     */
    public void dealFailOrderswithTx(List<Map<String,Object>> failueList,String orderMainId,String cardNo,String doDesc);


    Response<Boolean> dealFailOrderswithTX(List<Map<String,Object>> failueList, String orderMainid);

    /**
     * 处理bps分期支付信息
     * @param tblOrderMain
     * @param ordersTemp
     * @return
     */
    Response<Boolean> dealFQorderBpswithTX(OrderMainModel tblOrderMain, List<Map<String,Object>> ordersTemp);



    public void dealNoSureOrderswithTX(List list,String cardNo,String cardType,String errCode,String doDesc);

    public void dealWXFailOrderswithTX(List list,String ordermainId,String cardNo);

    public void dealWXFQorderBpswithTX(List<OrderCheckModel> orderCheckList2, List<OrderCheckModel> orderCheckList, List<String> goodsIdList, List<OrderSubModel> dealPointPoolList, List<TblOrderExtend1Model> tblOrderExtend1ModelIns,
            List<TblOrderExtend1Model> tblOrderExtend1Modelupd, OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList, List<OrderDoDetailModel> orderDoDetailModelList) throws Exception;

		//bug-305197 fixed by ldk
    public void updateWXOrderSourcewithTX(String ordermainId, String orderId,String sourceId,String sourceName, Date tradeDate);

    public Map<String,String> saveFQOrdersWithTX(OrderMainModel orderMain,Map orderMap,String businessType,List goodsList) throws Exception;

    /**
     * 处理bps分期支付信息
     * @param orderMainModel
     * @param orderSubModelList
     * @param orderCheckList
     * @param goodsIdList
     * @param dealPointPoolList
     * @param tblOrderExtend1Modelupd
     * @param orderExtend1ModelIns 
     * @param orderDoDetailModelList
     * @throws Exception
     */
    public void dealFQorderBpswithTX(OrderMainModel orderMainModel,List<OrderSubModel> orderSubModelList, List<OrderCheckModel> orderCheckList, List<String> goodsIdList, List<OrderSubModel> dealPointPoolList,
                                     List<TblOrderExtend1Model> tblOrderExtend1Modelupd,  List<TblOrderExtend1Model> orderExtend1ModelIns, List<OrderDoDetailModel> orderDoDetailModelList) throws Exception;

    public void orderChangeWithTX(OrderSubModel tblOrder, ItemModel itemModel, OrderDoDetailModel orderDetail, TblOrderExtend1Model tblOrderExtend1, OrderCheckModel orderCheck, TblOrderHistoryModel orderHistory) throws Exception ;

    public void orderChangeSuccessWithTX(OrderSubModel tblOrder, OrderDoDetailModel orderDetail, Map<String, String> runTime,TblOrderExtend1Model tblOrderExtend1,OrderCheckModel orderCheck,TblOrderHistoryModel orderHistory) throws Exception ;


}