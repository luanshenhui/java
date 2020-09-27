package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * (会员报表)会员搜索记录报表
 *
 * @author xiewl
 * @version 2016年6月16日 下午3:10:04
 */
@Getter
@Setter
@ToString
public class MemberSearchRecordModel implements Serializable {
	private static final long serialVersionUID = -5685013863372650235L;
	/**
	 * 关键字
	 */
	private String KeyWord;
	/**
	 * 来源商城
	 */
	private String mallNm;
	/**
	 * 搜索次数
	 */
	private String SearchNum;

}
