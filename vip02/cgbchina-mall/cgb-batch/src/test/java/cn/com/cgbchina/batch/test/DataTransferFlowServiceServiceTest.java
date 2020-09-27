package cn.com.cgbchina.batch.test;

import cn.com.cgbchina.batch.service.DataTransferFlowService;
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
public class DataTransferFlowServiceServiceTest {
    @Autowired
    private DataTransferFlowService dataTransferFlowService;

    @Test
    public void test1() {
        // 根据表名处理一个表的迁移
        dataTransferFlowService.dealOneTableByName("tblorderdodetail_history");
        // 处理所有表迁移
        //dataTransferFlowService.dealAllTable();
        // 根据recordId处理后续流程的迁移
        //dataTransferFlowService.dealTableById("");
    }
}
