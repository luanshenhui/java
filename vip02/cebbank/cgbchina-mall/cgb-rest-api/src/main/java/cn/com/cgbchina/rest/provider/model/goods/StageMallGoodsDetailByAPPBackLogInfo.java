package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

public class StageMallGoodsDetailByAPPBackLogInfo implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3094611099200200194L;
	private String goodsBackLog;
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
