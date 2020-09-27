package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.MakePrivilegeFileDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.MakeCheckAccManager;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by w2001316 on 2016/7/27.
 */
@Service
@Slf4j
public class MakeCheckAccServiceImpl implements MakeCheckAccService {

    @Autowired
    private MakeCheckAccManager makeCheckAccManager;
    @Resource
    private MakePrivilegeFileDao makePrivilegeFileDao;
    /**
     * 生成积分对账文件
     */
    @Override
    public Response<Boolean> makeCheckAccWithTxn() {
        Response<Boolean> response = new Response<>();
        try {
            log.info("生成积分对账文件批处理开始......");
            makeCheckAccManager.makeCheckAccWithTxn();
            log.info("生成积分对账文件批处理结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("生成积分对账文件批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    /**
     * 生成优惠券对账文件
     */
    @Override
    public Response<String> makePrivilegeFileWithTxn() {
        Response<String> response = new Response<>();
        try {
            log.info("生成优惠券对账文件批处理开始......");
            Integer cnt = makePrivilegeFileDao.getTblMkFileInfocount(DateHelper.getyyyyMMdd());
            if(cnt == null || cnt == 0) {
                makeCheckAccManager.makePrivilegeFileWithTxn();
                log.info("生成优惠券对账文件批处理结束......");
                response.setResult("0");
                return response;
            } else {
                log.info("【集中调度】优惠券对账文件任务已经跑过，不能重复跑");
                response.setResult("0");
                return response;
            }
        } catch (BatchException e) {
            log.error("生成优惠券对账文件批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

}
