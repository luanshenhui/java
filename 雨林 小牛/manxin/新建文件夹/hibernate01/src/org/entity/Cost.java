package org.entity;

import java.io.Serializable;
import java.sql.Date;

public class Cost implements Serializable{
	
	private static final long serialVersionUID = 1L;
	private Integer id;
	private String name;
	private Integer baseDuration;
	private Double baseCost;
	private Double unitCost;
	private String status;
	private String descr;
	private Date createTime;
	private Date startTime;
	private String costType;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getBaseDuration() {
		return baseDuration;
	}
	public void setBaseDuration(Integer baseDuration) {
		this.baseDuration = baseDuration;
	}
	public Double getBaseCost() {
		return baseCost;
	}
	public void setBaseCost(Double baseCost) {
		this.baseCost = baseCost;
	}
	public Double getUnitCost() {
		return unitCost;
	}
	public void setUnitCost(Double unitCost) {
		this.unitCost = unitCost;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getDescr() {
		return descr;
	}
	public void setDescr(String descr) {
		this.descr = descr;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Date getStartTime() {
		return startTime;
	}
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
	public String getCostType() {
		return costType;
	}
	public void setCostType(String costType) {
		this.costType = costType;
	}
	@Override
	public String toString() {
		return "Cost [baseCost=" + baseCost + ", baseDuration=" + baseDuration
				+ ", costType=" + costType + ", createTime=" + createTime
				+ ", descr=" + descr + ", id=" + id + ", name=" + name
				+ ", startTime=" + startTime + ", status=" + status
				+ ", unitCost=" + unitCost + "]";
	}
	
}
