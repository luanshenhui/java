package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class SaleRankModel implements Serializable {

    private static final long serialVersionUID = -6869192379314829189L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String goodsId;//商品id
    @Getter
    @Setter
    private String jfType;//积分类型
    @Getter
    @Setter
    private Integer rank;//拍训
    @Getter
    @Setter
    private String saleNum;//销售数量
    @Getter
    @Setter
    private java.util.Date rankTime;//排序时间
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
    @Getter
    @Setter
    private String extend1;//保留字段1
    @Getter
    @Setter
    private String extend2;//保留字段2
    @Getter
    @Setter
    private String extend3;//保留字段3
}