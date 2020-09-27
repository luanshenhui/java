package com.lsh.dlrc.domain;

import java.util.Date;

import org.apache.commons.net.ntp.TimeStamp;

public class Post {
	private float postId;
	private float forumId;
	private float userId;
	private String postTitle;
	private String postContent;
	private Date postTime;
	private float totalCommentCount;
	public float getPostId() {
		return postId;
	}
	public void setPostId(float postId) {
		this.postId = postId;
	}
	public float getForumId() {
		return forumId;
	}
	public void setForumId(float forumId) {
		this.forumId = forumId;
	}
	public float getUserId() {
		return userId;
	}
	public void setUserId(float userId) {
		this.userId = userId;
	}
	public String getPostTitle() {
		return postTitle;
	}
	public void setPostTitle(String postTitle) {
		this.postTitle = postTitle;
	}
	public String getPostContent() {
		return postContent;
	}
	public void setPostContent(String postContent) {
		this.postContent = postContent;
	}

	public Date getPostTime() {
		return postTime;
	}
	public void setPostTime(Date postTime) {
		this.postTime = postTime;
	}
	public float getTotalCommentCount() {
		return totalCommentCount;
	}
	public void setTotalCommentCount(float totalCommentCount) {
		this.totalCommentCount = totalCommentCount;
	}
	@Override
	public String toString() {
		return "Post [postId=" + postId + ", forumId=" + forumId + ", userId=" + userId + ", postTitle=" + postTitle
				+ ", postContent=" + postContent + ", postTime=" + postTime + ", totalCommentCount=" + totalCommentCount
				+ "]";
	}


}
