package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 
 */
public class AppBackLogInfo implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -8783900702576056966L;
	@Getter
	@Setter
	private String goodsBackLog;
	@Getter
	@Setter
	private String goodsTotal;
}
