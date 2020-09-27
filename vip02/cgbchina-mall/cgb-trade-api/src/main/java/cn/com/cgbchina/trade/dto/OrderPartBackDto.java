/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderReturnTrackDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-7-13.
 */
public class OrderPartBackDto implements Serializable{
    private static final long serialVersionUID = -4037931394043339420L;
    @Getter
    @Setter
    private OrderSubModel orderSubModel;
    @Getter
    @Setter
    private OrderReturnTrackDetailModel orderReturnTrackDetailModel;
    @Getter
    @Setter
    private TblOrderExtend1Model tblOrderExtend1Model;
    @Getter
    @Setter
    private OrderMainModel orderMainModel;
    @Getter
    @Setter
    private List<OrderItemAttributeDto> orderItemAttributeDtos; // 销售属性
    @Setter
    @Getter
    private String mid;//单品Id
    @Getter
    @Setter
    private String xid;//礼品Id
}
