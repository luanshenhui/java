package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

/**
 * Created by Xiehongri on 2016/7/11.
 */
public interface OrderStatusQueryService {

    /**
     * 企业网银状态回查-商城
     */
    Response<Boolean> orderStatusQuery();
}
