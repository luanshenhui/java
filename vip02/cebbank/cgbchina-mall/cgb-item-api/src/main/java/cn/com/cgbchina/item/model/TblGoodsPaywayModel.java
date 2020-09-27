package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class TblGoodsPaywayModel implements Serializable {

    private static final long serialVersionUID = 3591324700075657744L;
    @Getter
    @Setter
    private String goodsPaywayId;//商品支付编码
    @Getter
    @Setter
    private String goodsId;//单品编码
    @Getter
    @Setter
    private String paywayCode;//支付方式代码
    @Getter
    @Setter
    private String payType;//佣金代码
    @Getter
    @Setter
    private Long incCode;//手续费率代码
    @Getter
    @Setter
    private Integer stagesCode;//分期方式代码
    @Getter
    @Setter
    private String ruleId;//商品应用规则id
    @Getter
    @Setter
    private String authFlat1;//限制1
    @Getter
    @Setter
    private String authFlat2;//限制2
    @Getter
    @Setter
    private java.math.BigDecimal perStage;//每期
    @Getter
    @Setter
    private String stagesFlagCash;//是否支持分期[现金]（无用）
    @Getter
    @Setter
    private String stagesFlagPoint;//是否支持分期[积分]（无用）
    @Getter
    @Setter
    private String stagesFlagInc;//是否支持分期[手续费]
    @Getter
    @Setter
    private Long goodsPoint;//积分数量
    @Getter
    @Setter
    private String isAction;//活动类型(0-普通商品,1-活动商品,2-荷兰式拍卖,3-内宣产品)
    @Getter
    @Setter
    private String isBirth;//是否生日价格
    @Getter
    @Setter
    private String memberLevel;//会员等级(0000 金普,0001 钛金/臻享白金,0002 顶级/增值白金,0003 VIP,0004 生日,0005 积分+现金)
    @Getter
    @Setter
    private java.math.BigDecimal goodsPrice;//现金
    @Getter
    @Setter
    private java.math.BigDecimal calMoney;//清算金额
    @Getter
    @Setter
    private String goodsPaywayDesc;//备注
    @Getter
    @Setter
    private String ischeck;//是否待复核(商品录入 0,1,6,8,a,b,已提交｜待初审2,曾修改｜已提交｜待初审 3,c,已初审｜待复审   4,曾修改｜已初审｜待复审 e,已复审 5,7,曾修改｜已复审f ,删除d  ;  对礼品审核状态,0否,1礼品录入提交审核,2采购初审,3采购复审,4市场定价,5礼品上下架,6采购初审打回,7采购复审打回,8市场定价打回,d 删除)
    @Getter
    @Setter
    private String curStatus;//当前状态(0101：未启用，0102：已启用)
    @Getter
    @Setter
    private String categoryNo;//分期费率码
    @Getter
    @Setter
    private String createOper;//创建人
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private String modifyOper;//修改人
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
    @Getter
    @Setter
    private String reserved1;//保留字段
}