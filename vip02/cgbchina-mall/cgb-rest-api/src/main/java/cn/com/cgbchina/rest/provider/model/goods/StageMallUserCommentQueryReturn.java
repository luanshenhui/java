package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL320 用户点评(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallUserCommentQueryReturn extends BaseEntity implements Serializable {
	private String totalPages;
	private String totalCount;
	List<StageMallUserComment> Comments = new ArrayList<StageMallUserComment>();
}
