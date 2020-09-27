package cn.com.cgbchina.rest.visit.vo.point;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PointTypeQueryVO extends PointTypeInfoVO implements Serializable {
	private String channelID;
	private String currentPage;// 默认填写1，表示请求第一页
	private String midID;// 转接系统标识
	private String midTime;// 转接系统时间
	private String midSN;// 转接系统流水号
	private String midTag;// 节点机保留标识
	private String jgId;// 不输入表示默认所有都符合
	@XMLNodeName("jg_type")
	private String jgType;// 不输入表示默认所有都符合
	@XMLNodeName("is_adjectivel")
	private String isAdjectivel;// 0表示正常；1表示停用

	public String getMidID() {
		return midID;
	}

	public void setMidID(String midID) {
		this.midID = midID;
	}

	public String getMidTime() {
		return midTime;
	}

	public void setMidTime(String midTime) {
		this.midTime = midTime;
	}

	public String getMidSN() {
		return midSN;
	}

	public void setMidSN(String midSN) {
		this.midSN = midSN;
	}

	public String getMidTag() {
		return midTag;
	}

	public void setMidTag(String midTag) {
		this.midTag = midTag;
	}

	public String getJgId() {
		return jgId;
	}

	public void setJgId(String jgId) {
		this.jgId = jgId;
	}

	public String getJgType() {
		return jgType;
	}

	public void setJgType(String jgType) {
		this.jgType = jgType;
	}

	public String getIsAdjectivel() {
		return isAdjectivel;
	}

	public void setIsAdjectivel(String isAdjectivel) {
		this.isAdjectivel = isAdjectivel;
	}

	public String getChannelID() {
		return channelID;
	}

	public void setChannelID(String channelID) {
		this.channelID = channelID;
	}

	public String getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(String currentPage) {
		this.currentPage = currentPage;
	}
}
