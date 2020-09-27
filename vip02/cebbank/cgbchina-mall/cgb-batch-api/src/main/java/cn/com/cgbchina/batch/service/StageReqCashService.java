package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.StagesReqCash;

/**
 * 分期请款报表（广发商城管理平台）
 * 
 * @see StagesReqCash
 * @author huangcy
 */
public interface StageReqCashService {
	/**
	 * 分期请款报表 每日凌晨生成(生成当日从前天18点至昨天18点)
	 * 
	 * @throws IOException
	 */
	void exportStageCashoutForDay(String batchDate, String vendorId, String vendorNm) throws IOException;
}
