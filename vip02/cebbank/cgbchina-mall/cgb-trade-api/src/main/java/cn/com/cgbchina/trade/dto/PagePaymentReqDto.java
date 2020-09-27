/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/29.
 */
public class PagePaymentReqDto implements Serializable {
	private static final long serialVersionUID = 3310076859544637256L;
	@Getter
	@Setter
	private String errorMsg; // 错误消息
    @Getter
    @Setter
    private String payAddress; // 页面支付调用地址
	@Getter
	@Setter
	private String orderid; // 大订单号
	@Getter
	@Setter
	private String amount; // 总金额
	@Getter
	@Setter
	private String merchId; // 大商户号
	@Getter
	@Setter
	private String sign; // 签名
	@Getter
	@Setter
	private String returl; // 回调地址
	@Getter
	@Setter
	private String pointType; // 积分类型
	@Getter
	@Setter
	private String pointSum; // 总积分值
	@Getter
	@Setter
	private String isMerge; // 是否合并支付
	@Getter
	@Setter
	private String payType; // 支付类型
	@Getter
	@Setter
	private String orders; // 订单信息串
	@Getter
	@Setter
	private String otherOrdersInf; // 积分、优惠券信息串
	@Getter
	@Setter
	private String payAccountNo; // 支付账号
	@Getter
	@Setter
	private String serialNo; // 交易流水号
	@Getter
	@Setter
	private String tradeDate; // 商户订单日期
	@Getter
	@Setter
	private String tradeTime; // 商户订单时间
	@Getter
	@Setter
	private String entry_card; // 兑换卡号(广发未用)
	@Getter
	@Setter
	private String tradeCode; // 交易类型(广发未用)
	@Getter
	@Setter
	private String virtualPrice; // 兑换金额(广发未用)
	@Getter
	@Setter
	private String tradeDesc; // 交易描述(广发未用)
	@Getter
	@Setter
	private String certType; // 证件类型
	@Getter
	@Setter
	private String certNo; // 证件号
}
