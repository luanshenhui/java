package cn.com.cgbchina.rest.provider.vo.activity;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 * MAL326 分区查询接口
 * 
 * @author lizy 2016/4/28.
 */
public class AreaInfoVO {
	@XMLNodeName(value = "area_id")
	private String areaId;
	@XMLNodeName(value = "area_nm")
	private String areaNm;
	@XMLNodeName(value = "orderType_id")
	private String orderTypeId;
	@XMLNodeName(value = "area_type")
	private String areaType;
	@XMLNodeName(value = "jf_type")
	private String jfType;
	@XMLNodeName(value = "area_seq")
	private String areaSeq;
	@XMLNodeName(value = "goods_type")
	private String goodsType;
	@XMLNodeName(value = "format_id")
	private String formatId;

	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}

	public String getAreaNm() {
		return areaNm;
	}

	public void setAreaNm(String areaNm) {
		this.areaNm = areaNm;
	}

	public String getOrderTypeId() {
		return orderTypeId;
	}

	public void setOrderTypeId(String orderTypeId) {
		this.orderTypeId = orderTypeId;
	}

	public String getAreaType() {
		return areaType;
	}

	public void setAreaType(String areaType) {
		this.areaType = areaType;
	}

	public String getJfType() {
		return jfType;
	}

	public void setJfType(String jfType) {
		this.jfType = jfType;
	}

	public String getAreaSeq() {
		return areaSeq;
	}

	public void setAreaSeq(String areaSeq) {
		this.areaSeq = areaSeq;
	}

	public String getGoodsType() {
		return goodsType;
	}

	public void setGoodsType(String goodsType) {
		this.goodsType = goodsType;
	}

	public String getFormatId() {
		return formatId;
	}

	public void setFormatId(String formatId) {
		this.formatId = formatId;
	}

}
