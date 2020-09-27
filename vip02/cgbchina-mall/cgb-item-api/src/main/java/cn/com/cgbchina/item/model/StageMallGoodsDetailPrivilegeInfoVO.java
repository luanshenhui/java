package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * MAL117 商品详细信息(分期商城)返回对象 --优惠券信息
 * 
 * @author 2016/7/7
 */
public class StageMallGoodsDetailPrivilegeInfoVO implements Serializable {
	private static final long serialVersionUID = 1212083175978327129L;
	@Getter
	@Setter
	private String privilegeId;
	@Getter
	@Setter
	private String privilegeName;
	@Getter
	@Setter
	private String projectNO;
	@Getter
	@Setter
	private Double liquidateRatio;
	@Getter
	@Setter
	private Double privilegeMoney;
	@Getter
	@Setter
	private String useActivatiState;
	@Getter
	@Setter
	private String pastDueState;
	@Getter
	@Setter
	private Double limitMoney;
	@Getter
	@Setter
	private String regulation;
	@Getter
	@Setter
	private String beginDate;
	@Getter
	@Setter
	private String endDate;

}
