package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 修改积分 用于报表: 更改积分报告
 * 
 * @author xiewl
 * @version 2016年5月4日 下午4:40:19
 */
public class ModifyIntegral implements Serializable {

	/**
	 * 序号
	 */
	@Getter
	@Setter
	private String index;
	/**
	 * 所属批次号
	 */
	@Getter
	@Setter
	private String batchNo;
	/**
	 * 订单号
	 */
	@Getter
	@Setter
	private String orderId;
	/**
	 * 客户姓名
	 */
	@Getter
	@Setter
	private String customerName;
	/**
	 * 礼品编号
	 */
	@Getter
	@Setter
	private String goodsId;
	/**
	 * 礼品名称
	 */
	@Getter
	@Setter
	private String goodsName;
	/**
	 * 数量
	 */
	@Getter
	@Setter
	private String goodsNum;
	/**
	 * 单价
	 */
	@Getter
	@Setter
	private Double goodsPrice;
	/**
	 * 总额
	 */
	@Getter
	@Setter
	private Double goodsMoneySum;
	/**
	 * 退积分原因
	 */
	@Getter
	@Setter
	private String backReason;
	/**
	 * 需退积分
	 */
	@Getter
	@Setter
	private Integer backIntegral;
	/**
	 * 需退现金
	 */
	@Getter
	@Setter
	private Double backCash;
	/**
	 * 卡号
	 */
	@Getter
	@Setter
	private String cardNum;
	/**
	 * 类型
	 */
	@Getter
	@Setter
	private String modifyType;

}
