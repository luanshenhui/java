package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.trade.dto.OrderCommitSubmitDto;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderSubDetailDto;
import cn.com.cgbchina.trade.model.OrderMainModel;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by lvzd on 2016/9/25.
 */
public interface OrderCreateMainAndSubService {

    Response<OrderMainModel> createOrderMain_new(OrderMainDto orderMainDto, OrderCommitSubmitDto orderCommitSubmitDto, User user);
    Response<OrderMainModel> createJfOrderMain_new(OrderMainDto orderMainDto, OrderCommitSubmitDto orderCommitSubmitDto, User user);
    Response<OrderSubDetailDto> createOrderSubDoDetail_new( OrderMainDto orderMainDto, User user,
                                                            OrderMainModel orderMainModel);
    Response<OrderSubDetailDto> createJfOrderSubDoDetail_new(OrderCommitSubmitDto orderCommitSubmitDto, OrderMainDto orderMainDto,
                                                             User user, OrderMainModel orderMainModel);
}
