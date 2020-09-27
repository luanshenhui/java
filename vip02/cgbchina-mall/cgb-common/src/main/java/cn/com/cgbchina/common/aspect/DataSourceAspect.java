package cn.com.cgbchina.common.aspect;

import com.google.common.base.Throwables;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.core.Ordered;

/**
 * 切换数据源(不同方法调用不同数据源)
 */
@Aspect
@EnableAspectJAutoProxy(proxyTargetClass = true)
public class DataSourceAspect implements Ordered {
    private static final Logger log = LoggerFactory.getLogger(DataSourceAspect.class);

    @Pointcut("@within(org.springframework.transaction.annotation.Transactional) || @annotation(org.springframework.transaction.annotation.Transactional)")
    public void aspect() {
    }
    /**
     * 配置前置通知,使用在方法aspect()上注册的切入点
     */
    @Before("aspect()")
    public void before(JoinPoint point) {
        try {
            HandleDataSource.putDataSource("write");
        } catch (Exception e) {
            log.error(Throwables.getStackTraceAsString(e));
            HandleDataSource.putDataSource("write");
        }
    }

    @After("aspect()")
    public void after(JoinPoint point) {
        HandleDataSource.clear();
    }

    @Override
    public int getOrder() {
        return 100;
    }
}
