/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/1.
 */
public class OrderCommitInfo314Dto extends OrderCommitInfoDto implements Serializable {

	private static final long serialVersionUID = -1691525859191970010L;
	@Getter
	@Setter
	private String pointType;
	@Getter
	@Setter
	private String discountPrivMon;
	@Getter
	@Setter
	private String discountPrivilege;

}