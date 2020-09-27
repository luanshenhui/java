package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL117 商品详细信息(分期商城)的返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallGoodsDetailQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = 212415537352811468L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@XMLNodeName(value = "goods_omid")
	private String goodsOmid;
	@NotNull
	@XMLNodeName(value = "cont_idcard")
	private String contIdCard;

	public String getContIdCard() {
		return contIdCard;
	}

	public void setContIdCard(String contIdCard) {
		this.contIdCard = contIdCard;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getMallType() {
		return mallType;
	}

	public void setMallType(String mallType) {
		this.mallType = mallType;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsOmid() {
		return goodsOmid;
	}

	public void setGoodsOmid(String goodsOmid) {
		this.goodsOmid = goodsOmid;
	}

}
