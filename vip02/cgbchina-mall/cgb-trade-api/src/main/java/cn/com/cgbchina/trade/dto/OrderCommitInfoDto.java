/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

/**
 * 订单信息DTO
 *
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/1.
 */
@Setter
@Getter
@ToString
public class OrderCommitInfoDto extends BaseOrderCommitDto implements Serializable {

	private static final long serialVersionUID = -1691525859191970010L;

}