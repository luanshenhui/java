package chinsoft.entity;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="OrdenLade")
@XmlAccessorType(XmlAccessType.FIELD)
public class BlOrdenLadeXmlBean {

	/**
	 * 订单号
	 */
	@XmlElement(name="OrdenIds")
	private String ordenIds;
	
	/**
	 * 用户编号
	 */
	@XmlElement(name="MemberId")
	private String memberId;
	
	/**
	 * 用户名
	 */
	@XmlElement(name="MemberName")
	private String memberName;
	
	/**
	 * 货币类型
	 */
	@XmlElement(name="MoneySignId")
	private Integer moneySignId;

	/**
	 * 货币类型名称
	 */
	@XmlElement(name="MoneySignName")
	private String moneySignName;
	
	public String getOrdenIds() {
		return ordenIds;
	}

	public void setOrdenIds(String ordenIds) {
		this.ordenIds = ordenIds;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public Integer getMoneySignId() {
		return moneySignId;
	}

	public void setMoneySignId(Integer moneySignId) {
		this.moneySignId = moneySignId;
	}

	public String getMoneySignName() {
		return moneySignName;
	}

	public void setMoneySignName(String moneySignName) {
		this.moneySignName = moneySignName;
	}
}