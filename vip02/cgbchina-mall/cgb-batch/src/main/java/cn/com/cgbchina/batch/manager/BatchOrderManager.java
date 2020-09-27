package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.BatchOrderDao;
import cn.com.cgbchina.batch.model.ItemModel;
import cn.com.cgbchina.batch.model.OrderCheckModel;
import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by dhc on 2016/7/15.
 */
@Component
@Slf4j
@Transactional
public class BatchOrderManager {
    @Resource
    private BatchOrderDao batchOrderDao;
    @Transactional
    public void updateOrderStatus(Map<String, Object> paramMap) {
        batchOrderDao.updateOrderStatus(paramMap);
    }
    @Transactional
    public void saveTblOrderCheck(OrderCheckModel orderCheck) {
        batchOrderDao.saveTblOrderCheck(orderCheck);
    }
    @Transactional
    public void updateGoodsJF(ItemModel goodsModel) {
        batchOrderDao.updateGoodsJF(goodsModel);
    }
    @Transactional
    public void updateGoodsYG(ItemModel goodsModel) {
        batchOrderDao.updateGoodsYG(goodsModel);
    }
    @Transactional
    public void dealPointPoolForDate(Map<String, Object> paramJF) {
        batchOrderDao.dealPointPoolForDate(paramJF);
    }
    @Transactional
    public void updateOrderMainStatus(Map<String, Object> paramMap) {
        batchOrderDao.updateOrderMainStatus(paramMap);
    }
    @Transactional
    public void updateTblEspCustNew(Map<String, Object> paramMap) {
        batchOrderDao.updateTblEspCustNew(paramMap);
    }
    @Transactional
    public void updateTblEspCustNew0(Map<String, Object> paramMap) {
        batchOrderDao.updateTblEspCustNew0(paramMap);
    }
    @Transactional
    public void insertOrderDoDetail(OrderDoDetailModel orderDoDetailModel) {
        batchOrderDao.insertOrderDoDetail(orderDoDetailModel);
    }
}
