package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class AuditLoggingModel implements Serializable {

	private static final long serialVersionUID = 4920650452901566855L;

	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String outerId;// 外部id
	@Getter
	@Setter
	private String presenter;// 申请人
	@Getter
	@Setter
	private String presenterMemo;// 申请备注
	@Getter
	@Setter
	private java.util.Date presenterDatetime;// 申请时间
	@Getter
	@Setter
	private String auditor;// 审核人
	@Getter
	@Setter
	private String auditorMemo;// 审核备注
	@Getter
	@Setter
	private java.util.Date auditorDatetime;// 审核时间
	@Getter
	@Setter
	private String ext;// 扩展信息
	@Getter
	@Setter
	private String businessType;// 业务类型
	@Getter
	@Setter
	private String approveType;// 审核结果类型
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
}