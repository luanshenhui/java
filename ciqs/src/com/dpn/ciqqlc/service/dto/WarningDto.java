package com.dpn.ciqqlc.service.dto;

import java.util.List;

import com.dpn.ciqqlc.standard.model.WarningEventDto;

public class WarningDto {
	
	public WarningDto(){
		
	}
	public WarningDto(String businessType,String businessName){
		this.businessName = businessName;
		this.businessType = businessType;
	}
	private String businessType;
	
	private String businessName;
	
	private String warningId;
	
	private String warningNo;
	
	private String partnerCode;
	
	private String partnerName;
	
	private String departmentCode;
	
	private String departmentName;
	
	List<WarningEventDto> eventDtoList;

	public String getBusinessType() {
		return businessType;
	}

	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}

	public String getBusinessName() {
		return businessName;
	}

	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}

	public String getWarningId() {
		return warningId;
	}

	public void setWarningId(String warningId) {
		this.warningId = warningId;
	}

	public String getWarningNo() {
		return warningNo;
	}

	public void setWarningNo(String warningNo) {
		this.warningNo = warningNo;
	}

	public String getPartnerCode() {
		return partnerCode;
	}

	public void setPartnerCode(String partnerCode) {
		this.partnerCode = partnerCode;
	}

	public String getPartnerName() {
		return partnerName;
	}

	public void setPartnerName(String partnerName) {
		this.partnerName = partnerName;
	}

	public String getDepartmentCode() {
		return departmentCode;
	}

	public void setDepartmentCode(String departmentCode) {
		this.departmentCode = departmentCode;
	}

	public String getDepartmentName() {
		return departmentName;
	}

	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}

	public List<WarningEventDto> getEventDtoList() {
		return eventDtoList;
	}

	public void setEventDtoList(List<WarningEventDto> eventDtoList) {
		this.eventDtoList = eventDtoList;
	}
	
}
