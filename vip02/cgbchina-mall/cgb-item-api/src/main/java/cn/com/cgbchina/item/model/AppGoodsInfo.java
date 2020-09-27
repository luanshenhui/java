package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 
 */
public class AppGoodsInfo implements Serializable {
	private static final long serialVersionUID = -1L;
	@Getter
	@Setter
	private String goodsId;
	@Getter
	@Setter
	private String goodsAttr1;
	@Getter
	@Setter
	private String goodsAttr2;
	@Getter
	@Setter
	private String goodsColor;
	@Getter
	@Setter
	private String goodsModel;
}
