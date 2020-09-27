package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.item.service.PromotionService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.exception.TradeException;
import cn.com.cgbchina.trade.model.*;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by 11141021050225 on 2016/9/23.
 */
@Component
@Transactional
@Slf4j
public class OrderCheckManager {
    @Resource
    private OrderMainDao orderMainDao;
    @Resource
    private OrderOutSystemDao orderOutSystemDao;
    @Resource
    private TblOrderCheckDao tblOrderCheckDao;
    @Resource
    private TblOrderHistoryDao tblOrderHistoryDao;
    @Resource
    private TblOrderExtend1Dao tblOrderExtend1Dao;
    @Resource
    private TblEspCustCartDao tblEspCustCartDao;
    @Resource
    private OrderCancelDao orderCancelDao;
    @Resource
    private OrderDoDetailDao orderDoDetailDao;
    @Resource
    private OrderSubDao orderSubDao;
    @Resource
    private ItemService itemService;
    @Resource
    private PromotionService promotionService;
    @Resource
    private PointsPoolService pointsPoolService;

    public Integer update(OrderMainModel orderMainModel){
        return orderMainDao.update(orderMainModel);
    }
    public void updateWXOrderSourcewithTX(OrderSubModel orderSubModel, OrderMainModel orderMainModel) {
        int ret = orderMainDao.update(orderMainModel);
        if (ret <= 0) {
            throw new RuntimeException("Ordermain update error");
        }
        ret = orderSubDao.update(orderSubModel);
        if (ret <= 0) {
            throw new RuntimeException("Ordersub update error");
        }
    }

    public Integer insert(OrderOutSystemModel orderOutSystem){
        return orderOutSystemDao.insert(orderOutSystem);
    }

    public void saveTblOrderCheck(OrderCheckModel orderCheck){
        tblOrderCheckDao.saveTblOrderCheck(orderCheck);
    }

    public Integer insert(OrderCheckModel orderCheck){
        return tblOrderCheckDao.insert(orderCheck);
    }

    public Integer update(TblOrderHistoryModel orderHistory){
        return tblOrderHistoryDao.update(orderHistory);
    }

    public Integer insert(TblOrderExtend1Model tblOrderExtend1){
        return tblOrderExtend1Dao.insert(tblOrderExtend1);
    }

    public Integer updateByOrderId(TblOrderExtend1Model tblOrderExtend1Model){
        return tblOrderExtend1Dao.updateByOrderId(tblOrderExtend1Model);
    }

    public Integer update(TblEspCustCartModel tblEspCustCartModel){
        return tblEspCustCartDao.update(tblEspCustCartModel);
    }

    public Integer insert(OrderCancelModel model){
        return orderCancelDao.insert(model);
    }

    public Integer insert(OrderDoDetailModel orderDoDetailModel){
        return orderDoDetailDao.insert(orderDoDetailModel);
    }

    public Integer updateTuiSongMsg(OrderOutSystemModel orderOutSystem){
        return orderOutSystemDao.updateTuiSongMsg(orderOutSystem);
    }

    public Integer updateByFlag(Map<String,Object> dataMap){
        return orderOutSystemDao.updateByFlag(dataMap);
    }

    /**
     * 处理支付信息
     * @param orderSubModelList
     * @param rollBackStockMap
     * @param orderCheckModelList
     * @param orderCheckModelList2
     * @param orderExtend1ModelsI
     * @param orderExtend1ModelsU
     * @param tblEspCustCartModels
     * @param orderMainModel
     * @param orderDoDetailModelList
     * @throws Exception
     */
    @Transactional(rollbackFor = {Exception.class})
    public void dealOrderwithTX(List<OrderSubModel> orderSubModelList,
                                  Map<String, Integer> rollBackStockMap,
                                  Map<String, Long> pointMap,
                                  List<OrderCheckModel> orderCheckModelList,
                                  List<OrderCheckModel> orderCheckModelList2,
                                  List<TblOrderExtend1Model> orderExtend1ModelsI,
                                  List<TblOrderExtend1Model> orderExtend1ModelsU,
                                  List<TblEspCustCartModel> tblEspCustCartModels,
                                  OrderMainModel orderMainModel,
                                  List<OrderDoDetailModel> orderDoDetailModelList) throws Exception {
        //积分正交易
        log.info("保存积分正交易");
        if (orderCheckModelList != null && !orderCheckModelList.isEmpty()) {
            tblOrderCheckDao.insertBatch(orderCheckModelList);
        }

        //优惠券
        log.info("保存积分优惠券");
        if (orderCheckModelList2 != null && !orderCheckModelList2.isEmpty()) {
            tblOrderCheckDao.insertBatch(orderCheckModelList2);
        }

        //插入扩展表
        log.info("插入扩展表");
        if (orderExtend1ModelsI != null && !orderExtend1ModelsI.isEmpty()) {
            tblOrderExtend1Dao.insertBatch(orderExtend1ModelsI);
        }
        //更新扩展表
        log.info("更新扩展表");
        if (orderExtend1ModelsU != null) {
            for (TblOrderExtend1Model tblOrderExtend1Model : orderExtend1ModelsU) {
                tblOrderExtend1Dao.update(tblOrderExtend1Model);
            }
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
            if ("0308".equals(orderSubModel.getCurStatusId())) {
                updateSaleCount(orderSubModel);
            }
        }

        //订单处理明细
        log.info("保存订单处理明细");
        if (orderDoDetailModelList != null && orderDoDetailModelList.size() != 0) {
            orderDoDetailDao.insertBatch(orderDoDetailModelList);
        }

        // 清理购物车
        log.info("清理购物车");
        if (tblEspCustCartModels != null) {
            for (TblEspCustCartModel tblEspCustCartModel : tblEspCustCartModels) {
                tblEspCustCartDao.update(tblEspCustCartModel);
            }
        }

        Response<Boolean> result;
        log.info("回滚商品库存");
        if (rollBackStockMap != null && rollBackStockMap.size() > 0) {
            User user = new User();
            user.setId(orderSubModelList.get(0).getCreateOper());
            result = itemService.updateBatchStock(rollBackStockMap, user);
            if (!result.isSuccess()) {
                throw new TradeException("回滚商品库存失败");
            }
        }
        //回滚积分池
        log.info("回滚积分池");
        for (String ymd : pointMap.keySet()) {
            Map<String, Object> paramMap = Maps.newHashMap();
            paramMap.put("used_point", pointMap.get(ymd));
            paramMap.put("cur_month", ymd);
            result = pointsPoolService.dealPointPool(paramMap);
            if (!result.isSuccess()) {
                throw new TradeException("回滚积分池失败");
            }
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

    public void orderReturnwithTX(OrderSubModel tblOrder, OrderDoDetailModel orderDodetail,OrderCheckModel orderCheck,TblOrderHistoryModel orderHistory){
        if(tblOrder!=null){
            orderSubDao.update(tblOrder);
        }
        if(orderDodetail!=null && orderDodetail.getOrderId() != null){
            orderDoDetailDao.insert(orderDodetail);
        }
        if(orderCheck!=null){
            tblOrderCheckDao.insert(orderCheck);
        }
        if(orderHistory!=null){
            tblOrderHistoryDao.update(orderHistory);
        }
    }
}
