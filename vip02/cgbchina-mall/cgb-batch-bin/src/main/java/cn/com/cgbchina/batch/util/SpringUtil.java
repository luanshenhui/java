package cn.com.cgbchina.batch.util;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Spring 共通类
 *
 * @author lvzhida
 */
public class SpringUtil {
    /**
     * 取得Bean实例
     *
     * @return
     */
    public static <T> T getBean(Class<T> beanClass) {
        AbstractApplicationContext ctx = new ClassPathXmlApplicationContext("spring/batch-bin-consumer.xml");
        ctx.start();
        return ctx.getBean(beanClass);
    }
}
