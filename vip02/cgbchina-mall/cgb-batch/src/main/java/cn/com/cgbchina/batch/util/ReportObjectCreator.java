package cn.com.cgbchina.batch.util;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class ReportObjectCreator extends AbstractReportObjectCreator
		implements ApplicationContextAware, ApplicationListener<ContextRefreshedEvent> {

	private ApplicationContext applicationContext;

	@Override
	protected Object getTargetObjectForClass(Class<?> clazz) {
		try {
			return applicationContext.getBean(clazz);
		} catch(NoSuchBeanDefinitionException e) {
			return null;
		}
	}

	@Override
	public void setApplicationContext(ApplicationContext applicationContext) {
		this.applicationContext = applicationContext;
	}

	@Override
	public void onApplicationEvent(ContextRefreshedEvent contextRefreshedEvent) {
		if(contextRefreshedEvent.getApplicationContext().equals(applicationContext)) {
			this.addPackage("cn.com.cgbchina.batch.excel");
		}
	}
}
