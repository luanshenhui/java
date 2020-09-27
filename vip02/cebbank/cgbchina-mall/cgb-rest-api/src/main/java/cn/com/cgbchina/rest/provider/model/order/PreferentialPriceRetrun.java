package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL322 获取最优价
 * 
 * @author lizy 2016/4/28.
 */
public class PreferentialPriceRetrun extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5783900555173643507L;
	private String goodsPaywaId;
	private String level;
	private String goodsPoint;
	private String isBir;
	private String brthTimes;
	private String goodsPaywaIdBir;
	private String goodsPointBir;
	private String goodsPaywaIdJm;
	private String goodsPointJm;
	private String goodsPriceJm;

	public String getGoodsPaywaId() {
		return goodsPaywaId;
	}

	public void setGoodsPaywaId(String goodsPaywaId) {
		this.goodsPaywaId = goodsPaywaId;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public String getGoodsPoint() {
		return goodsPoint;
	}

	public void setGoodsPoint(String goodsPoint) {
		this.goodsPoint = goodsPoint;
	}

	public String getIsBir() {
		return isBir;
	}

	public void setIsBir(String isBir) {
		this.isBir = isBir;
	}

	public String getBrthTimes() {
		return brthTimes;
	}

	public void setBrthTimes(String brthTimes) {
		this.brthTimes = brthTimes;
	}

	public String getGoodsPaywaIdBir() {
		return goodsPaywaIdBir;
	}

	public void setGoodsPaywaIdBir(String goodsPaywaIdBir) {
		this.goodsPaywaIdBir = goodsPaywaIdBir;
	}

	public String getGoodsPointBir() {
		return goodsPointBir;
	}

	public void setGoodsPointBir(String goodsPointBir) {
		this.goodsPointBir = goodsPointBir;
	}

	public String getGoodsPaywaIdJm() {
		return goodsPaywaIdJm;
	}

	public void setGoodsPaywaIdJm(String goodsPaywaIdJm) {
		this.goodsPaywaIdJm = goodsPaywaIdJm;
	}

	public String getGoodsPointJm() {
		return goodsPointJm;
	}

	public void setGoodsPointJm(String goodsPointJm) {
		this.goodsPointJm = goodsPointJm;
	}

	public String getGoodsPriceJm() {
		return goodsPriceJm;
	}

	public void setGoodsPriceJm(String goodsPriceJm) {
		this.goodsPriceJm = goodsPriceJm;
	}

}
