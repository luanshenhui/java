package cn.com.cgbchina.admin.test;

import org.junit.Ignore;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.transaction.annotation.Transactional;

import junit.framework.TestCase;

@ContextConfiguration(locations = { "classpath:/spring/related-dubbo-provider.xml" })
@Ignore
@Transactional
public class BaseTestCase extends TestCase {

}
