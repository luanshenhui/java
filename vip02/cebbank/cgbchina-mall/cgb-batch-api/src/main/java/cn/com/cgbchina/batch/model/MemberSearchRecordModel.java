package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * (会员报表)会员搜索记录报表
 * 
 * @author xiewl
 * @version 2016年6月16日 下午3:10:04
 */
public class MemberSearchRecordModel implements Serializable {
	/**
	 * 关键字
	 */
	@Getter
	@Setter
	private String KeyWord;
	/**
	 * 来源商城
	 */
	@Getter
	@Setter
	private String mallNm;
	/**
	 * 搜索次数
	 */
	@Getter
	@Setter
	private String SearchNum;

}
