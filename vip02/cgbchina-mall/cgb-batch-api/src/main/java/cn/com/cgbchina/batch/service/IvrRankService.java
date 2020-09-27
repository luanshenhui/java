package cn.com.cgbchina.batch.service;


import com.spirit.common.model.Response;

/**
 * Created by txy on 2016/7/22.
 */
public interface IvrRankService {
    /**
     * IVR排行
     * @return
     */
    Response<Boolean> rankListWithTxn();
}
