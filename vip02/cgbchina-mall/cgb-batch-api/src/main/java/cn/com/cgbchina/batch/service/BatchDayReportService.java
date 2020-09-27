package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

import java.util.Map;

public interface BatchDayReportService {

	Response<Boolean> runBatchDayReport(String beginDate, String param1);

	Response<Boolean> runBatchDayReport();
}