package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL311 商品类别查询(分期商城) 的传入对象
 * 
 * @author lizy 2016/4/29.
 */
public class StageMallGoodsTypeQuery extends BaseQueryEntity implements Serializable {

	private static final long serialVersionUID = 4746642833826344900L;
	private String origin;
	private String mallType;

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

	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}

	private String areaId;

}
