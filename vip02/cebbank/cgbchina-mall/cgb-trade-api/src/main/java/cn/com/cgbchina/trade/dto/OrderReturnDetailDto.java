/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderReturnTrackDetailModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * 查询退货详情
 * @author yanjie.cao
 * @version 1.0
 * @Since 2016/7/6.
 */
public class OrderReturnDetailDto implements Serializable {
    private static final long serialVersionUID = 6581654183936728496L;

    @Getter
    @Setter
    private List<OrderReturnTrackDetailModel> orderRrturnTrackDetailModels;

    @Getter
    @Setter
    private String status;
}

