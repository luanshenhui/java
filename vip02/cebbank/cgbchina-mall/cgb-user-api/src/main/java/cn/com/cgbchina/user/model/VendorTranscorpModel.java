package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class VendorTranscorpModel implements Serializable {

	private static final long serialVersionUID = 1272488454818545203L;
	@Getter
	@Setter
	private Long id;// ID 自增
	@Getter
	@Setter
	private Long vendorInfId;//
	@Getter
	@Setter
	private String transcorpName;// 物流公司名称
	@Getter
	@Setter
	private String contact;// 联系人
	@Getter
	@Setter
	private String mobile;// 手机
	@Getter
	@Setter
	private String phone;// 电话
	@Getter
	@Setter
	private String fax;// 传真
	@Getter
	@Setter
	private String address;// 地址
	@Getter
	@Setter
	private String email;// EMAIL
	@Getter
	@Setter
	private String servicePhone;// 客服电话
	@Getter
	@Setter
	private String serviceUrl;// 查询网址
	@Getter
	@Setter
	private String transCorpDesc;// 供应商描述（未用）
	@Getter
	@Setter
	private String status;// 当前状态（未用） 0101：未启用 0102：已启用
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String reserved1;// 保留字段一
}