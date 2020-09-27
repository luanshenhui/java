package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.spirit.common.model.Response;
import com.spirit.event.Listener;

/**
 * Created by sf on 16-7-18.
 */
public interface DealO2OOrderService {
    @Listener(hint = "dealO2OOrdersAfterPaySucc1")
    public Response<BaseResult> dealO2OOrdersAfterPaySucc(String orderId);
    @Listener(hint = "dealO2OOrdersAfterPaySucc2")
    public Response<BaseResult> dealO2OOrdersAfterPaySucc(String orderId,String orderMainId,String vendorId);
    @Listener(hint = "dealO2OOrdersAfterPaySucc3")
    public Response<BaseResult> dealO2OOrdersAfterPaySucc(String orderMainId,OrderSubModel orderSubModel);

}
