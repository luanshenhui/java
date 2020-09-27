package cn.com.cgbchina.scheduler.task;

import cn.com.cgbchina.scheduler.model.TaskScheduled;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Throwables;
import com.spirit.jms.mq.QueueSender;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Created by 11150121040023 on 2016/7/19.
 */
@Slf4j
public class TaskManage {
    public static void main(String[] args) throws Exception {
        AbstractApplicationContext ctx = new ClassPathXmlApplicationContext("spring/scheduler-client-mq.xml");
        ctx.start();
        QueueSender queueSender = (QueueSender)ctx.getBean("queueSender");
        List<TaskScheduled> tasks = new ArrayList<TaskScheduled>();
        ObjectMapper mapper = new ObjectMapper();
        try {
            DeserializationExampleTreeModel(tasks);
        } catch (Exception e) {
            log.error("task.json 文件解析失败{}", Throwables.getStackTraceAsString(e));
            System.out.println("task.json 文件解析失败");
            return;
        }
        for (TaskScheduled ss : tasks) {
            queueSender.send(ss);
        }
        System.out.println("导入任务!");
        System.exit(0);
    }
    public static void DeserializationExampleTreeModel(List<TaskScheduled> tasks) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        URL url = Thread.currentThread().getClass().getResource("/");
        JsonNode node = mapper.readTree(new File(url.getPath() + "/task.json"));
        Iterator<JsonNode> jsonNodes = node.iterator();
        TaskScheduled taskScheduler;
        while (jsonNodes.hasNext()) {
            taskScheduler = new TaskScheduled();
            JsonNode subnode = (JsonNode) jsonNodes.next();
            JsonNode taskSchedulerN = subnode.get("taskScheduler");
            taskScheduler.setTaskGroup(taskSchedulerN.get("taskGroup").asText());
            taskScheduler.setTaskName(taskSchedulerN.get("taskName").asText());
            taskScheduler.setDesc(taskSchedulerN.get("desc").asText());
            taskScheduler.setTaskCron(taskSchedulerN.get("taskCron").asText());
            taskScheduler.setTaskType(taskSchedulerN.get("taskType").asText());
            taskScheduler.setStatus(taskSchedulerN.get("status").asText());
            System.out.println(taskScheduler);
            tasks.add(taskScheduler);
        }
    }

}
