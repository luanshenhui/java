package com.test.outinterface;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQuery;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQueryResult;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import com.spirit.util.JsonMapper;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

/**
 * Created by txy on 2016/8/3.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
public class pointServiceTest {
    private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    @Resource
    PointService pointServiceImpl;

    @Test
    public void test_queryPoint_01() {
        PointTypeQuery info = BeanUtils.randomClass(PointTypeQuery.class);
        // 【商城提供部分】
        info.setChannelID("MALL");
        info.setCurrentPage("0");//页数
        PointTypeQueryResult result = pointServiceImpl.queryPointType(info);
        System.out.println("输出结果：" + jsonMapper.toJson(result));
        Assert.assertNotNull(pointServiceImpl.getClass().getName() + "对比失败",
                result);
    }
}
