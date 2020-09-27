package cn.com.cgbchina.rest.common.model;

import lombok.Getter;
import lombok.Setter;

public class O2OEncryptModel {
	private String vendor;
	private String url;
	@Setter
	@Getter
	private byte[] publicKey;

	public String getVendor() {
		return vendor;
	}

	public void setVendor(String vendor) {
		this.vendor = vendor;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

}
