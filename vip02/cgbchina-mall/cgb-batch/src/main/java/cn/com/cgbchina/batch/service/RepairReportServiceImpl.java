package cn.com.cgbchina.batch.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.batch.dao.BatchStatusDao;
import cn.com.cgbchina.batch.model.BatchStatusModel;
import cn.com.cgbchina.batch.util.ReportConstant;

import com.spirit.common.model.Response;

@Service
public class RepairReportServiceImpl implements RepairReportService {
	@Resource
	private BatchStatusDao batchStatusDao;
	@Resource
	private BatchDayReportService batchDayReportService;
	@Resource
	private BatchWeekReportService batchWeekReportService;
	@Resource
	private BatchMonthReportService batchMonthReportService;
	@Override
	public Response<Boolean> repairRunBatchReport(){
		List<BatchStatusModel> list = batchStatusDao.getFaildReport();
		for(BatchStatusModel model:list){
			switch (model.getJobName()) {
			case ReportConstant.JOBKEY_DAY:
				batchDayReportService.runBatchDayReport(model.getBeginDate(), model.getJobParam1());
				break;
			case ReportConstant.JOBKEY_WEEK:
				batchWeekReportService.runBatchWeekReport(model.getBeginDate(), model.getJobParam1());
				break;
			case ReportConstant.JOBKEY_MONTH:
				batchMonthReportService.runBatchMonthReport(model.getBeginDate(), model.getJobParam1());
				break;
			default:
				break;
			}
		}
		Response<Boolean> response = new Response<Boolean>();
		response.setResult(true);
		return response;
	}
}
