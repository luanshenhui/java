package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.trade.dto.OrderCommitSubmitDto;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderSubDetailDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;

import com.spirit.common.model.Response;
import com.spirit.user.User;

public interface OrderSubService {

	Response<OrderSubDetailDto> createOrderSubDoDetail_new( OrderMainDto orderMainDto, User user,
															OrderMainModel orderMainModel);
	Response<OrderSubDetailDto> createJfOrderSubDoDetail_new(OrderCommitSubmitDto orderCommitSubmitDto,
									  OrderMainDto orderMainDto, User user,
								  OrderMainModel orderMainModel);
}
