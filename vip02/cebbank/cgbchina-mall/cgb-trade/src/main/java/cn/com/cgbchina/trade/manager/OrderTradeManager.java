package cn.com.cgbchina.trade.manager;

import java.util.Map;

import com.google.common.collect.Maps;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.item.service.*;

import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
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
    OrderPartBackDao orderPartBackDao;
    @Resource
    TblOrderCheckDao tblOrderCheckDao;
    @Resource
    OrderReturnTrackDao orderReturnTrackDao;
    @Resource
    OrderTransDao orderTransDao;
    @Resource
    PointsPoolService pointsPoolService;
    @Resource
    GoodsService goodsService;

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
    public void processMailOrder(List<OrderSubModel> orderSubModelList, List<String> goodsIdList, List<OrderSubModel> dealPointPoolList, List<OrderCheckModel> orderCheckModelList, OrderMainModel orderMainModel, List<OrderDoDetailModel> orderDoDetailModelList) throws Exception {
        //更新子订单
        log.info("更新子订单");
        for (int i = 0; i < orderSubModelList.size(); i++) {
            OrderSubModel orderSubModel = orderSubModelList.get(i);
            orderSubDao.update(orderSubModel);
        }

        //回滚商品库存
//        for (int i = 0; i < goodsIdList.size(); i++) {
//            String goodsId =goodsIdList.get(i);
//            goodsService.updateStock(goodsId);
//        }

        //回滚积分池
//        for (int i = 0; i < dealPointPoolList.size(); i++) {
//            OrderSubModel orderSubModel = dealPointPoolList.get(i);
//            Map<String, Object> paramMap = Maps.newHashMap();
//            paramMap.put("used_point", orderSubModel.getBonusTotalvalue());
//            if (null != orderSubModel.getCreateTime()) {
//                paramMap.put("cur_month", DateHelper.getyyyyMM(orderSubModel.getCreateTime()).substring(0, 6));
//            } else {
//                paramMap.put("cur_month", "");
//            }
//            Response<Boolean> result = pointsPoolService.dealPointPool(paramMap);
//        }

        //优惠券对账文件
        log.info("保存优惠券对账文件");
        if (orderCheckModelList.size()!=0) {
            tblOrderCheckDao.insertBatch(orderCheckModelList);
        }

        //更新主订单
        log.info("更新主订单");
        orderMainDao.update(orderMainModel);

        //订单处理明细
        log.info("保存订单处理明细");
        if(orderDoDetailModelList.size()!=0) {
            orderDoDetailDao.insertBatch(orderDoDetailModelList);
        }
    }

    /**
     * 分期
     *
     * @param orderCheckList2
     * @param orderCheckList
     * @param goodsIdList
     * @param dealPointPoolList
     * @param tblOrderExtend1ModelIns
     * @param tblOrderExtend1Modelupd
     * @param orderMainModel
     * @param orderSubModelList
     * @return
     */
    @Transactional(rollbackFor = {Exception.class})
    public void processInstallment(List<OrderCheckModel> orderCheckList2, List<OrderCheckModel> orderCheckList, List<String> goodsIdList, List<OrderSubModel> dealPointPoolList, List<TblOrderExtend1Model> tblOrderExtend1ModelIns,
                                      List<TblOrderExtend1Model> tblOrderExtend1Modelupd, OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList, List<OrderDoDetailModel> orderDoDetailModelList) throws Exception {

        //积分正交易
        log.info("保存积分正交易");
        if (orderCheckList2.size()!=0) {
            tblOrderCheckDao.insertBatch(orderCheckList2);
        }

        //优惠券
        log.info("保存优惠券");
        if(orderCheckList.size()!=0) {
            tblOrderCheckDao.insertBatch(orderCheckList);
        }

        //回滚商品库存
//        for (int i = 0; i < goodsIdList.size(); i++) {
//            String goodsId =goodsIdList.get(i);
//            goodsService.updateStock(goodsId);
//        }

        //回滚积分池
//        for (int i = 0; i < dealPointPoolList.size(); i++) {
//            OrderSubModel orderSubModel = dealPointPoolList.get(i);
//            Map<String, Object> paramMap = Maps.newHashMap();
//            paramMap.put("used_point", orderSubModel.getBonusTotalvalue());
//            if (null != orderSubModel.getCreateTime()) {
//                paramMap.put("cur_month", DateHelper.getyyyyMM(orderSubModel.getCreateTime()).substring(0, 6));
//            } else {
//                paramMap.put("cur_month", "");
//            }
//            Response<Boolean> result = pointsPoolService.dealPointPool(paramMap);
//        }


        //插入扩展表
        log.info("插入扩展表");
        if(tblOrderExtend1ModelIns.size()!=0) {
            tblOrderExtend1Dao.insertBatch(tblOrderExtend1ModelIns);
        }

        //更新扩展表
        log.info("更新扩展表");
        for (int i = 0; i < tblOrderExtend1Modelupd.size(); i++) {
            TblOrderExtend1Model tblOrderExtend1Model = tblOrderExtend1Modelupd.get(i);
            tblOrderExtend1Dao.update(tblOrderExtend1Model);
        }

        //更新主订单
        log.info("更新主订单");
        orderMainDao.update(orderMainModel);

        //更新子订单
        log.info("更新子订单");
        for (int i = 0; i < orderSubModelList.size(); i++) {
            OrderSubModel orderSubModel = orderSubModelList.get(i);
            orderSubDao.update(orderSubModel);
        }

        //订单处理明细
        log.info("保存订单处理明细");
        if(orderSubModelList.size()!=0) {
            orderDoDetailDao.insertBatch(orderDoDetailModelList);
        }
    }

    /**
     * 积分
     *
     * @param orderSubModel
     * @param orderSubModelList
     * @return
     */
    @Transactional(rollbackFor = {Exception.class})
    public void processPoints( OrderSubModel orderSubModel, List<OrderSubModel> orderSubModelList) throws Exception {

    }

}
