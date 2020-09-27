package cn.com.cgbchina.rest.provider.vo.order;

import java.util.Date;

import javax.validation.constraints.NotNull;

import lombok.Getter;
import lombok.Setter;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * 验证通知接口 根据xml返回的接口
 * 
 * @author Lizy
 *
 */
@Setter
@Getter
public class VerificationNoticVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8277219283369448302L;
	@NotNull
	@XMLNodeName(value = "orderno")
	private String orderNo;

	@NotNull
	@XMLNodeName(value = "suborderno")
	private String subOrderNo;

	@NotNull
	@XMLNodeName(value = "verifyid")
	private String verifyId;

	@NotNull
	@XMLNodeName(value = "verifynum")
	private Integer verifyNum;

	@NotNull
	@XMLNodeName(value = "codedata")
	private String codeData;

	@NotNull
	@XMLNodeName(value = "verifytime")
	private Date verifyTime;

	@NotNull
	@XMLNodeName(value = "verifytype")
	private Integer verifyType;

	@NotNull
	@XMLNodeName(value = "verifyopor")
	private String verifyopor;

}
