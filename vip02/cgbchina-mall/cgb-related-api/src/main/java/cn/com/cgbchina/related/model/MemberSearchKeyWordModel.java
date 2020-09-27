package cn.com.cgbchina.related.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 会员搜索关键字 日期 : 2016年7月7日<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-related-api<br>
 * 功能 : <br>
 */
public class MemberSearchKeyWordModel extends TblEspKeywordRecordModel implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6130928280831432475L;
	/**
	 * 搜索次数
	 */
	@Setter
	@Getter
	public BigDecimal searchNum;

}
