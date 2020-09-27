package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.DealPayResult;
import cn.com.cgbchina.trade.dto.OrderPealPayInfoDto;
import cn.com.cgbchina.trade.dto.PayOrderInfoDto;
import cn.com.cgbchina.trade.model.OrderMainModel;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * Created by shangqinbin on 2016/6/29.
 */
public interface OrderDealService {

    /**
     * 处理支付网关返回的报文
     *
     * @param payOrderInfoDto
     * @return
     */
    Response<DealPayResult> dealPay(PayOrderInfoDto payOrderInfoDto,
                                    OrderMainModel orderMainModel,
                                    List<OrderPealPayInfoDto> payOrderIfDtos);

    /**
     * 处理支付网关返回数据
     * @param payOrderInfoDto
     * @return
     */
    Response<DealPayResult> makeOrderTradeInfo(PayOrderInfoDto payOrderInfoDto);

    /**
     * 更新订单SourceID
     * @param sourceId
     * @param orderMainId
     * @return
     */
    Response<Boolean> createOrderSourceId(String sourceId, String orderMainId);
}
