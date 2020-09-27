package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.BatchStatusDao;
import cn.com.cgbchina.batch.model.BatchStatusModel;
import cn.com.cgbchina.batch.util.ReportConstant;
import cn.com.cgbchina.batch.util.ReportObjectCreator;
import cn.com.cgbchina.batch.util.Reporter;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;


@Slf4j
@Service
public class BatchReportManager {

	private String jobKey;
	private String logKey;
	private static final String LOGKEY_DAY = "日报";
	private static final String LOGKEY_MONTH = "月报";
	private static final String LOGKEY_WEEK = "周报";
	protected static final String FLG_DAY = "day";
	protected static final String FLG_MONTH = "month";
	protected static final String FLG_WEEK = "week";
	private static final String IS_SUS_Y = "Y";
	private static final String IS_SUS_N = "N";
	protected static final String PARAM_ALL = "all";
	@Resource
	private BatchStatusDao batchStatusDao;
	@Autowired
	private ReportObjectCreator reportObjectCreator;
	@Resource
	private VendorService vendorService;
	// 批处理状态表MAP
	private ConcurrentMap<String, BatchStatusModel> batchStatusMap;
	private ThreadLocal<Boolean> singleThread = new ThreadLocal<Boolean>();
	private ThreadLocal<Boolean> erroThread = new ThreadLocal<>();
	// 线程池
	private ExecutorService executorService = Executors.newCachedThreadPool();
	@Resource
	private BatchReportStatusManager batchReportStatusManager;
	public Response<Boolean> runBatchReport(String batchDate, String param1, String reportFlg) {
		log.info("runBatchReport start...");
		Response<Boolean> rps = new Response<>();
		try {
			// 判断报表batch是否已经跑了
			if (StringUtils.isTrimEmpty(param1) && !param1.equalsIgnoreCase(PARAM_ALL)) {
				singleThread.set(Boolean.TRUE);
			} else {
				singleThread.set(Boolean.FALSE);
			}
			switch (reportFlg) {
				case FLG_DAY:
					jobKey = ReportConstant.JOBKEY_DAY;
					logKey = LOGKEY_DAY;
					getStatus(batchDate);
					run(batchDate, param1, reportObjectCreator.getDayReporterMap());
					break;
				case FLG_WEEK:
					jobKey = ReportConstant.JOBKEY_WEEK;
					logKey = LOGKEY_WEEK;
					getStatus(batchDate);
					run(batchDate, param1, reportObjectCreator.getWeekReporterMap());
					break;
				case FLG_MONTH:
					jobKey = ReportConstant.JOBKEY_MONTH;
					logKey = LOGKEY_MONTH;
					getStatus(batchDate);
					run(batchDate, param1, reportObjectCreator.getMonthReporterMap());
					break;
				default:
					break;
			}
			if (erroThread.get() == null) {
				rps.setSuccess(true);
			}
			return rps;
		} catch (Exception e) {
			log.error(logKey + "生成失败 erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		} finally {
			log.info("runBatchReport end.");
		}
	}

	/**
	 * 批处理状态表记录取得
	 * @param batchDate 开始时间
	 */
	private void getStatus(String batchDate) {
		BatchStatusModel param = new BatchStatusModel();
		param.setJobName(jobKey);
		param.setBeginDate(batchDate);
		List<BatchStatusModel> batchStatusModels = batchStatusDao.selectByObj(param);
		batchStatusMap = Maps.newConcurrentMap();
		for (BatchStatusModel batchstatus : batchStatusModels) {
			batchStatusMap.put(batchstatus.getJobParam1(), batchstatus);
		}
	}

	/**
	 * 执行报表处理
	 * @param batchDate 开始日期（YYYYMMDD）
	 * @param param1 all/null/指定报表ID
	 * @param reporterMap 报表信息
	 * @throws Exception
	 */
	private void run(String batchDate, String param1, Map<String, Reporter> reporterMap) throws Exception {
		if (singleThread.get() !=null && singleThread.get()) {
			Reporter reporter = reporterMap.get(param1);
			if (reporter == null) {
				return;
			}
			log.info(logKey + "批量，只跑指定报表。ID:" + reporter.getId() + ",报表名称：" + reporter.getName());
			Response<Boolean> retReport = new Response<>();
			if (reporter.getParameterTypes().length == 3) {
				runVenderReport(batchStatusMap.get(reporter.getId()), reporter, batchDate);
			} else {
				retReport = runBatchReport(batchDate, null, null, batchStatusMap.get(reporter.getId()), reporter);
				if (!retReport.isSuccess()) {
					erroThread.set(Boolean.TRUE);
				}
				createAndUpdateStatus(retReport, batchStatusMap.get(reporter.getId()), reporter, batchDate);
			}
			return;
		}
		// 多线程执行
		ExecutorService executorService = Executors.newFixedThreadPool(reporterMap.size());
		CompletionService<ReportObj> completionService = new ExecutorCompletionService<ReportObj>(executorService);

		int i = 0;
		for (String reportId : reporterMap.keySet()) {
			Reporter reporter = reporterMap.get(reportId);
			BatchStatusModel curTblBatchStatus = batchStatusMap.get(reporter.getId());
			if (PARAM_ALL.equalsIgnoreCase(param1)) {
				log.info(logKey + "批量，重跑报表。ID:" + reporter.getId() + ",报表名称：" + reporter.getName());
			} else if (singleThread.get() !=null && !singleThread.get()
					&& curTblBatchStatus != null && IS_SUS_Y.equalsIgnoreCase(curTblBatchStatus.getIsSuccess())) {
				log.info(logKey + "批量，报表ID：" + reporter.getId() + ",报表名称：" + reporter.getName() + ",已经生成过，本次任务不再重新生成");
				continue;
			}
			if (reporter.getParameterTypes().length == 3) {
				runVenderReport(curTblBatchStatus, reporter, batchDate);
			} else {
				completionService.submit(execReport(batchDate, null, null, curTblBatchStatus, reporter));
				i++;
			}
		}
		for (int j = 0; j < i; j++) {
			ReportObj retObj = completionService.take().get();
			Reporter reporter = retObj.getReporter();
			Response<Boolean> retReport = retObj.getRetReport();
			if (!retReport.isSuccess()) {
				erroThread.set(Boolean.TRUE);
			}
			createAndUpdateStatus(retReport, retObj.getCurTblBatchStatus(), reporter, batchDate);
		}
		executorService.shutdown();
	}

	private void createAndUpdateStatus(final Response<Boolean> retReport, final BatchStatusModel curTblBatchStatus,
									 final Reporter reporter,
									 final String batchDate) {
		executorService.submit(new Runnable() {
			public void run() {
				try {
					batchReportStatusManager.createAndUpdateStatus(retReport, curTblBatchStatus, reporter, batchDate, jobKey);
				} catch (Exception e) {
					log.error("executorBatchStatus erro : {}" , Throwables.getStackTraceAsString(e));
				}
			}
		});
	}

	/**
	 * 供应商报表处理
	 * @param curTblBatchStatus 批处理状态表记录
	 * @param reporter 报表信息
	 * @param batchDate 开始日期
	 * @throws Exception
	 */
	private void runVenderReport(BatchStatusModel curTblBatchStatus, Reporter reporter, String batchDate) throws Exception {
		boolean allSuccess = true;
		StringBuffer sb = new StringBuffer();
		// 生成全供应商报表
		Response<Boolean> rReport = runBatchReport(batchDate, null, null, batchStatusMap.get(reporter.getId()), reporter);
		if (!rReport.isSuccess()) {
			allSuccess = false;
			sb.append(rReport.getError().concat("\r\n#################\r\n"));
		}
		List<VendorInfoModel> models = queryVendorByOrdertype(reporter.getOrdertypeId());
		int m = 0;
		// 启动线程池
		ExecutorService executorServiceVender = Executors.newFixedThreadPool(models.size());
		CompletionService<ReportObj> completionServiceVender = new ExecutorCompletionService<ReportObj>(executorServiceVender);
		for(VendorInfoModel model : models){
			completionServiceVender.submit(execReport(batchDate, model.getVendorId(), model.getFullName(), curTblBatchStatus, reporter));
			m++;
		}
		for (int n = 0; n < m; n++) {
			ReportObj retObj = completionServiceVender.take().get();
			Response<Boolean> retReport = retObj.getRetReport();
			if (!retReport.isSuccess()) {
				allSuccess = false;
				sb.append(retReport.getError().concat("\r\n#################\r\n"));
			}
		}
		Response<Boolean> retReport = new Response<>();
		if (allSuccess) {
			retReport.setResult(true);
		} else {
			retReport.setError(sb.toString());
		}
		if (!retReport.isSuccess()) {
			erroThread.set(Boolean.TRUE);
		}
		createAndUpdateStatus(retReport, curTblBatchStatus, reporter, batchDate);
		executorServiceVender.shutdown();
	}

	/**
	 * 异步执行报表处理
	 */
	private Callable<ReportObj> execReport(final String beginDate, final String vendorId, final String vendorNm,
										   final BatchStatusModel curTblBatchStatus, final Reporter reporter) {
		Callable<ReportObj> ret = new Callable<ReportObj>() {
			@Override
			public ReportObj call() throws Exception {
				Response<Boolean> finalRetReport = runBatchReport(beginDate, vendorId, vendorNm, curTblBatchStatus, reporter);
				ReportObj objs = new ReportObj();
				objs.setCurTblBatchStatus(curTblBatchStatus);
				objs.setReporter(reporter);
				objs.setRetReport(finalRetReport);
				return objs;
			}
		};
		return ret;
	}

	/*
	 * 报表生成处理
	 */
	private Response<Boolean> runBatchReport(String beginDate,String vendorId, String vendorNm,
											 BatchStatusModel curTblBatchStatus, Reporter reporter) {
		Response<Boolean> retReport = new Response<>();
		try {
			if (reporter.getParameterTypes().length == 3) {
				retReport = (Response<Boolean>)reporter.getMethod().invoke(reporter.getTarget(), new Object[]{beginDate, vendorId, vendorNm});
			} else {
				retReport = (Response<Boolean>)reporter.getMethod().invoke(reporter.getTarget(), beginDate);
			}
		} catch (Exception e) {
			log.error(logKey + "生成失败 erro:{}", Throwables.getStackTraceAsString(e));
			retReport.setError(Throwables.getStackTraceAsString(e));
		}
		return retReport;
	}

	private List<VendorInfoModel> queryVendorByOrdertype(String ordertypeId){
		VendorInfoModel vendorInfoModel = new VendorInfoModel();
		vendorInfoModel.setBusinessTypeId(ordertypeId);
		Response<List<VendorInfoModel>> response = vendorService.findAll(vendorInfoModel);
		if(!response.isSuccess()){
			throw new RuntimeException(response.getError());
		}
		List<VendorInfoModel> vendorInfoModels = response.getResult();
		return vendorInfoModels;
	}

	@Setter
	@Getter
	private class ReportObj {
		private String beginDate;
		private Reporter reporter;
		private BatchStatusModel curTblBatchStatus;
		private Response<Boolean> retReport;
	}
}