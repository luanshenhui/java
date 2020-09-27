package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL320 用户点评(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallUserCommentVO extends BaseEntityVO implements Serializable {

	private static final long serialVersionUID = 2105470799189782438L;
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@XMLNodeName(value = "comment_title")
	private String commentTitle;
	@XMLNodeName(value = "comment_content")
	private String commentContent;
	@XMLNodeName(value = "comment_lvl")
	private String commentLvl;
	@XMLNodeName(value = "cust_id")
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
