package cn.com.cgbchina.item.dto;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Created by niufw on 16-5-31.
 */
public class CouponScaleDto implements Serializable{

	private static final long serialVersionUID = -2017899585223980361L;
	private java.math.BigDecimal commonCard;// 普卡/金卡

	public BigDecimal getCommonCard() {
		return commonCard;
	}

	public void setCommonCard(BigDecimal commonCard) {
		this.commonCard = commonCard;
	}

	private java.math.BigDecimal platinumCard;// 钛金卡/臻享白金卡

	public BigDecimal getPlatinumCard() {
		return platinumCard;
	}

	public void setPlatinumCard(BigDecimal platinumCard) {
		this.platinumCard = platinumCard;
	}

	private java.math.BigDecimal topCard;// 顶级/增值白金卡

	public BigDecimal getTopCard() {
		return topCard;
	}

	public void setTopCard(BigDecimal topCard) {
		this.topCard = topCard;
	}

	private java.math.BigDecimal VIP;// VIP

	public BigDecimal getVIP() {
		return VIP;
	}

	public void setVIP(BigDecimal VIP) {
		this.VIP = VIP;
	}

	private java.math.BigDecimal birthday;// 生日

	public BigDecimal getBirthday() {
		return birthday;
	}

	public void setBirthday(BigDecimal birthday) {
		this.birthday = birthday;
	}

	private String modifyOper;// 更新人

	public String getModifyOper() {
		return modifyOper;
	}

	public void setModifyOper(String modifyOper) {
		this.modifyOper = modifyOper;
	}
}
