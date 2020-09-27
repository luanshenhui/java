package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by txy on 2016/8/24.
 */
@Getter
@Setter
@ToString
public class HotRankModel extends BaseModel implements Serializable {

    private static final long serialVersionUID = -3872694922778010302L;
    private String itemCode;//单品编码

    private String goodsNm;//商品名称

    private String goodsCode;//商品编码

    private BigDecimal price;//采购价

    private String installmentNumber;//最高期数

    private String image1;//单品图片1

    private Integer num;// 总数

    private Integer cnt;//总数

    private String vendorId;//供应商ID

    private String fullName;//供应商全称

    /* add start by geshuo 20160902 ---------------------- */
    private Integer goodsCount;//商品销量(热销品类用)

    private Long backCategory1Id;//三级分类id(热销品类用)

    private String backCategory1Nm;//三级分类名称(热销品类用)

    private Long productId;//产品id

    private Integer orderCount;// 订单数量 (供应商周统计用)

    private Integer memberCount;// 用户数量 (供应商周统计用)

    private Date doTime;//日期
    /* add end  by geshuo 20160902 ------------------------ */
}
