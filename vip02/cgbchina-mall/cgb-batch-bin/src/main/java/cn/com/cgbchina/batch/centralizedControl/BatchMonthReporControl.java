package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.BatchMonthReportService;
import cn.com.cgbchina.batch.util.SpringUtil;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;

import java.util.Calendar;
import java.util.Date;

/**
 * Created by 11150121040023 on 2016/8/16.
 */
public class BatchMonthReporControl extends BaseControl {

    /**
     * 月报批量任务
     * @param args
     */
    public static void main(String[] args) {
        BatchMonthReporControl synControl = new BatchMonthReporControl();
        synControl.setBatchName("【集中调度】月报批量任务");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        String[] args = getArgs();
        String str1 = "";
        String str2 = "";
        if (args.length == 1) {
            str1 = args[0];
        } else if (args.length >= 2) {
            str1 = args[0];
            str2 = args[1];
        } else {
        }
        BatchMonthReportService batchMonthReportService = SpringUtil.getBean(BatchMonthReportService.class);
        if (!Strings.isNullOrEmpty(str1)) {
            try {
                Date runDate = DateHelper.string2Date(str1, DateHelper.YYYYMMDD);
                Calendar cal = Calendar.getInstance();
                cal.setTime(runDate);
                if (1 != cal.get(Calendar.DAY_OF_MONTH)) {
                    throw new BatchException("月报表日期参数必须是每月第一天");
                }
            } catch (Exception e) {
                throw new BatchException("日期格式有误");
            }
            return batchMonthReportService.runBatchMonthReport(str1, str2);
        } else {
            return batchMonthReportService.runBatchMonthReport();
        }
    }
}
