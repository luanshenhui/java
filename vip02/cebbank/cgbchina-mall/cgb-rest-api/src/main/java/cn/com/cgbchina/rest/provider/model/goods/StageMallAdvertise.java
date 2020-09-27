package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL321 广告查询(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallAdvertise extends BaseQueryEntity implements Serializable {
	private String origin;
	private String mallType;
	private String advertisePos;

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

	public String getAdvertisePos() {
		return advertisePos;
	}

	public void setAdvertisePos(String advertisePos) {
		this.advertisePos = advertisePos;
	}

}
