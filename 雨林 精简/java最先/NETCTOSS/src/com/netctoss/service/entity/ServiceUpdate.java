package com.netctoss.service.entity;

public class ServiceUpdate {
	private int id;
	private int serviceId;
	private int costId;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getServiceId() {
		return serviceId;
	}
	public void setServiceId(int serviceId) {
		this.serviceId = serviceId;
	}
	public int getCostId() {
		return costId;
	}
	public void setCostId(int costId) {
		this.costId = costId;
	}
	@Override
	public String toString() {
		return "ServiceUpdate [costId=" + costId + ", id=" + id
				+ ", serviceId=" + serviceId + "]";
	}
	
}
