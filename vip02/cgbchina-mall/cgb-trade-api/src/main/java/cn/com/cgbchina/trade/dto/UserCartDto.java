package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Created by Cong on 16-4-28.
 */
public class UserCartDto implements Serializable {

	private static final long serialVersionUID = -5130686248412262111L;
	@Getter
	@Setter
	private String branchNo;

	@Getter
	@Setter
	private String cardNo;

	@Getter
	@Setter
	private Integer cardType;

}
