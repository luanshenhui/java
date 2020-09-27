package cn.com.cgbchina.scheduler.manager;

import com.alibaba.dubbo.config.spring.ReferenceBean;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.quartz.*;
import org.springframework.context.ApplicationContext;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@PersistJobDataAfterExecution
@DisallowConcurrentExecution
@Slf4j
public class JobTask implements Job {
	private static final ConcurrentMap<String, ReferenceBean<?>> referenceConfigs = new ConcurrentHashMap<String, ReferenceBean<?>>();
	private static final ConcurrentMap<String, Object> localBeanMap = new ConcurrentHashMap<String, Object>();

	private static final ConcurrentMap<JobKey, Boolean> isRunningMap = new ConcurrentHashMap<JobKey, Boolean>();
	@Override
	public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
		JobKey jobKey = jobExecutionContext.getJobDetail().getKey();
		if (isRunningMap.containsKey(jobKey)) {
			if (isRunningMap.get(jobKey)) {
				log.info(jobKey.getGroup() + "." + jobKey.getName() + "前次批处理正在执行中...");
				return;
			}
		}
		isRunningMap.put(jobKey, true);
		try {
			Object refer;
			String type = (String)jobExecutionContext.getJobDetail().getJobDataMap().get("taskType");
			if ("dubbo".equals(type)) {
				refer = getDubboBean(jobExecutionContext, jobKey.getGroup());
			} else if ("promotion".equals(type)) {
				int idx = jobKey.getGroup().lastIndexOf("_");
				refer = getDubboBean(jobExecutionContext, jobKey.getGroup().substring(idx + 1));
			} else if("smsClock".equalsIgnoreCase(type)){
				int idx = jobKey.getGroup().lastIndexOf("_");
				refer = getDubboBean(jobExecutionContext, jobKey.getGroup().substring(idx + 1));
			} else {
				refer = getLocalBean(jobExecutionContext, jobKey.getGroup());
			}
			String[] params = (String[])jobExecutionContext.getJobDetail().getJobDataMap().get("params");
			Response r = null;
			if (params == null) {
				r = (Response)refer.getClass().getDeclaredMethod(jobKey.getName()).invoke(refer);
			} else {
				r = (Response)refer.getClass().getDeclaredMethod(jobKey.getName(),params.getClass()).invoke(refer, (Object) params);
			}
			if (!Strings.isNullOrEmpty(r.getError())) {
				log.error("Jobtask erro:{}", r.getError());
				throw new JobExecutionException(r.getError());
			}
		} catch (Exception e) {
			log.error("Jobtask execute erro:{}", Throwables.getStackTraceAsString(e));
			throw new JobExecutionException(e);
		} finally {
			isRunningMap.put(jobKey, false);
		}
	}

	/** 获取本地服务 */
	private static Object getLocalBean(JobExecutionContext context, String interfaceName) throws SchedulerException {
		Object localBean = localBeanMap.get(interfaceName);
		if (localBean == null) {
			ApplicationContext applicationContext = (ApplicationContext) context.getScheduler().getContext().get("applicationContext");
			localBean = applicationContext.getBean(interfaceName);
			localBeanMap.put(interfaceName, localBean);
		}
		return localBean;
	}
	/** 获取Dubbo服务 */
	private static Object getDubboBean(JobExecutionContext context, String interfaceName) throws SchedulerException {
		String key = "/" + interfaceName + ":";
		ReferenceBean<?> referenceConfig = referenceConfigs.get(key);
		if (referenceConfig == null) {
			referenceConfig = new ReferenceBean<Object>();
			referenceConfig.setInterface(interfaceName);
			ApplicationContext applicationContext = (ApplicationContext) context.getScheduler().getContext().get("applicationContext");
			if (applicationContext != null) {
				referenceConfig.setApplicationContext(applicationContext);
				try {
					referenceConfig.afterPropertiesSet();
				} catch (RuntimeException e) {
					throw (RuntimeException) e;
				} catch (Exception e) {
					throw new IllegalStateException(e.getMessage(), e);
				}
			}
			referenceConfigs.putIfAbsent(key, referenceConfig);
			referenceConfig = referenceConfigs.get(key);
		}
		return referenceConfig.get();

	}
}
