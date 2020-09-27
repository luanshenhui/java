package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL314 下单接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppIntergralAddOrderPrivilege extends BaseQueryEntity {

    /**
	 * 
	 */
    private static final long serialVersionUID = 3084140980876763888L;
    private String privilegeId;
    private String privilegeName;
    private String privilegeMoney;
    private String discountPrivilege;
    private String pointType;
    private String discountPrivMon;
    private String goodsId;
    private String goodsNum;
    private String goodsPaywayId;
    private String custCartId;
    // 仅用于check 新增订单渠道 如果为09需要中文转码
    private Boolean appSource;
    // 仅用于check 新增手机号 check如果O2O商品 必须填写手机好否则over
    private String csgPhone1;

    public String getCsgPhone1() {
	return csgPhone1;
    }

    public void setCsgPhone1(String csgPhone1) {
	this.csgPhone1 = csgPhone1;
    }

    public Boolean getAppSource() {
	return appSource;
    }

    public void setAppSource(Boolean appSource) {
	this.appSource = appSource;
    }

    public String getPrivilegeId() {
	return privilegeId;
    }

    public void setPrivilegeId(String privilegeId) {
	this.privilegeId = privilegeId;
    }

    public String getPrivilegeName() {
	return privilegeName;
    }

    public void setPrivilegeName(String privilegeName) {
	this.privilegeName = privilegeName;
    }

    public String getPrivilegeMoney() {
	return privilegeMoney;
    }

    public void setPrivilegeMoney(String privilegeMoney) {
	this.privilegeMoney = privilegeMoney;
    }

    public String getDiscountPrivilege() {
	return discountPrivilege;
    }

    public void setDiscountPrivilege(String discountPrivilege) {
	this.discountPrivilege = discountPrivilege;
    }

    public String getPointType() {
	return pointType;
    }

    public void setPointType(String pointType) {
	this.pointType = pointType;
    }

    public String getDiscountPrivMon() {
	return discountPrivMon;
    }

    public void setDiscountPrivMon(String discountPrivMon) {
	this.discountPrivMon = discountPrivMon;
    }

    public String getGoodsId() {
	return goodsId;
    }

    public void setGoodsId(String goodsId) {
	this.goodsId = goodsId;
    }

    public String getGoodsNum() {
	return goodsNum;
    }

    public void setGoodsNum(String goodsNum) {
	this.goodsNum = goodsNum;
    }

    public String getGoodsPaywayId() {
	return goodsPaywayId;
    }

    public void setGoodsPaywayId(String goodsPaywayId) {
	this.goodsPaywayId = goodsPaywayId;
    }

    public String getCustCartId() {
	return custCartId;
    }

    public void setCustCartId(String custCartId) {
	this.custCartId = custCartId;
    }

}
