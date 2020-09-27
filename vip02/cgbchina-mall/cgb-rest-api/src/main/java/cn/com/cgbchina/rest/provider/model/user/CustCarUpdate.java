package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL306 修改购物车(分期商城)
 * 
 * @author lizy 2016/4/29.
 */
public class CustCarUpdate extends BaseQueryEntity implements Serializable {

	private static final long serialVersionUID = 3158530929641408535L;
	private String origin;
	private String mallType;
	private List<CustCarUpdateInfo> updateInfos = new ArrayList<CustCarUpdateInfo>();

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

	public List<CustCarUpdateInfo> getUpdateInfos() {
		return updateInfos;
	}

	public void setUpdateInfos(List<CustCarUpdateInfo> updateInfos) {
		this.updateInfos = updateInfos;
	}

}
