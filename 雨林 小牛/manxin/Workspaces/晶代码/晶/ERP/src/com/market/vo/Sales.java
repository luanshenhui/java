package com.market.vo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "sales")
public class Sales {

	/** serialVersionUID */
	protected static final long serialVersionUID = -1L;

	public Sales() {

	}

	@Id
	@GeneratedValue(generator = "generator")
	@GenericGenerator(name = "generator", strategy = "increment")
	@Column(name = "ID")
	private Long id;
	@Column(name = "MEMBER_NO")
	private String memberNo;
	@Column(name = "MEMBER_NAME")
	private String memberName;
	@Column(name = "SALES_DATE")
	private Date salesDate;
	@Column(name = "EMPLOYEE")
	private String employee;
	@Column(name = "TOTAL_MONEY")
	private Double totalMoney;
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
	 * @return Returns the MemberNo.
	 */
	public String getMemberNo() {
		return this.memberNo;
	}

	/**
	 * @param memberNo
	 *            Set the memberNo.
	 */
	public void setMemberNo(String memberNo) {
		this.memberNo = memberNo;
	}

	/**
	 * @return Returns the MemberName.
	 */
	public String getMemberName() {
		return this.memberName;
	}

	/**
	 * @param memberName
	 *            Set the memberName.
	 */
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	/**
	 * @return Returns the SalesDate.
	 */
	public Date getSalesDate() {
		return this.salesDate;
	}

	/**
	 * @param salesDate
	 *            Set the salesDate.
	 */
	public void setSalesDate(Date salesDate) {
		this.salesDate = salesDate;
	}

	/**
	 * @return Returns the Employee.
	 */
	public String getEmployee() {
		return this.employee;
	}

	/**
	 * @param employee
	 *            Set the employee.
	 */
	public void setEmployee(String employee) {
		this.employee = employee;
	}

	/**
	 * @return Returns the TotalMoney.
	 */
	public Double getTotalMoney() {
		return this.totalMoney;
	}

	/**
	 * @param totalMoney
	 *            Set the totalMoney.
	 */
	public void setTotalMoney(Double totalMoney) {
		this.totalMoney = totalMoney;
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
