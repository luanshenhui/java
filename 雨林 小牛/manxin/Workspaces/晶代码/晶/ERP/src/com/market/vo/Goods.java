package com.market.vo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "goods")
public class Goods {

	/** serialVersionUID */
	protected static final long serialVersionUID = -1L;

	public Goods() {

	}

	@Id
	@GeneratedValue(generator = "generator")
	@GenericGenerator(name = "generator", strategy = "increment")
	@Column(name = "ID")
	private Long id;
	@Column(name = "GOOD_NO")
	private String goodNo;
	@Column(name = "GOOD_NAME")
	private String goodName;
	@Column(name = "GOOD_TYPE")
	private String goodType;
	@Column(name = "BRAND")
	private String brand;
	@Column(name = "GOOD_STYLE")
	private String goodStyle;
	@Column(name = "GOOD_UNIT")
	private String goodUnit;
	@Column(name = "IN_COME")
	private Double inCome;
	@Column(name = "OUT_COME")
	private Double outCome;
	@Column(name = "FACTORY")
	private String factory;
	@Column(name = "REMARK")
	private String remark;
	@Column(name = "GOOD_NUM")
	private Long goodNum;

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
	 * @return Returns the GoodNo.
	 */
	public String getGoodNo() {
		return this.goodNo;
	}

	/**
	 * @param goodNo
	 *            Set the goodNo.
	 */
	public void setGoodNo(String goodNo) {
		this.goodNo = goodNo;
	}

	/**
	 * @return Returns the GoodName.
	 */
	public String getGoodName() {
		return this.goodName;
	}

	/**
	 * @param goodName
	 *            Set the goodName.
	 */
	public void setGoodName(String goodName) {
		this.goodName = goodName;
	}

	/**
	 * @return Returns the GoodType.
	 */
	public String getGoodType() {
		return this.goodType;
	}

	/**
	 * @param goodType
	 *            Set the goodType.
	 */
	public void setGoodType(String goodType) {
		this.goodType = goodType;
	}

	/**
	 * @return Returns the Brand.
	 */
	public String getBrand() {
		return this.brand;
	}

	/**
	 * @param brand
	 *            Set the brand.
	 */
	public void setBrand(String brand) {
		this.brand = brand;
	}

	/**
	 * @return Returns the GoodStyle.
	 */
	public String getGoodStyle() {
		return this.goodStyle;
	}

	/**
	 * @param goodStyle
	 *            Set the goodStyle.
	 */
	public void setGoodStyle(String goodStyle) {
		this.goodStyle = goodStyle;
	}

	/**
	 * @return Returns the GoodUnit.
	 */
	public String getGoodUnit() {
		return this.goodUnit;
	}

	/**
	 * @param goodUnit
	 *            Set the goodUnit.
	 */
	public void setGoodUnit(String goodUnit) {
		this.goodUnit = goodUnit;
	}

	/**
	 * @return Returns the InCome.
	 */
	public Double getInCome() {
		return this.inCome;
	}

	/**
	 * @param inCome
	 *            Set the inCome.
	 */
	public void setInCome(Double inCome) {
		this.inCome = inCome;
	}

	/**
	 * @return Returns the OutCome.
	 */
	public Double getOutCome() {
		return this.outCome;
	}

	/**
	 * @param outCome
	 *            Set the outCome.
	 */
	public void setOutCome(Double outCome) {
		this.outCome = outCome;
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

	/**
	 * @return Returns the GoodNum.
	 */
	public Long getGoodNum() {
		return this.goodNum;
	}

	/**
	 * @param goodNum
	 *            Set the goodNum.
	 */
	public void setGoodNum(Long goodNum) {
		this.goodNum = goodNum;
	}

}
