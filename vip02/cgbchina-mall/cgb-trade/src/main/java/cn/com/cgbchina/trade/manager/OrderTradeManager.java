package cn.com.cgbchina.trade.manager;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.model.*;
import lombok.extern.slf4j.Slf4j;

import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionService;
import cn.com.cgbchina.trade.dto.OrderDealPayTradeDto;
import cn.com.cgbchina.trade.exception.TradeException;
import cn.com.cgbchina.trade.service.AuctionRecordService;
import cn.com.cgbchina.user.model.EspCustNewModel;
import cn.com.cgbchina.user.service.EspCustNewService;

import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;

@Slf4j
@Component
@Transactional
public class OrderTradeManager {

    //@Resource
    //PointPoolDao pointPoolDao;
    @Resource
    TblOrderExtend1Dao tblOrderExtend1Dao;
    @Resource
    OrderSubDao orderSubDao;
    @Resource
    OrderMainDao orderMainDao;
    @Resource
    OrderDoDetailDao orderDoDetailDao;
    @Resource
    TblOrderHistoryDao orderHistoryDao;
    @Resource
    OrderPartBackDao orderPartBackDao;
    @Resource
    TblOrderCheckDao tblOrderCheckDao;
    @Resource
    OrderCancelManager orderCancelManager;
    @Resource
    OrderDodetailManger orderDodetaiManger;
    @Resource
    OrderReturnTrackDao orderReturnTrackDao;
    @Resource
    OrderTransDao orderTransDao;
    @Resource
    AuctionRecordDao auctionRecordDao;
    @Resource
    PointsPoolService pointsPoolService;
    @Resource
    GoodsService goodsService;
    @Resource
    ItemService itemService;
    @Resource
    EspCustNewService espCustNewService;
    @Resource
    PromotionService promotionService;
    @Resource
    MallPromotionService mallPromotionService;
    @Resource
    AuctionRecordService auctionRecordService;
    @Resource
    GoodsPayWayService goodsPayWayService;
    @Value("#{app.birthdayLimit}")
    private String birthdayLimit;
    /**
     * 邮购
     *
     * @param orderSubModelList
     * @param goodsIdList
     * @param dealPointPoolList
     * @param orderCheckModelList
     * @param orderMainModel
     * @param orderDoDetailModelList
     * @return
     */
    @Transactional(rollbackFor = {Exception.class})
    public void processMailOrder(List<OrderSubModel> orderSubModelList, List<String> goodsIdList,
                                 List<OrderSubModel> dealPointPoolList,
                                 List<OrderCheckModel> orderCheckModelList,
                                 OrderMainModel orderMainModel, List<OrderDoDetailModel> orderDoDetailModelList) throws Exception {
       log.error("一期进入方法体内manager时间{}", DateTime.now());
        //更新子订单
        log.info("更新子订单");
        for (OrderSubModel orderSubModel : orderSubModelList) {
            orderSubDao.update(orderSubModel);
            if ("0308".equals(orderSubModel.getCurStatusId())) {
                updateSaleCount(orderSubModel);
            }

        }

        //回滚商品库存
        for (int i = 0; i < goodsIdList.size(); i++) {
            String goodsId = goodsIdList.get(i);
            goodsService.updateStock(goodsId);
        }

        //回滚积分池
        for (int i = 0; i < dealPointPoolList.size(); i++) {
            OrderSubModel orderSubModel = dealPointPoolList.get(i);
            Map<String, Object> paramMap = Maps.newHashMap();
            paramMap.put("used_point", orderSubModel.getBonusTotalvalue());
            if (null != orderSubModel.getCreateTime()) {
                paramMap.put("cur_month", DateHelper.getyyyyMM(orderSubModel.getCreateTime()).substring(0, 6));
            } else {
                paramMap.put("cur_month", "");
            }
            Response<Boolean> result = pointsPoolService.dealPointPool(paramMap);
        }

        //优惠券对账文件
        log.info("保存优惠券对账文件");
        if (orderCheckModelList != null && orderCheckModelList.size() != 0) {
            tblOrderCheckDao.insertBatch(orderCheckModelList);
        }

        //更新主订单
        log.info("更新主订单");
        if (orderMainModel != null) {
            orderMainDao.update(orderMainModel);
        }

        //订单处理明细
        log.info("保存订单处理明细");
        if (orderDoDetailModelList != null && orderDoDetailModelList.size() != 0) {
            orderDoDetailDao.insertBatch(orderDoDetailModelList);
        }
        log.error("一期结束manager方法体内时间{}",DateTime.now());
    }

