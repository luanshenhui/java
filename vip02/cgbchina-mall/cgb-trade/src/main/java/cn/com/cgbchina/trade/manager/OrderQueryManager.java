package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.model.*;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 11141021050225 on 2016/9/23.
 */
@Component
@Transactional
public class OrderQueryManager {
    @Resource
    private OrderSubDao orderSubDao;
    @Resource
    private OrderMainDao orderMainDao;
    @Resource
    private OrderDoDetailDao orderDoDetailDao;
    @Resource
    private TblOrderMainHisDao tblOrderMainHisDao;
    @Resource
    private TblOrderExtend1Dao tblOrderExtend1Dao;
    @Resource
    private OrderCheckDao orderCheckDao;
    @Resource
    private TblBatchStatusDao tblBatchStatusDao;
    @Resource
    private AuctionRecordDao auctionRecordDao;

    public Integer updateOrderSerialNo(Map<String,Object> params){
        return orderSubDao.updateOrderSerialNo(params);
    }

    public Integer updateOrder(OrderSubModel orderSubModel){
        return orderSubDao.updateOrder(orderSubModel);
    }

    public Integer updateOrderMainAddr(OrderMainModel orderMainModel){
        return orderMainDao.updateOrderMainAddr(orderMainModel);
    }

    public Integer insert(OrderDoDetailModel orderDoDetailModel){
        return orderDoDetailDao.insert(orderDoDetailModel);
    }

    public Integer insert(TblOrderMainHisModel tblOrderMainHis){
        return tblOrderMainHisDao.insert(tblOrderMainHis);
    }

    public Integer updateByOrderId(TblOrderExtend1Model tblOrderExtend1){
        return tblOrderExtend1Dao.updateByOrderId(tblOrderExtend1);
    }
    public Integer insert(OrderCheckModel orderCheck){
        return orderCheckDao.insert(orderCheck);
    }
    public Integer updateBatchStatus(Map<String,String> runTime){
        return tblBatchStatusDao.updateBatchStatus(runTime);
    }
    public Integer update(AuctionRecordModel auctionRecord){
        return auctionRecordDao.update(auctionRecord);
    }
}
