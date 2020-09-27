package cn.com.cgbchina.user.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by wusy on 2016/5/19.
 */
public class LoginSettingDto implements Serializable {

	private static final long serialVersionUID = 5156536940999879195L;
	@Setter
	@Getter
	private String accPassword;
	@Setter
	@Getter
	private String accountNo;
	@Setter
	@Getter
	private String email;
	@Setter
	@Getter
	private String transferFlowNo;
	@Setter
	@Getter
	private String phoneNo;
	@Setter
	@Getter
	private String mobileNo;

}
