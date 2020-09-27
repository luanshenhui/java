package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL321 广告查询(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallAdvertiseVO extends BaseQueryEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -3635738769391921628L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	@XMLNodeName(value = "advertise_pos")
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
