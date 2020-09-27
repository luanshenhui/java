package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by zhangLin on 2016/9/6.
 */
public class CommendRankDto implements Serializable {
    private static final long serialVersionUID = 5063377634207369005L;
    @Getter
    @Setter
    private String minPoint;//积分商品积分价（最优）
    @Getter
    @Setter
    private String prices;//现金价格
    @Getter
    @Setter
    private String maxInstallmentNumber;//最大分期数
    @Getter
    @Setter
    private String goodsName;//商品名
    @Getter
    @Setter
    private String image;//商品图片
    @Getter
    @Setter
    private String itemCode;//单品编码
    @Getter
    @Setter
    private int statNum;//销售数量或收藏数量
    @Getter
    @Setter
    private String goodsCode;//单品编码

}
