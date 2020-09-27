package cn.com.cgbchina.rest.visit.vo.point;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PointTypeQueryVO extends PointTypeInfoVO implements Serializable {
	private String channelID;
	private String currentPage;// Ĭ����д1����ʾ�����һҳ
	private String midID;// ת��ϵͳ��ʶ
	private String midTime;// ת��ϵͳʱ��
	private String midSN;// ת��ϵͳ��ˮ��
	private String midTag;// �ڵ��������ʶ
	private String jgId;// �������ʾĬ�����ж�����
	@XMLNodeName("jg_type")
	private String jgType;// �������ʾĬ�����ж�����
	@XMLNodeName("is_adjectivel")
	private String isAdjectivel;// 0��ʾ������1��ʾͣ��

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
