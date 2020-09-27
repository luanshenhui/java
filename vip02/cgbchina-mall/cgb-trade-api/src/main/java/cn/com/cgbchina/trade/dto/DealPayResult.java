package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderMainModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Comment:
 * Created by 11150321050126 on 2016/9/16.
 */
@Setter
@Getter
public class DealPayResult implements Serializable {
    private static final long serialVersionUID = -3749905282656214531L;
    private String goodsType;
    private String goodsName;
    private OrderDealDto orderDealDto;

    private List<OrderPealPayInfoDto> payOrderIfDtos;
    private OrderMainModel orderMainModel;
}
