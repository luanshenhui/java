package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * @author Lizy MAL103 CC积分商城单个礼品详细信息查询
 */
public class IVRIntergralPresentDetailQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = -785065354520111288L;
	private String goodsId;
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
