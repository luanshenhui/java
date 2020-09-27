package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.ClearOrderOutSysDao;
import cn.com.cgbchina.batch.model.TblOrderBkupOutSystemModel;
import cn.com.cgbchina.batch.model.TblOrderOutSystemModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by 11150121050003 on 2016/9/3.
 */
@Component
@Slf4j
public class ClearOrderOutSysManager {
    @Resource
    private ClearOrderOutSysDao clearOrderOutSysDao;

    @Transactional
    public void clearWithTxn(List<TblOrderOutSystemModel> outsysOrder) {
        log.info("into ClearOrderOutSysServiceImpl");
        if (outsysOrder != null && outsysOrder.size() > 0) {
            // 循环取出推送状态为1的记录
            for (TblOrderOutSystemModel tblOrderOutSystemModel : outsysOrder) {
                // 将查处的记录存入订单推送备份表model
                TblOrderBkupOutSystemModel newModel = new TblOrderBkupOutSystemModel();
                newModel.setOrderMainId(tblOrderOutSystemModel.getOrderMainId());
                newModel.setOrderId(tblOrderOutSystemModel.getOrderId());
                newModel.setTimes(tblOrderOutSystemModel.getTimes());
                newModel.setTuisongFlag(tblOrderOutSystemModel.getTuisongFlag());
                newModel.setSystemRole(tblOrderOutSystemModel.getSystemRole());
                newModel.setCreateOper(tblOrderOutSystemModel.getCreateOper());
                newModel.setCreateTime(tblOrderOutSystemModel.getCreateTime());
                newModel.setModifyOper(tblOrderOutSystemModel.getModifyOper());
                newModel.setModifyTime(tblOrderOutSystemModel.getModifyTime());
                //插入备份表
                clearOrderOutSysDao.insertOrderBkupOutSystem(newModel);
//                log.info("backup success：" + tblOrderOutSystemModel.getOrderId());
                //删除推送表
                clearOrderOutSysDao.deleteOrderOutSystem(tblOrderOutSystemModel);
//                log.info("delete success：" + tblOrderOutSystemModel.getOrderId());
            }
        }
    }
}
