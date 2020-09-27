package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.ClearOrderOutSysDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.ClearOrderOutSysManager;
import cn.com.cgbchina.batch.model.TblOrderOutSystemModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 定时清理推送表 JOB
 * Created by 11150121050003 on 2016/9/3.
 */
@Service
@Slf4j
public class ClearOrderOutSysServiceImpl implements ClearOrderOutSysService {
    @Resource
    private ClearOrderOutSysManager clearOrderOutSysManager;
    @Resource
    private ClearOrderOutSysDao clearOrderOutSysDao;
    @Override
    public Response<Boolean> clearWithTxn() {
        Response<Boolean> response = new Response<>();
        try{
            log.info("定时清理推送表开始......");
            List<TblOrderOutSystemModel> outsysOrder = clearOrderOutSysDao.findOrderOutSysList();
            clearOrderOutSysManager.clearWithTxn(outsysOrder);
            log.info("定时清理推送表结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("定时清理推送表失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }
}
