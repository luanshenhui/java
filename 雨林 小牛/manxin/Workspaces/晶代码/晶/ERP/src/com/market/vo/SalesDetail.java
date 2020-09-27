package com.market.vo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "sales_detail")
public class SalesDetail {

	/** serialVersionUID */
	protected static final long serialVersionUID = -1L;

	public SalesDetail() {

	}

	@Id
	@GeneratedValue(generator = "generator")
	@GenericGenerator(name = "generator", strategy = "increment")
	@Column(name = "ID")
	private Long id;
	@Column(name = "SALES_ID")
	private Long salesId;
	@Column(name = "GOODS_ID")
	private Long goodsId;
	@Column(name = "NUM")
	private Long num;
	@Column(name = "MONEY")
	private Double money;
	@Column(name = "GOODS_NAME")
	private String goodsName;
	@Column(name = "PRICE")
	private Double price;

	@Transient
	private Date startDate;

	@Transient
	private Date endDate;
	@Transient
	private Date salesDate;
	@Transient
	private String memberName;
	@Transient
	private String goodNo;
	@Transient
	private String goodType;
	@Transient
	private String brand;
	@Transient
	private Double inCome;
	@Transient
	private Double outCome;
	@Transient
	private Long goodNum;

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
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
	 * @return Returns the SalesId.
	 */
	public Long getSalesId() {
		return this.salesId;
	}

	/**
	 * @param salesId
	 *            Set the salesId.
	 */
	public void setSalesId(Long salesId) {
		this.salesId = salesId;
	}

	/**
	 * @return Returns the GoodsId.
	 */
	public Long getGoodsId() {
		return this.goodsId;
	}

	/**
	 * @param goodsId
	 *            Set the goodsId.
	 */
	public void setGoodsId(Long goodsId) {
		this.goodsId = goodsId;
	}

	/**
	 * @return Returns the Num.
	 */
	public Long getNum() {
		return this.num;
	}

	/**
	 * @param num
	 *            Set the num.
	 */
	public void setNum(Long num) {
		this.num = num;
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

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public Date getSalesDate() {
		return salesDate;
	}

	public void setSalesDate(Date salesDate) {
		this.salesDate = salesDate;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getGoodNo() {
		return goodNo;
	}

	public void setGoodNo(String goodNo) {
		this.goodNo = goodNo;
	}

	public String getGoodType() {
		return goodType;
	}

	public void setGoodType(String goodType) {
		this.goodType = goodType;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public Double getInCome() {
		return inCome;
	}

	public void setInCome(Double inCome) {
		this.inCome = inCome;
	}

	public Double getOutCome() {
		return outCome;
	}

	public void setOutCome(Double outCome) {
		this.outCome = outCome;
	}

	public Long getGoodNum() {
		return goodNum;
	}

	public void setGoodNum(Long goodNum) {
		this.goodNum = goodNum;
	}

}
