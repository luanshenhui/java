package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * @author huangcy on 2016年6月16日
 */
public class IntegralDayOrderModel implements Serializable {
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
	private String createTime;
	
	/**
	 * 客户姓名，表tbl_order_main(cont_nm)
	 */
	@Getter
	@Setter
	private String contNm;
	
	/**
	 * 客户证件，表tbl_order_main(cont_idcard)
	 */
	@Getter
	@Setter
	private String contIdCard;
	
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
	 * 数量，表tbl_order(goods_num)
	 */
	@Getter
	@Setter
	private Integer goodsNum;
	
	/**
	 * 积分数，表tbl_order(bonus_totalvalue)
	 */
	@Getter
	@Setter
	private Long bonusTotalValue;
	
	/**
	 * 卡号，表tbl_order_virtual(entry_card)
	 */
	@Getter
	@Setter
	private String entryCard;
	
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
	 * 保单号，表tbl_order_virtual(SERIALNO)
	 */
	@Getter
	@Setter
	private String serialNo;
}
