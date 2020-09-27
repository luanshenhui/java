package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import org.joda.time.DateTime;

import java.io.Serializable;

/**
 *	日期		:	2016-7-8<br>
 *	作者		:	lizeyuan<br>
 *	项目		:	cgb-trade-api<br>
 *	功能		:	继承子订单、包含虚拟物品扩展表信息（OrderVirtualModel） 还有物流信息(OrderTransModel)
 */
public class OrderSubModelVirtualExtend extends OrderSubModel {
	@Getter
	@Setter
	 private OrderVirtualModel orderVirtualModel; 
	@Getter
	@Setter
	private OrderTransModel orderTransModel;
}