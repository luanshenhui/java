/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 *
 * @author 11150721040343
 * @version 1.0
 * @Since 2016/6/22
 */
public class RequestOrderDto implements Serializable {

    private static final long serialVersionUID = -831897150174950127L;
    //商品子订单
    @Setter
    @Getter
    private OrderSubModel orderSubModel;

    //商品主订单
    @Getter
    @Setter
    private OrderMainModel orderMainModel;
}
