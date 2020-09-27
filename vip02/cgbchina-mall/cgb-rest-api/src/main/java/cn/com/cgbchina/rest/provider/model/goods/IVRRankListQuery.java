package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL202 IVR排行列表查询对象
 * 
 * @author lizy 2016/4/28.
 */
public class IVRRankListQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = -7290938333938684473L;
	private String cardNo;
	private String jfType;

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
}
