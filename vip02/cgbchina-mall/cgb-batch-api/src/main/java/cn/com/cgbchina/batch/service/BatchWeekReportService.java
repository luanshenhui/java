package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

import java.util.Map;

public interface BatchWeekReportService {

	Response<Boolean> runBatchWeekReport(String beginDate, String param1);

	Response<Boolean> runBatchWeekReport();
}