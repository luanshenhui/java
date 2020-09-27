package cn.com.cgbchina.item.dto;

import com.spirit.user.User;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class GoodsBatchDto implements Serializable {

	private static final long serialVersionUID = -6892453773708255491L;
	@Getter
	@Setter
	private String code;
	@Getter
	@Setter
	private String approveStatus;
	@Getter
	@Setter
	private String operate;
	@Getter
	@Setter
	private String memo;
	@Getter
	@Setter
	private User user;

}
