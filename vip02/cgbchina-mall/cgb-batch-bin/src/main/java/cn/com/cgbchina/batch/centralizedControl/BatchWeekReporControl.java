package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.BatchWeekReportService;
import cn.com.cgbchina.batch.util.SpringUtil;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;

import java.util.Calendar;
import java.util.Date;

/**
 * Created by 11150121040023 on 2016/8/16.
 */
public class BatchWeekReporControl extends BaseControl {

    /**
     * 周报批量任务开始
     * @param args
     */
    public static void main(String[] args) {
        BatchWeekReporControl synControl = new BatchWeekReporControl();
        synControl.setBatchName("【集中调度】周报批量任务");
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
        BatchWeekReportService batchWeekReportService = SpringUtil.getBean(BatchWeekReportService.class);
        if (!Strings.isNullOrEmpty(str1)) {
            try {
                Date runDate = DateHelper.string2Date(str1, DateHelper.YYYYMMDD);
                Calendar cal = Calendar.getInstance();
                cal.setTime(runDate);
                if (Calendar.SUNDAY != cal.get(Calendar.DAY_OF_WEEK)) {
                    throw new BatchException("周报日期参数必须是星期日");
                }
            } catch (Exception e) {
                throw new BatchException("日期格式有误");
            }
            return batchWeekReportService.runBatchWeekReport(str1, str2);
        } else {
            return batchWeekReportService.runBatchWeekReport();
        }
    }
}
