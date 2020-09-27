package cn.com.cgbchina.trade.service;

import java.util.List;

import cn.com.cgbchina.trade.dto.OrderCommitSubmitDto;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.PagePaymentReqDto;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;

import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserAccount;

public interface OrderJFMainService {

//	Response<OrderMainModel> createJfOrderMain_new(OrderMainDto orderMainDto,
//												   OrderCommitSubmitDto orderCommitSubmitDto, User user);

	Response<OrderMainDto> checkCreateJfOrderArgumentAndGetInfos_new(
			OrderCommitSubmitDto orderCommitSubmitDto, UserAccount selectedCardInfo, User user);
	Response<PagePaymentReqDto> getReturnObjForPay_new(OrderMainModel orderMain,
													   List<OrderSubModel> orderSubModelList,
													   List<OrderVirtualModel> orderVirtualList);
}
