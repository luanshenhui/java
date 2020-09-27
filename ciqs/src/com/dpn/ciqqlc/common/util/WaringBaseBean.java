package com.dpn.ciqqlc.common.util;

public class WaringBaseBean {
	
	public WaringBaseBean(){
		
	}
	public WaringBaseBean(String procType,String fileType,String  procMainId,String urlParam,String portOrgCode){
		this.procType = procType;
		this.fileType = fileType;
		this.procMainId = procMainId;
		this.urlParam = urlParam;
		this.portOrgCode = portOrgCode;
	}
	//环节类型
	private String procType;
	
	private String fileType;
	
	//业务ID
	private String  procMainId;
	
	//参数
	private String urlParam;

	private String portOrgCode;
	
	public String getPortOrgCode() {
		return portOrgCode;
	}

	public void setPortOrgCode(String portOrgCode) {
		this.portOrgCode = portOrgCode;
	}

	public String getProcType() {
		return procType;
	}

	public void setProcType(String procType) {
		this.procType = procType;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getProcMainId() {
		return procMainId;
	}

	public void setProcMainId(String procMainId) {
		this.procMainId = procMainId;
	}

	public String getUrlParam() {
		return urlParam;
	}

	public void setUrlParam(String urlParam) {
		this.urlParam = urlParam;
	}
	
	
}
