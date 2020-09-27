package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.trade.vo.SystemEnvelopeVo;
import com.spirit.common.model.Response;

/**
 * Created by sf on 16-7-18.
 */
public interface OrderSendForO2OService {

    public Response orderSendForO2O(String orderMainId, String orderId);

    public Response orderBatchSendForO2O(SystemEnvelopeVo systemEnvolopeVo);

    public Response<BaseResult> sendO2OOrderProcess(SystemEnvelopeVo systemEnvolopeVo);

}
