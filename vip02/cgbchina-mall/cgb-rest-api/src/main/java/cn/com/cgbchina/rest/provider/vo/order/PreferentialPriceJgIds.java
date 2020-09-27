package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

/**
 *	日期		:	2016-8-28<br>
 *	作者		:	xiewl<br>
 *	项目		:	cgb-rest-api<br>
 *	功能		:	<br>
 */
public class PreferentialPriceJgIds implements Serializable {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -124542335125007746L;
	@NotNull
	private String jgId;

	public String getJgId() {
		return jgId;
	}

	public void setJgId(String jgId) {
		this.jgId = jgId;
	}
	
	
}
