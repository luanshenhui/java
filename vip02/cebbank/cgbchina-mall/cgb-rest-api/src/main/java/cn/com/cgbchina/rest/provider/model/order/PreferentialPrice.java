package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL322 获取最优价
 * 
 * @author lizy 2016/4/28.
 */
public class PreferentialPrice extends BaseQueryEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5111767488954460983L;
	private String origin;
	private String custId;
	private String custLevel;
	private String birthDay;
	private String goodsId;
	private String goodsNum;
	private String cardFormatNbr;
	private String jgId;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getCustLevel() {
		return custLevel;
	}

	public void setCustLevel(String custLevel) {
		this.custLevel = custLevel;
	}

	public String getBirthDay() {
		return birthDay;
	}

	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
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

	public String getCardFormatNbr() {
		return cardFormatNbr;
	}

	public void setCardFormatNbr(String cardFormatNbr) {
		this.cardFormatNbr = cardFormatNbr;
	}

	public String getJgId() {
		return jgId;
	}

	public void setJgId(String jgId) {
		this.jgId = jgId;
	}

}
