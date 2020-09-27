package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL201 CC积分商城预判接口 传入对象
 * 
 * @author lizy 2016/4/28.
 */
public class CCIntergralAnticipation extends BaseQueryEntity implements Serializable {

	private static final long serialVersionUID = 6017986461435906861L;
	private String cardNo;
	private String certNo;
	private String goodsId;
	private String formatId;

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getCertNo() {
		return certNo;
	}

	public void setCertNo(String certNo) {
		this.certNo = certNo;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getFormatId() {
		return formatId;
	}

	public void setFormatId(String formatId) {
		this.formatId = formatId;
	}
}
