package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.List;

/**
 * 礼品最优价格、客户最优等级等
 */
public class PriceLevelVo  implements Serializable {
	private static final long serialVersionUID = 5434359521116446010L;
	//客户最优等级
	private String custLevel;
	//最优价格支付方式
	private String goodsPaywayId;
	//是否生日价标志
	private boolean isBirth;
	//是否VIP标志
	private boolean isVip;

	//卡号对应的卡板
	private String cardBoard;
	//客户对应的卡板
	private List<String> custBoard;
	//对应卡号的积分类型List
	private List<String> cardJfType;
	//对应卡号的积分类型List
	private List<String> custJfType;

	public String getCustLevel() {
		return custLevel;
	}
	public void setCustLevel(String custLevel) {
		this.custLevel = custLevel;
	}
	public String getGoodsPaywayId() {
		return goodsPaywayId;
	}
	public void setGoodsPaywayId(String goodsPaywayId) {
		this.goodsPaywayId = goodsPaywayId;
	}
	public boolean isBirth() {
		return isBirth;
	}
	public void setBirth(boolean isBirth) {
		this.isBirth = isBirth;
	}
	public boolean isVip() {
		return isVip;
	}
	public String getCardBoard() {
		return cardBoard;
	}
	public void setCardBoard(String cardBoard) {
		this.cardBoard = cardBoard;
	}
	public List<String> getCustBoard() {
		return custBoard;
	}
	public void setCustBoard(List<String> custBoard) {
		this.custBoard = custBoard;
	}
	public List<String> getCardJfType() {
		return cardJfType;
	}
	public void setCardJfType(List<String> cardJfType) {
		this.cardJfType = cardJfType;
	}
	public List<String> getCustJfType() {
		return custJfType;
	}
	public void setCustJfType(List<String> custJfType) {
		this.custJfType = custJfType;
	}
	public void setVip(boolean isVip) {
		this.isVip = isVip;
	}

}
