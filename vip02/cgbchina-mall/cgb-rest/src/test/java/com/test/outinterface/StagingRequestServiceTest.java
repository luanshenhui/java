package com.test.outinterface;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQuery;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQueryResult;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import com.spirit.util.JsonMapper;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

/**
 * Created by CuiZhengwei on 2016/8/3.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
public class StagingRequestServiceTest {
    @Resource
    StagingRequestService stagingRequestServiceImpl;
    private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

    /**
     * bps工单进展查询
     */
    @Test
    public void test_workOrderQuery_01() {
        WorkOrderQuery info = BeanUtils.randomClass(WorkOrderQuery.class);
        // 【外部接口提供部分】
        info.setCaseID(""); // BPS工单号
        // 【商城提供部分】
        info.setSrcCaseId("201607190000047010"); // 商城订单号
        info.setChannel("070"); // 渠道
        WorkOrderQueryResult result = stagingRequestServiceImpl.workOrderQuery(info);
        System.out.println("输出结果：" + jsonMapper.toJson(result));
        Assert.assertNotNull(stagingRequestServiceImpl.getClass().getName() + "对比失败", result);
    }
}
