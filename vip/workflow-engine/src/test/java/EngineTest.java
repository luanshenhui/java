import com.hepowdhc.dcapp.Application;
import com.hepowdhc.dcapp.dao.ExtractDataDao;
import org.apache.commons.lang3.StringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by fzxs on 16-11-29.
 */

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootConfiguration()
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, classes = Application.class)
public class EngineTest {
//
//
    @Autowired
    private ExtractDataDao extractDataDao;


    /**
     * 根据实例数据id更新oa实例数据
     */
    @Test
    public void TestTimeConstraint() {
        // 过滤三种节假日类型：周末、法定节假日、调休（工作日）
        List<Map<String, Object>> nodeDataList = extractDataDao.findOADataByWfId("2AP1IRVG");

        Map<String,Object> nodeData = nodeDataList.get(0);
        // 取得OA数据
        ZoneId zone = ZoneId.systemDefault();
        LocalDateTime flowStartDate = LocalDateTime.ofInstant(((Date) nodeData.get("oaFlowStartTime")).toInstant(), zone);
        LocalDateTime startDate = LocalDateTime.ofInstant(((Date) nodeData.get("oaNodeStartTime")).toInstant(), zone);
        LocalDateTime endDate = LocalDateTime.ofInstant(((Date) nodeData.get("oaNodeEndTime")).toInstant(), zone);

        //  查询周末 ，最后应该放到外面做！！！
        Map<String,Object> weekendMap = extractDataDao.findNormalWeekends();
        String holidays = String.valueOf(weekendMap.get("holidays"));//获取每周的休息日
        List<Integer> holidaysOfWeek = new ArrayList<>();
        for(String dayNumber :holidays.split(";")){
            if(StringUtils.isNotEmpty(dayNumber)){//过滤掉为空的值
                holidaysOfWeek.add(Integer.parseInt(dayNumber));
            }
        }

        //  查询法定节假日（工作流开始日期～），类型区分：is_holiday=0，是工作日；=1是休息日
        List<Map<String,Object>> holidayDataList = extractDataDao.findHolidays();

        List<LocalDateTime> holidayList = new ArrayList<>();
        List<LocalDateTime> workWeekendList = new ArrayList<>();
        for(Map<String,Object> holidayMap:holidayDataList){
            // 日期分类：节假日列表 和 需要上班的周末
            String isHoliday = String.valueOf(holidayMap.get("isHoliday"));//是否是假日
            LocalDateTime specialDay =  LocalDateTime.ofInstant(((Date) nodeData.get("specialDay")).toInstant(), zone);
            if(isHoliday.equals("0")){
                // 需要上班的周末
                workWeekendList.add(specialDay);
            } else if(isHoliday.equals("1")){
                // 节假日列表
                holidayList.add(specialDay);
            }
        }

        System.out.println(holidayList.size());

        //  根据开始结束日期，判断经历的工作日天数
//        DateTime startDate = new DateTime("2017-01-20");
//        DateTime endDate = new DateTime("2017-02-05");
//        DateTime startDate = new DateTime("2017-01-15");
//        DateTime endDate = new DateTime("2017-01-20");
        int maxDay = 10;

        // 不考虑时间单位 只考虑 【天】;根据开始结束日期，计算工作日天数
        int timeNodeOA = computeWorkDay(startDate,endDate,holidayList,holidaysOfWeek,workWeekendList);// 节点花费时间(工作日)
        int timeSumOA = computeWorkDay(flowStartDate, endDate,holidayList,holidaysOfWeek,workWeekendList);// 流程开始～节点完成时间(工作日)

        System.out.println(computeWorkDay(startDate,endDate,holidayList,holidaysOfWeek,workWeekendList));
    }

    public static void main(String[] args){
        java.util.Date date = new java.util.Date();
        Instant instant = date.toInstant();
        ZoneId zone = ZoneId.systemDefault();
        LocalDateTime localDateTime = LocalDateTime.ofInstant(instant, zone);

        System.out.println(localDateTime);

        System.out.println(localDateTime.getDayOfWeek().getValue());
    }


