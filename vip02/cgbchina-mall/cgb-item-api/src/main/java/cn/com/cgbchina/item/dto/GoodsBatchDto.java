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
	private String approveType;
	@Getter
	@Setter
	private String approveResult;
	@Getter
	@Setter
	private String approveMemo;
	@Getter
	@Setter
	private String rate;
	@Getter
	@Setter
	private String cards;
	@Getter
	@Setter
	private String displayFlag;
	@Getter
	@Setter
	private String channel;

}
