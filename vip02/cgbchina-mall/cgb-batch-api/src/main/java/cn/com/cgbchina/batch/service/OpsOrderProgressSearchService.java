package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.OrderSubModel;
import com.spirit.common.model.Response;

/**
 * Created by dhc on 2016/7/19.
 */
public interface OpsOrderProgressSearchService {
    /**
     * 发送OPS订单至BPS
     * @return
     */
    Response<Boolean> sendOPSOrderToBPS();
}
