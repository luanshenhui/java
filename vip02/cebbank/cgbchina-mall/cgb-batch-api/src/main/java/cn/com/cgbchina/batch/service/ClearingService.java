package cn.com.cgbchina.batch.service;

import java.io.IOException;

/**
 * 结算报表（积分商城） {@link SettlementDatail}
 * 
 * @author huangcy
 */
public interface ClearingService {
	/**
	 * 结算日报表 每日凌晨生成（统计每日0点至24点）
	 * 
	 * @throws IOException
	 */
	void exportClearingPdfForDay(String batchDate) throws IOException;
}
