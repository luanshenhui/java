/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.dto;

import cn.com.cgbchina.related.model.CardPro;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-15.
 */
public class CardProDto implements Serializable {
	private static final long serialVersionUID = 8977234243097090019L;
	@Getter
	@Setter
	private String proNm;

	@Getter
	@Setter
	private CardPro CardPro;

}
