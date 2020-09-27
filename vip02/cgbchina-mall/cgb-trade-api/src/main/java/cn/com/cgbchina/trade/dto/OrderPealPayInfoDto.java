package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by lvzd on 2016/9/27.
 */
@Setter
@Getter
public class OrderPealPayInfoDto implements Serializable {
    private static final long serialVersionUID = 2069417160818324681L;
    private PayOrderSubDto payOrderSubDto;
    private OrderSubModel orderSubModel;
    // 取得订单扩展表1
    private TblOrderExtend1Model tblOrderExtend1Model;
    // 空和0:没发送过,1:发送过给bps
    private String isAlreadySendBps;
    private StagingRequestResult stagingRequestResult;
    private String errorCode;
    private String payAccountNo;
}
