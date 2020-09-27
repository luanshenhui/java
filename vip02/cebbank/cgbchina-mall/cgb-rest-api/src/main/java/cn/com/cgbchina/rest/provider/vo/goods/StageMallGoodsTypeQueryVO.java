package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL311 商品类别查询(分期商城) 的传入对象
 * 
 * @author lizy 2016/4/29.
 */
public class StageMallGoodsTypeQueryVO extends BaseQueryEntityVO implements Serializable {

	private static final long serialVersionUID = 4746642833826344900L;
	@NotNull
	private String origin;
	@NotNull
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
