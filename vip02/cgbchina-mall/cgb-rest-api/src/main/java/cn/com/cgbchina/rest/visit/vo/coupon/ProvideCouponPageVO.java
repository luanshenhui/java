package cn.com.cgbchina.rest.visit.vo.coupon;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ProvideCouponPageVO extends BaseQueryVo implements Serializable {
	private String channel;
	@XMLNodeName("cont_id_type")
	private String contIdType;
	@XMLNodeName("cont_idcard")
	private String contIdCard;
	private String projectNO;
	private String sProjectNO;
	private String grantType;
	private Integer num;

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}

	public String getContIdType() {
		return contIdType;
	}

	public void setContIdType(String contIdType) {
		this.contIdType = contIdType;
	}

	public String getContIdCard() {
		return contIdCard;
	}

	public void setContIdCard(String contIdCard) {
		this.contIdCard = contIdCard;
	}

	public String getProjectNO() {
		return projectNO;
	}

	public void setProjectNO(String projectNO) {
		this.projectNO = projectNO;
	}

	public String getSProjectNO() {
		return sProjectNO;
	}

	public void setSProjectNO(String sProjectNO) {
		this.sProjectNO = sProjectNO;
	}

	public String getGrantType() {
		return grantType;
	}

	public void setGrantType(String grantType) {
		this.grantType = grantType;
	}

	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
}
