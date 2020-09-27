package cn.com.cgbchina.user.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class ShopinfOutsystemModel implements Serializable {

	private static final long serialVersionUID = 7155472596506638661L;
	@Getter
	@Setter
	private Long id;// 自增长序号
	@Getter
	@Setter
	private String shopId;// 商家id 外系统提供
	@Getter
	@Setter
	private String name;// O2O系统名称
	@Getter
	@Setter
	private String outsystemId;// 外系统编号
	@Getter
	@Setter
	private String actionUrl;// 发送地址
	@Getter
	@Setter
	private String shopKey;// 密钥（旧系统使用）
	@Getter
	@Setter
	private byte[] key;// 密钥（新系统使用）
	@Getter
	@Setter
	private Integer type;
	@Getter
	@Setter
	private String remark;// 备注
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String entend1;// 扩展字段1
	@Getter
	@Setter
	private String extend2;// 扩展字段2
	@Getter
	@Setter
	private String extend3;// 扩展字段3
}