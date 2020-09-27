package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class CommendRankModel implements Serializable {

    private static final long serialVersionUID = 6496710784951046853L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String statType;//统计类型(0001热销商品统计,0002热门收藏统计,0003热销品类统计,0004供应商销量统计,0005供应商一周数据统计,0006供应商热门收藏商品统计,0007供应商热门销售商品统计)
    @Getter
    @Setter
    private String ordertypeId;//业务类型 yg:广发商城,jf:积分商城
    @Getter
    @Setter
    private String itemCode;//单品编码
    @Getter
    @Setter
    private String goodsName;//商品名称
    @Getter
    @Setter
    private java.math.BigDecimal price;//实际价格
    @Getter
    @Setter
    private String installmentNumber;//最高期数
    @Getter
    @Setter
    private String image1;//图片1
    @Getter
    @Setter
    private Long backCategory1Id;//类目id
    @Getter
    @Setter
    private String backCategory1Name;//类目名称
    @Getter
    @Setter
    private String vendorId;//供应商id
    @Getter
    @Setter
    private String vendorName;//供应商名称
    @Getter
    @Setter
    private Integer rank;//排行
    @Getter
    @Setter
    private Integer statNum01;//统计数量1
    @Getter
    @Setter
    private Integer statNum02;//统计数量2
    @Getter
    @Setter
    private java.util.Date rankDate;//排行日期
    @Getter
    @Setter
    private java.util.Date rankTime;//排行时间
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
    @Getter
    @Setter
    private String extend1;//扩展字段1
    @Getter
    @Setter
    private String extend2;//扩展字段2
    @Getter
    @Setter
    private String extend3;//扩展字段3
 }