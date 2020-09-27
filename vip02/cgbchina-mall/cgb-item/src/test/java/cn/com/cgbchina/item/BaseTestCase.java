package cn.com.cgbchina.item;

import org.junit.runner.RunWith;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
        "classpath:spring/mysql-dao-context-test.xml",
        "classpath:spring/redis-context-test.xml",
})
@Rollback
@Transactional
public class BaseTestCase {


}
