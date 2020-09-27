package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class VendorMenuModel implements Serializable {

	private static final long serialVersionUID = -1741988477548703273L;
	@Getter
	@Setter
	private Long id;// 资源编码
	@Getter
	@Setter
	private String memuType;// 资源类型（0按钮，1菜单）
	@Getter
	@Setter
	private String name;// 资源名称
	@Getter
	@Setter
	private String link;// 链接
	@Getter
	@Setter
	private String isShow;// 是否显示0显示1不显示
	@Getter
	@Setter
	private String isEnabled;// 是否启用0启用1禁用
	@Getter
	@Setter
	private Integer sort;// 排序
	@Getter
	@Setter
	private String pid;// 父节点ID
	@Getter
	@Setter
	private Integer grade;// 层数
	@Getter
	@Setter
	private String shopType;// 平台类型 YG广发商城JF积分商城
	@Getter
	@Setter
	private String param;// 资源参数
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String vendorId;// 供应商ID
	@Getter
	@Setter
	private String delFlag;// 删除标志0-未删除1-已删除
	@Getter
	@Setter
	private String dataPaths;// tab页路径

}