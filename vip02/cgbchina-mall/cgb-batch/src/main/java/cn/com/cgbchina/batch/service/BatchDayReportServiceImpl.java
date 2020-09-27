package cn.com.cgbchina.batch.service;

import java.util.*;

import cn.com.cgbchina.batch.manager.BatchReportManager;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.stereotype.Service;


@Slf4j
@Service
public class BatchDayReportServiceImpl extends BatchReportManager implements BatchDayReportService {
	@Override
	public Response<Boolean> runBatchDayReport(String batchDate,String param1) {
		if (Strings.isNullOrEmpty(batchDate)) {
			batchDate = new DateTime().minusDays(1).toString(DateHelper.YYYYMMDD);
		}
		if (Strings.isNullOrEmpty(param1)) {
			param1 = PARAM_ALL;
		}
		return super.runBatchReport(batchDate, param1, FLG_DAY);
	}

	@Override
	public Response<Boolean> runBatchDayReport() {
		return super.runBatchReport(new DateTime().minusDays(1).toString(DateHelper.YYYYMMDD), PARAM_ALL, FLG_DAY);
	}
}
