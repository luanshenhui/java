package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Created by niufw on 16-5-31.
 */
public class CardScaleDto implements Serializable{


	private static final long serialVersionUID = -7125825142401398979L;
	@Getter
	@Setter
	private BigDecimal scal;	//优惠比例

	@Getter
	@Setter
	private String cardName;  //卡名称

}
