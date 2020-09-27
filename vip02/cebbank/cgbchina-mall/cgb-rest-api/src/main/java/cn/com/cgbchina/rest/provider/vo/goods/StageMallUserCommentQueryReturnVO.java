package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL320 用户点评(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallUserCommentQueryReturnVO extends BaseEntityVO implements Serializable {
	private String totalPages;
	@NotNull
	private String totalCount;
	List<StageMallUserCommentVO> Comments = new ArrayList<StageMallUserCommentVO>();

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

	public List<StageMallUserCommentVO> getComments() {
		return Comments;
	}

	public void setComments(List<StageMallUserCommentVO> comments) {
		Comments = comments;
	}

}
