package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by zhangLin on 2016/12/1.
 */
@Setter
@Getter
public class OrderExportModel implements Serializable {
    private static final long serialVersionUID = -5390874697808057226L;

    private Long productId;

    private String ordermainId;

    private String orderId;

    private String vendorSnm;

    private String mid;

    private String xid;

    private String goodsNm;

    private String goodsBrandName;

    private String promotionName;

    private String actType;

    private String o2oCode;

    private String o2oVoucherCode;

    private java.math.BigDecimal totalMoney;

    private String voucherNm;

    private java.math.BigDecimal voucherPrice;

    private java.math.BigDecimal singlePrice;

    private String singleBonus;

    private java.math.BigDecimal uitdrtamt;

    private String specShopno;

    private String curStatusNm;

    private java.util.Date createTime;

    private String ordernbr;

    private String sinStatusNm;

    private String goodsNum;

    private String csgProvince;

    private String csgCity;

    private String csgBorough;

    private String csgAddress;

    private String transcorpNm;

    private String mailingNum;

}
