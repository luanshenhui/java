package cn.com.cgbchina.batch.service;


import cn.com.cgbchina.batch.manager.BatchReportManager;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class BatchMonthReportServiceImpl extends BatchReportManager implements BatchMonthReportService {
	@Override
	public Response<Boolean> runBatchMonthReport(String batchDate, String param1) {
		if (Strings.isNullOrEmpty(batchDate)) {
			batchDate = new DateTime().minusMonths(1).dayOfMonth().withMinimumValue().toString(DateHelper.YYYYMMDD);
		}
		if (Strings.isNullOrEmpty(param1)) {
			param1 = PARAM_ALL;
		}
		return super.runBatchReport(batchDate, param1, FLG_MONTH);
	}

	@Override
	public Response<Boolean> runBatchMonthReport() {
		return super.runBatchReport(
				new DateTime().minusMonths(1).dayOfMonth().withMinimumValue().toString(DateHelper.YYYYMMDD)
				, PARAM_ALL, FLG_MONTH);
	}

	public static void main(String[] args) {
		System.out.println(new DateTime().minusMonths(1).dayOfMonth().withMinimumValue().toString(DateHelper.YYYYMMDD));
		System.out.println(new DateTime().minusDays(1).toString(DateHelper.YYYYMMDD));
		System.out.println(new DateTime().minusWeeks(1).dayOfWeek().withMaximumValue().toString(DateHelper.YYYYMMDD));
	}
}
