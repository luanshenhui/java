package cn.com.cgbchina.scheduler.util;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Spring 共通类
 *
 * @author lvzhida
 */
public class SpringUtil {
    private static AbstractApplicationContext ctx;

    /**
     * 初期化spring
     */
    public static void initSpring() {
        ctx = new ClassPathXmlApplicationContext("spring/scheduler-consumer.xml");
        ctx.start();
    }

    /**
     * 取得ApplicationContext实例
     *
     * @return
     */
    public static AbstractApplicationContext getContext() {
        return ctx;
    }

    public static <T> T getBeanScheduler(Class<T> beanClass) {
        if (beanClass == null)
            return null;
        if (ctx == null)
            initSpring();
        return ctx.getBean(beanClass);
    }

    /**
     * 取得Bean实例
     *
     * @return
     */
    public static <T> T getBean(Class<T> beanClass) {
        AbstractApplicationContext ctx = new ClassPathXmlApplicationContext("spring/scheduler-consumer.xml");
        ctx.start();
        return ctx.getBean(beanClass);
    }
}
