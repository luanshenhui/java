package cn.com.cgbchina.rest.provider.model.activity;

import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL330 场次列表查询
 * 
 * @author lizy 2016/4/28.
 */
public class ActivityQueryReturn extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6822640099935849378L;
	private String totalPages;
	private String totalCount;
	private String mallDate;
	private String mallTime;

	private List<ActivityQueryInfo> infos = new ArrayList<ActivityQueryInfo>();

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

	public List<ActivityQueryInfo> getInfos() {
		return infos;
	}

	public void setInfos(List<ActivityQueryInfo> infos) {
		this.infos = infos;
	}

}
