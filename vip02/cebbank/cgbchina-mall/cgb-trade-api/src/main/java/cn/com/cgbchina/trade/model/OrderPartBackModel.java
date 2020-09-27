package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class OrderPartBackModel implements Serializable {

	private static final long serialVersionUID = 5810907436099489086L;
	@Getter
	@Setter
	private Long id;// id
	@Getter
	@Setter
	private String ordertypeId;// 业务类型YG：广发JF：积分
	@Getter
	@Setter
	private String orderId;// 订单号
	@Getter
	@Setter
	private String referenceNo;// 参考号码
	@Getter
	@Setter
	private Integer goodsNum;// 退货商品数量
	@Getter
	@Setter
	private java.math.BigDecimal totalMoney;// 退货金额
	@Getter
	@Setter
	private java.math.BigDecimal commission;// 退货佣金金额
	@Getter
	@Setter
	private String curStatusId;// 当前状态id0334--退货申请0327--退货成功0335--拒绝退货申请0312--已撤单
	@Getter
	@Setter
	private String curStatusNm;// 状态名称
	@Getter
	@Setter
	private String userType;// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
	@Getter
	@Setter
	private String doUserid;// 处理用户
	@Getter
	@Setter
	private java.util.Date doTime;// 处理时间
	@Getter
	@Setter
	private String doDesc;// 处理描述
	@Getter
	@Setter
	private String goodsName;// 商品名称
	@Getter
	@Setter
	private String goodsId;// 商品id
	@Getter
	@Setter
	private String vendorId;// 供应商id
	@Getter
	@Setter
	private String vendorName;// 供应商
	@Getter
	@Setter
	private String memberId;// 会员
	@Getter
	@Setter
	private String memo;// 留言
	@Getter
	@Setter
	private String operationType;// 订单操作类型（0撤单，1退货）
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记为(0未删除，1已删除)
	@Getter
	@Setter
	private String memoExt;// 补充说明
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private String memberName;// 买家
	@Getter
	@Setter
	private String returnType;// 退货（撤单）类型00用户01商城02CC端
}