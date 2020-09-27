package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderSubModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * for MAL113 CC订单查询(分期商城)
 * Created by 11150121050003 on 2016/8/29.
 */
public class OrderCCInfoDto extends OrderSubModel implements Serializable {

    private static final long serialVersionUID = -3303251586073440812L;
    @Getter
    @Setter
    private Integer stagesCode;//分期方式代码
    @Getter
    @Setter
    private BigDecimal goodsPrice;//现金
    @Getter
    @Setter
    private String orderNbr;//银行订单号
}
