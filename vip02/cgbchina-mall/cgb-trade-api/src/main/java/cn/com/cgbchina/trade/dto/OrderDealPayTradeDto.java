package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by lvzd on 2016/9/26.
 */
@Setter
@Getter
public class OrderDealPayTradeDto implements Serializable{
    private static final long serialVersionUID = -864652771533068511L;
    //  积分正交易
    private List<OrderCheckModel> orderCheckList2 = Lists.newArrayList();
    // 优惠券
    private List<OrderCheckModel> orderCheckList = Lists.newArrayList();
    // 回滚商品库存
    private Map<String, Integer> rollBackItemStockmap;
    // 回滚活动商品库存
    private List<Map<String, Object>> rollBackPromotionStockmaps;
    // 回滚积分池
    private List<OrderSubDto> dealPointPoolList = Lists.newArrayList();
    private List<TblOrderExtend1Model> tblOrderExtend1ModelIns = Lists.newArrayList();
    private List<TblOrderExtend1Model> tblOrderExtend1Modelupd = Lists.newArrayList();
    // 插入子订单表
    private List<OrderSubModel> orderSubModelList = Lists.newArrayList();
    // 更新拍卖记录表
    private List<String> custCartIdList = Lists.newArrayList();
    // 回滚荷兰拍
    private List<OrderSubDto> dealAuctionRecordList = Lists.newArrayList();



    public void putItemStock(String id) {
        if (rollBackItemStockmap == null) {
            rollBackItemStockmap = Maps.newHashMap();
        }
        if (rollBackItemStockmap.containsKey(id)) {
            rollBackItemStockmap.put(id, rollBackItemStockmap.get(id) + 1);
        } else {
            rollBackItemStockmap.put(id, 1);
        }
    }
    public void putPromotionStock(OrderSubModel orderSubModel) {
        if (rollBackPromotionStockmaps == null) {
            rollBackPromotionStockmaps = Lists.newArrayList();
        }
        Map<String, Object> proMap = Maps.newHashMap();
        proMap.put("promId", orderSubModel.getActId());
        proMap.put("periodId", orderSubModel.getPeriodId() == null ? null : orderSubModel.getPeriodId().toString());
        proMap.put("itemCode", orderSubModel.getGoodsId());
        // 接口需要“-”代表回滚
        proMap.put("itemCount", orderSubModel.getGoodsNum());
        proMap.put("orderId", orderSubModel.getOrderId());
        proMap.put("actType", orderSubModel.getActType());
        rollBackPromotionStockmaps.add(proMap);
    }
}
