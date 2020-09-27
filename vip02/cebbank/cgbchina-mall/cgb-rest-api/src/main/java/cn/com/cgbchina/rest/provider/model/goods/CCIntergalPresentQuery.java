package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL101 积分商城礼品查询对象
 * 
 * @author lizy
 *
 */
public class CCIntergalPresentQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = 7127421525571452004L;
	private String currentPage;
	private String cardNo;
	private String jfType;
	private String keyValue;
	private String goodsXid;
	private String bonusRegion;
	private String origin;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(String currentPage) {
		this.currentPage = currentPage;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getJfType() {
		return jfType;
	}

	public void setJfType(String jfType) {
		this.jfType = jfType;
	}

	public String getKeyValue() {
		return keyValue;
	}

	public void setKeyValue(String keyValue) {
		this.keyValue = keyValue;
	}

	public String getGoodsXid() {
		return goodsXid;
	}

	public void setGoodsXid(String goodsXid) {
		this.goodsXid = goodsXid;
	}

	public String getBonusRegion() {
		return bonusRegion;
	}

	public void setBonusRegion(String bonusRegion) {
		this.bonusRegion = bonusRegion;
	}
}
