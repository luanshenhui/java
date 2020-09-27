package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL320 用户点评(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallUserComment extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 2105470799189782438L;
	private String goodsId;
	private String commentTitle;
	private String commentContent;
	private String commentLvl;
	private String custId;

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getCommentTitle() {
		return commentTitle;
	}

	public void setCommentTitle(String commentTitle) {
		this.commentTitle = commentTitle;
	}

	public String getCommentContent() {
		return commentContent;
	}

	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}

	public String getCommentLvl() {
		return commentLvl;
	}

	public void setCommentLvl(String commentLvl) {
		this.commentLvl = commentLvl;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

}
