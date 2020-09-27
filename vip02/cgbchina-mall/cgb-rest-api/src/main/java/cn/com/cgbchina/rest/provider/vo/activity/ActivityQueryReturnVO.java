package cn.com.cgbchina.rest.provider.vo.activity;

import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.model.activity.ActivityQueryInfo;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL330 场次列表查询
 * 
 * @author lizy 2016/4/28.
 */
public class ActivityQueryReturnVO  {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6822640099935849378L;
	private String returnCode;
	private String returnDes;
	
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

	private String totalPages;
	private String totalCount;
	private String mallDate;
	private String mallTime;

	private List<ActivityQueryInfoVO> infos = new ArrayList<ActivityQueryInfoVO>();

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

	public String getMallDate() {
		return mallDate;
	}

	public void setMallDate(String mallDate) {
		this.mallDate = mallDate;
	}

	public String getMallTime() {
		return mallTime;
	}

	public void setMallTime(String mallTime) {
		this.mallTime = mallTime;
	}

	public List<ActivityQueryInfoVO> getInfos() {
		return infos;
	}

	public void setInfos(List<ActivityQueryInfoVO> infos) {
		this.infos = infos;
	}

}
