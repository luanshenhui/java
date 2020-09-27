package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class OrderReturnTrackModel implements Serializable {

	private static final long serialVersionUID = 401666130936944895L;
	@Getter
	@Setter
	private Long partbackId;// 退货单id
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String status;// 状态
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记为(0未删除，1已删除)

	/**
	 * 暂时现在这么写
	 */
	public OrderReturnTrackModel() {
		this.createOper = "admin";
	}

}