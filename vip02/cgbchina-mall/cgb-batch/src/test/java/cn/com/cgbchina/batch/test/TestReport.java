package cn.com.cgbchina.batch.test;

import cn.com.cgbchina.batch.service.BatchDayReportService;
import cn.com.cgbchina.batch.service.BatchMonthReportService;
import cn.com.cgbchina.batch.service.BatchWeekReportService;
import cn.com.cgbchina.batch.util.ReportConstant;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Created by 11150121040023 on 2016/7/15.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/batch-context-test.xml")
@ActiveProfiles("dev")
public class TestReport {
    @Autowired
    private BatchDayReportService batchDayReportService;
    @Autowired
    private BatchMonthReportService batchMonthReportService;
    @Autowired
    private BatchWeekReportService weekReportService;
    @Test
    public void test4() {
        batchDayReportService.runBatchDayReport("20160820", "JF03");
    }
    @Test
    public void test5() {
        batchDayReportService.runBatchDayReport("20160820", "all");
    }

    @Test
    public void test7() {
        weekReportService.runBatchWeekReport("20160820", "all");
    }

    @Test
    public void test8() {
        batchMonthReportService.runBatchMonthReport("20160820", "all");
    }

}
