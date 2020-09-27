package cn.com.cgbchina.related.dto;

import java.io.Serializable;

/**
 * Created by yuxinxin on 16-6-8.
 */
public class LocalProcodeDto implements Serializable {

	private static final long serialVersionUID = -2483994504130319319L;
	private boolean proCodeCheck;

	public boolean isProCodeCheck() {
		return proCodeCheck;
	}

	public void setProCodeCheck(boolean proCodeCheck) {
		this.proCodeCheck = proCodeCheck;
	}

	public boolean isProNmCheck() {
		return proNmCheck;
	}

	public void setProNmCheck(boolean proNmCheck) {
		this.proNmCheck = proNmCheck;
	}

	private boolean proNmCheck;
}
