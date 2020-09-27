package cn.com.cgbchina.trade.dto;


import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 批量导出订单信息
 * Created by zhoupeng on 2016/7/21.
 */
public class OrderOutputDto implements Serializable {

    private static final long serialVersionUID = -54520433264642729L;

    public OrderOutputDto(Integer number,
                          String orderId,
                          String goodsCode,
                          String xid,
                          String mid,
                          String goodsNm,
                          String singlePrice,
                          String specShopno,
                          String miaoshaActionFlag,
                          Integer goodsNum,
                          Integer stagesNum,
                          String totalMoney,
                          BigDecimal uitdrtamt,
                          String voucherPrice,
                          String goodsBrand,
                          String goodsModel,
                          String goodsColor,
                          String goodsPresent,
                          String goodsPresentDesc,
                          String invoice,
                          String contNm,
                          String csgName,
                          String csgPhone1,
                          String csgPhone2,
                          String csgAddress,
                          String csgPostcode,
                          String sourceId,
                          String custOrdermainDesc,
                          String ccOrdermainDesc,
                          String bpCustGrp,
                          String curStatusNm,
                          String sinStatusNm,
                          String goodssendFlag,
                          String custType,
                          String orderDesc,
                          String ordermainDesc,
                          String transcorpNm,
                          String mailingNum
                          ) {
        this.number = number;
        this.orderId = orderId;
        this.goodsCode = goodsCode;
        this.xid = xid;
        this.mid = mid;
        this.goodsNm = goodsNm;
        this.singlePrice = singlePrice;
        this.specShopno = specShopno;
        this.miaoshaActionFlag = miaoshaActionFlag;
        this.goodsNum = goodsNum;
        this.stagesNum = stagesNum;
        this.totalMoney = totalMoney;
        this.uitdrtamt = uitdrtamt;
        this.voucherPrice = voucherPrice;
        this.goodsBrand = goodsBrand;
        this.goodsModel = goodsModel;
        this.goodsColor = goodsColor;
        this.goodsPresent = goodsPresent;
        this.goodsPresentDesc = goodsPresentDesc;
        this.invoice = invoice;
        this.contNm = contNm;
        this.csgName = csgName;
        this.csgPhone1 = csgPhone1;
        this.csgPhone2 = csgPhone2;
        this.csgAddress = csgAddress;
        this.csgPostcode = csgPostcode;
        this.sourceId = sourceId;
        this.custOrdermainDesc = custOrdermainDesc;
        this.ccOrdermainDesc = ccOrdermainDesc;
        this.bpCustGrp = bpCustGrp;
        this.curStatusNm = curStatusNm;
        this.sinStatusNm = sinStatusNm;
        this.goodssendFlag = goodssendFlag;
        this.custType = custType;
        this.orderDesc = orderDesc;
        this.ordermainDesc = ordermainDesc;
        this.transcorpNm = transcorpNm;
        this.mailingNum =  mailingNum;
    }
    @Getter
    @Setter
    private Integer number;//序号
    @Getter
    @Setter
    private String orderId;// 子订单号为：主订单号+2位顺序号如：201203280100000101一个主订单支持最多99个子订单
    @Getter
    @Setter
    private String vendorId;// 供应商代码
    @Getter
    @Setter
    private String vendorSnm;// 供应商名称简写
    @Getter
    @Setter
    private String goodsCode;// 商品编码
    @Getter
    @Setter
    private String xid;// 礼品编码
    @Getter
    @Setter
    private String mid;// 产品编码
    @Getter
    @Setter
    private String singlePrice;// 单个商品对应的价格
    @Getter
    @Setter
    private String miaoshaActionFlag;// 商品活动标志 0 不是 1 是
    @Getter
    @Setter
    private Integer goodsNum;// 商品数量
    @Getter
    @Setter
    private String goodsNm;// 商品名称
    @Getter
    @Setter
    private Integer stagesNum;// 现金[或积分]分期数
    @Getter
    @Setter
    private String totalMoney;// 现金总金额
    @Getter
    @Setter
    private java.math.BigDecimal uitdrtamt;// 本金减免金额(未用)
    @Getter
    @Setter
    private String voucherPrice;// 优惠金额
    @Getter
    @Setter
    private String specShopno;// 特店号邮购分期费率类别码
    @Getter
    @Setter
    private String goodsBrand;// 品牌
    @Getter
    @Setter
    private String goodsModel;// 型号
    @Getter
    @Setter
    private String goodsColor;// 商品颜色
    @Getter
    @Setter
    private String goodsPresent;// 赠品
    @Getter
    @Setter
    private String goodsPresentDesc;// 赠品说明
    @Getter
    @Setter
    private String invoice;// 发票抬头
    @Getter
    @Setter
    private String contNm;// 订货人姓名
    @Getter
    @Setter
    private String csgName;// 收货人姓名
    @Getter
    @Setter
    private String csgPhone1;// 收货人电话一
    @Getter
    @Setter
    private String csgPhone2;// 收货人电话二
    @Getter
    @Setter
    private String csgAddress;// 收货人详细地址
    @Getter
    @Setter
    private String csgPostcode;// 收货人邮政编码
    @Getter
    @Setter
    private String sourceId;//00: 商城01: CallCenter02: IVR渠道03: 手机商城04: 短信渠道05: 微信广发银行06：微信广发信用卡
    @Getter
    @Setter
    private String custOrdermainDesc;//用户留言
    @Getter
    @Setter
    private String ccOrdermainDesc ; //客服留言
    @Getter
    @Setter
    private String bpCustGrp;// 送货时间01: 工作日、双休日与假日均可送货02: 只有工作日送货（双休日、假日不用送）03: 只有双休日、假日送货（工作日不用送货）
    @Getter
    @Setter
    private String curStatusNm;// 订单状态
    @Getter
    @Setter
    private String sinStatusNm;// 请款状态
    @Getter
    @Setter
    private String goodssendFlag;// 发货标记0－未发货[默认]1－已发货2－已签收
    @Getter
    @Setter
    private String custType;// A:金普 ;B:钛金/臻淳白金 ;C:顶级/增值白金;D: VIP
    @Getter
    @Setter
    private String orderDesc;// 订单表备注
    @Getter
    @Setter
    private String ordermainDesc;// 客户备注
    @Getter
    @Setter
    private String transcorpNm;//物流公司名称
    @Getter
    @Setter
    private String mailingNum;//物流单号

}
