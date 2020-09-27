package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

/** 
 * 报表  积分兑换订单数据
 * @author huangcy
 * on 2016年6月23日 
 */
public class IntegralExchangeModel implements Serializable{

	private static final long serialVersionUID = 3630048588640829748L;
	@Getter
	@Setter
	private Integer index;
	/**
	 * 订单号,表tbl_order(order_id)
	 */
	@Getter
	@Setter
	private String orderId;
	
	/**
	 * 礼品名称，表tbl_order(goods_nm)
	 */
	@Getter
	@Setter
	private String goodsNm;
	
	/**
	 * 数量，表tbl_order(goods_num)
	 */
	@Getter
	@Setter
	private Integer goodsNum;
	
	/**
	 * 信用卡号,表tbl_order(cardno)
	 */
	@Getter
	@Setter
	private String cardNo;
	
	/**
	 * 供应商，表tbl_order(vendor_snm)
	 */
	@Getter
	@Setter
	private String vendorSnm;
	
	/**
	 * 消费时间，表tbl_order(create_time)
	 */
	@Getter
	@Setter
	private Date createTime;
	
	/**
	 * 积分数，表tbl_order(bonus_totalvalue)
	 */
	@Getter
	@Setter
	private Long bonusTotalValue;
	
	/**
	 * 客户姓名，表tbl_order_main(cont_nm)
	 */
	@Getter
	@Setter
	private String contNm;
	
	/**
	 * 手机号码，表tbl_order_main(cont_mob_phone)
	 */
	@Getter
	@Setter
	private String contMobPhone;
	
	/**
	 * 客户证件，表tbl_order_main(cont_idcard)
	 */
	@Getter
	@Setter
	private String contIdCard;
	
	/**
	 * 礼品编号
	 */
	@Getter
	@Setter
	private String goodsXid;
	
	/**
	 * 积分别名编码
	 */
	@Getter
	@Setter
	private String goodsBid;
	
	/**
	 * 入账卡号
	 */
	@Getter
	@Setter
	private String entryCard;
	
	/**
	 * 卡类
	 */
	@Getter
	@Setter
	private String virtualCardType;
	
	/**
	 * 里程数
	 */
	@Getter
	@Setter
	private Integer virtualAllMileage;
	
	/**
	 * 单价
	 */
	@Getter
	@Setter
	private String virtualSinglePrice;
	
	/**
	 * 金额
	 */
	@Getter
	@Setter
	private BigDecimal virtualAllPrice;
	
	/**
	 * 会员号
	 */
	@Getter
	@Setter
	private String virtualMemberId;
	
	/**
	 * 会员姓名(中文)
	 */
	@Getter
	@Setter
	private String virtualMemberNm;
	
	/**
	 * 会员姓名(英文)
	 */
	@Getter
	@Setter
	private String engName;
	
	/**
	 * 航空类型
	 */
	@Getter
	@Setter
	private String virtualAviationType;
	
	/**
	 * 卡版描述
	 */
	@Getter
	@Setter
	private String extend2;
	
	/**
	 * 保单号
	 */
	@Getter
	@Setter
	private String serialNo;
	
	/**
	 * 发卡城市
	 */
	@Getter
	@Setter
	private String cardCity;
}
