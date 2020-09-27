package cn.rkylin.core.job;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;


public class JobListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        new RegisterJob().loadJob();
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }

}
