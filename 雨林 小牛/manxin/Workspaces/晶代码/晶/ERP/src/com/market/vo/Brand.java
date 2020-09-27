package com.market.vo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "brand")
public class Brand {

	/** serialVersionUID */
	protected static final long serialVersionUID = -1L;

	public Brand() {

	}

	@Id
	@GeneratedValue(generator = "generator")
	@GenericGenerator(name = "generator", strategy = "increment")
	@Column(name = "ID")
	private Long id;
	@Column(name = "NUM")
	private String num;
	@Column(name = "NAME")
	private String name;
	@Column(name = "FACTORY")
	private String factory;
	@Column(name = "PHONE")
	private String phone;
	@Column(name = "ADDRESS")
	private String address;
	@Column(name = "REMARK")
	private String remark;

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
	 * @return Returns the Num.
	 */
	public String getNum() {
		return this.num;
	}

	/**
	 * @param num
	 *            Set the num.
	 */
	public void setNum(String num) {
		this.num = num;
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
	 * @return Returns the Factory.
	 */
	public String getFactory() {
		return this.factory;
	}

	/**
	 * @param factory
	 *            Set the factory.
	 */
	public void setFactory(String factory) {
		this.factory = factory;
	}

	/**
	 * @return Returns the Phone.
	 */
	public String getPhone() {
		return this.phone;
	}

	/**
	 * @param phone
	 *            Set the phone.
	 */
	public void setPhone(String phone) {
		this.phone = phone;
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

	/**
	 * @return Returns the Remark.
	 */
	public String getRemark() {
		return this.remark;
	}

	/**
	 * @param remark
	 *            Set the remark.
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}

}
