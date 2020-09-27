package cn.com.cgbchina.user.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class LocalCardRelateModel implements Serializable {

	private static final long serialVersionUID = -3488162459681609226L;
	@Getter
	@Setter
	private String proCode;// 卡类id
	@Getter
	@Setter
	private String formatId;// 卡等级id
}