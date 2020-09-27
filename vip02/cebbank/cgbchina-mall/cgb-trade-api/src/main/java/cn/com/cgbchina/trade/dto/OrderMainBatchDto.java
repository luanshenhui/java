package cn.com.cgbchina.trade.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 报表 主订单信息
 * 
 * @author xiewl
 * @version 2016年6月22日 下午2:36:33
 */
public class OrderMainBatchDto implements Serializable {
	private static final long serialVersionUID = 3371726654183016243L;
	/**
	 * 主订单号
	 */
	@Getter
	@Setter
	private String ordermainId;
	/**
	 * 业务类型名称
	 */
	@Getter
	@Setter
	private String ordertypeNm;
	/**
	 * 客户卡号
	 */
	@Getter
	@Setter
	private String cardNo;
	/**
	 * 送货地址
	 */
	@Getter
	@Setter
	private String csgAddress;
	/**
	 * 送货邮编
	 */
	@Getter
	@Setter
	private String csgPostcode;
	/**
	 * 手机号码
	 */
	@Getter
	@Setter
	private String csgPhone1;
	/**
	 * 固话
	 */
	@Getter
	@Setter
	private String csgPhone2;
	/**
	 * 发票抬头
	 */
	@Getter
	@Setter
	private String invoice;
	/**
	 * 客户姓名
	 */
	@Getter
	@Setter
	private String contNm;
	/**
	 * 收货人证件号码
	 */
	@Getter
	@Setter
	private String csgIdcard;
	/**
	 * 卡类
	 */
	@Getter
	@Setter
	private String pdtNbr;

	/**
	 * 省份
	 */
	@Getter
	@Setter
	private String csgProvince;
	/**
	 * 城市
	 */
	@Getter
	@Setter
	private String csgCity;
	/**
	 * 受理号
	 */
	@Getter
	@Setter
	private String acceptedNo;
}
