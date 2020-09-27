/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderMainModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * @author yanjie.cao
 * @version 1.0
 * @Since 2016/7/4.
 */
public class OrderMallManageDto implements Serializable {
    private static final long serialVersionUID = 9051259575377245L;

    @Getter
    @Setter
    private List<OrderInfoDto> orderInfoDtos;

    @Getter
    @Setter
    private OrderMainModel orderMainModel;

}

