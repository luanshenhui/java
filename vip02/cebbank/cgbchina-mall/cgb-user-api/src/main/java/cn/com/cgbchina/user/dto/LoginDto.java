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

	private static final long serialVersionUID = 3375250453883045923L;
	@Setter
	@Getter
	private String url;
	@Setter
	@Getter
	private Integer count;
	@Setter
	@Getter
	private String errorMes;
	@Setter
	@Getter
	private Boolean isUpPwd;

}
