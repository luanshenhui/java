package cn.com.cgbchina.batch.service;

import java.io.IOException;

/**
 * (会员报表)会员总数报表
 * 
 * @author xiewl
 * @version 2016年6月16日 下午2:56:31
 */
public interface MemberNumService {
	/**
	 * 会员总数报表周报表 excel 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @throws IOException
	 */
	void exportMemberNumForWeek(String batchDate) throws IOException;

	/**
	 * 会员总数报表月报表excel 每月一日凌晨生成（每月初至月底）
	 * 
	 * @throws IOException
	 */
	void exportMemberNumForMonth(String batchDate) throws IOException;
}
