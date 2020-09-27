package cn.com.cgbchina.batch.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * (会员报表)会员搜索记录报表
 * 
 * @author xiewl
 * @version 2016年6月16日 下午3:10:04
 */
public class MemberSearchDto implements Serializable {
	private static final long serialVersionUID = 9055972780398998383L;
	/**
	 * 广发关键字
	 */
	@Getter
	@Setter
	private String keyWordsYG;
	/**
	 * 广发搜索次数
	 */
	@Getter
	@Setter
	private String searchNumYG;
	/**
	 * 积分关键字
	 */
	@Getter
	@Setter
	private String keyWordsJF;
	/**
	 * 积分搜索次数
	 */
	@Getter
	@Setter
	private String searchNumJF;

	/**
	 * 关键字
	 */
	/*@Getter
	@Setter
	private String KeyWord;*/
	/**
	 * 来源商城
	 */
/*	@Getter
	@Setter
	private String mallNm;*/

	/**
	 * 搜索次数
	 */
	/*@Getter
	@Setter
	private String SearchNum;*/

}
