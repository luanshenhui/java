package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

/**
 * 积分对账文件-集中调度平台
 *
 */
public interface MakeCheckAccService {
    /**
     * 生成积分对账文件
     */
    Response<Boolean> makeCheckAccWithTxn();
    /**
     * 生成优惠券对账文件
     */
    Response<String> makePrivilegeFileWithTxn();
}
