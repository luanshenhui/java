package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

public class StageMallGoodsDetailByAPPBackLogInfoVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -8783900702576056966L;
	@XMLNodeName(value="goods_backlog")
	private String goodsBackLog;
	@XMLNodeName(value="goods_total")
	private String goodsTotal;
	public String getGoodsBackLog() {
		return goodsBackLog;
	}
	public void setGoodsBackLog(String goodsBackLog) {
		this.goodsBackLog = goodsBackLog;
	}
	public String getGoodsTotal() {
		return goodsTotal;
	}
	public void setGoodsTotal(String goodsTotal) {
		this.goodsTotal = goodsTotal;
	}
	
}
