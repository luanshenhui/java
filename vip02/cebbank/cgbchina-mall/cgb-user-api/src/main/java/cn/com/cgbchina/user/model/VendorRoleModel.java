package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class VendorRoleModel implements Serializable {

	private static final long serialVersionUID = 7940444433319460686L;
	@Getter
	@Setter
	private Long id;// 角色ID
	@Getter
	@Setter
	private Integer pid;// 角色父ID
	@Getter
	@Setter
	private String name;// 角色名称
	@Getter
	@Setter
	private String type;// 角色类型
	@Getter
	@Setter
	private String descript;// 角色描述
	@Getter
	@Setter
	private String checkStatus;// 审核状态 0:否 1:是(新增) 2:是(修改) 3:是(删除) 4:同意 5:拒绝
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private String modifyOper;// 修改人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建日期
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改日期
	@Getter
	@Setter
	private String shopType;// 平台类型 YG：广发商城，JF：积分商城
	@Getter
	@Setter
	private String vendorId;// 供应商ID
    @Getter
    @Setter
    private String delFlag;// 删除标志0-未删除1-删除
}