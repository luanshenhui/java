package cn.com.cgbchina.rest.provider.vo.user;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL323 客户信息查询-卡片列表
 * 
 * @author geshuo 20160721
 */
public class CustInfoItem extends BaseQueryEntity {

	private static final long serialVersionUID = -4237044567996884827L;
	private String cardNo;//卡号
	private String formatId;//卡板代码
	private String cardLevel;//卡等级

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getFormatId() {
		return formatId;
	}

	public void setFormatId(String formatId) {
		this.formatId = formatId;
	}

	public String getCardLevel() {
		return cardLevel;
	}

	public void setCardLevel(String cardLevel) {
		this.cardLevel = cardLevel;
	}

}
