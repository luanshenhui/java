package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL101 积分商城礼品查询对象
 * 
 * @author lizy
 *
 */
public class CCIntergalPresentQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = 7127421525571452004L;
	@NotNull
	private String currentPage;
	@NotNull
	private String cardNo;
	@NotNull
	private String jfType;
	private String keyValue;
	@NotNull
	private String goodsXid;
	private String bonusRegion;
	@NotNull
	private String origin;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
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
