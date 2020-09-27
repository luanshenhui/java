package cn.com.cgbchina.batch.test;

import cn.com.cgbchina.batch.service.ClearQueryService;
import cn.com.cgbchina.batch.service.MakeCheckAccRenewService;
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
public class MakeCheckAccRenewServiceTest {
    @Autowired
    private MakeCheckAccRenewService makeCheckAccRenewService;

    @Test
    public void test1() {
        makeCheckAccRenewService.makeCheckAccRenewWithTxn();
    }
}
