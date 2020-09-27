package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class LocalCardRelateModel implements Serializable {

	@Getter
	@Setter
	private String proCode;// 卡类id
	@Getter
	@Setter
	private String formatId;// 卡等级id
}