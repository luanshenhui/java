package cn.com.cgbchina.user.model;

import com.spirit.user.User;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by yuxinxin on 16-5-24.
 */
public class MallUserModel extends User implements Serializable {
	private static final long serialVersionUID = 1227130411941526853L;

	@Getter
	@Setter
	private String pwfirst;// 一次密码
	@Getter
	@Setter
	private String pwsecond;// 二次密码
	@Getter
	@Setter
	private String phone;// 电话
	@Getter
	@Setter
	private String fax;// 传真
	@Getter
	@Setter
	private String password;// 用户密码
	@Getter
	@Setter
	private String papersType;// 用户证件
	@Getter
	@Setter
	private String papersNum;// 证件号码
	@Getter
	@Setter
	private String isFirst;// 是否第一次登陆 0第一次登陆1否
	@Getter
	@Setter
	private String address;// 地址（未用）
	@Getter
	@Setter
	private String email;// EMAIL
	@Getter
	@Setter
	private String status;// 当前状态0101未启用0102已启用
	@Getter
	@Setter
	private String descript;// 用户备注
	@Getter
	@Setter
	private String rightCode;// 权限位
	@Getter
	@Setter
	private String level;// 用户等级 0管理员1普通用户
	@Getter
	@Setter
	private java.util.Date loginTime;// 登录时间
	@Getter
	@Setter
	private Integer loginCount;// 登录个数
	@Getter
	@Setter
	private Integer errorCount;// 错误个数
	@Getter
	@Setter
	private String checkStatus;// 审核状态
	@Getter
	@Setter
	private String refuseDesc;// 拒绝原因
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
	private String editPwTime;//
	@Getter
	@Setter
	private String isSub;// 0不是子账户1是
	@Getter
	@Setter
	private String delFlag;// 删除标志0-未删除1-删除
	@Getter
	@Setter
	private String parentId;// 父ID
	@Getter
	@Setter
	private String vendorId;// 供应商代码
	@Getter
	@Setter
	private String simpleName;// 供应商简称
	@Getter
	@Setter
	private String code;// 用户编码

}
