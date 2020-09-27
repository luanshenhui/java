package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL322 获取最优价
 * 
 * @author lizy 2016/4/28.
 * @modify xiewl 2016/8/28
 */
public class PreferentialPriceVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5111767488954460983L;
	@NotNull
	private String origin;
	@NotNull
	@XMLNodeName(value = "cust_id")
	private String custId;
	@NotNull
	@XMLNodeName(value = "cust_level")
	private String custLevel;
	@NotNull
	private String birthDay;
	@NotNull
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@NotNull
	@XMLNodeName(value = "goods_num")
	private String goodsNum;
	private List<PreferentialPriceCardFormatNbrs> cardFormatNbrs;

	private List<PreferentialPriceJgIds> priceJgIds;

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

	public List<PreferentialPriceCardFormatNbrs> getCardFormatNbrs() {
		return cardFormatNbrs;
	}

	public void setCardFormatNbrs(List<PreferentialPriceCardFormatNbrs> cardFormatNbrs) {
		this.cardFormatNbrs = cardFormatNbrs;
	}

	public List<PreferentialPriceJgIds> getPriceJgIds() {
		return priceJgIds;
	}

	public void setPriceJgIds(List<PreferentialPriceJgIds> priceJgIds) {
		this.priceJgIds = priceJgIds;
	}


}
