package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class MemberGoodsFavoriteModel implements Serializable {

	private static final long serialVersionUID = 3752556727708486741L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String custId;// 会员编号
	@Getter
	@Setter
	private String goodsCode;// 商品编码
	@Getter
	@Setter
	private String itemCode;// 单品编码
	@Getter
	@Setter
	private java.math.BigDecimal price;// 实际价格
	@Getter
	@Setter
	private java.util.Date createTime;// 收藏时间
	@Getter
	@Setter
	private String memo;// 备注
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private String vendorId;// 供应商id
	@Getter
	@Setter
	private String count;// 热门交易TOP10交易数
}