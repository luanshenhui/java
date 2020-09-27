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

    @Getter
    @Setter
    private Long partBackId; // 退货详情id

    @Getter
    @Setter
    private Boolean voucherFlag; // 设置使用积分标识

    @Getter
    @Setter
    private Boolean bonusTotalFlag; // 设置是否使用优惠券标识

    @Getter
    @Setter
    private Boolean orderTransFlag; // 设置查看物流权限标示

    // 设置使用积分标识 true——使用
    public void makeBonusTotalFlag() {
        if (!(orderSubModel == null)) {
            if (null == orderSubModel.getVoucherPrice()
                    || BigDecimal.valueOf(0.).setScale(2).equals(orderSubModel.getVoucherPrice())) {
                this.setVoucherFlag(Boolean.FALSE);
            } else {
                this.setVoucherFlag(Boolean.TRUE);
            }
        }
    }

    // 设置是否使用优惠券标示 true——使用
    public void makeVoucherFlag() {
        if (!(orderSubModel == null)) {
            if (null == orderSubModel.getBonusTotalvalue() || orderSubModel.getBonusTotalvalue().longValue() == 0) {
                this.setBonusTotalFlag(Boolean.FALSE);
            } else {
                this.setBonusTotalFlag(Boolean.TRUE);
            }
        }
    }
}
