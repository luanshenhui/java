package cn.com.cgbchina.trade.model;

import java.util.List;

import cn.com.cgbchina.trade.dto.OrderDetailDto;

import lombok.Getter;
import lombok.Setter;

public class OrderDetailDtoExtend extends OrderDetailDto {
	@Getter
	@Setter
	private List<OrderSubModelVirtualExtend> orderSubModelVirtualExtends;//查询返回的子订单信息
 
}