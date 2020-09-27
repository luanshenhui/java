package cn.com.cgbchina.rest.provider.model.order;

import lombok.Getter;
import lombok.Setter;
import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * 发码（购票）成功通知接口
 * 
 * @author lizy
 *
 */
@Getter
@Setter
public class SendCodeOrderInfo extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1950519867371751969L;
	private String subOrderNo;
	private String codeData;
	private String fileUrl;

}
