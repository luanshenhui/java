package cn.com.cgbchina.rest.provider.vo.user;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;
import com.google.common.collect.Lists;

import java.util.List;

/**
 * MAL323 客户信息查询
 * 
 * @author lizy 2016/4/28.
 */
public class CustInfoVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4190271749944806055L;
	@NotNull
	private String origin;
	@NotNull
	private String custId;
	@NotNull
	private String certNo;
	private String isVip;
	private String birthDay;

	private List<CustInfoItem> cardList = Lists.newArrayList();

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getCertNo() {
		return certNo;
	}

	public void setCertNo(String certNo) {
		this.certNo = certNo;
	}

	public String getIsVip() {
		return isVip;
	}

	public void setIsVip(String isVip) {
		this.isVip = isVip;
	}

	public String getBirthDay() {
		return birthDay;
	}

	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}

	public List<CustInfoItem> getCardList() {
		return cardList;
	}

	public void setCardList(List<CustInfoItem> cardList) {
		this.cardList = cardList;
	}
}
