package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by lvzd on 2016/9/16.
 */
@Setter
@Getter
public class OrderSubDetailDto implements Serializable {
    private static final long serialVersionUID = -54520433264642729L;
    private List<OrderSubModel> orderSubModelList;
    private List<OrderDoDetailModel> orderDoDetailModelList;
    private List<OrderVirtualModel> orderVirtualModelList;

    public void addOrderSubModel(OrderSubModel orderSubModel) {
        if (this.orderSubModelList == null) {
            this.orderSubModelList = Lists.newArrayList();
        }
        this.orderSubModelList.add(orderSubModel);
    }
    public void addOrderDoDetailModel(OrderDoDetailModel orderDoDetailModel) {
        if (this.orderDoDetailModelList == null) {
            this.orderDoDetailModelList = Lists.newArrayList();
        }
        this.orderDoDetailModelList.add(orderDoDetailModel);
    }
    public void addOrderVirtualModel(OrderVirtualModel orderVirtualModel) {
        if (this.orderVirtualModelList == null) {
            this.orderVirtualModelList = Lists.newArrayList();
        }
        this.orderVirtualModelList.add(orderVirtualModel);
    }
}
