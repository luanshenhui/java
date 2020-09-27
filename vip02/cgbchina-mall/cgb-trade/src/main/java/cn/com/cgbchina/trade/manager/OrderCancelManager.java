package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.OrderDoDetailDao;
import cn.com.cgbchina.trade.dao.TblBatchStatusDao;
import cn.com.cgbchina.trade.dao.TblOrderCheckDao;
import cn.com.cgbchina.trade.dao.TblOrderDao2;
import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 11141021050225 on 2016/9/23.
 */
@Component
@Transactional
public class OrderCancelManager {
    @Resource
    private TblOrderDao2 tblOrderDao2;
    @Resource
    private TblOrderCheckDao tblOrderCheckDao;
    @Resource
    private OrderDoDetailDao orderDoDetailDao;
    @Resource
    private TblBatchStatusDao tblBatchStatusDao;

    public void updateOrderStatus(Map<String, Object> paramMap){
        tblOrderDao2.updateOrderStatus(paramMap);
    }

    public void updateOrderMainStatus(Map<String, Object> paramMap){
        tblOrderDao2.updateOrderMainStatus(paramMap);
    }

    public void updateTblEspCustNew(Map<String, Object> paramMap){
        tblOrderDao2.updateTblEspCustNew(paramMap);
    }

    public void updateTblEspCustNew0(Map<String, Object> paramMap){
        tblOrderDao2.updateTblEspCustNew0(paramMap);
    }
    
    public void saveTblOrderCheck(Map<String, Object> paramMap){
        tblOrderCheckDao.saveTblOrderCheck(paramMap);
    }

    public void saveTblOrderCheck(OrderCheckModel orderCheckModel){
        tblOrderCheckDao.saveTblOrderCheck(orderCheckModel);
    }

    public Integer insert(OrderDoDetailModel orderDoDetailModel){
        return orderDoDetailDao.insert(orderDoDetailModel);
    }

    public Integer updateBatchStatus(Map<String,String> runTime){
        return tblBatchStatusDao.updateBatchStatus(runTime);
    }
}
