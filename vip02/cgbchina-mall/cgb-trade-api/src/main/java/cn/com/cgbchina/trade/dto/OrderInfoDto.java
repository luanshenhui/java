package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

import cn.com.cgbchina.trade.model.OrderSubModel;
import lombok.Getter;
import lombok.Setter;

/**
 * Created by 11141021040453 on 16-4-25.
 */
public class OrderInfoDto implements Serializable {
	private static final long serialVersionUID = 2343075823893313179L;

	@Getter
	@Setter
	private OrderSubModel orderSubModel;
	@Getter
	@Setter
	private List<OrderItemAttributeDto> orderItemAttributeDtos; // 销售属性
	@Getter
	@Setter
	private Boolean voucherFlag; // 设置是否使用优惠券标识
	@Getter
	@Setter
	private Boolean bonusTotalFlag;  // 设置使用积分标识
	@Getter
	@Setter
	private Boolean orderTransFlag; // 设置查看物流权限标示
	@Getter
	@Setter
	private String mid; // 单品编码(商品ID,唯一值用于外系统)'
	@Getter
	@Setter
	private String xid; // 礼品编码
	@Getter
	@Setter
	private BigDecimal price;//售价（一期-现金， 分期-（现金+优惠+积分抵扣）/期数）
	@Getter
	@Setter
	private Boolean uitdrtamtFlag; //积分抵扣值标识
	@Getter
	@Setter
	private String exchangeName;//兑换方式

	// 设置使用积分标识 true——使用
	public void makeBonusTotalFlag() {
		if (!(orderSubModel == null)) {
			if (null == orderSubModel.getBonusTotalvalue() || orderSubModel.getBonusTotalvalue().longValue() == 0) {
				this.setBonusTotalFlag(Boolean.FALSE);
			} else {
				this.setBonusTotalFlag(Boolean.TRUE);
			}
		}
	}

	// 设置是否使用优惠券标示 true——使用
	public void makeVoucherFlag() {
		if (!(orderSubModel == null)) {
			if (null == orderSubModel.getVoucherPrice() || (BigDecimal.ZERO.compareTo(orderSubModel.getVoucherPrice())==0)) {
				this.setVoucherFlag(Boolean.FALSE);
			} else {
				this.setVoucherFlag(Boolean.TRUE);
			}
		}
	}

	//积分抵扣值标识
	public void makeUitdrtamtFlag() {
		if (!(orderSubModel == null)) {
			if (null == orderSubModel.getUitdrtamt() || (BigDecimal.ZERO.compareTo(orderSubModel.getUitdrtamt())==0)) {
				this.setUitdrtamtFlag(Boolean.FALSE);
			} else {
				this.setUitdrtamtFlag(Boolean.TRUE);
			}
		}
	}

}
