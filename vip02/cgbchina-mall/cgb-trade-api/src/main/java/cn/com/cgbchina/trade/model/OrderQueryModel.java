package cn.com.cgbchina.trade.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class OrderQueryModel implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2130651925119294752L;
	private String orderMainId;
	private Integer subOrderNum;
}
