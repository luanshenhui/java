package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderSubModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * Created by 张成 on 16-4-28.
 */
public class CartDto implements Serializable {

	private static final long serialVersionUID = 7831708519174827609L;

	@Getter
	@Setter
	private String itemCode;

	@Getter
	@Setter
	private Integer itemCount;

	@Getter
	@Setter
	private String payType;

	@Getter
	@Setter
	private String instalments;

	@Getter
	@Setter
	private BigDecimal price;

	@Getter
	@Setter
	private String UsableIntegral;//	使用积分

	@Getter
	@Setter
	private String IntegralType; //积分类型

	@Getter
	@Setter
	private String favourableTicketId; //优惠券ID

	@Getter
	@Setter
	private String favourableTicketName; //优惠券名称

	@Getter
	@Setter
	private String favourableTicketPrice; //优惠价价格

}
