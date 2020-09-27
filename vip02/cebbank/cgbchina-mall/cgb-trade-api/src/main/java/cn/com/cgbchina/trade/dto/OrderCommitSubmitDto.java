package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 张成 on 16-6-1.
 */
public class OrderCommitSubmitDto implements Serializable {

	private static final long serialVersionUID = 5292077045219936873L;
	@Getter
	@Setter
	private List<OrderCommitInfoDto> orderCommitInfoList;// 商品list

	@Getter
	@Setter
	private Long addressId;// 地址ID
	@Getter
	@Setter
	private String bpCustGrp;// 送货时间
	@Getter
	@Setter
	private String cardNo;// 银行卡号

	@Getter
	@Setter
	private String isInvoice;// 是否开发票
	@Getter
	@Setter
	private String invoice;// 发票抬头
	@Getter
	@Setter
	private String ordermainDesc;// 留言
	@Getter
	@Setter
	private String payType;// 支付类型
	@Getter
	@Setter
	private String userName;// 客户姓名
	@Getter
	@Setter
	private String phoneNo;// 发码用电话号码
    @Getter
    @Setter
    private String miaoFlag;// 0元秒杀标志
    @Getter
    @Setter
    private String orderId;// 临时用主订单ＩＤ
    @Getter
    @Setter
    private String payFlag;// 临时用支付成功失败处理中
}
