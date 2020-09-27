package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.*;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 *
 *Created by Xiehongri on 2016/7/15.
 *
 */
@Slf4j
@Repository
public class OrderStatusQueryDao extends BaseDao{
    /**
     * 获取昨天和今天的状态是待付款和状态异常的小订单
     *
     * @return
     * @throws Exception
     */
    public List<OrderStatusQueryModel> getUnCommOrder(String time, String ordertypeId){
        OrderStatusQueryModel oderStatusQueryModel = new OrderStatusQueryModel();
        oderStatusQueryModel.setParamPrevDate(DateHelper.getYestoday());
        oderStatusQueryModel.setParamSubdate(time);
        oderStatusQueryModel.setParamOrdertypeId(ordertypeId);
        return getSqlSession().selectList("OrderStatusQuery.findOrderListByParam", oderStatusQueryModel);
    }

    /**
     * 通过订单id查询订单状态
     *
     * @param orderId
     * @return
     */
    public OrderStatusQueryModel findOrderById(String orderId) {
        return getSqlSession().selectOne("OrderStatusQuery.findOrderById", orderId);
    }
    /**
     * 通过订单orderMainid查询所有订单
     *
     * @param orderMainId
     * @return
     */
    public List<OrderStatusQueryModel> findOrderByOrderMainId(String orderMainId) {
        List<OrderStatusQueryModel> orderSubModelList = getSqlSession().selectList("OrderStatusQuery.findByOrderMainId", orderMainId);
        return orderSubModelList;
    }
    /**
     * 通过商品id查询商品信息
     *
     * @param code
     * @return
     */
    public ItemModel findItemById(String code) {
        ItemModel itemModel = new ItemModel();
        itemModel = getSqlSession().selectOne("OrderStatusQuery.findItemById", code);
        return itemModel;
    }
    /**
     * 通过VendorId查询VendorInfoModel信息
     *
     * @param vendorId
     * @return
     */
    public VendorInfoModel findVendorInfoModelById(String vendorId){
        return getSqlSession().selectOne("OrderStatusQuery.findVendorById", vendorId);
    }

    /**
     * 更新商品信息
     * @param params
     */
    public void updateItem(Map<String,Object> params) {
        getSqlSession().update("OrderStatusQuery.updateItem", params);
    }

    /**
     * 通过主订单id查询主订单信息
     *
     * @param orderMainId
     * @return
     */
    public OrderMainModel findOrderMainModelById(String orderMainId){
        return getSqlSession().selectOne("OrderStatusQuery.findOrderMainById", orderMainId);
    }

    /**
     * 通过GoodsPaywayId查询TblGoodsPaywayModel信息
     *
     * @param goodsPaywayId
     * @return
     */
    public TblGoodsPaywayModel findTblGoodsPaywayModelById(String goodsPaywayId){
        return getSqlSession().selectOne("OrderStatusQuery.findGoodsPayWayById", goodsPaywayId);
    }

