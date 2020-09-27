package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL306 修改购物车(分期商城)
 * 
 * @author lizy 2016/4/29.
 */
public class CustCarUpdateVO extends BaseQueryEntityVO implements Serializable {

	private static final long serialVersionUID = 3158530929641408535L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@XMLNodeName("cust_id")
	private String custId;

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	private List<CustCarUpdateInfoVO> UpdateInfos = new ArrayList<CustCarUpdateInfoVO>();

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

	public List<CustCarUpdateInfoVO> getUpdateInfos() {
		return UpdateInfos;
	}

	public void setUpdateInfos(List<CustCarUpdateInfoVO> updateInfos) {
		UpdateInfos = updateInfos;
	}

}
