package cn.com.cgbchina.batch.util;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Spring 共通类
 *
 * @author lvzhida
 */
public class SpringUtil {
    private static AbstractApplicationContext ctx;
    private static final String SPRING_COTEXT_PATH = "springContextPath";
    private static final String PROFILE = "profile";

    /**
     * 初期化spring
     */
    public static void initSpring() {
        ctx = new ClassPathXmlApplicationContext(ConfigProperties.getProperties(SPRING_COTEXT_PATH));
        ctx.getEnvironment().setActiveProfiles(ConfigProperties.getProperties(PROFILE));
        ctx.refresh();
    }

    /**
     * 取得ApplicationContext实例
     *
     * @return
     */
    public static AbstractApplicationContext getContext() {
        return ctx;
    }

    /**
     * 取得Bean实例
     *
     * @return
     */
    public static <T> T getBean(Class<T> beanClass) {
        if (beanClass == null)
            return null;
        if (ctx == null)
            initSpring();
        return ctx.getBean(beanClass);
    }
}
