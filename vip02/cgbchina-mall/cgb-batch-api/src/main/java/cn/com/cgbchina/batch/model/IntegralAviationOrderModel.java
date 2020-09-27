package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

/**
 * @author huangcy on 2016年6月16日
 */
public class IntegralAviationOrderModel implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/**
	 * 订单号，表tbl_order(order_id)
	 */
	@Getter
	@Setter
	private String orderId;
	
	/**
	 * 航空类型，表tbl_order_virtual(virtual_aviation_type)
	 */
	@Getter
	@Setter
	private String aviationType;
	
	/**
	 * 航空会员号，表tbl_order_virtual(virtual_member_id)
	 */
	@Getter
	@Setter
	private String virtualMemberId;
	
	/**
	 * 会员姓名(中文),表tbl_order_virtual(virtual_member_nm)
	 */
	@Getter
	@Setter
	private String virtualMemberNm;
	
	/**
	 * 会员姓名(英文)，表a_cust_toelectronbank(eng_name)
	 */
	@Getter
	@Setter
	private String engName;
	
	/**
	 * 信用卡号，表tbl_order(cardno)
	 */
	@Getter
	@Setter
	private String cardNo;
	
	/**
	 * 手机号码，表tbl_order_main(cont_mob_phone)
	 */
	@Getter
	@Setter
	private String contMobPhone;
	
	/**
	 * 消费时间，表tbl_order(create_time)
	 */
	@Getter
	@Setter
	private Date createTime;
	
	/**
	 * 礼品编号，表tbl_order_virtual(goods_xid)
	 */
	@Getter
	@Setter
	private String goodsId;
	
	/**
	 * 礼品名称，表tbl_order(goods_nm)
	 */
	@Getter
	@Setter
	private String goodsNm;
	
	/**
	 * 里程数，表tbl_order_virtual(virtual_all_mileage)
	 */
	@Getter
	@Setter
	private Integer virtualAllMileage;
	
	/**
	 * 积分数，表tbl_order(bonus_totalvalue)
	 */
	@Getter
	@Setter
	private Long bonusTotalValue;
	
	/**
	 * 卡类，表tbl_order_virtual(virtual_card_type)
	 */
	@Getter
	@Setter
	private String virtualCardType;

}
