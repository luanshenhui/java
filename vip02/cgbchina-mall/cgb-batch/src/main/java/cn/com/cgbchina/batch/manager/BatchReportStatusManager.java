package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.BatchStatusDao;
import cn.com.cgbchina.batch.model.BatchStatusModel;
import cn.com.cgbchina.batch.util.Reporter;
import cn.com.cgbchina.common.utils.DateHelper;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by lvzd on 2016/9/20.
 */
@Component
public class BatchReportStatusManager {

    private static final String IS_SUS_Y = "Y";
    private static final String IS_SUS_N = "N";
    @Resource
    private BatchStatusDao batchStatusDao;
    /**
     * 批处理状态表记录更新
     * @param retReport 报表生成返回值
     * @param curTblBatchStatus 批处理状态表记录
     * @param reporter 报表信息
     * @param batchDate 开始日期
     */
    @Transactional
    public void createAndUpdateStatus(Response<Boolean> retReport, BatchStatusModel curTblBatchStatus, Reporter reporter,
                                      String batchDate, String jobKey) {
        if (retReport.isSuccess()) {
            if (curTblBatchStatus == null) {
                curTblBatchStatus = new BatchStatusModel();
                curTblBatchStatus.setJobName(jobKey);
                curTblBatchStatus.setJobParam1(reporter.getId());
                curTblBatchStatus.setRunTime(DateHelper.string2Date(batchDate + DateHelper.getHHmmss(), DateHelper.YYYYMMDDHHMMSS));
                curTblBatchStatus.setJobParam2(getJobParam2(reporter.getName()));
                curTblBatchStatus.setIsSuccess(IS_SUS_Y);
                batchStatusDao.insert(curTblBatchStatus);
            } else {
                curTblBatchStatus.setIsSuccess(IS_SUS_Y);
                curTblBatchStatus.setRunTime(DateHelper.string2Date(batchDate + DateHelper.getHHmmss(), DateHelper.YYYYMMDDHHMMSS));
                curTblBatchStatus.setExceptionMsg("");
                batchStatusDao.updateByPrimaryKey(curTblBatchStatus);
            }
        } else {
            if (curTblBatchStatus == null) {
                curTblBatchStatus = new BatchStatusModel();
                curTblBatchStatus.setJobName(jobKey);
                curTblBatchStatus.setJobParam1(reporter.getId());
                curTblBatchStatus.setRunTime(DateHelper.string2Date(batchDate + DateHelper.getHHmmss(), DateHelper.YYYYMMDDHHMMSS));
                curTblBatchStatus.setJobParam2(getJobParam2(reporter.getName()));
                curTblBatchStatus.setIsSuccess(IS_SUS_N);
                curTblBatchStatus.setExceptionMsg(retReport.getError());
                batchStatusDao.insert(curTblBatchStatus);
            } else {
                curTblBatchStatus.setIsSuccess(IS_SUS_N);
                curTblBatchStatus.setRunTime(DateHelper.string2Date(batchDate + DateHelper.getHHmmss(), DateHelper.YYYYMMDDHHMMSS));
                curTblBatchStatus.setExceptionMsg(retReport.getError());
                batchStatusDao.updateByPrimaryKey(curTblBatchStatus);
            }
        }
    }

    private static String getJobParam2(String reportName) {
        return reportName.length() > 50 ? reportName.substring(0, 50) : reportName;
    }
}
