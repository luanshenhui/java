package cn.com.cgbchina.rest.provider.model.activity;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL326 分区查询接口
 * 
 * @author lizy 2016/4/28.
 */
public class Area extends BaseQueryEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1814334510390544608L;
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

}
