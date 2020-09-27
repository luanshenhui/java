package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

/**
 * Created by 1115012105001 on 2016/9/25.
 */
@Setter
@Getter
@ToString
public class OrderTransParaDto implements Serializable {
	private String k;
	private String i;
	private String c;
}