    public static int computeWorkDay(LocalDateTime startDate,LocalDateTime endDate,List<LocalDateTime> holidayList,
                                     List<Integer> holidaysOfWeek,List<LocalDateTime> workWeekendList){
        int count = 0;
        while (startDate.plusDays(1).compareTo(endDate) != 1){
            startDate = startDate.plusDays(1);

            //01.判断是否节假日，节假日直接跳过
            if(holidayList.contains(startDate)){
                continue;
            }

            //02.判断是否是周末
            int dayOfWeek = startDate.getDayOfWeek().getValue()%7;//取余7，获得在一个星期中的天数，oa中星期日是0
            boolean isWeekend = false;
            for(int dayNumber :holidaysOfWeek){
                if(dayNumber == dayOfWeek){
                    //如果是周末，跳过
                    isWeekend = true;
                    break;
                }
            }

            //03.判断是否是需要上班的周末
            if(isWeekend && !workWeekendList.contains(startDate)){
                //是周末，并且不需要上班
                continue;
            }
            // 是工作日， 天数 +1
            count ++;
        }
        return count;
    }

//    /**
//     * 根据实例数据id更新oa实例数据
//     */
//    @Test
//    public void TestUpdateInstanceData() {
//        extractDataDao.updateOaDataById("TraceI003525023N");
//        System.out.println("更新实例数据完成状态");
//    }

//    /**
//     * 根据实例id更新oa实例数据
//     */
//    @Test
//    public void TestUpdateInstanceData() {
//        extractDataDao.updateOaInstanceById("TraceI002315Q4LT");
//        System.out.println("更新实例完成状态");
//    }

//
//    @Autowired
//    @Qualifier("sysMessage")
//    private MsgBean msgBean;
//
//    /**
//     * 查询所有工作流数据 （n*n*4）
//     */
//    @Test
//    public void TestFindWorkFlow() {
//        List<Map<String, Object>> mapList = extractDataDao.findAllWorkFlow();
//        System.out.println(mapList.size());
//
//    }
//
////
////    @Test
////    public void testJDBC() throws Exception {
////        List businessData = testDao.findBusinessData();
////
////        System.out.println(businessData);
////
////
////    }
////
////    @Test
////    public void testEngine001() {
////
////        try {
//////            flowEngine.initlialize();
////
////            Map<String, Instance> instances = flowEngine.loadAllInstance();
////
////            System.out.println(instances);
////
////
////        } catch (Exception e) {
////            e.printStackTrace();
////        }
////    }
//
//    /**
//     * 根据工作流id查询业务数据 （1*n）
//     */
//    @Test
//    public void TestExtractOaData() {
//        List<Map<String, Object>> mapList = extractDataDao.findOADataByWfId("d1c759cb01b24882aaa86f32afb8ce3a");
//        System.out.println(mapList.size());
//
//    }
//
//    /**
//     * 根据实例id查询实例数据
//     */
//    @Test
//    public void TestExtractInstanceData() {
//        List<Map<String, Object>> mapList = extractDataDao.findOADataByWfId("instance0011");
//        System.out.println(mapList.size());
//    }
//
//    /**
//     * 插入实例数据
//     */
//    @Test
//    public void TesInsertInstanceData() {
//        Map<String, Object>[] mapArray = new HashMap[1];
//        Map<String, Object> instanceMap = new HashMap<>();
////        :bizInstanceId, :bizInstanceName, :wfId, 0,
////        :createPerson, sysdate, :updatePerson, sysdate, :markDone
//        instanceMap.put("bizInstanceId", "instance003");
//        instanceMap.put("bizInstanceName", "实例003");
//        instanceMap.put("wfId", "d1c759cb01b24882aaa86f32afb8ce3a");
//        instanceMap.put("createPerson", "geshuo");
//        instanceMap.put("updatePerson", "geshuo");
//        instanceMap.put("markDone", "0");
//        mapArray[0] = instanceMap;
//        extractDataDao.insertBizInstance(mapArray);
//        System.out.println("插入实例数据END");
//    }
//
//    /**
//     * 插入实例节点日志数据
//     */
//    @Test
//    public void TestInsertNodeData() {
//        Map<String, Object> nodeMap = new HashMap<>();
////        :bizInstanceId, :bizDataId, bizDataName, :bizOptPerson, :bizOptPersonDepart,
////        :startTime, :endTime, 0, :createPerson, sysdate, :updatePerson,
////                sysdate, :markDone
//        nodeMap.put("bizInstanceId", "instance004");
//        nodeMap.put("bizDataId", "TraceI00352903SQ");
//        nodeMap.put("bizDataName", "部门经理");
//        nodeMap.put("bizOptPerson", "geshuo");
//        nodeMap.put("bizOptPersonDepart", "sol2");
//        nodeMap.put("startTime", new DateTime().minusDays(2).toDate());
//        nodeMap.put("endTime", new Date());
//        nodeMap.put("createPerson", "geshuo");
//        nodeMap.put("updatePerson", "geshuo");
//        nodeMap.put("markDone", "1");
//        List<String> strList = new ArrayList<>();
//        strList.add("产生黄色预警，时间约束");
//        strList.add("产生风险，行为约束");
//        nodeMap.put("resultType", "2");
//        nodeMap.put("resultMsg", strList.toString());
//        extractDataDao.insertBizNodeLog(nodeMap);
//        System.out.println("插入实例节点日志END");
//    }
//
//    /**
//     * 更新实例数据
//     */
//    @Test
//    public void TestUpdateInstanceData() {
//        String instanceId = "instance003";
//        extractDataDao.updateBizInstanceById(instanceId);
//        System.out.println("更新实例数据END");
//    }
//
//    @Test
//    public void TestMsg() {
//        String key = "DEMO_MSG";
//
//        System.out.println("====================");
//
//        System.out.println(msgBean);
//
//        System.out.println(msgBean.getMsg(key, "中国", "大连"));
//
//    }
//
//    /**
//     * 插入权力实例统计表
//     */
//    @Test
//    public void TestInsertPowerInstance() {
//        Map<String, Object> map = new HashMap<>();
//
//        map.put("uuid","1");
//        map.put("wfId","2");
//        map.put("powerId","3");
//        map.put("instanceCount","4");
//        map.put("createPerson","5");
//        map.put("updatePerson","6");
//        extractDataDao.insertPowerInstanceCount(map);
//        System.out.println("插入权力实例统计表END");
//    }
//
//    /**
//     * 插入权力节点统计表
//     */
//    @Test
//    public void TestInsertPowerNode() {
//        Map<String, Object> map = new HashMap<>();
//
//        map.put("uuid","1");
//        map.put("wfId","2");
//        map.put("powerId","3");
//        map.put("instanceId","in001");
//        map.put("taskCount","4");
//        map.put("createPerson","5");
//        map.put("updatePerson","6");
////        extractDataDao.insertPowerNodeCount(map);
//        System.out.println("插入权力节点统计表END");
//    }
//
//    /**
//     * 插入权力业务数据统计表
//     */
//    @Test
//    public void TestInsertPowerBizData() {
//        Map<String, Object> map = new HashMap<>();
//
//        map.put("uuid","1");
//        map.put("wfId","2");
//        map.put("powerId","3");
//        map.put("instanceId","in001");
//        map.put("taskId","t001");
//        map.put("dataCount",4);
//        map.put("createPerson","5");
//        map.put("updatePerson","6");
//        extractDataDao.insertPowerBizDataCount(map);
//        System.out.println("插入权力节点统计表END");
//    }

//    @Autowired
//    private AuditImpl auditImpl;
//
//    /**
//     * 测试权利实例分析
//     */
//    @Test
//    public void TestPowerWorkFlowAudit() {
//        Map<String,Object> mapData = new HashMap<>();
//        mapData.put("wfId","w001");
//        mapData.put("powerId","0101");
//
//        auditImpl.powerWorkFlowAudit(mapData);
//        auditImpl.powerWorkFlowNodeAudit(mapData);
//        auditImpl.powerWorkFlowNodeAudit(mapData);
//        auditImpl.powerWorkFlowNodeAudit(mapData);
//
//        Map<String,Object> mapData2 = new HashMap<>();
//        mapData2.put("wfId","w001");
//        mapData2.put("powerId","0101");
//
//        auditImpl.powerWorkFlowAudit(mapData2);
//        auditImpl.powerWorkFlowNodeAudit(mapData2);
//        auditImpl.powerWorkFlowNodeAudit(mapData2);
//        auditImpl.powerWorkFlowNodeAudit(mapData2);
//
//        Map<String,Object> mapData3 = new HashMap<>();
//        mapData3.put("wfId","w003");
//        mapData3.put("powerId","0103");
//
//        auditImpl.powerWorkFlowAudit(mapData3);
//        auditImpl.powerWorkFlowNodeAudit(mapData3);
//        auditImpl.powerWorkFlowNodeAudit(mapData3);
//        auditImpl.powerWorkFlowNodeAudit(mapData3);
//
//        Map<String,Object> dataMap1 = new HashMap<>();
//        dataMap1.put("wfId","w001");
//        dataMap1.put("powerId","0101");
//        dataMap1.put("taskId","t001");
//        auditImpl.powerWorkFlowNodeDataAudit(dataMap1);
//        auditImpl.powerWorkFlowNodeDataAudit(dataMap1);
//        auditImpl.powerWorkFlowNodeDataAudit(dataMap1);
//        auditImpl.powerWorkFlowNodeDataAudit(dataMap1);
//        auditImpl.powerWorkFlowNodeDataAudit(dataMap1);
//
//        Map<String,Object> dataMap2 = new HashMap<>();
//        dataMap2.put("wfId","w001");
//        dataMap2.put("powerId","0101");
//        dataMap2.put("taskId","t002");
//        auditImpl.powerWorkFlowNodeDataAudit(dataMap2);
//        auditImpl.powerWorkFlowNodeDataAudit(dataMap2);
//        auditImpl.powerWorkFlowNodeDataAudit(dataMap2);
//        auditImpl.powerWorkFlowNodeDataAudit(dataMap2);
//
//        auditImpl.save();
//
//        System.out.println("测试权利实例分析 END");
//    }

}
