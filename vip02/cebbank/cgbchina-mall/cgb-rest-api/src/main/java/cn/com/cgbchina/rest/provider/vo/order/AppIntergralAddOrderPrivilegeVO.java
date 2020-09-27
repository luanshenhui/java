package cn.com.cgbchina.rest.provider.vo.order;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL314 下单接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppIntergralAddOrderPrivilegeVO extends BaseQueryEntityVO {

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
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@XMLNodeName(value = "goods_num")
	private String goodsNum;
	@XMLNodeName(value = "goods_payway_id")
	private String goodsPaywayId;
	private String custCartId;

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
