package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.BatchOrderModel;
import com.spirit.common.model.Response;

/**
 * Created by dhc on 2016/7/18.
 */
public interface BatchOrderService {

    /**
     * 废单批处理
     * @throws BatchException
     */
    Response<Boolean> overdueOrderProc();

}
