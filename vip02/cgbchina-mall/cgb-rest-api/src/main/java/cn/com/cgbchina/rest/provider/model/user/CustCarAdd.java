package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * MAL304 加入购物车(分期商城)
 */
@Getter
@Setter
@ToString
public class CustCarAdd extends BaseQueryEntity implements Serializable {

	private static final long serialVersionUID = -800068614622375745L;
	private String origin; //渠道 03:如手机商城  00: 网上商城（包括广发，积分商城）CHANNEL_MALL_CODE
	private String mallType;  //商城类型 商城类型标识  "01":广发商城 ;"02":积分商城
	private String ordertypeId; //订单类型id:分期订单:FQ  一次性订单:YG 积分订单：JF
	private String custId; //客户id
	private String goodsId;  //单品id
	private String goodsPaywayId; //付款方式id
	private String goodsNum;  //数量
	private String bonusValue; //抵扣积分

}
