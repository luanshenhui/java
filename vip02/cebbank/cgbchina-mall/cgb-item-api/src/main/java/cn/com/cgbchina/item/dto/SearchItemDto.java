/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author liuchang
 * @version 1.0
 * @Since 16-5-30.
 */

public class SearchItemDto implements Serializable {

	private static final long serialVersionUID = -826269430394067163L;
	@Setter
	@Getter
	private String businessType;

	@Setter
	@Getter
	private String channelType;

	@Setter
	@Getter
	private String keywords;

	@Setter
	@Getter
	private String sortField;

	@Setter
	@Getter
	private String sortDir;

	@Setter
	@Getter
	private String startPage;

	@Setter
	@Getter
	private String pageSize;

	@Setter
	@Getter
	private String filterParams;
}
