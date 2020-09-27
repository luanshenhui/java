package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by zhangLin on 2016/11/23.
 */
public class OrderOutputAdminDto implements Serializable {

    private static final long serialVersionUID = 5484186789597953673L;

    @Setter
    @Getter
    private Integer number; //大订单号(AL)

    @Getter
    private String ordermainId; //大订单号(AL)

    @Getter
    private String orderId; //子订单号(AL)

    @Getter
    private String vendorSnm; //合作商名称（供应商名称简写）(AL)

    @Getter
    private String mid; //商品编码(YG)

    @Getter
    private String xid; //礼品编码(JF)

    @Getter
    private String itemName; //商品,礼品名称(AL)

    @Getter
    private String goodsBrand; //品牌(YG)（id -》goodsbrand）

    @Getter
    private String backCategory1; //一级类目(YG)

    @Getter
    private String backCategory2; //二级类目(YG)

    @Getter
    private String backCategory3; //三级类目(YG)

    @Getter
    private String actName; //活动名称(YG)   act_id （id -》tbl_promotion ）

    @Getter
    private String actType; //活动类型(YG)   act_type （id -》匹配 ）

    @Getter
    private String o2oCode; //O2O商品编号(YG)   act_type （item -》 tbl_item :o2o_code ）

    @Getter
    private String o2oVoucherCode; //O2O兑换券编号(YG)

    @Getter
    private String paywayPrice; //订单总金额(AL)(payway-> price)

    @Getter
    private String totalMoney; //交易金额(YG)

    @Getter
    private String voucherNm; //使用优惠券(YG)

    @Getter
    private String voucherPrice; //优惠券金额(YG)

    @Getter
    private String singleBonus; //使用积分(YG)

    @Getter
    private String uitdrtamt; //积分抵扣金额(YG)

    @Getter
    private String specShopno; //邮购分期类别码(YG)

    @Getter
    private String curStatusNm; //订单状态(YG)

    @Getter
    private String createTime; //生成订单时间(AL)

    @Getter
    private String sendTime; //发货时间(AL)

    @Getter
    private String receivedTime; //签收时间(AL)

    @Getter
    private String applyReturnTime; //申请退货时间(AL)

    @Getter
    private String agreeReturnTime; //同意退货时间(AL)

    @Getter
    private String refusedReturnTime; //拒绝退货时间(AL)

    @Getter
    private String applyFundsTime; //申请请款时间(AL)

    @Getter
    private String agreeFundsTime; //同意请款时间(YG)

    @Getter
    private String bankOrderNumber; //银行订单号(YG)

    @Getter
    private String sinStatusNm; //请款状态(YG)

    @Getter
    private String goodsNum; //订单数量(JF)

    @Getter
    private String area; //地区(JF)

    @Getter
    private String deliveryTime; //发货时效(JF)

    @Getter
    private String signInTime; //签收时效(JF)

    @Getter
    private String orderSettlementTime; //订单结算时间(JF)

    @Getter
    private String settlementAging; //结算时效(JF)

    @Getter
    private String logisticsCompany; //物流公司(JF)

    @Getter
    private String logisticsNumber; //物流单号(JF)


    public void setOrdermainId(String ordermainId) {
        this.ordermainId = ordermainId==null?"":ordermainId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId==null?"":orderId;
    }

    public void setVendorSnm(String vendorSnm) {
        this.vendorSnm = vendorSnm==null?"":vendorSnm;
    }

    public void setMid(String mid) {
        this.mid = mid==null?"":mid;
    }

    public void setXid(String xid) {
        this.xid = xid==null?"":xid;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName==null?"":itemName;
    }

    public void setGoodsBrand(String goodsBrand) {
        this.goodsBrand = goodsBrand==null?"":goodsBrand;
    }

    public void setBackCategory1(String backCategory1) {
        this.backCategory1 = backCategory1==null?"":backCategory1;
    }

    public void setBackCategory2(String backCategory2) {
        this.backCategory2 = backCategory2==null?"":backCategory2;
    }

    public void setBackCategory3(String backCategory3) {
        this.backCategory3 = backCategory3==null?"":backCategory3;
    }

    public void setActName(String actName) {
        this.actName = actName==null?"":actName;
    }

    public void setActType(String actType) {
        this.actType = actType==null?"":actType;
    }

    public void setO2oCode(String o2oCode) {
        this.o2oCode = o2oCode==null?"":o2oCode;
    }

    public void setO2oVoucherCode(String o2oVoucherCode) {
        this.o2oVoucherCode = o2oVoucherCode==null?"":o2oVoucherCode;
    }

