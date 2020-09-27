package cn.com.cgbchina.batch.test;

import cn.com.cgbchina.batch.service.IvrRankService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

/**
 * Created by 11150121040023 on 2016/7/15.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/batch-context-test.xml")
@ActiveProfiles("dev")
public class IvrRankServiceTest {
    @Autowired
    private IvrRankService service;
    @Test
    public void test1() {

        service.rankListWithTxn();
    }
}
