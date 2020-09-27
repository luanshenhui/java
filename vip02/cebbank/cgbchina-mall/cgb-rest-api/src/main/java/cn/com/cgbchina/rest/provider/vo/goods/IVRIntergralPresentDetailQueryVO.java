package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * @author Lizy MAL103 CC积分商城单个礼品详细信息查询
 */
public class IVRIntergralPresentDetailQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = -785065354520111288L;
	@NotNull
	private String goodsId;
	@NotNull
	private String cardNo;

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}
}
