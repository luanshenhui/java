package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL304 加入购物车(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class CustCarDelVO extends BaseQueryEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7167993869079641581L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	private List<CustCarDelIdsVO> ids = new ArrayList<CustCarDelIdsVO>();

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

	public List<CustCarDelIdsVO> getIds() {
		return ids;
	}

	public void setIds(List<CustCarDelIdsVO> ids) {
		this.ids = ids;
	}


}
