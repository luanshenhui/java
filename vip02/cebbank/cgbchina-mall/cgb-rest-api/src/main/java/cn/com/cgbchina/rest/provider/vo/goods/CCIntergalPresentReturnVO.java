package cn.com.cgbchina.rest.provider.vo.goods;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL101 积分商城礼品返回的对象
 * @author  lizy
 *
 */
public class CCIntergalPresentReturnVO implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = -3369562034621783564L;
	@NotNull
	private String returnCode;
	@XMLNodeName("ReturnDes")
    private String returnDes;
	@NotNull
	private String channelSN;
	@NotNull
    private String successCode;
	@NotNull
    private String totalPages;
	@NotNull
    private String curPage;
    private String loopTag;
    private String loopCount;
    private List<CCIntergalPresentVO> CCIntergalPresents = new ArrayList<CCIntergalPresentVO>();
    public String getReturnCode() {
		return returnCode;
	}
	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}
	public String getReturnDes() {
		return returnDes;
	}
	public void setReturnDes(String returnDes) {
		this.returnDes = returnDes;
	}
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

    public List<CCIntergalPresentVO> getCCIntergalPresents() {
        return CCIntergalPresents;
    }

    public void setCCIntergalPresents(List<CCIntergalPresentVO> CCIntergalPresents) {
        this.CCIntergalPresents = CCIntergalPresents;
    }
}
