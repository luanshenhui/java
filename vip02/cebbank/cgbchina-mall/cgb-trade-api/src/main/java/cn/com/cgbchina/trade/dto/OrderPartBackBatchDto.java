package cn.com.cgbchina.trade.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 报表 部分退货信息
 * 
 * @author xiewl
 * @version 2016年6月23日 下午2:16:39
 */
public class OrderPartBackBatchDto implements Serializable {
	private static final long serialVersionUID = 5724311270524204316L;
	@Getter
	@Setter
	private String orderId;// 订单号
	@Getter
	@Setter
	private String goodsName;// 商品名称
	@Getter
	@Setter
	private String goodsId;// 商品id
	@Getter
	@Setter
	private String vendorName;// 供应商
	@Getter
	@Setter
	private Integer goodsNum;// 退货商品数量

	/**
	 * 是否为生日(商品退货报表)
	 */
	@Getter
	@Setter
	private String isBirthDay;
}
