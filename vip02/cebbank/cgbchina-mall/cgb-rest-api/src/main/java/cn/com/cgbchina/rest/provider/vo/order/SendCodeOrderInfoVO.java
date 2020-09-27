package cn.com.cgbchina.rest.provider.vo.order;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

public class SendCodeOrderInfoVO {
	@NotNull
	@XMLNodeName(value = "suborderno")
	private String subOrderNo;

	@NotNull
	@XMLNodeName(value = "codedata")
	private String codeData;

	@NotNull
	@XMLNodeName(value = "fileurl")
	private String fileUrl;

	public String getSubOrderNo() {
		return subOrderNo;
	}

	public void setSubOrderNo(String subOrderNo) {
		this.subOrderNo = subOrderNo;
	}

	public String getCodeData() {
		return codeData;
	}

	public void setCodeData(String codeData) {
		this.codeData = codeData;
	}

	public String getFileUrl() {
		return fileUrl;
	}

	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}

}
