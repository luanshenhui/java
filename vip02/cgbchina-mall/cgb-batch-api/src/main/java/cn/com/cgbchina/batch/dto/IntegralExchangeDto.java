package cn.com.cgbchina.batch.dto;

import java.io.Serializable;

import cn.com.cgbchina.batch.model.IntegralExchangeModel;
import lombok.Getter;
import lombok.Setter;

/**
 * 报表 订单虚拟礼品信息
 * 
 * @author huangcy on 2016年6月23日
 */
public class IntegralExchangeDto extends IntegralExchangeModel implements Serializable {


	private static final long serialVersionUID = 7573676924519651718L;
	@Setter
	@Getter
	private String createDate;
	
	@Setter
	@Getter
	private String expDate;
}
