package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Congzy
 */
public class UserPointDto implements Serializable {

	private static final long serialVersionUID = -2993082313676867635L;

	@Getter
	@Setter
	private String commonAmount;    //用户普通积分

	@Getter
	@Setter
	private String hopeAmount;  //用户希望积分

	@Getter
	@Setter
	private String truthAmount; //用户真情积分
}
