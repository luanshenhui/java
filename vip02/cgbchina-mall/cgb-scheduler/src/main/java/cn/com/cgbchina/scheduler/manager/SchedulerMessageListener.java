package cn.com.cgbchina.scheduler.manager;

import cn.com.cgbchina.scheduler.model.TaskScheduled;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.jms.mq.QueueMessageListener;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by lvzd on 2016/9/10.
 */
@Slf4j
public class SchedulerMessageListener extends QueueMessageListener<TaskScheduled> {

    @Autowired
    private SchedulerManager schedulerManager;

    // 线程池
    private ExecutorService executorService = Executors.newCachedThreadPool();
    @Override
    public void onMsgListener(final TaskScheduled taskScheduled) {
        if (taskScheduled == null) return;
        executorService.submit(new Runnable() {
            public void run() {
                try {
                    if ("promotion".equals(taskScheduled.getTaskType())) {
                        if(StringUtils.isNotEmpty(taskScheduled.getPeriodId())){
                            taskScheduled.setTaskGroup("promotion_" + taskScheduled.getPromotionId() +"_"+taskScheduled.getPeriodId()+ "_" + taskScheduled.getTaskGroup());

                        }else {
                            taskScheduled.setTaskGroup("promotion_" + taskScheduled.getPromotionId() + "_" + taskScheduled.getTaskGroup());
                        }
//            /*
//               秒                         0-59                               , - * /
//               分                         0-59                               , - * /
//               小时                     0-23                               , - * /
//               日                         1-31                               , - * ? / L W C
//               月                         1-12 or JAN-DEC         , - * /
//               周几                     1-7 or SUN-SAT           , - * ? / L C #
//               年 (可选字段)     empty, 1970-2099      , - * /
//            */
//            DateTime dt = new DateTime(taskScheduled.getPromotionStartDate());
//            StringBuffer sb = new StringBuffer();
//            sb.append(dt.getSecondOfMinute() + " ");
//            sb.append(dt.getMinuteOfHour() + " ");
//            sb.append(dt.getHourOfDay() + " ");
//            sb.append(dt.getDayOfMonth() + " ");
//            sb.append(dt.getMonthOfYear() + " ");
//            sb.append("? ");
//            sb.append(dt.getYear() + "-" + dt.getYear());
//            taskScheduled.setTaskCron(sb.toString());
                    } else if("smsClock".equalsIgnoreCase(taskScheduled.getTaskType())){
                        //短信发送任务
                        taskScheduled.setTaskGroup("smsClock_" + taskScheduled.getPromotionId() + "_" + taskScheduled.getTaskGroup());

                    }
                    // 添加Job
                    schedulerManager.addTaskJob(Lists.newArrayList(taskScheduled));
                } catch (Exception e) {
                    log.error("SchedulerMessage eroor : {}" , Throwables.getStackTraceAsString(e));
                }
            }
        });

    }
}
