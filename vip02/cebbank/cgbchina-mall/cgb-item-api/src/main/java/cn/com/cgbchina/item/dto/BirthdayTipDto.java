package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by liuchang on 2016/6/15.
 */
public class BirthdayTipDto implements Serializable {

	private static final long serialVersionUID = 495275585075605404L;
	@Getter
	@Setter
	private String birthScale;// 生日折扣

	@Getter
	@Setter
	private String birthday;// 生日
}
