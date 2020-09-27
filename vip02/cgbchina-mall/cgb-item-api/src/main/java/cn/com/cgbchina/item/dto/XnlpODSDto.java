package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class XnlpODSDto implements Serializable{
	@Getter
	@Setter
	private String custName;
	@Getter
	@Setter
	private String certNbr;
	@Getter
	@Setter
	private String card4;
	@Getter
	@Setter
	private String serverStart;
}
