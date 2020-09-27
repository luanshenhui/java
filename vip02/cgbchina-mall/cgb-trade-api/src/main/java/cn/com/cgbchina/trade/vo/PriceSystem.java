package cn.com.cgbchina.trade.vo;

public class PriceSystem implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	public String memberLevel;

	public String goodsPaywayId;

	public String goodsPoint;

	public String goodsPrice;

	public PriceSystem() {

	}

	public PriceSystem(String member_level, String goods_payway_id, String goods_point) {
		this.setGoodsPaywayId(goods_payway_id);
		this.setGoodsPoint(goods_point);
		this.setGoodsPrice("0.00");
		this.setMemberLevel(member_level);
	}

	public String getGoodsPaywayId() {
		return goodsPaywayId;
	}

	public void setGoodsPaywayId(String goodsPaywayId) {
		this.goodsPaywayId = goodsPaywayId;
	}

	public String getGoodsPoint() {
		return goodsPoint;
	}

	public void setGoodsPoint(String goodsPoint) {
		this.goodsPoint = goodsPoint;
	}

	public String getGoodsPrice() {
		return goodsPrice;
	}

	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
	}

	public String getMemberLevel() {
		return memberLevel;
	}

	public void setMemberLevel(String memberLevel) {
		this.memberLevel = memberLevel;
	}

}