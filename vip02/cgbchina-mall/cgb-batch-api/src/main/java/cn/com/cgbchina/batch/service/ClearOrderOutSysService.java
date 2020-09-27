package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

/**
 * Created by 11150121050003 on 2016/9/3.
 */
public interface ClearOrderOutSysService {
    Response<Boolean> clearWithTxn();
}