    public void setPaywayPrice(String paywayPrice) {
        this.paywayPrice = paywayPrice==null?"":paywayPrice;
    }

    public void setTotalMoney(String totalMoney) {
        this.totalMoney = totalMoney==null?"":totalMoney;
    }

    public void setVoucherNm(String voucherNm) {
        this.voucherNm = voucherNm==null?"":voucherNm;
    }

    public void setVoucherPrice(String voucherPrice) {
        this.voucherPrice = voucherPrice==null?"":voucherPrice;
    }

    public void setSingleBonus(String singleBonus) {
        this.singleBonus = singleBonus==null?"":singleBonus;
    }

    public void setUitdrtamt(String uitdrtamt) {
        this.uitdrtamt = uitdrtamt==null?"":uitdrtamt;
    }

    public void setSpecShopno(String specShopno) {
        this.specShopno = specShopno==null?"":specShopno;
    }

    public void setCurStatusNm(String curStatusNm) {
        this.curStatusNm = curStatusNm==null?"":curStatusNm;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime==null?"":createTime;
    }

    public void setSendTime(String sendTime) {
        this.sendTime = sendTime==null?"":sendTime;
    }

    public void setReceivedTime(String receivedTime) {
        this.receivedTime = receivedTime==null?"":receivedTime;
    }

    public void setApplyReturnTime(String applyReturnTime) {
        this.applyReturnTime = applyReturnTime==null?"":applyReturnTime;
    }

    public void setAgreeReturnTime(String agreeReturnTime) {
        this.agreeReturnTime = agreeReturnTime==null?"":agreeReturnTime;
    }

    public void setRefusedReturnTime(String refusedReturnTime) {
        this.refusedReturnTime = refusedReturnTime==null?"":refusedReturnTime;
    }

    public void setApplyFundsTime(String applyFundsTime) {
        this.applyFundsTime = applyFundsTime==null?"":applyFundsTime;
    }

    public void setAgreeFundsTime(String agreeFundsTime) {
        this.agreeFundsTime = agreeFundsTime==null?"":agreeFundsTime;
    }

    public void setBankOrderNumber(String bankOrderNumber) {
        this.bankOrderNumber = bankOrderNumber==null?"":bankOrderNumber;
    }

    public void setSinStatusNm(String sinStatusNm) {
        this.sinStatusNm = sinStatusNm==null?"":sinStatusNm;
    }

    public void setGoodsNum(String goodsNum) {
        this.goodsNum = goodsNum==null?"":goodsNum;
    }

    public void setArea(String area) {
        this.area = area==null?"":area;
    }

    public void setDeliveryTime(String deliveryTime) {
        this.deliveryTime = deliveryTime==null?"":deliveryTime;
    }

    public void setSignInTime(String signInTime) {
        this.signInTime = signInTime==null?"":signInTime;
    }

    public void setOrderSettlementTime(String orderSettlementTime) {
        this.orderSettlementTime = orderSettlementTime==null?"":orderSettlementTime;
    }

    public void setSettlementAging(String settlementAging) {
        this.settlementAging = settlementAging==null?"":settlementAging;
    }

    public void setLogisticsCompany(String logisticsCompany) {
        this.logisticsCompany = logisticsCompany==null?"":logisticsCompany;
    }

    public void setLogisticsNumber(String logisticsNumber) {
        this.logisticsNumber = logisticsNumber==null?"":logisticsNumber;
    }

    public OrderOutputAdminDto() {
        this.ordermainId = "";
        this.orderId = "";
        this.vendorSnm = "";
        this.mid = "";
        this.xid = "";
        this.itemName = "";
        this.goodsBrand = "";
        this.backCategory1 = "";
        this.backCategory2 = "";
        this.backCategory3 = "";
        this.actName = "";
        this.actType = "";
        this.o2oCode = "";
        this.o2oVoucherCode = "";
        this.paywayPrice = "";
        this.totalMoney = "";
        this.voucherNm = "";
        this.voucherPrice = "";
        this.singleBonus = "";
        this.uitdrtamt = "";
        this.specShopno = "";
        this.curStatusNm = "";
        this.createTime = "";
        this.sendTime = "";
        this.receivedTime = "";
        this.applyReturnTime = "";
        this.agreeReturnTime = "";
        this.refusedReturnTime = "";
        this.applyFundsTime = "";
        this.agreeFundsTime = "";
        this.bankOrderNumber = "";
        this.sinStatusNm = "";
        this.goodsNum = "";
        this.area = "";
        this.deliveryTime = "";
        this.signInTime = "";
        this.orderSettlementTime = "";
        this.settlementAging = "";
        this.logisticsCompany = "";
        this.logisticsNumber = "";
    }
}
