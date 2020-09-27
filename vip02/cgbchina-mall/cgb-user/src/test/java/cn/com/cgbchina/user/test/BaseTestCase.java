package cn.com.cgbchina.user.test;

import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
        "classpath:spring/mysql-dao-context-test.xml",
        "classpath:spring/redis-context-test.xml",
        "classpath:spring/user-service-context-test.xml"

})
public class BaseTestCase {


}
