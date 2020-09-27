/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.RequestOrderDto;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * 手动推送订单
 * @author 11150721040343
 * @version 1.0
 * @Since 2016/7/27
 */
public interface OrderPushService {

    /**
     * 查询所有需要手动推送的订单
     * @param user
     * @param pageNo
     * @param size
     * @param orderId
     * @param startTime
     * @param endTime
     * @param orderType
     * @return
     */
     Response<Pager<RequestOrderDto>> find(@Param("pageNo") Integer pageNo,
                                                 @Param("size") Integer size, @Param("orderId") String orderId, @Param("startTime") String startTime,
                                                 @Param("endTime") String endTime,@Param("orderType") String orderType,@Param("_USER_") User user);

    /**
     * 手动推送订单
     * @param orderId
     * @param vendorName
     * @return
     */
    Response<Boolean> pushOrder(String orderId,String vendorName,String vendorId);
}
