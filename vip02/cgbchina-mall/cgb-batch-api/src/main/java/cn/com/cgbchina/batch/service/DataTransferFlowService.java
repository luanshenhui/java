package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

import java.util.List;

/**
 * Created by 11150121050003 on 2016/9/5.
 */
public interface DataTransferFlowService {
    /**
     * 根据recordId处理后续流程的迁移
     * @param recordId
     * @return
     */
    Response<Boolean> dealTableById(String recordId);

    /**
     * 根据recordId处理后续流程的迁移
     * @return
     */
    Response<Boolean> dealTableById();

    /**
     * 根据表名处理一个表的迁移
     * @param tableName
     * @return
     */
    Response<Boolean> dealOneTableByName(String tableName);

    /**
     * 处理所有表迁移
     * @return
     */
    Response<Boolean> dealAllTable();
}
