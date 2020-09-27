package cn.com.cgbchina.rest.provider.vo.user;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;
import com.google.common.collect.Lists;

import java.util.List;

/**
 * MAL323 客户信息查询
 * 
 * @author lizy 2016/4/28.
 */
public class CustInfoQueryReturnVO extends BaseEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3404853584817626427L;
	private String custLevel;
	private String brthDate;
	private String brthTimes;
	/**
	 * 卡片列表
	 */
	private List<CustInfoQueryCardItem> cardList = Lists.newArrayList();

	public String getCustLevel() {
		return custLevel;
	}

	public void setCustLevel(String custLevel) {
		this.custLevel = custLevel;
	}

	public String getBrthDate() {
		return brthDate;
	}

	public void setBrthDate(String brthDate) {
		this.brthDate = brthDate;
	}

	public String getBrthTimes() {
		return brthTimes;
	}

	public void setBrthTimes(String brthTimes) {
		this.brthTimes = brthTimes;
	}

	public List<CustInfoQueryCardItem> getCardList() {
		return cardList;
	}

	public void setCardList(List<CustInfoQueryCardItem> cardList) {
		this.cardList = cardList;
	}
}
