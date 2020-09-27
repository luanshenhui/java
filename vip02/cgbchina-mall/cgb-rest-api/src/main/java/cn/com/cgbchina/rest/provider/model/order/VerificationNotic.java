package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

/**
 * 验证通知接口
 * 
 * @author Lizy
 *
 */
@Setter
@Getter
public class VerificationNotic extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8277219283369448302L;
	private String orderNo;
	private String subOrderNo;
	private String verifyId;
	private Integer verifyNum;
	private String codeData;
	private Date verifyTime;
	private Integer verifyType;
	private String verifyopor;


}
