package com.market.vo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;
import java.util.Date;

@Entity
@Table(name = "stock")
public class Stock {

	/** serialVersionUID */
	protected static final long serialVersionUID = -1L;

	public Stock() {

	}

	@Id
	@GeneratedValue(generator = "generator")
	@GenericGenerator(name = "generator", strategy = "increment")
	@Column(name = "ID")
	private Long id;
	@Column(name = "STOCK_NO")
	private String stockNo;
	@Column(name = "STOCK_DATE")
	private Date stockDate;
	@Column(name = "MEMBER")
	private String member;
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
	 * @return Returns the StockNo.
	 */
	public String getStockNo() {
		return this.stockNo;
	}

	/**
	 * @param stockNo
	 *            Set the stockNo.
	 */
	public void setStockNo(String stockNo) {
		this.stockNo = stockNo;
	}

	/**
	 * @return Returns the StockDate.
	 */
	public Date getStockDate() {
		return this.stockDate;
	}

	/**
	 * @param stockDate
	 *            Set the stockDate.
	 */
	public void setStockDate(Date stockDate) {
		this.stockDate = stockDate;
	}

	/**
	 * @return Returns the Member.
	 */
	public String getMember() {
		return this.member;
	}

	/**
	 * @param member
	 *            Set the member.
	 */
	public void setMember(String member) {
		this.member = member;
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
