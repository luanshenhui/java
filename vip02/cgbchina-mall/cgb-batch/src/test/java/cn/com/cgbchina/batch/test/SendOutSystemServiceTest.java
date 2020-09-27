package cn.com.cgbchina.batch.test;

import cn.com.cgbchina.batch.service.SendOutSystemService;
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
public class SendOutSystemServiceTest {
    @Autowired
    private SendOutSystemService sendOutSystemService;

    @Test
    public void test1() throws InterruptedException {
        sendOutSystemService.sendOrders2Outsystem();

        Thread.sleep(7000);
    }
}
