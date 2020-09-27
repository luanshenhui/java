package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL303 删除收藏商品(分期商城) 删除对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallFavoriteDel extends BaseQueryEntity implements
		Serializable {
	private static final long serialVersionUID = -8877836206499352245L;
	private String origin;
	private String mallType;
	private String id;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	private List<String> ids = new ArrayList<String>();

	public List<String> getIds() {
		return ids;
	}

	public void setIds(List<String> ids) {
		this.ids = ids;
	}

	private String custId;

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

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}
}
