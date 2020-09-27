package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL422 微信易信验证码查询
 * 
 * @author lizy 2016/4/28.
 */
public class VerificationCodeReturn extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6788492755727548279L;
	private String totalPages;
	private String totalCount;
	private List<WXYXVerificationCodeInfo> wXYXVerificationCodeInfos = new ArrayList<WXYXVerificationCodeInfo>();

	public String getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(String totalPages) {
		this.totalPages = totalPages;
	}

	public String getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(String totalCount) {
		this.totalCount = totalCount;
	}

	public List<WXYXVerificationCodeInfo> getWXYXVerificationCodeInfos() {
		return wXYXVerificationCodeInfos;
	}

	public void setWXYXVerificationCodeInfos(List<WXYXVerificationCodeInfo> wx) {
		wXYXVerificationCodeInfos = wx;
	}

}
