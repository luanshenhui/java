package cn.com.cgbchina.rest.visit.model.order;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class SecureOrder implements Serializable {
	private static final long serialVersionUID = 3253136533291079565L;
	@NotNull
	private String serialno;
	@NotNull
	private String identify;

	public String getSerialno() {
		return serialno;
	}

	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}

	public String getIdentify() {
		return identify;
	}

	public void setIdentify(String identify) {
		this.identify = identify;
	}
}