    /**
     * 分期
     *
     * @param orderDealPayTradeDto
     * @return
     */
    @Transactional(rollbackFor = {Exception.class})
    public void processInstallment(OrderDealPayTradeDto orderDealPayTradeDto, OrderMainModel orderMainModel, List<OrderDoDetailModel> orderDoDetailModelList) throws Exception {
        //积分正交易
        log.info("保存积分正交易");
        if (!orderDealPayTradeDto.getOrderCheckList2().isEmpty()) {
            tblOrderCheckDao.insertBatch(orderDealPayTradeDto.getOrderCheckList2());
        }

        //优惠券
        log.info("保存优惠券");
        if (!orderDealPayTradeDto.getOrderCheckList().isEmpty()) {
            tblOrderCheckDao.insertBatch(orderDealPayTradeDto.getOrderCheckList());
        }
        Response<Boolean> result;
        //回滚商品库存
        if (orderDealPayTradeDto.getRollBackItemStockmap() != null && orderDealPayTradeDto.getRollBackItemStockmap().size() > 0) {
            User user = new User();
            user.setId(orderDealPayTradeDto.getOrderSubModelList().get(0).getCreateOper());
            result = itemService.updateBatchStock(orderDealPayTradeDto.getRollBackItemStockmap(), user);
            if (!result.isSuccess()) {
                throw new TradeException("回滚商品库存失败");
            }
        }

        //回滚活动商品库存
        if (orderDealPayTradeDto.getRollBackPromotionStockmaps() != null && orderDealPayTradeDto.getRollBackPromotionStockmaps().size() > 0) {
            result = mallPromotionService.updateRollbackPromotionStock(orderDealPayTradeDto.getRollBackPromotionStockmaps());
            if (!result.isSuccess() || !result.getResult()) {
                throw new TradeException("回滚活动商品库存失败");
            }
        }

        //回滚积分池
        if (orderMainModel != null && orderMainModel.getTotalBonus() > 0l) {
            Long totalBonus = orderMainModel.getTotalBonus();
            Map<String, Object> paramPoolMap = Maps.newHashMap();
            paramPoolMap.put("used_point", totalBonus);
            if (null != orderMainModel.getCreateTime()) {
                paramPoolMap.put("cur_month", DateHelper.getyyyyMM(orderMainModel.getCreateTime()).substring(0, 6));
            } else {
                paramPoolMap.put("cur_month", "");
            }
            result = pointsPoolService.dealPointPool(paramPoolMap);
            if (!result.isSuccess() || !result.getResult()) {
                throw new TradeException("回滚积分池失败");
            }
        }

        //插入扩展表
        log.info("插入扩展表");
        if (!orderDealPayTradeDto.getTblOrderExtend1ModelIns().isEmpty()) {
            tblOrderExtend1Dao.insertBatch(orderDealPayTradeDto.getTblOrderExtend1ModelIns());
        }

        //更新扩展表
        log.info("更新扩展表");
        for (TblOrderExtend1Model tblOrderExtend1Model : orderDealPayTradeDto.getTblOrderExtend1Modelupd()) {
            tblOrderExtend1Dao.update(tblOrderExtend1Model);
        }

        //更新主订单
        log.info("更新主订单");
        if (orderMainModel != null) {
            orderMainDao.update(orderMainModel);
        }

        //更新子订单
        log.info("更新子订单");
        for (OrderSubModel orderSubModel : orderDealPayTradeDto.getOrderSubModelList()) {
            orderSubDao.update(orderSubModel);
            if ("0308".equals(orderSubModel.getCurStatusId())) {
                updateSaleCount(orderSubModel);
            }
        }

        //订单处理明细
        log.info("保存订单处理明细");
        if (orderDoDetailModelList != null && orderDoDetailModelList.size() != 0) {
            orderDoDetailDao.insertBatch(orderDoDetailModelList);
        }

        //更新拍卖表
        for (String custCartId : orderDealPayTradeDto.getCustCartIdList()) {
            AuctionRecordModel auctionRecordModel = new AuctionRecordModel();
            auctionRecordModel.setId(Long.valueOf(custCartId));
            auctionRecordModel.setPayFlag("1");
            auctionRecordService.updatePayFlag(auctionRecordModel);
        }

        //回滚荷兰拍
        for (OrderSubModel orderSubModel : orderDealPayTradeDto.getDealAuctionRecordList()) {
            dealAuctionRecord(orderSubModel);
        }
    }

    /**
     * 积分
     *
     * @param orderSubModelList
     * @param orderDoDetailModelList
     * @return
     */
    @Transactional(rollbackFor = {Exception.class})
    public void processPoints(List<OrderSubModel> orderSubModelList, List<OrderSubModel> orderSubModelListRollBack,
                              List<OrderDoDetailModel> orderDoDetailModelList, OrderMainModel orderMainModel) throws Exception {

        //更新主订单
        log.info("更新主订单");
        if (orderMainModel != null) {
            orderMainDao.update(orderMainModel);
        }

        Map<String, Integer> itemStockmap = Maps.newHashMap();
        User user = new User();

        for (OrderSubModel orderSubModel : orderSubModelListRollBack) {
            //回滚活动

            //回滚生日
            Response<TblGoodsPaywayModel> tblGoodsPaywayModelResponse = goodsPayWayService.findGoodsPayWayInfo(orderSubModel.getGoodsPaywayId());
            TblGoodsPaywayModel tblGoodsPaywayModel = null;
            if(tblGoodsPaywayModelResponse.isSuccess()){
                tblGoodsPaywayModel = tblGoodsPaywayModelResponse.getResult();
            }
            if("1".equals(tblGoodsPaywayModel.getIsBirth())) {
                //处理生日
                espCustNewService.updateBirthUsedCount(orderSubModel.getCreateOper());
            }

            if (itemStockmap.get(orderSubModel.getGoodsId()) == null) {
                itemStockmap.put(orderSubModel.getGoodsId(), orderSubModel.getGoodsNum());
            } else {
                itemStockmap.put(orderSubModel.getGoodsId(), itemStockmap.get(orderSubModel.getGoodsId()) + orderSubModel.getGoodsNum());
            }
            user.setId(orderSubModel.getCreateOper());
        }
        // 回滚库存
        Response<Boolean> booleanResponse = itemService.updateRollBackStockForJF(itemStockmap, user);
        if (!booleanResponse.isSuccess()) {
            log.error("orderTradeManager processPoints,itemService updateRollBackStockForJF returnResult be wrong");
            throw new TradeException("itemService.updateRollBackStockForJF.be.wrong");
        }

        //更新子订单
        log.info("更新子订单");
        for (OrderSubModel orderSubModel : orderSubModelList) {
            orderSubDao.update(orderSubModel);
            if ("0308".equals(orderSubModel.getCurStatusId())) {
                updateSaleCount(orderSubModel);
            }
        }

        //订单处理明细
        log.info("保存订单处理明细");
        if (orderDoDetailModelList != null && orderDoDetailModelList.size() != 0) {
            orderDoDetailDao.insertBatch(orderDoDetailModelList);
        }

    }

