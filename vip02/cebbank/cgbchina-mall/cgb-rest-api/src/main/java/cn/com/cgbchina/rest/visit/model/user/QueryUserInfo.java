package cn.com.cgbchina.rest.visit.model.user;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

public class QueryUserInfo implements Serializable {
	private static final long serialVersionUID = -8786323926863124429L;
	@NotNull
	private String certNo;

	public String getCertNo() {
		return certNo;
	}

	public void setCertNo(String certNo) {
		this.certNo = certNo;
	}

}
