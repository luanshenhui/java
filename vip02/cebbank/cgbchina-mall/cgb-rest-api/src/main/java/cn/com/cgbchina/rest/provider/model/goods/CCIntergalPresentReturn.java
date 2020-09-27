package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL101 积分商城礼品返回的对象
 * 
 * @author lizy
 *
 */
public class CCIntergalPresentReturn extends BaseEntity implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 157770783964025364L;
	private String channelSN;
	private String successCode;
	private String totalPages;
	private String curPage;
	private String loopTag;
	private String loopCount;
	private List<CCIntergalPresent> CCIntergalPresents = new ArrayList<CCIntergalPresent>();

	public String getChannelSN() {
		return channelSN;
	}

	public void setChannelSN(String channelSN) {
		this.channelSN = channelSN;
	}

	public String getSuccessCode() {
		return successCode;
	}

	public void setSuccessCode(String successCode) {
		this.successCode = successCode;
	}

	public String getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(String totalPages) {
		this.totalPages = totalPages;
	}

	public String getCurPage() {
		return curPage;
	}

	public void setCurPage(String curPage) {
		this.curPage = curPage;
	}

	public String getLoopTag() {
		return loopTag;
	}

	public void setLoopTag(String loopTag) {
		this.loopTag = loopTag;
	}

	public String getLoopCount() {
		return loopCount;
	}

	public void setLoopCount(String loopCount) {
		this.loopCount = loopCount;
	}

	public List<CCIntergalPresent> getCCIntergalPresents() {
		return CCIntergalPresents;
	}

	public void setCCIntergalPresents(List<CCIntergalPresent> CCIntergalPresents) {
		this.CCIntergalPresents = CCIntergalPresents;
	}
}
