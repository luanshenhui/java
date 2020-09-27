package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;
import cn.com.cgbchina.rest.provider.vo.order.AppStageMallPayVerificationReturnVO;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.trade.model.*;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * MAL315 订单支付结果校验接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
@Setter
@Getter
public class AppStageMallPayVerificationReturnSubVO extends AppStageMallPayVerificationReturnVO implements
		Serializable {
	private static final long serialVersionUID = -3385774749610312891L;
	private String orderId;
	private String errorCode;
	private OrderMainModel tblOrderMain;
	private OrderSubModel subOrder;
	private String cardNo;
	private String cardType;
	private String itemCode;
	private String itemMid;//分期编码

	private TblOrderExtend1Model tblOrderExtendI;
	private TblOrderExtend1Model tblOrderExtendU;
	private String errorCodeText;
	private String goodsPrice;
	// BPS错误码
	private String bpserrorCode;
	// BPS错误码说明
	private String bpserrorCodeText;
	// BPS返回码
	private String bpsapproveResult;
	private StagingRequestResult stagingRequestResult;
	private TblEspCustCartModel tblEspCustCartModel;
	private OrderCheckModel orderCheckModel;
	private OrderCheckModel orderCheckModelPlus;
	private OrderDoDetailModel orderDoDetailModel;
}
