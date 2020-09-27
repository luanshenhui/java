package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderSubModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 张成 on 16-4-28.
 */
public class OrderSubDto extends OrderSubModel implements Serializable {

	private static final long serialVersionUID = 7831708519174827609L;

	@Getter
	@Setter
	private String bpsErrorcode; //bps错误码  数据库没此字段，只作为临时保存数据用

	@Getter
	@Setter
	private String approveResult;//bps返回码  数据库没此字段，只作为临时保存数据
}
