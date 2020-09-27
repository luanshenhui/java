package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

import java.util.Map;

public interface BatchMonthReportService {

	Response<Boolean> runBatchMonthReport(String beginDate, String param1);

	Response<Boolean> runBatchMonthReport();
}