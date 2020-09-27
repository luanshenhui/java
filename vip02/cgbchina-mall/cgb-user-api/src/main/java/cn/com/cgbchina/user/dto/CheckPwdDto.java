package cn.com.cgbchina.user.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by wusy on 2016/5/19.
 */
public class CheckPwdDto implements Serializable {

	private static final long serialVersionUID = 5156536940999879195L;
	@Setter
	@Getter
	private String certNo;
	@Setter
	@Getter
	private String accountNo;
	@Setter
	@Getter
	private String certType;
	@Setter
	@Getter
	private String customerName;
	@Setter
	@Getter
	private String phoneNo;
	@Setter
	@Getter
	private String mobileNo;
	@Setter
	@Getter
	private String email;
	@Setter
	@Getter
	private String transferFlowNo;

}
