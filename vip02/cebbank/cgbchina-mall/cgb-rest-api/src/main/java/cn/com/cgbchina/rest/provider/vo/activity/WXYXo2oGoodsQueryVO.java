package cn.com.cgbchina.rest.provider.vo.activity;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL421 微信易信O2O0元秒杀商品详情查询
 * 
 * @author lizy 2016/4/28.
 */
public class WXYXo2oGoodsQueryVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1921999183280368284L;
	@NotNull
	private String origin;
	@XMLNodeName(value = "goods_mid")
	private String goodsMid;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getGoodsMid() {
		return goodsMid;
	}

	public void setGoodsMid(String goodsMid) {
		this.goodsMid = goodsMid;
	}

}
