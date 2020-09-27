package cn.com.cgbchina.rest.visit.model.coupon;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ActivateCouponInfo extends BaseQuery implements Serializable {
	private static final long serialVersionUID = 310891365129399860L;
	@NotNull
	private String channel;
	@XMLNodeName(value = "cont_id_type")
	private String contIdType;
	@NotNull
	@XMLNodeName(value = "cont_idcard")
	private String contIdCard;
	@NotNull
	private String activation;

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

	public String getActivation() {
		return activation;
	}

	public void setActivation(String activation) {
		this.activation = activation;
	}
}
