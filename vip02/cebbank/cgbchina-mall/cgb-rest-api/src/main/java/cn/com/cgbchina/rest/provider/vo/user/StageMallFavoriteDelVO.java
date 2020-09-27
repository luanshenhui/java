package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL303 删除收藏商品(分期商城) 删除对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallFavoriteDelVO extends BaseQueryEntityVO implements
		Serializable {
	private static final long serialVersionUID = -8877836206499352245L;
	@NotNull
	private String origin;
	@NotNull
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

	@XMLNodeName(value = "cust_id")
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
