package cn.com.cgbchina.rest.provider.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

@Setter
@Getter
public class BaseO2OEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@XMLNodeName("result_code")
	private String returnCode;
	@XMLNodeName("result_msg")
	private String returnDes;
}
