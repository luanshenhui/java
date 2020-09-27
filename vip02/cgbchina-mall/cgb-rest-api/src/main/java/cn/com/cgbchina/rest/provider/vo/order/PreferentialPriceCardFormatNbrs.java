package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 *	日期		:	2016-8-28<br>
 *	作者		:	xiewl<br>
 *	项目		:	cgb-rest-api<br>
 *	功能		:	<br>
 */
public class PreferentialPriceCardFormatNbrs implements Serializable {

	

	private static final long serialVersionUID = -6386608680941991627L;
	@NotNull
	@XMLNodeName(value = "card_format_nbr")
	private  String cardFormatNbr;

	public String getCardFormatNbr() {
		return cardFormatNbr;
	}

	public void setCardFormatNbr(String cardFormatNbr) {
		this.cardFormatNbr = cardFormatNbr;
	}
	
	
}
