package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.exception.BatchException;
import com.spirit.common.model.Response;

/**
 * Created by txy on 2016/7/21.
 */
public interface SynBonusService {
    /**
     * 积分类型同步
     */
    Response<Boolean> synBonusTypeByBPMSWithTxn();
}
