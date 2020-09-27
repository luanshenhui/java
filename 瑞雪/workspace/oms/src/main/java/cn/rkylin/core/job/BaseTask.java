package cn.rkylin.core.job;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;
import org.apache.log4j.Logger;


public class BaseTask extends TimerTask {
    private static Logger logger = Logger.getLogger(BaseTask.class);

    private CronExpression expression;//时间格式
    private BaseJob job;//定时任务

    public BaseTask(CronExpression expression, BaseJob job){
        this.expression = expression;
        this.job = job;
    }

    @Override
    public void run() {
        logger.error("===================== "+this.getClass().getName()+" Run ["+job.getClass().getName()+"] Start ======================");
        try {
            //执行业务逻辑
            job.executeInternal();
        } catch (Exception e) {
            e.printStackTrace();
            //日志输出错误信息
            logger.error(job.getClass().getName()+" errror : "+ e.getMessage());
        } finally {
            //获得下一个任务的时间
            Date startDate = expression.getNextValidTimeAfter(new Date());
            //在下一个时间到达时，启动任务
            new Timer().schedule(new BaseTask(expression, job), startDate);
        }
        logger.error("=================== "+this.getClass().getName()+" Run ["+job.getClass().getName()+"] End ===================");
    }

}
