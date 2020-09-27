package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
public class CfgPriceSystemModel implements Serializable {

    private static final long serialVersionUID = -7926791881233601680L;
    @Getter
    @Setter
    private Integer id;//主键ID
    @Getter
    @Setter
    private String pricesystemId;//体系ID
    @Getter
    @Setter
    private String pricesystemNm;//体系名称
    @Getter
    @Setter
    private Integer upLimit;//上限积分
    @Getter
    @Setter
    private Integer downLimit;//下限积分'
    @Getter
    @Setter
    private java.math.BigDecimal argumentNormal;//金普卡参数
    @Getter
    @Setter
    private java.math.BigDecimal argumentOther;//其它参数
    @Getter
    @Setter
    private String curStatus;//状态
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
}