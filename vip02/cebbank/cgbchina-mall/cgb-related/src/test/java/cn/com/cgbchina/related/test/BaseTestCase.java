package cn.com.cgbchina.related.test;

import junit.framework.TestCase;
import org.junit.Ignore;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.transaction.annotation.Transactional;

@ContextConfiguration(locations = { "classpath:/spring/related-dubbo-provider.xml" })
@Ignore
@Transactional
public class BaseTestCase extends TestCase {

}
