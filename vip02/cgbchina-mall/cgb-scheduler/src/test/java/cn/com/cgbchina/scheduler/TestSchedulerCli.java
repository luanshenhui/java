package cn.com.cgbchina.scheduler;

import cn.com.cgbchina.scheduler.model.TaskScheduled;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spirit.jms.mq.QueueSender;
import org.joda.time.DateTime;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

/**
 * Created by lvzd on 2016/9/9.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/scheduler-client-mq.xml")
@ActiveProfiles("dev")
public class TestSchedulerCli {

    @Autowired
    @Qualifier("queueSender")
    private QueueSender queueSender;

    @Test
    public void test4() {
//        TaskScheduled ts = new TaskScheduled();
//        ts.setTaskGroup("testServiceImpl");
//        ts.setTaskName("getstr");
//        ts.setPromotionStartDate(DateTime.now().plusMinutes(2).toDate());
//        ts.setPromotionId("5555");
//        ts.setDesc("计算最佳倍率sdsds");
//        ts.setTaskType("promotion");
//        ts.setStatus("1");
//        queueSender.send(ts);
//        System.out.println(1);

        List<TaskScheduled> tasks = new ArrayList<TaskScheduled>();
        ObjectMapper mapper = new ObjectMapper();
        try {
            DeserializationExampleTreeModel(tasks);
        } catch (Exception e) {
            System.out.println("task.json 文件解析失败");
            return;
        }

        for (TaskScheduled tsd : tasks) {
            queueSender.send(tsd);
            System.out.println(tsd);
        }

    }

    private static void DeserializationExampleTreeModel(List<TaskScheduled> tasks) throws Exception {
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
