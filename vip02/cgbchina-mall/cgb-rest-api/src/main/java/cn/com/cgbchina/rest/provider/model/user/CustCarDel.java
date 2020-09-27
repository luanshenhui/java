package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL304 加入购物车(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class CustCarDel extends BaseQueryEntity implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7167993869079641581L;
	private String origin;
	private String mallType;
	private List<CustCarDelIds> ids = new ArrayList<CustCarDelIds>();

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

	public List<CustCarDelIds> getIds() {
		return ids;
	}

	public void setIds(List<CustCarDelIds> ids) {
		this.ids = ids;
	}



}
