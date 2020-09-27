package cn.com.cgbchina.rest.visit.model;

import com.google.common.base.Objects;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class BaseResult implements Serializable {

	private static final long serialVersionUID = -5867898441514570308L;

	@NotNull
	private String retCode;
	private String retErrMsg;
	public String getRetCode() {
		return retCode;
	}

	public void setRetCode(String retCode) {
		this.retCode = retCode;
	}

	public String getRetErrMsg() {
		return retErrMsg;
	}

	public void setRetErrMsg(String retErrMsg) {
		this.retErrMsg = retErrMsg;
	}

	public static enum ResultCode {
		SUCCESS("00", "正常处理"), FAILED("01", "其他失败");

		private String value;
		private String display;

		private ResultCode(String value, String display) {
			this.value = value;
			this.display = display;
		}

		public String value() {
			return value;
		}

		public static ResultCode fromNumber(String value) {
			for (ResultCode status : ResultCode.values()) {
				if (Objects.equal(status.value, value)) {
					return status;
				}
			}
			return null;
		}
	}

}
