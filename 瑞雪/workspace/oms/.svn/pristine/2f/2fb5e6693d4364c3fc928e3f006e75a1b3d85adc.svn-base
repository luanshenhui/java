package cn.rkylin.core.job;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.InputStream;
import java.text.ParseException;
import java.util.Map;


public class RegisterJob {
    private static Logger logger = Logger.getLogger(RegisterJob.class);
    private ApplicationContext context;
    //定时任务文件
    private static final String JOB_FILE_NAME = "job.xml";
    public RegisterJob(){
    	String[] locations = {"spring/applicationContext.xml"};  
        context = new ClassPathXmlApplicationContext(locations);
    }
    /**
     * 加载定时任务
     */
    public void loadJob() {
        //解析xml文件
        Map<String, JobInitVO> map = ansyle();

        //如果解析错误，则不加载定时任务
        if(null == map || map.isEmpty()){
            return;
        }

        //注册定时任务
        registerJob(map);
    }

    /**
     * 解析xml文件内容
     * @return
     */
    private Map<String, JobInitVO> ansyle() {
        InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream(JOB_FILE_NAME);
        if(null == in){
            return null;
        }
        try {
            Map<String, JobInitVO> jobInitMap =  new JobXMLToolKit().analyze(in);
            logger.error(this.getClass().getName()+": Init success! Job num is " + jobInitMap.size());
            return jobInitMap;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 注册定时任务
     * @param map
     */
    private void registerJob(Map<String, JobInitVO> map) {
        for(String key : map.keySet()){
            JobInitVO vo = map.get(key);
            BaseJob job = null;
            try {
            	job = context.getBean(vo.getJobClass(),BaseJob.class);
                //使用定时任务管理器加载任务
                TimerManager.getInstance().startSchedule(new CronExpression(vo.getCronExpression()), job);
            } catch (ParseException e) {
                e.printStackTrace();
                logger.error("Job register failed : CronExpression format Exception!");
            } 
        }
    }
}
