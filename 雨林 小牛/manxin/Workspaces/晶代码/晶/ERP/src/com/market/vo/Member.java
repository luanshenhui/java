package com.market.vo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;
import java.util.Date;

@Entity
@Table(name = "member")
public class Member {

	/** serialVersionUID */
	protected static final long serialVersionUID = -1L;

	public Member() {

	}

	@Id
	@GeneratedValue(generator = "generator")
	@GenericGenerator(name = "generator", strategy = "increment")
	@Column(name = "ID")
	private Long id;
	@Column(name = "NAME")
	private String name;
	@Column(name = "SEX")
	private String sex;
	@Column(name = "IDNO")
	private String idno;
	@Column(name = "BIRTHDAY")
	private Date birthday;
	@Column(name = "TELPHONE")
	private String telphone;
	@Column(name = "ADDRESS")
	private String address;
	@Column(name = "CARD_NO")
	private String cardNo;

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
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
	 * @return Returns the Name.
	 */
	public String getName() {
		return this.name;
	}

	/**
	 * @param name
	 *            Set the name.
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return Returns the Sex.
	 */
	public String getSex() {
		return this.sex;
	}

	/**
	 * @param sex
	 *            Set the sex.
	 */
	public void setSex(String sex) {
		this.sex = sex;
	}

	/**
	 * @return Returns the Idno.
	 */
	public String getIdno() {
		return this.idno;
	}

	/**
	 * @param idno
	 *            Set the idno.
	 */
	public void setIdno(String idno) {
		this.idno = idno;
	}

	/**
	 * @return Returns the Birthday.
	 */
	public Date getBirthday() {
		return this.birthday;
	}

	/**
	 * @param birthday
	 *            Set the birthday.
	 */
	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

	/**
	 * @return Returns the Telphone.
	 */
	public String getTelphone() {
		return this.telphone;
	}

	/**
	 * @param telphone
	 *            Set the telphone.
	 */
	public void setTelphone(String telphone) {
		this.telphone = telphone;
	}

	/**
	 * @return Returns the Address.
	 */
	public String getAddress() {
		return this.address;
	}

	/**
	 * @param address
	 *            Set the address.
	 */
	public void setAddress(String address) {
		this.address = address;
	}

}
