package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by zhangLin on 2016/9/25.
 */
public class MallPromotionalDetailDto implements Serializable {

    private static final long serialVersionUID = 5350230890382048694L;
    @Setter
    @Getter
    private String itemCode;//单品id
    @Setter
    @Getter
    private Integer id;// 活动ID
    @Setter
    @Getter
    private String name;// 活动名称
    @Setter
    @Getter
    private String shortName;// 简称
    @Setter
    @Getter
    private Integer promType;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
    @Setter
    @Getter
    private String periodId;// 场次ID
    @Getter
    @Setter
    private java.util.Date beginDate;// 开始时间
    @Getter
    @Setter
    private java.util.Date endDate;// 结束时间
    @Getter
    @Setter
    private java.util.Date promNowDate;//当前时间
    @Setter
    @Getter
    private Integer ruleLimitBuyCount;// 限购数量
    @Setter
    @Getter
    private Boolean haveStock;//库存
    @Setter
    @Getter
    private String saleAmountAll;//已售

}
