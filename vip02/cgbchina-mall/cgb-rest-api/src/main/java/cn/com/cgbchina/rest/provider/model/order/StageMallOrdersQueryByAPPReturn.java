package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL308 订单查询(分期商城)
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersQueryByAPPReturn extends BaseEntity implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8982607486390459338L;
	private String totalPages;
	private String totalCount;
	private String mainmerId;
	private List<StageMallOrdersInfoByAPP> stageMallOrdersInfos = new ArrayList<StageMallOrdersInfoByAPP>();

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

	public String getMainmerId() {
		return mainmerId;
	}

	public void setMainmerId(String mainmerId) {
		this.mainmerId = mainmerId;
	}

	public List<StageMallOrdersInfoByAPP> getStageMallOrdersInfos() {
		return stageMallOrdersInfos;
	}

	public void setStageMallOrdersInfos(List<StageMallOrdersInfoByAPP> stageMallOrdersInfos) {
		this.stageMallOrdersInfos = stageMallOrdersInfos;
	}

}
