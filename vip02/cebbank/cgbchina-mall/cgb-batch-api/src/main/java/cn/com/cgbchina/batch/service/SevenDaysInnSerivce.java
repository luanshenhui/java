package cn.com.cgbchina.batch.service;

import java.io.IOException;

/**
 * 7天联名卡住宿券报表服务
 * 
 * @author xiewl
 * @version 2016年6月16日 上午10:00:19
 */
public interface SevenDaysInnSerivce {
	/**
	 * 7天联名卡住宿券报表 excel 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @throws IOException
	 */
	void exportSevenDaysInnModelForWeek(String batchDate) throws IOException;
}
