package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL202 IVR排行列表查询对象
 * 
 * @author lizy 2016/4/28.
 */
public class IVRRankListQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = -7290938333938684473L;
	@NotNull
	private String cardNo;
	@NotNull
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
