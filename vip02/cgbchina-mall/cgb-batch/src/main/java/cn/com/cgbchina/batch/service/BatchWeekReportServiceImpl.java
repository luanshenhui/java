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
public class BatchWeekReportServiceImpl extends BatchReportManager implements BatchWeekReportService {
	@Override
	public Response<Boolean> runBatchWeekReport(String batchDate, String param1) {
		if (Strings.isNullOrEmpty(batchDate)) {
			batchDate = new DateTime().minusWeeks(1).dayOfWeek().withMaximumValue().toString(DateHelper.YYYYMMDD);
		}
		if (Strings.isNullOrEmpty(param1)) {
			param1 = PARAM_ALL;
		}
		return super.runBatchReport(batchDate, param1, FLG_WEEK);
	}

	@Override
	public Response<Boolean> runBatchWeekReport() {
		return super.runBatchReport(
				new DateTime().minusWeeks(1).dayOfWeek().withMaximumValue().toString(DateHelper.YYYYMMDD), PARAM_ALL,
				FLG_WEEK);
	}
}
