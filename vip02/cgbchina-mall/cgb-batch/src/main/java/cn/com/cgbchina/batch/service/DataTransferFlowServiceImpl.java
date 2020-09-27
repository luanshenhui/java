package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.DataTransferFlowManager;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by 11150121050003 on 2016/9/5.
 */
@Service
@Slf4j
public class DataTransferFlowServiceImpl implements DataTransferFlowService {
    @Resource
    private DataTransferFlowManager dataTransferFlowManager;

    /**
     * 根据recordId处理后续流程的迁移
     *
     * @param recordId
     * @return
     */
    @Override
    public Response<Boolean> dealTableById(String recordId) {
        Response<Boolean> response = new Response<>();
        try{
            log.info("数据迁移批处理开始......");
            dataTransferFlowManager.dealTableById(recordId,false);
            log.info("数据迁移批处理结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("数据迁移批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    @Override
    public Response<Boolean> dealTableById() {
        return dealTableById(null);
    }

    /**
     * 根据表名处理一个表的迁移
     * @param tableName
     * @return
     */
    @Override
    @Deprecated
    public Response<Boolean> dealOneTableByName(String tableName) {
        Response<Boolean> response = new Response<>();
        try{
            log.info("数据迁移批处理开始......");
            dataTransferFlowManager.dealOneTableByName(tableName);
            log.info("数据迁移批处理结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("数据迁移批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    /**
     * 处理所有表迁移
     * @return
     */
    @Override
    public Response<Boolean> dealAllTable() {
        Response<Boolean> response = new Response<>();
        try{
            log.info("处理表迁移的任务开始......");
            dataTransferFlowManager.dealTableById(null,true);
            log.info("处理表迁移的任务结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("处理表迁移的任务失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

}
