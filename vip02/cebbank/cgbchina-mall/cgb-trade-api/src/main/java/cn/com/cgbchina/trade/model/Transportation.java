package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by 11141021040453 on 16-4-15.
 */
public class Transportation implements Serializable {
	private static final long serialVersionUID = 2513059221486538884L;

	@Getter
	@Setter
	private String id;// 物流ID

	@Getter
	@Setter
	private Date time;// 发货时间

	@Getter
	@Setter
	private String code;// 兑换码

	@Getter
	@Setter
	private String company;// 物流公司
}
