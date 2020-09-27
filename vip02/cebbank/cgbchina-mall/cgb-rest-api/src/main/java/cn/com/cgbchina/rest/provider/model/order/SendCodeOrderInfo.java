package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * 发码（购票）成功通知接口
 * 
 * @author lizy
 *
 */
public class SendCodeOrderInfo extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1950519867371751969L;
	private String suborderno;
	private String codedata;
	private String fileurl;

	public String getSuborderno() {
		return suborderno;
	}

	public void setSuborderno(String suborderno) {
		this.suborderno = suborderno;
	}

	public String getCodedata() {
		return codedata;
	}

	public void setCodedata(String codedata) {
		this.codedata = codedata;
	}

	public String getFileurl() {
		return fileurl;
	}

	public void setFileurl(String fileurl) {
		this.fileurl = fileurl;
	}

}
