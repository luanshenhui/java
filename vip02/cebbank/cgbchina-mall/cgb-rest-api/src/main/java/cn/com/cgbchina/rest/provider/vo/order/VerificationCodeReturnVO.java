package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL422 微信易信验证码查询
 * 
 * @author lizy 2016/4/28.
 */
public class VerificationCodeReturnVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6788492755727548279L;
	private String totalPages;
	@NotNull
	private String totalCount;
	private List<WXYXVerificationCodeInfoVO> WXYXVerificationCodeInfos = new ArrayList<WXYXVerificationCodeInfoVO>();

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

	public List<WXYXVerificationCodeInfoVO> getWXYXVerificationCodeInfos() {
		return WXYXVerificationCodeInfos;
	}

	public void setWXYXVerificationCodeInfos(List<WXYXVerificationCodeInfoVO> wXYXVerificationCodeInfos) {
		WXYXVerificationCodeInfos = wXYXVerificationCodeInfos;
	}

}
