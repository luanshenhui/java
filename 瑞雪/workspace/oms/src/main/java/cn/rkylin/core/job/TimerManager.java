package cn.rkylin.core.job;

import java.util.Date;
import java.util.Timer;

/**
 * Created with Liu Yong
 * User: zy
 * Date: 14-12-11
 * Time: 下午11:22
 */
public final class TimerManager {
    private static TimerManager instance = new TimerManager();
    private TimerManager(){}

    public static TimerManager getInstance(){
        return instance;
    }

    public void startSchedule(CronExpression expression, BaseJob job) {
        //初始化任务
        BaseTask task = new BaseTask(expression, job);
        //获得任务启动时间
        Date startDate = expression.getNextValidTimeAfter(new Date());
        //在指定时间到达时执行任务
        new Timer().schedule(task, startDate);
    }
}
