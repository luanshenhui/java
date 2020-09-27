package cn.com.cgbchina.promotion;

import lombok.extern.slf4j.Slf4j;
import org.unitils.UnitilsJUnit4;
import org.unitils.database.annotations.Transactional;
import org.unitils.database.util.TransactionMode;
import org.unitils.spring.annotation.SpringApplicationContext;

@SpringApplicationContext({ "classpath:/spring/promotion-service-test.xml" })
@Transactional(TransactionMode.ROLLBACK)
@Slf4j
public abstract class BaseTestCase extends UnitilsJUnit4 {

}
