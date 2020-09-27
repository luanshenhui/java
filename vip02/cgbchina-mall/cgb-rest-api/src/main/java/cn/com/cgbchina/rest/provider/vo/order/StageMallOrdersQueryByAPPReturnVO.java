package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL308 订单查询(分期商城)
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersQueryByAPPReturnVO extends BaseEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8982607486390459338L;
	private String totalPages;
	@NotNull
	private String totalCount;
	@XMLNodeName(value = "mainmer_id")
	private String mainmerId;
	private List<StageMallOrdersInfoByAPPVO> stageMallOrdersInfos = new ArrayList<StageMallOrdersInfoByAPPVO>();

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

	public List<StageMallOrdersInfoByAPPVO> getStageMallOrdersInfos() {
		return stageMallOrdersInfos;
	}

	public void setStageMallOrdersInfos(List<StageMallOrdersInfoByAPPVO> stageMallOrdersInfos) {
		this.stageMallOrdersInfos = stageMallOrdersInfos;
	}

}
