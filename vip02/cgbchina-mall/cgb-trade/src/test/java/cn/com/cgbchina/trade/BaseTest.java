package cn.com.cgbchina.trade;

import org.springframework.test.context.ContextConfiguration;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by 11140721050130 on 16-3-23.
 */
@ContextConfiguration(locations = "classpath:/spring/trade-dubbo-provider.xml")
@Transactional
// @Ignore
public class BaseTest {
}
