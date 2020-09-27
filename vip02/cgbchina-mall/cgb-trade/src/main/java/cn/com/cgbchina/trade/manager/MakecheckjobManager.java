package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.model.TblCfgSysparamModel;
import cn.com.cgbchina.trade.model.TblMakecheckjobHistoryModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 11141021050225 on 2016/9/23.
 */
@Component
@Transactional
public class MakecheckjobManager {
    @Resource
    TblMakecheckjobHistoryDao tblMakecheckjobHistoryDao;
    @Resource
    OrderMainDao orderMainDao;
    @Resource
    TblOrderCancelDao tblOrderCancelDao;
    @Resource
    OrderCheckDao orderCheckDao;
    @Resource
    TblCfgSysparamDao tblCfgSysparamDao;

    public Integer insert(TblMakecheckjobHistoryModel tblMakecheckjobHistory){
        return tblMakecheckjobHistoryDao.insert(tblMakecheckjobHistory);
    }

    public Integer updateCheckStatus(String create_date){
        return orderMainDao.updateCheckStatus(create_date);
    }
    public Integer updateTblOrderCancel(String create_date){
        return tblOrderCancelDao.updateTblOrderCancel(create_date);
    }
    public Integer updatePoint(Map<String, Object> params){
        return orderCheckDao.updatePoint(params);
    }

    public Integer updatePoint1(Map<String, Object> params){
        return orderCheckDao.updatePoint1(params);
    }

    public Integer update(TblCfgSysparamModel tblCfgSysparamModel){
        return tblCfgSysparamDao.update(tblCfgSysparamModel);
    }

}
