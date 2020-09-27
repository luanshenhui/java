package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.CartItem;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by 张成 on 16-4-28.
 */
public class CartResultDto implements Serializable {

    private static final long serialVersionUID = 9139812121280701315L;
    @Getter
    @Setter
    private List<CartItem> installmentsList = new ArrayList<CartItem>(); // 多期信用卡付款

    @Getter
    @Setter
    private List<CartItem> immediatePaymentList =  new ArrayList<CartItem>(); // 立即付款

    @Getter
    @Setter
    private Long surplusPoint;    //积分池剩余

    @Getter
    @Setter
    private String commonAmount;    //用户普通积分

    @Getter
    @Setter
    private String hopeAmount;//用户希望积分

    @Getter
    @Setter
    private String truthAmount;//用户真情积分

}
