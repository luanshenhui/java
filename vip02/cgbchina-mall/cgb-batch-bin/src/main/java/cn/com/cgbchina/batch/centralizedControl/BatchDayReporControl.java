package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.BatchDayReportService;
import cn.com.cgbchina.batch.util.SpringUtil;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;

/**
 * Created by 11150121040023 on 2016/8/16.
 */
public class BatchDayReporControl extends BaseControl {

    /**
     * 日报批量任务
     * @param args
     */
    public static void main(String[] args) {
        BatchDayReporControl synControl = new BatchDayReporControl();
        synControl.setBatchName("【集中调度】日报批量任务");
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
        BatchDayReportService batchDayReportService = SpringUtil.getBean(BatchDayReportService.class);
        if (!Strings.isNullOrEmpty(str1)) {
            try {
                DateHelper.string2Date(str1, DateHelper.YYYYMMDD);
            } catch (Exception e) {
                throw new BatchException("日期格式有误");
            }
            return batchDayReportService.runBatchDayReport(str1, str2);
        } else {
            return batchDayReportService.runBatchDayReport();
        }
    }
}
