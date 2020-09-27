package cn.com.cgbchina.batch.service;

import java.io.IOException;

/**
 * (会员报表)会员搜索记录报表
 * 
 * @author xiewl
 * @version 2016年6月16日 下午3:18:11
 */
public interface MemberSearchRecordService {

	/**
	 * 会员搜索记录周报表 excel 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @throws IOException
	 */
	void exportMemberSearchRecordForWeek(String batchDate) throws IOException;

	/**
	 * 会员搜索记录月报表excel 每月一日凌晨生成（每月初至月底）
	 * 
	 * @throws IOException
	 */
	void exportMemberSearchRecordForMonth(String batchDate) throws IOException;
}
