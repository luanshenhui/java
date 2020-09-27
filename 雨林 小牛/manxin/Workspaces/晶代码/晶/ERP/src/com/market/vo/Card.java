package com.market.vo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "card")
public class Card {

	/** serialVersionUID */
	protected static final long serialVersionUID = -1L;

	public Card() {

	}

	@Id
	@GeneratedValue(generator = "generator")
	@GenericGenerator(name = "generator", strategy = "increment")
	@Column(name = "ID")
	private Long id;
	@Column(name = "CARD_NO")
	private String cardNo;
	@Column(name = "CARD_TYPE")
	private String cardType;
	@Column(name = "MONEY")
	private Double money;
	@Column(name = "SCORE")
	private Long score;
	@Column(name = "MEMBER_ID")
	private String memberId;
	@Transient
	private String memberName;

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	/**
	 * @return Returns the Id.
	 */
	public Long getId() {
		return this.id;
	}

	/**
	 * @param id
	 *            Set the id.
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return Returns the CardNo.
	 */
	public String getCardNo() {
		return this.cardNo;
	}

	/**
	 * @param cardNo
	 *            Set the cardNo.
	 */
	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	/**
	 * @return Returns the CardType.
	 */
	public String getCardType() {
		return this.cardType;
	}

	/**
	 * @param cardType
	 *            Set the cardType.
	 */
	public void setCardType(String cardType) {
		this.cardType = cardType;
	}

	/**
	 * @return Returns the Money.
	 */
	public Double getMoney() {
		return this.money;
	}

	/**
	 * @param money
	 *            Set the money.
	 */
	public void setMoney(Double money) {
		this.money = money;
	}

	/**
	 * @return Returns the Score.
	 */
	public Long getScore() {
		return this.score;
	}

	/**
	 * @param score
	 *            Set the score.
	 */
	public void setScore(Long score) {
		this.score = score;
	}

	/**
	 * @return Returns the MemberId.
	 */
	public String getMemberId() {
		return this.memberId;
	}

	/**
	 * @param memberId
	 *            Set the memberId.
	 */
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

}
