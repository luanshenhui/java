package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.MenuMagModel;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by wusy on 2016/5/19.
 */
public class LoginDto implements Serializable {

	private static final long serialVersionUID = 419586185838258287L;
	@Setter
	@Getter
	private String url;//跳转路径
	@Setter
	@Getter
	private String couponNm;//项目名称
	@Setter
	@Getter
	private String errorMes;//错误名称
	@Setter
	@Getter
	private Boolean isUpPwd;//是否修改密码

}
