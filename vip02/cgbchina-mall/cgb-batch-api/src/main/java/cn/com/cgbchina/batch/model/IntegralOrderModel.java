package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/** 
 * 积分订单
 * 通过礼品清单确定
 * @author huangcy
 * on 2016年6月15日 
 */
public class IntegralOrderModel implements Serializable{
	private static final long serialVersionUID = 1L;
	
	/**
	 * 订单号，表tbl_order(order_id)
	 */
	@Getter
	@Setter
	private String orderId;
	
	/**
	 * 下单时间，表tbl_order(create_time)
	 */
	@Getter
	@Setter
	private String createDate;
	
	/**
	 * 积分数，表tbl_order(bonus_totalvalue)
	 */
	@Getter
	@Setter
	private Long bonusTotalValue;
	
	/**
	 * 数量，表tbl_order(goods_num)
	 */
	@Getter
	@Setter
	private Integer goodsNum;
	
	/**
	 * 卡号，表tbl_order_virtual(entry_card)
	 */
	@Getter
	@Setter
	private String entryCard;
	
	/**
	 * 会员号，表tbl_order_virtual(virtual_member_id)
	 */
	@Getter
	@Setter
	private String virtualMemberId;
	
	/**
	 * 礼品编号，表tbl_order_virtual(goods_xid)
	 */
	@Getter
	@Setter
	private String goodsId;
	
	/**
	 * 礼品代号，表tbl_order_virtual(goods_bid)
	 */
	@Getter
	@Setter
	private String goodsBid;
	
	
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
	 * 单价，表tbl_order_virtual(virtual_single_price)
	 */
	@Getter
	@Setter
	private BigDecimal virtualSinglePrice;
	
	/**
	 * 金额，表tbl_order_virtual(virtual_all_price)
	 */
	@Getter
	@Setter
	private BigDecimal virtualAllPrice;
	
	/**
	 * 卡类，表tbl_order_virtual(virtual_card_type)
	 */
	@Getter
	@Setter
	private String virtualCardType;
	
	/**
	 * 供应商，表tbl_order(vendor_snm)
	 */
	@Getter
	@Setter
	private String vendorSnm;
	
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
	
}