    /**
     * 更新销量
     *
     * @param orderSubModel
     */
    private void updateSaleCount(OrderSubModel orderSubModel) {
        //支付成功更新销量
        if (StringUtils.isEmpty(orderSubModel.getActId())) {
            ItemModel itemModel = new ItemModel();
            itemModel.setCode(orderSubModel.getGoodsId());
            itemModel.setGoodsTotal(Long.valueOf(orderSubModel.getGoodsNum()));
            itemService.updateItemTotal(itemModel);
        } else {
            //内管  更新活动表 直接更db  redis中的sale字段当库存使 不是销量
            Integer promIdN = Integer.valueOf(orderSubModel.getActId());// 活动id
            String selectCodeN = orderSubModel.getGoodsId(); //单品号
            Integer saleCountN = orderSubModel.getGoodsNum(); //销量
            promotionService.updateSaleCount(promIdN, selectCodeN, saleCountN);
        }
    }

    /**
     * 回滚荷兰式商品和活动数
     *
     * @throws Exception
     */
    private void dealAuctionRecord(OrderSubModel orderSubModel) throws Exception {
        String custCartId = orderSubModel.getCustCartId();
        Response<AuctionRecordModel> response = auctionRecordService.findById(custCartId);
        AuctionRecordModel auctionRecordModel = null;
        if (response.isSuccess()) {
            auctionRecordModel = response.getResult();
        }
        if (auctionRecordModel != null) {
            String isBackLock = auctionRecordModel.getIsBacklock();
            if ("1".equals(isBackLock)) {
                //超过五分钟回滚库存更新拍卖纪录
                AuctionRecordModel auctionRecordModelUpd = new AuctionRecordModel();
                auctionRecordModelUpd.setIsBacklock("0");
                auctionRecordModelUpd.setReleaseTime(new Date());
                auctionRecordModelUpd.setId(Long.valueOf(custCartId));
                Response<Integer> responseCount = auctionRecordService.updateByIdAndBackLock(auctionRecordModelUpd);
                Integer count = 0;
                if (responseCount.isSuccess()) {
                    count = responseCount.getResult();
                }
                if (count > 0) {
                    String promId = String.valueOf(auctionRecordModel.getAuctionId());// 活动id
                    String periodId = String.valueOf(orderSubModel.getPeriodId());
                    String itemCode = orderSubModel.getGoodsId(); //单品号
                    String buyCount = "-" + String.valueOf(orderSubModel.getGoodsNum()); //销量
                    User user = new User();
                    user.setId(orderSubModel.getCreateOper());
                    mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, buyCount, user);
                }
            }
        }

    }

    /**
     * 其他渠道在微信继续支付，修改订单渠道和创建时间
     * @param ordermainId
     * @param orderId
     * @param sourceId
     * @param sourceName
     * @param date 
     */
		//bug-305197 fixed by ldk
    @Transactional(rollbackFor = { Exception.class })
    public void updateWXOrderSourcewithTX(String ordermainId, String orderId, String sourceId, String sourceName, Date date) {
        //修改大订单
        OrderMainModel orderMainModel = orderMainDao.findById(ordermainId);;
        orderMainModel.setSourceId(sourceId);
        orderMainModel.setSourceNm(sourceName);
        orderMainModel.setCreateTime(new Date());
        orderMainDao.update(orderMainModel);

        //修改小订单
        OrderSubModel orderSubModel = orderSubDao.findById(orderId);
        orderSubModel.setSourceId(sourceId);
        orderSubModel.setSourceNm(sourceName);
        orderSubModel.setCreateTime(new Date());
        orderSubModel.setOrder_succ_time(date);
        orderSubDao.update(orderSubModel);
    }

    /**
     * 支付返回状态未明，小单状态置为“状态未明”
     * @param list
     * @param cardNo
     * @param cardType
     * @param errCode
     * @param doDesc
     */
    @Transactional(rollbackFor = { Exception.class })
    public void dealNoSureOrderswithTX(List list,String cardNo,String cardType,String errCode,String doDesc) {
        for(int i=0;i<list.size();i++){
            Map map = (Map)list.get(i);
            String orderId = map.get("orderId").toString();
            // 更新子订单表
            OrderSubModel orderSubModel = orderSubDao.findById(orderId);
            orderSubModel.setCardno(cardNo);
            orderSubModel.setCardtype(cardType);
            orderSubModel.setCurStatusId("0316");
            orderSubModel.setCurStatusNm("状态未明");
            orderSubModel.setErrorCode(errCode);
            orderSubModel.setOrderId(orderId);
            orderSubModel.setOrder_succ_time(orderSubModel.getCreateTime());
            orderSubDao.update(orderSubModel);

            //插入历史记录
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setDoTime(new Date());
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setDoDesc(doDesc);
            orderDoDetailModel.setOrderId(orderId);
            orderDoDetailModel.setStatusId("0316");
            orderDoDetailModel.setStatusNm("状态未明");
            orderDoDetailModel.setDelFlag(0);
            orderDoDetailModel.setCreateTime(new Date());
            orderDoDetailModel.setCreateOper("System");
            orderDoDetailDao.insert(orderDoDetailModel);
        }
    }

    /**
     * 处理支付失败订单信息(微信渠道)
     * @param list
     * @param ordermainId
     * @param cardNo
     */
    @Transactional(rollbackFor = { Exception.class })
    public void dealWXFailOrderswithTX(List list, String ordermainId, String cardNo) {
        for(int i=0;i<list.size();i++){
            Map map = (Map)list.get(i);
            String orderId = map.get("orderId").toString();
            OrderSubModel orderSubModel = orderSubDao.findById(orderId);
            if(orderSubModel.getErrorCode()==null||"".equals(orderSubModel.getErrorCode())){//未返回支付结果的情况下回滚
                goodsService.updateStock(orderSubModel.getGoodsId());// 回滚商品数量
                if(orderSubModel.getBonusTotalvalue()!=null&&orderSubModel.getBonusTotalvalue().longValue()!=0){//回滚积分池
                    Map<String, Object> paramMap = Maps.newHashMap();
                    paramMap.put("used_point", orderSubModel.getBonusTotalvalue());
                    if (null != orderSubModel.getCreateTime()) {
                        paramMap.put("cur_month", DateHelper.getyyyyMM(orderSubModel.getCreateTime()).substring(0, 6));
                    } else {
                        paramMap.put("cur_month", "");
                    }
                    pointsPoolService.dealPointPool(paramMap);

                }
            }
            // 更新子订单表
            //OrderSubModel orderSubModelUpd = new OrderSubModel();            
            orderSubModel.setOrderId(orderId);
            orderSubModel.setCurStatusId("0307");
            orderSubModel.setCurStatusNm("支付失败");
            orderSubModel.setCardno(cardNo);
            orderSubModel.setOrder_succ_time(orderSubModel.getCreateTime());
            orderSubDao.update(orderSubModel);
            /****支付失败时插入对账文件表begin****/
            if(orderSubModel.getVoucherNo()!=null&&!"".equals(orderSubModel.getVoucherNo())){
                OrderCheckModel orderCheck = new OrderCheckModel();
                orderCheck.setOrderId(orderSubModel.getOrderId());
                orderCheck.setCurStatusId("0307");
                orderCheck.setCurStatusNm("支付失败");
                orderCheck.setDoDate(DateHelper.getyyyyMMdd());
                orderCheck.setDoTime(DateHelper.getHHmmss());
                orderCheck.setIscheck("0");
                orderCheck.setIspoint("");
                orderCheck.setDelFlag(0);
                tblOrderCheckDao.insert(orderCheck);
            }
            /****支付失败时插入对账文件表end****/
            //插入历史记录
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setDoTime(new Date());
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setDoDesc("微信广发分期支付");
            orderDoDetailModel.setOrderId(orderId);
            orderDoDetailModel.setStatusId("0316");
            orderDoDetailModel.setStatusNm("状态未明");
            orderDoDetailModel.setDelFlag(0);
            orderDoDetailModel.setCreateTime(new Date());
            orderDoDetailModel.setCreateOper("System");
            orderDoDetailDao.insert(orderDoDetailModel);
        }
    }

	/**
	 * 401短信失败订单
	 * 
	 * @param list
	 * @param ordermainId
	 * @param cardNo
	 * @param doDesc
	 */
    @Transactional(rollbackFor = { Exception.class })
    public void dealWXFailOrderswithTX(List list, String ordermainId, String cardNo,String doDesc) {
        for(int i=0;i<list.size();i++){
            Map map = (Map)list.get(i);

            String orderId = map.get("orderId").toString();
            OrderSubModel orderSubModel = orderSubDao.findById(orderId);
            if(orderSubModel.getErrorCode()==null||"".equals(orderSubModel.getErrorCode())){//未返回支付结果的情况下回滚
                goodsService.updateStock(orderSubModel.getGoodsId());// 回滚商品数量
                if(orderSubModel.getBonusTotalvalue()!=null&&orderSubModel.getBonusTotalvalue().longValue()!=0){//回滚积分池
                    Map<String, Object> paramMap = Maps.newHashMap();
                    paramMap.put("used_point", orderSubModel.getBonusTotalvalue());
                    if (null != orderSubModel.getCreateTime()) {
                        paramMap.put("cur_month", DateHelper.getyyyyMM(orderSubModel.getCreateTime()).substring(0, 6));
                    } else {
                        paramMap.put("cur_month", "");
                    }
                    pointsPoolService.dealPointPool(paramMap);

                }
            }
            // 更新子订单表
            orderSubModel.setCurStatusId("0307");
            orderSubModel.setCurStatusNm("支付失败");
            orderSubModel.setCardno(cardNo);
            orderSubDao.update(orderSubModel);
            /****支付失败时插入对账文件表begin****/
            if(orderSubModel.getVoucherNo()!=null&&!"".equals(orderSubModel.getVoucherNo())){
                OrderCheckModel orderCheck = new OrderCheckModel();
                orderCheck.setOrderId(orderSubModel.getOrderId());
                orderCheck.setCurStatusId("0307");
                orderCheck.setCurStatusNm("支付失败");
                orderCheck.setDoDate(DateHelper.getyyyyMMdd());
                orderCheck.setDoTime(DateHelper.getHHmmss());
                orderCheck.setIscheck("0");
                orderCheck.setIspoint("");
                orderCheck.setDelFlag(0);
                tblOrderCheckDao.insert(orderCheck);
            }
            /****支付失败时插入对账文件表end****/
            //插入历史记录
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setDoTime(new Date());
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setDoDesc(doDesc);
            orderDoDetailModel.setOrderId(orderId);
            orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
            orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
            orderDoDetailModel.setDelFlag(0);
            orderDoDetailModel.setCreateTime(new Date());
            orderDoDetailModel.setCreateOper("System");
            orderDoDetailDao.insert(orderDoDetailModel);
        }
    }

    /**
     * 分期(微信)
     * @param orderCheckList2
     * @param orderCheckList
     * @param goodsIdList
     * @param dealPointPoolList
     * @param tblOrderExtend1ModelIns
     * @param tblOrderExtend1Modelupd
     * @param orderMainModel
     * @param orderSubModelList
     * @param orderDoDetailModelList
     * @throws Exception
     */
    @Transactional(rollbackFor = {Exception.class})
    public void processInstallmentWX(List<OrderCheckModel> orderCheckList2, List<OrderCheckModel> orderCheckList, List<String> goodsIdList, List<OrderSubModel> dealPointPoolList, List<TblOrderExtend1Model> tblOrderExtend1ModelIns,
                                   List<TblOrderExtend1Model> tblOrderExtend1Modelupd, OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList, List<OrderDoDetailModel> orderDoDetailModelList) throws Exception {

        //积分正交易
        log.info("保存积分正交易");
        if (orderCheckList2 != null && orderCheckList2.size() != 0) {
            tblOrderCheckDao.insertBatch(orderCheckList2);
        }

        //优惠券
        log.info("保存优惠券");
        if (orderCheckList != null && orderCheckList.size() != 0) {
            tblOrderCheckDao.insertBatch(orderCheckList);
        }

        //回滚商品库存
        for (int i = 0; i < goodsIdList.size(); i++) {
            String goodsId = goodsIdList.get(i);
            goodsService.updateStock(goodsId);
        }

        //回滚积分池
        for (int i = 0; i < dealPointPoolList.size(); i++) {
            OrderSubModel orderSubModel = dealPointPoolList.get(i);
            Map<String, Object> paramMap = Maps.newHashMap();
            paramMap.put("used_point", orderSubModel.getBonusTotalvalue());
            if (null != orderSubModel.getCreateTime()) {
                paramMap.put("cur_month", DateHelper.getyyyyMM(orderSubModel.getCreateTime()).substring(0, 6));
            } else {
                paramMap.put("cur_month", "");
            }
            Response<Boolean> result = pointsPoolService.dealPointPool(paramMap);
        }


        //插入扩展表
        log.info("插入扩展表");
        if (tblOrderExtend1ModelIns != null && tblOrderExtend1ModelIns.size() != 0) {
            tblOrderExtend1Dao.insertBatch(tblOrderExtend1ModelIns);
        }

        //更新扩展表
        log.info("更新扩展表");
        for (TblOrderExtend1Model tblOrderExtend1Model : tblOrderExtend1Modelupd) {
            tblOrderExtend1Dao.updateByOrderId(tblOrderExtend1Model);
        }

        //更新主订单
        log.info("更新主订单");
        if (orderMainModel != null) {
            orderMainDao.update(orderMainModel);
        }

        //更新子订单
        log.info("更新子订单");
        for (OrderSubModel orderSubModel : orderSubModelList) {
            orderSubDao.update(orderSubModel);
        }

        //订单处理明细
        log.info("保存订单处理明细");
        if (orderDoDetailModelList != null && orderDoDetailModelList.size() != 0) {
            orderDoDetailDao.insertBatch(orderDoDetailModelList);
        }
    }

    @Transactional(rollbackFor = {Exception.class})
    public  Map<String,String> saveOrdersWithTX(OrderMainModel orderMainModel,List<OrderSubModel> order,boolean subFlag,List<OrderDoDetailModel> detail){
        Map<String,String> returnMap = null;
        String createOper = orderMainModel.getCreateOper();
        //保存主订单
        log.info("保存的大订单号："+orderMainModel.getOrdermainId()+"商品数量："+orderMainModel.getTotalNum());
        if (orderMainModel != null) {
            if(StringUtils.isEmpty(orderMainModel.getIsInvoice())){
                orderMainModel.setIsInvoice("0");//默认不开发票
                orderMainModel.setDelFlag(0);
            }
            orderMainDao.insert(orderMainModel);
        }
        List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();
        String goods_id = "";
        int goods_num = 1;
        if(order != null && order.size() > 0){
            log.info("需要保存的小订单数目：{}", order.size());
            for (int i = 0; i < order.size(); i++) {
                OrderSubModel tblOrder = (OrderSubModel)order.get(i);
                if(i==0){
                    goods_id = tblOrder.getGoodsId();// 由于为同一个商品，这些数据可以统一处理
                }
                goods_num = tblOrder.getGoodsNum().intValue();
                tblOrder.setDelFlag("0");
                tblOrder.setO2oExpireFlag(0);
                tblOrder.setFenefit(new BigDecimal(0.00));
                tblOrder.setOrder_succ_time(orderMainModel.getCreateTime());
                orderSubModelList.add(tblOrder);
                if(subFlag){
                    //扣减库存
                    Response<Integer> countResponse = itemService.subtractStock(goods_id,Long.valueOf(goods_num));// 减库存
                    int goodsNum =0;
                    if(countResponse.isSuccess()){
                        goodsNum = countResponse.getResult();
                    }
                    if(goodsNum==0){
                        returnMap = new HashMap<>();
                        returnMap.put("errorCode","000074");
                        returnMap.put("errorDesc","商品数量不足");
                    }
                }

                //如果是生日价购买需要扣减生日使用次数
                if(Contants.PAYWAY_MENBER_LEVEL_BIRTHDAY.equals(tblOrder.getMemberLevel())){
                    int row = 0;
                    Map<String,Object> paramMap = new HashMap<>();
                    paramMap.put("custId",tblOrder.getCreateOper());
                    paramMap.put("goodsCount",goods_num);
                    paramMap.put("birthLimitCount", birthdayLimit);
                    Response<Integer> rowResponse = espCustNewService.updateCustNewByParams(paramMap);
                    if(rowResponse.isSuccess()){
                        row = rowResponse.getResult();
                    }
                    if(row <= 0){
                        returnMap = new HashMap<>();
                        returnMap.put("errorCode","000102");
                        returnMap.put("errorDesc", "生日当月已兑换过生日礼品，本次兑换不成功");
                    }
                }
            }

            List<OrderDoDetailModel> orderDoDetailModelList = new ArrayList<OrderDoDetailModel>();
            if(detail != null && detail.size() > 0){
                log.info("需要保存的小订单历史数目：{}", detail.size());
                for (int j = 0; j < detail.size(); j++) {
                    OrderDoDetailModel orderDodetail = (OrderDoDetailModel)detail.get(j);
                    orderDodetail.setDelFlag(0);
                    orderDodetail.setCreateOper(createOper);
                    orderDodetail.setCreateTime(new Date());
                    orderDoDetailModelList.add(orderDodetail);
                }

                //订单处理明细
                log.info("保存订单处理明细");
                if (orderDoDetailModelList != null && orderDoDetailModelList.size() != 0) {
                    orderDoDetailDao.insertBatch(orderDoDetailModelList);
                }
            }
        }

        //保存子订单
        log.info("保存子订单");
        if(orderSubModelList != null && !orderSubModelList.isEmpty()){
        	orderSubDao.insertBatch(orderSubModelList);
        }

        return returnMap;
    }


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
    @Transactional(rollbackFor = {Exception.class})
    public void dealFQorderBpswithTX(OrderMainModel orderMainModel,List<OrderSubModel> orderSubModelList, List<OrderCheckModel> orderCheckList, List<String> goodsIdList, List<OrderSubModel> dealPointPoolList,
                                     List<TblOrderExtend1Model> tblOrderExtend1Modelupd,  List<TblOrderExtend1Model> orderExtend1ModelIns, List<OrderDoDetailModel> orderDoDetailModelList) throws Exception{
        //更新主订单
        log.info("更新主订单");
        if (orderMainModel != null) {
            orderMainDao.update(orderMainModel);
        }

        //更新子订单
        log.info("更新子订单");
        if(orderSubModelList != null && !orderSubModelList.isEmpty()) {
            orderSubDao.updateBatch(orderSubModelList);
        }

        //优惠券
        log.info("保存积分优惠券");
        if (orderCheckList != null && orderCheckList.size() != 0) {
            tblOrderCheckDao.insertBatch(orderCheckList);
        }

        //回滚商品库存
        if(goodsIdList != null && !goodsIdList.isEmpty()){
        	Map<String, Integer> itemStockMap = new HashMap<>();
            for (String itemCd : goodsIdList) {
                if (itemStockMap.containsKey(itemCd)) {
            		itemStockMap.put(itemCd, itemStockMap.get(itemCd) + 1);
                } else {
                	itemStockMap.put(itemCd, 1);
                }
            }
            // 批量更新
            User user = new User(orderMainModel.getCreateOper(), orderMainModel.getContNm());
 			Response<Boolean> booleanResponse = itemService.updateBatchStock(itemStockMap, user);
 			if (!booleanResponse.isSuccess()) {
 				log.error("orderMainManager updateCancelOrder,itemService updateBatchStock returnResult be wrong");
 				throw new TradeException("itemService.updateBatchStock.be.wrong");
 			}
        }
        
        //回滚积分池
        for (int i = 0; i < dealPointPoolList.size(); i++) {
            OrderSubModel orderSubModel = dealPointPoolList.get(i);
            Map<String, Object> paramMap = Maps.newHashMap();
            paramMap.put("used_point", orderSubModel.getBonusTotalvalue());
            paramMap.put("cur_month", DateHelper.getyyyyMM(orderSubModel.getCreateTime()).substring(0, 6));
            pointsPoolService.dealPointPool(paramMap);
        }

        log.info("批量插入扩展表");
        if(orderExtend1ModelIns != null && !orderExtend1ModelIns.isEmpty()){
        	tblOrderExtend1Dao.insertBatch(orderExtend1ModelIns);
        }
        
        //更新扩展表
        log.info("更新扩展表");
        for (TblOrderExtend1Model tblOrderExtend1Model : tblOrderExtend1Modelupd) {
            tblOrderExtend1Dao.updateByOrderId(tblOrderExtend1Model);
        }

        //订单处理明细
        log.info("保存订单处理明细");
        if (orderDoDetailModelList != null && orderDoDetailModelList.size() != 0) {
            orderDoDetailDao.insertBatch(orderDoDetailModelList);
        }
    }
    
    /**
     * 支付返回状态未明，小单状态置为“状态未明”
     * @param orderIds
     * @param cardNo
     * @param cardType
     * @param errCode
     * @param doDesc
     */
    @Transactional(rollbackFor = { Exception.class })
    public void dealNoSureOrders(List<String> orderIds,String cardNo,String cardType,String errCode,String doDesc) {
        List<OrderSubModel> orderSubModels = new ArrayList<>();
        List<OrderDoDetailModel> orderDoDetailModels = new ArrayList<>();
    	for(String orderId : orderIds){
            // 更新子订单表
            OrderSubModel orderSubModel = orderSubDao.findById(orderId);
            orderSubModel.setCardno(cardNo);
            orderSubModel.setCardtype(cardType);
            orderSubModel.setCurStatusId("0316");
            orderSubModel.setCurStatusNm("状态未明");
            orderSubModel.setErrorCode(errCode);
            orderSubModel.setOrderId(orderId);
            orderSubModels.add(orderSubModel);

            //插入历史记录
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setDoTime(new Date());
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setDoDesc(doDesc);
            orderDoDetailModel.setOrderId(orderId);
            orderDoDetailModel.setStatusId("0316");
            orderDoDetailModel.setStatusNm("状态未明");
            orderDoDetailModel.setDelFlag(0);
            orderDoDetailModel.setCreateTime(new Date());
            orderDoDetailModel.setCreateOper("System");
            orderDoDetailModels.add(orderDoDetailModel);
        }
    	
    	log.info("更新子订单表");
    	if(orderSubModels != null && !orderSubModels.isEmpty()){
    		orderSubDao.updateBatch(orderSubModels);
    	}
    	
    	//订单处理明细
        log.info("保存订单处理明细");
        if (orderDoDetailModels != null && !orderDoDetailModels.isEmpty()) {
            orderDoDetailDao.insertBatch(orderDoDetailModels);
        }
    }
    
    /**
	 * 支付失败订单，回滚库存和积分池
	 * 
	 * @param orderIds
	 * @param ordermainId
	 * @param cardNo
	 * @param doDesc
     * @param user 
	 */
    @Transactional(rollbackFor = { Exception.class })
    public void dealFailOrders(List<String> orderIds, String ordermainId, String cardNo,String doDesc, User user) {
    	//llll
    	List<OrderSubModel> orderSubModels = new ArrayList<>();
        List<OrderDoDetailModel> orderDoDetailModels = new ArrayList<>();
        List<OrderCheckModel> orderCheckModels = new ArrayList<>();
        Map<String, Integer> itemStockMap = new HashMap<>();
        for(String orderId : orderIds){
            OrderSubModel orderSubModel = orderSubDao.findById(orderId);
            if(Strings.isNullOrEmpty(orderSubModel.getErrorCode())){//未返回支付结果的情况下回滚
            	String itemCd = orderSubModel.getGoodsId();//保存回滚库存数量
            	int cnt = orderSubModel.getGoodsNum();
            	if (itemStockMap.containsKey(itemCd)) {
            		itemStockMap.put(itemCd, itemStockMap.get(itemCd) + cnt);
                } else {
                	itemStockMap.put(itemCd, cnt);
                }
            	
                if(orderSubModel.getBonusTotalvalue()!=null&&orderSubModel.getBonusTotalvalue().longValue()!=0){//回滚积分池
                    Map<String, Object> paramMap = Maps.newHashMap();
                    paramMap.put("used_point", orderSubModel.getBonusTotalvalue());
                    paramMap.put("cur_month", DateHelper.getyyyyMM(orderSubModel.getCreateTime()));
                    pointsPoolService.dealPointPool(paramMap);
                }
            }
            // 更新子订单表
            orderSubModel.setCurStatusId("0307");
            orderSubModel.setCurStatusNm("支付失败");
            orderSubModel.setCardno(cardNo);
            orderSubModel.setOrder_succ_time(orderSubModel.getCreateTime());
            orderSubModels.add(orderSubModel);
            /****支付失败时插入对账文件表begin****/
            if(orderSubModel.getVoucherNo()!=null&&!"".equals(orderSubModel.getVoucherNo())){
                OrderCheckModel orderCheck = new OrderCheckModel();
                orderCheck.setOrderId(orderSubModel.getOrderId());
                orderCheck.setCurStatusId("0307");
                orderCheck.setCurStatusNm("支付失败");
                orderCheck.setDoDate(DateHelper.getyyyyMMdd());
                orderCheck.setDoTime(DateHelper.getHHmmss());
                orderCheck.setIscheck("0");
                orderCheck.setIspoint("");
                orderCheck.setDelFlag(0);
                orderCheckModels.add(orderCheck);
            }
            /****支付失败时插入对账文件表end****/
            //插入历史记录
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setDoTime(new Date());
            orderDoDetailModel.setDoUserid("System");
            orderDoDetailModel.setUserType("0");
            orderDoDetailModel.setDoDesc(doDesc);
            orderDoDetailModel.setOrderId(orderId);
            orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
            orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
            orderDoDetailModel.setDelFlag(0);
            orderDoDetailModel.setCreateTime(new Date());
            orderDoDetailModel.setCreateOper("System");
            orderDoDetailModels.add(orderDoDetailModel);
        }
        
        log.info("更新子订单表");
    	if(orderSubModels != null && !orderSubModels.isEmpty()){
    		orderSubDao.updateBatch(orderSubModels);
    	}
    	
    	//订单处理明细
        log.info("保存订单处理明细");
        if (orderDoDetailModels != null && !orderDoDetailModels.isEmpty()) {
            orderDoDetailDao.insertBatch(orderDoDetailModels);
        }
        
        //优惠券
        log.info("保存积分优惠券");
        if (orderCheckModels != null && !orderCheckModels.isEmpty()) {
            tblOrderCheckDao.insertBatch(orderCheckModels);
        }
        
        // 回滚单品库存
		if (itemStockMap != null && !itemStockMap.isEmpty()) {
			// 批量更新
			Response<Boolean> booleanResponse = itemService.updateBatchStock(itemStockMap, user);
			if (!booleanResponse.isSuccess()) {
				log.error("orderMainManager updateCancelOrder,itemService updateBatchStock returnResult be wrong");
				throw new TradeException("itemService.updateBatchStock.be.wrong");
			}
		}
    }

    @Transactional(rollbackFor = { Exception.class })
	public void dealOrdersJF(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModels,
			List<OrderDoDetailModel> orderDoDetailModels, Map<String, Integer> itemStockMap, Integer birthDayCount,
			User user) {
		orderMainDao.update(orderMainModel);
		
		log.info("更新子订单表");
    	if(orderSubModels != null && !orderSubModels.isEmpty()){
    		orderSubDao.updateBatch(orderSubModels);
    	}
    	
    	//订单处理明细
        log.info("保存订单处理明细");
        if (orderDoDetailModels != null && !orderDoDetailModels.isEmpty()) {
            orderDoDetailDao.insertBatch(orderDoDetailModels);
        }
        
        // 回滚单品库存
		if (itemStockMap != null && !itemStockMap.isEmpty()) {
			// 批量更新
			Response<Boolean> booleanResponse = itemService.updateRollBackStockForJF(itemStockMap, user);
			if (!booleanResponse.isSuccess()) {
				log.error("orderMainManager updateCancelOrder,itemService updateBatchStock returnResult be wrong");
				throw new TradeException("itemService.updateBatchStock.be.wrong");
			}
		}
		//释放生日资格 按子订单使用的次数进行释放
		if (birthDayCount != 0) {
			// 更新生日购买件数
			EspCustNewModel espCustNewModel = espCustNewService.findById(orderMainModel.getCreateOper()).getResult();
			if(espCustNewModel == null) {
				throw new TradeException("查询会员信息失败");
			}
			
			int birthUsedCount = espCustNewModel.getBirthUsedCount() - birthDayCount;
			if(birthUsedCount < 0){
				throw new TradeException("回滚生日次数失败,回滚的生日次数大于已使用生日次数");
			}
			espCustNewModel.setBirthUsedCount(birthUsedCount);
			espCustNewService.update(espCustNewModel);
		}
	}
    @Transactional(rollbackFor = { Exception.class })
    public void orderChangeWithTX(OrderSubModel tblOrder, ItemModel itemModel, OrderDoDetailModel orderDetail,
                                  TblOrderExtend1Model tblOrderExtend1, OrderCheckModel orderCheck,
                                  TblOrderHistoryModel orderHistory)  throws Exception {
        log.info("into orderChangewithTX");
        if(orderCheck!=null){
            orderCheck.setDelFlag(0);
            orderCancelManager.saveTblOrderCheck(orderCheck);
        }
        if(orderHistory!=null){
            orderHistoryDao.update(orderHistory);
        }
        if(tblOrder != null){
            //荷兰式判断进行回滚
            if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(tblOrder.getActType())){
                AuctionRecordModel auctionRecordModel = new AuctionRecordModel();
                auctionRecordModel.setId(Long.valueOf(tblOrder.getCustCartId()));
                auctionRecordModel.setIsBacklock("0");
                auctionRecordModel.setReleaseTime(new Date());
                auctionRecordDao.updateByIdAndBackLock(auctionRecordModel);

            }
        }
        if(orderHistory != null){
            //荷兰式判断进行回滚
            if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderHistory.getActType())){
                AuctionRecordModel auctionRecordModel = new AuctionRecordModel();
                auctionRecordModel.setId(Long.valueOf(orderHistory.getCustCartId()));
                auctionRecordModel.setIsBacklock("0");
                auctionRecordModel.setReleaseTime(new Date());
                auctionRecordDao.updateByIdAndBackLock(auctionRecordModel);
            }
        }
        if(null!=tblOrder && null!=orderDetail && null!=tblOrderExtend1){
            orderDoDetailDao.insert(orderDetail);
            orderSubDao.updateStatues(tblOrder);  // 更新订单状态
            tblOrderExtend1Dao.update(tblOrderExtend1);
            //更新库存 （按新业务更新：普通商品回滚库存，活动商品只有荷兰拍回滚）
            Response<Boolean> response = itemService.updateStock(tblOrder.getActId(), tblOrder.getActType(), tblOrder.getPeriodId(),
                    tblOrder.getGoodsId(), tblOrder.getGoodsNum(), tblOrder.getCreateOper(),
                    tblOrder.getBonusTotalvalue(),itemModel);
            if (!response.isSuccess()){
                throw new RuntimeException("更新库存失败");
            }
        }

    }

    @Transactional(rollbackFor = { Exception.class })
    public void orderChangeSuccessWithTX(OrderSubModel tblOrder, OrderDoDetailModel orderDetail, Map<String, String> runTime,
                                         TblOrderExtend1Model tblOrderExtend1, OrderCheckModel orderCheck,
                                         TblOrderHistoryModel orderHistory)  throws Exception {
        log.info("into orderChangeSuccessWithTX");
        if(tblOrder != null){//防止空指针异常
            orderSubDao.updateStatues(tblOrder);  // 更新订单状态
        }

        if(orderCheck!=null){
            orderCheck.setDelFlag(0);
            orderCancelManager.saveTblOrderCheck(orderCheck);
        }
        orderDodetaiManger.insert(orderDetail);
        log.info("runTime:"+runTime);
        if(runTime != null && runTime.size() > 0){	// 如果有补跑时间，更新不跑表，没有则不更新
            log.info("runTime.size:"+runTime.size());
            // 更新batch表
            orderCancelManager.updateBatchStatus(runTime);
        }
        tblOrderExtend1Dao.update(tblOrderExtend1);
        if(orderHistory!=null){
            orderHistoryDao.update(orderHistory);
        }
    }


}