    /**
     * 根据orderMainId更新订单状态
     */
    public void updateOrderStatusbyId(OrderStatusQueryModel orderStatusQueryModell){
        if (orderStatusQueryModell.getOrder_succ_time() != null) {
            orderStatusQueryModell.setOrder_succ_timeStr(DateHelper.date2string(orderStatusQueryModell.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
       getSqlSession().update("OrderStatusQuery.updateOrderStatusFromMain", orderStatusQueryModell);
    }

    /**
     * 根据orderId更新子订单状态
     * @param orderStatusQueryModel
     * @return
     */
    public Integer updateTblOrderStatus(OrderStatusQueryModel orderStatusQueryModel){
        if (orderStatusQueryModel.getOrder_succ_time() != null) {
            orderStatusQueryModel.setOrder_succ_timeStr(DateHelper.date2string(orderStatusQueryModel.getOrder_succ_time(), DateHelper.YYYY_MM_DD_HH_MM_SS));
        }else {
            orderStatusQueryModel.setOrder_succ_time(new Date());
        }
        return getSqlSession().update("OrderStatusQuery.updateOrderStatus",orderStatusQueryModel);
    }

    /**
     * 插入履历
     */
    public void insertOrderDodetailByOrders(OrderDoDetailModel orderDoDetailModel){
        getSqlSession().insert("OrderStatusQuery.insertOrderDoDetail", orderDoDetailModel);
    }

    public List<OrderMainModel> getUnCommOrderMain(String time,String ordertypeId){
        //获取昨日日期Start
        String prevDate = DateHelper.getYestoday();
        //获取昨日日期End
        //String subdate = time.substring(0, 8);
        //String subtime = time.substring(8, 14);
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("prevDate",prevDate+" 00:00:00");
        paramMap.put("subdate",time);
        //paramMap.put("subtime",subtime);
        paramMap.put("ordertypeId",ordertypeId);
        List<OrderMainModel> orderSubModelList = getSqlSession().selectList("OrderStatusQuery.getUnCommOrderMain", paramMap);
        return orderSubModelList;
    }

    public void insertOrderOutSystem(TblOrderOutSystemModel tblOrderOutSystemModel){
        getSqlSession().insert("OrderStatusQuery.insertOrderOutSystem", tblOrderOutSystemModel);
    }

    /**
     * 更新大订单状态
     */
    public void updateOrderMainStatus(OrderMainModel orderMainModel) {
        getSqlSession().update("OrderStatusQuery.updateOrderMainStatus", orderMainModel);
        //String hql = "update TblOrderMain o set o.curStatusId=?,o.curStatusNm=? where o.ordermainId =?";
    }

    public List<OrderStatusQueryModel> getOrderList(String ordermain_id){
        List<OrderStatusQueryModel> orderListNew = Lists.newArrayList();
        List<OrderStatusQueryModel> orderList = findOrderByOrderMainId(ordermain_id);//根据大订单id查询所有订单（由于是非主键所以用list接收）
        for(OrderStatusQueryModel orderSubModel : orderList){
            if(orderSubModel!=null && orderSubModel.getVendorId()!=null){
                VendorInfoModel vendorInfoModel = findVendorInfoModelById(orderSubModel.getVendorId());
                if(vendorInfoModel!=null&&vendorInfoModel.getVendorRole()!=null&&"3".equals(vendorInfoModel.getVendorRole())){
                	orderListNew.add(orderSubModel);
                }
            }
        }
        return orderListNew;
    }
    public Integer getSumOrderExtend1ById(String orderId) {
        Long total = getSqlSession().selectOne("OrderStatusQuery.getSumOrderExtend1ById", orderId);
        return Integer.valueOf(String.valueOf(total));
    }
    public TblOrderExtend1Model getOrderExtend1ById(String orderId) {
        TblOrderExtend1Model tblOrderExtend1Model = getSqlSession().selectOne("OrderStatusQuery.getOrderExtend1ById", orderId);
        return tblOrderExtend1Model;
    }
    public void insertTblOrderExtend1(String orderId, String extend1,String extend2) {
        TblOrderExtend1Model tblOrderExtend1Model = new TblOrderExtend1Model();
        tblOrderExtend1Model.setOrderId(orderId);
        tblOrderExtend1Model.setExtend1(extend1);
        tblOrderExtend1Model.setExtend2(extend2);
        getSqlSession().insert("OrderStatusQuery.insertTblOrderExtend1", tblOrderExtend1Model);
    }
    public void updateTblOrderExtend1ByExtend1(String orderId, String extend1) {
        TblOrderExtend1Model tblOrderExtend1Model = new TblOrderExtend1Model();
        tblOrderExtend1Model.setOrderId(orderId);
        tblOrderExtend1Model.setExtend1(extend1);
        //String hql = "update TblOrderExtend1 set extend1=? where orderId = ?";
        getSqlSession().update("OrderStatusQuery.updateTblOrderExtend1ByExtend1", tblOrderExtend1Model);
    }
    //更新广发商城小订单流水号
    public void updateOrderSerialNo(String orderId,String serialno) throws Exception{
       // String hql = "update TblOrder o set o.orderIdHost=? where o.orderId=? ";
        OrderStatusQueryModel orderStatusQueryModel = new OrderStatusQueryModel();
        orderStatusQueryModel.setOrderId(orderId);
        orderStatusQueryModel.setOrderIdHost(serialno);
        getSqlSession().update("OrderStatusQuery.updateOrderSerialNo", orderStatusQueryModel);
    }
    public TblVendorRatioModel getTblVendorRatio(String vendor_id, Integer period) {
        //String hql = " from TblVendorRatio  where vendorId=? and period=? and delFlag ='0' ";
        TblVendorRatioModel tblVendorRatioModel = new TblVendorRatioModel();
        tblVendorRatioModel.setVendorId(vendor_id);
        tblVendorRatioModel.setPeriod(period);
        List<TblVendorRatioModel> paywayList = getSqlSession().selectList("OrderStatusQuery.getTblVendorRatio", tblVendorRatioModel);
        TblVendorRatioModel tblVendorRatio = new TblVendorRatioModel();
        if (paywayList != null && paywayList.size() > 0) {
            tblVendorRatio = paywayList.get(0);
        }
        return tblVendorRatio;
    }
    public VendorInfoModel queryVendor(String vendor_id){
        return findVendorInfoModelById(vendor_id);
    }

    public VendorPayNoModel getTblVendorPayNo(String vendor_id, Integer period) {
        //String hql = " from TblVendorPayNo  where vendorId=? and period=? and delFlag!='1' ";
        VendorPayNoModel vendorPayNoModel = new VendorPayNoModel();
        vendorPayNoModel.setVendorInfId(vendor_id);
        vendorPayNoModel.setPeriod(period);
        List<VendorPayNoModel> paywayList = getSqlSession().selectList("OrderStatusQuery.getTblVendorPayNo", vendorPayNoModel);
        VendorPayNoModel tblVendorPayNo = new VendorPayNoModel();
        if (paywayList != null && paywayList.size() > 0) {
            tblVendorPayNo = paywayList.get(0);
        }
        return tblVendorPayNo;
    }

    public void insertTblOrderExtend1Model(TblOrderExtend1Model tblOrderExtend1) {
        getSqlSession().insert("OrderStatusQuery.insertTblOrderExtend1", tblOrderExtend1);
    }
    public void updateTblOrderExtend1Model(TblOrderExtend1Model tblOrderExtend1) {
        getSqlSession().update("OrderStatusQuery.updateTblOrderExtend1Model", tblOrderExtend1);
    }
    public void updateOrder(String orderId,String  cashAuthType) {
        OrderStatusQueryModel orderStatusQueryModel = new OrderStatusQueryModel();
        orderStatusQueryModel.setOrderId(orderId);
        orderStatusQueryModel.setCashAuthType(cashAuthType);
        getSqlSession().update("OrderStatusQuery.updateOrderCashAuthType", orderStatusQueryModel);

        //String hql = "update TblOrder set cashAuthType=? where orderId=?";

    }
    /**
     * 插入历史记录
     * @param doDate
     * @param doTime
     * @param doUserid
     * @param userType
     * @param doDesc
     * @param orderId
     */
    public void insertTblOrderDodetail(String doDate, String doTime,String doUserid, String userType, String doDesc, String orderId){
        OrderStatusQueryModel orderStatusQueryModel = new OrderStatusQueryModel();
        orderStatusQueryModel = findOrderById(orderId);
        OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
        orderDoDetailModel.setDoTime(new Date());
        orderDoDetailModel.setDoDesc(doDesc);
        orderDoDetailModel.setUserType(userType);
        orderDoDetailModel.setOrderId(orderId);
        orderDoDetailModel.setDoUserid(doUserid);
        orderDoDetailModel.setStatusId(orderStatusQueryModel.getCurStatusId());
        orderDoDetailModel.setStatusNm(orderStatusQueryModel.getSinStatusNm());
        getSqlSession().insert("OrderStatusQuery.insertOrderDoDetail", orderDoDetailModel);
    }

    public void updateTblOrderExtend1ByOrderId(String ERRORCODE,String APPROVERESULT,String FOLLOWDIR,String CASEID,String SPECIALCUST,String RELEASETYPE,String REJECTCODE,String APRTCODE,String ORDERNBR,String ORDER_ID){
        TblOrderExtend1Model tblOrderExtend1Model = new TblOrderExtend1Model();
        tblOrderExtend1Model.setErrorcode(ERRORCODE);
        tblOrderExtend1Model.setApproveresult(APPROVERESULT);
        tblOrderExtend1Model.setFollowdir(FOLLOWDIR);
        tblOrderExtend1Model.setCaseid(CASEID);
        tblOrderExtend1Model.setSpecialcust(SPECIALCUST);
        tblOrderExtend1Model.setReleasetype(RELEASETYPE);
        tblOrderExtend1Model.setAprtcode(APRTCODE);
        tblOrderExtend1Model.setOrderId(ORDER_ID);
        tblOrderExtend1Model.setOrdernbr(ORDERNBR);
        tblOrderExtend1Model.setRejectcode(REJECTCODE);
        getSqlSession().update("OrderStatusQuery.updateTblOrderExtend1ByExtend1", tblOrderExtend1Model);

//        String hql = "update TblOrderExtend1  set errorcode=?,approveresult=?,followdir=?,caseid=?,specialcust=?,releasetype=?,rejectcode=?,aprtcode=?,ordernbr=? where orderId =?";
    }
    /**
     * 更新大订单状态
     * @param curStatusId
     * @param curStatusNm
     * @param ordermainId
     */
    public void updateorderMainStatus(String curStatusId, String curStatusNm,String ordermainId) {
        OrderMainModel orderMainModel = new OrderMainModel();
        orderMainModel.setCurStatusId(curStatusId);
        orderMainModel.setCurStatusNm(curStatusNm);
        orderMainModel.setOrdermainId(ordermainId);
        getSqlSession().update("OrderStatusQuery.updateOrderMainStatus", orderMainModel);
       // String hql = "update TblOrderMain o set o.curStatusId=?,o.curStatusNm=? where o.ordermainId =?";
    }
    public void updateOrderStatus(String orderId,String curStatusId,String curStatusNm) {
        OrderStatusQueryModel orderStatusQueryModel = new OrderStatusQueryModel();
        orderStatusQueryModel.setOrderId(orderId);
        orderStatusQueryModel.setCurStatusId(curStatusId);
        orderStatusQueryModel.setCurStatusNm(curStatusNm);
        getSqlSession().update("OrderStatusQuery.updateOrderStatus", orderStatusQueryModel);
//        hql = "update TblOrder t set t.curStatusId=?,t.curStatusNm=? where t.orderId =?";
    }
    /**
     * 更新搭销订单的临时状态  0002-已完成
     */
    public void updateTyingsaleOrder(String orderId, String balance_status) {
        OrderStatusQueryModel orderStatusQueryModel = new OrderStatusQueryModel();
        orderStatusQueryModel.setOrderId(orderId);
        orderStatusQueryModel.setBalanceStatus(balance_status);
        getSqlSession().update("OrderStatusQuery.updateOrderStatus", orderStatusQueryModel);
//        String hql = "update TblOrder set balanceStatus=? where orderId=? and actCategory='1'";
    }
    public void updateOrderStatus(String orderId,String cardNo,String cardType,String curStatusId,String curStatusNm,String errCode) {
        OrderStatusQueryModel orderStatusQueryModel = new OrderStatusQueryModel();
        orderStatusQueryModel.setOrderId(orderId);
        orderStatusQueryModel.setCurStatusId(curStatusId);
        orderStatusQueryModel.setCurStatusNm(curStatusNm);
        orderStatusQueryModel.setErrorCode(errCode);
        orderStatusQueryModel.setCardno(cardNo);
        orderStatusQueryModel.setCardtype(cardType);
        getSqlSession().update("OrderStatusQuery.updateOrderStatus", orderStatusQueryModel);
    }
    /**
     * 回滚积分池
     *
     * @param paramMap
     * @return
     */
    public void dealPointPool(Map<String, Object> paramMap) {
        getSqlSession().update("OrderStatusQuery.dealPointPool", paramMap);
    }
    public void updateOrderStatusCashAuthType(String orderId, String cardNo, String cardType, String curStatusId, String curStatusNm, String cashAuthType, Date payTime) {
        OrderStatusQueryModel orderStatusQueryModel = new OrderStatusQueryModel();
        orderStatusQueryModel.setOrderId(orderId);
        orderStatusQueryModel.setCurStatusId(curStatusId);
        orderStatusQueryModel.setCurStatusNm(curStatusNm);
        orderStatusQueryModel.setCashAuthType(cashAuthType);
        orderStatusQueryModel.setCardno(cardNo);
        orderStatusQueryModel.setCardtype(cardType);
        orderStatusQueryModel.setOrder_succ_time(payTime);
        orderStatusQueryModel.setOrder_succ_timeStr(DateHelper.date2string(payTime,DateHelper.YYYY_MM_DD_HH_MM_SS));
        getSqlSession().update("OrderStatusQuery.updateOrderStatus", orderStatusQueryModel);
    }
    /**
     * 获取信用卡大机改造试运行阶段的参数
     */
    public List<TblCfgProCodeModel> getBigMachineParam() {
        return getSqlSession().selectList("OrderStatusQuery.getBigMachineParam");
    }

    public void updateOrderIsCancelNetbank(String orderId) {
        OrderStatusQueryModel orderStatusQueryModel = new OrderStatusQueryModel();
        orderStatusQueryModel.setOrderId(orderId);
        orderStatusQueryModel.setIsCancelNetbank(1);
        getSqlSession().update("OrderStatusQuery.updateOrderIsCancelNetbank", orderStatusQueryModel);
    }
//
//    /**
//     * 根据orderId更新购物车
//     * @param orderId
//     * @param payFlag
//     */
//    public void updateTblEspCustCartByOrderId(String orderId, String payFlag) {
//        Map<String,Object> params1 = Maps.newHashMap();
//        params1.put("orderId", orderId);
//        List custCartIds = getSqlSession().selectList("OrderStatusQuery.findCustCartIdById", params1);
//        if (custCartIds.size() > 0) {
//            Map<String,Object> params = Maps.newHashMap();
//            params.put("payFlag",payFlag);
//            params.put("custCartIds",custCartIds);
//            getSqlSession().update("OrderStatusQuery.updateTblEspCustCartByOrderId",params);
//        }
//    }

//    /**
//     * 根据orderMainId更新购物车
//     * @param orderMainId
//     * @param payFlag
//     */
//    public void updateTblEspCustCart(String orderMainId, String payFlag) {
//        Map<String,Object> params1 = Maps.newHashMap();
//        params1.put("orderMainId", orderMainId);
//        List custCartIds = getSqlSession().selectList("OrderStatusQuery.findCustCartIdById", params1);
//        if (custCartIds.size() > 0) {
//            Map<String,Object> params = Maps.newHashMap();
//            params.put("payFlag",payFlag);
//            params.put("custCartIds",custCartIds);
//            getSqlSession().update("OrderStatusQuery.updateTblEspCustCart",params);
//        }
//    }

    /**
     * 插入积分和优惠券对账文件对象
     * @param orderCheckModel
     */
    public void saveTblOrderCheck(OrderCheckModel orderCheckModel){
        getSqlSession().insert("OrderStatusQuery.insertOrderCheckModel",orderCheckModel);
    }

    /**
     * 更新拍卖记录表（荷兰拍）
     * @param auctionId
     */
    public void updateRecordSucc(String auctionId) {
        getSqlSession().update("OrderStatusQuery.updateRecordSucc",auctionId);
    }

    /**
     * 更新生日件数
     * @param orderMainId
     */
    public void updateBirthday(String orderMainId) {
        if (orderMainId != null && orderMainId.length() == 16) {// 如果是大订单(只有商城渠道才回滚)
            Integer sum = getSqlSession().selectOne("OrderStatusQuery.findCountByOrderMainId", orderMainId);
            String custid = getSqlSession().selectOne("OrderStatusQuery.findCustIdByOrderMainId", orderMainId);
            Map<String,Object> params = Maps.newHashMap();
            params.put("sum",sum);
            params.put("custid",custid);
            getSqlSession().update("OrderStatusQuery.updateBirthUsedCount",params);
        }
    }

    /**
     * 更新对应拍卖记录状态，标识已经释放库存，不能再生成订单，对应已经生成订单的活动记录
     */
    public int updateRecordOrderReleased(String id) {
        return getSqlSession().update("OrderStatusQuery.updateAuctionRecord", id);
    }
}
