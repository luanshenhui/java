package cn.com.cgbchina.rest.provider.vo.activity;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL326 分区查询接口
 * 
 * @author lizy 2016/4/28.
 */
public class AreaVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1814334510390544608L;
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

}
