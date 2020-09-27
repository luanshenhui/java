package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.BatchReportRegDao;
import cn.com.cgbchina.batch.model.ReportModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * 
 * 日期 : 2016年7月14日<br>
 * 作者 : Administrator<br>
 * 项目 : cgb-related<br>
 * 功能 : 报表文件记录<br>
 */
@Component
@Slf4j
@Transactional
public class ReportSubManager {
	@Autowired
	private BatchReportRegDao reportRegDao;
	@Transactional
	public Integer insert(ReportModel reportModel) {
		return reportRegDao.insert(reportModel);
	}
	@Transactional
	public Integer update(ReportModel existReportModel) {
		return reportRegDao.update(existReportModel);
	}

}
