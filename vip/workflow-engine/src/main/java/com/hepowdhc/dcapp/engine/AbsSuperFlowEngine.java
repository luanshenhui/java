package com.hepowdhc.dcapp.engine;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hepowdhc.dcapp.bean.MsgBean;
import com.hepowdhc.dcapp.config.EngineConf;
import com.hepowdhc.dcapp.dao.ExtractDataDao;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import javax.annotation.PostConstruct;
import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.IntConsumer;
import java.util.stream.Collectors;

/**
 * 业务流引擎
 */
public abstract class AbsSuperFlowEngine implements FlowEngine, Serializable {


    protected final Logger logger = LoggerFactory.getLogger(getClass());

    protected Map<String, String> userRoleMap;

    protected List<LocalDateTime> holidayList;//节假日列表

    protected List<LocalDateTime> workWeekendList;//需要上班的工作日列表

    protected List<Integer> holidaysOfWeek;//获取周末休息日

    // protected List<Map<String, Object>> workFlowList;

//    protected final List<WorkFlow> workFlowList = new ArrayList<>();

//    protected Map<String, WorkFlow> workFlowMap = new HashMap<>();

    protected final Map<String, WorkFlow> workFlowMap = new HashMap<String, WorkFlow>() {

//        @Override
//        public WorkFlow get(Object key) {
//
//            final WorkFlow workFlow = super.get(key);
//
//
//            return Objects.isNull(workFlow) ? workFlow : workFlow.deepClone();
//        }
    };

    @Autowired
    protected ExtractDataDao extractDataDao;

    @Autowired
    protected Audit audit;

    @Autowired
    @Qualifier("sysMessage")
    protected MsgBean msgBean;

    @Autowired
//    @Qualifier("engineConf")
    protected EngineConf engineConf;

    private final IntConsumer workFlowConsumer = (int b) -> {

        List<Map<String, Object>> workFlowListMap = loadAllWorkFlow();

        if (CollectionUtils.isEmpty(workFlowListMap)) {
            return;
        }
        //工作流数据 m * n * 4
        //m 工作流数量 n 每个工作流节点 4 个约束

//          workFlowListMap =
        workFlowListMap

                .stream()

//                .parallelStream()

                .filter(map -> StringUtils.isNotEmpty((String) map.get("dcaWfId")))

                .filter(map -> StringUtils.isNotEmpty((String) map.get("dcaXmlContent")))

                .filter(map -> StringUtils.isNotEmpty((CharSequence) map.get("dcaAlarmType")))

                .filter(map -> StringUtils.isNotEmpty((CharSequence) map.get("dcaTaskId")))

                .collect(Collectors.groupingBy(o -> (String) o.get("dcaWfId"),

                        Collectors.groupingBy(o -> (String) o.get("dcaTaskId")

                        )))

                .forEach((fwid, nodesData) -> {
                            //N*4
//                            workFlowList.add(createWorkFlow(fwid, nodesData));

                            workFlowMap.put(fwid, createWorkFlow(fwid, nodesData));
                        }


                );


//                .map(map -> createWorkFlow(map))
//TODO
//                .collect(Collectors.toList());

        ;


    };


    @PostConstruct
    private void postConstruct() {

        logger.debug("引擎初化中....");

        Optional<Map<String, String>> userRoleOptional = Optional.ofNullable(userRoleMap);

        userRoleMap = userRoleOptional.orElse(getUserRole());

        /* ADD START BY geshuo 20170111: 获取节假日列表 ------------------------------------ */
        //获取节假日列表
        Map<String, List<LocalDateTime>> specialDayMap = getSpecialDayList();

        //节假日列表
        Optional<List<LocalDateTime>> holidayListOptional = Optional.ofNullable(holidayList);
        holidayList = holidayListOptional.orElse(specialDayMap.get("holidayList"));

        //需要上班的周末列表
        Optional<List<LocalDateTime>> workWeekendListOptional = Optional.ofNullable(workWeekendList);
        workWeekendList = workWeekendListOptional.orElse(specialDayMap.get("workWeekendList"));

        // 获取周末休息日列表 add by geshuo 20170111
        Optional<List<Integer>> weekHolidayOptional = Optional.ofNullable(holidaysOfWeek);
        holidaysOfWeek = weekHolidayOptional.orElse(getHolidaysOfWeek());
        /* ADD END BY geshuo 20170111: 获取节假日列表 ------------------------------------ */

        workFlowConsumer.accept(1);

        logger.debug("引擎初始化完成!");
    }

    /**
     * 刷新引擎基础数据;
     */
    public void flushBaseData() {

        logger.info("刷新用户角色信息");

        userRoleMap = Optional.ofNullable(getUserRole()).get();

        logger.debug("刷新用户角色信息:" + userRoleMap);

        logger.info("刷新流程图配置数据");

//        workFlowList = Optional.ofNullable(loadAllWorkFlow()).get();

        workFlowConsumer.accept(1);

        loadAllWorkFlow();


    }

    /**
     * @param fwId
     * @param nodesData nodeID, 4*规
     * @return
     */
    protected WorkFlow createWorkFlow(String fwId, final Map<String, List<Map<String, Object>>> nodesData) {
        return null;
    }

    /**
     * 加载业务流程数据
     *
     * @param url
     * @param path
     * @return
     * @throws Exception
     */
    public Map<String, Object> readJsonData(String url, String... path) throws Exception {

        if (StringUtils.isEmpty(url)) {
            return Collections.emptyMap();
        }

        return readJsonData(Paths.get(url, path));
    }

    /**
     * 加载业务流程数据
     *
     * @param reader
     * @return
     * @throws IOException
     */
    public Map<String, Object> readJsonData(Reader reader) throws IOException {

        if (reader == null) {
            return Collections.emptyMap();
        }

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> value = mapper.readValue(reader, HashMap.class);

        readJsonData(value);

        return value;
    }

    /**
     * 加载业务流程数据
     *
     * @param str
     * @return
     * @throws IOException
     */
    public Map<String, Object> readJsonData(String str) {

        if (StringUtils.isEmpty(str)) {
            return Collections.emptyMap();
        }

        ObjectMapper mapper = new ObjectMapper();
        try {
            HashMap<String, Object> value = mapper.readValue(new StringReader(str), HashMap.class);

            return value;
        } catch (IOException e) {
            e.printStackTrace();
            return Collections.emptyMap();
        }

//        readJsonData(value);


    }

    /**
     * 加载业务流程数据
     *
     * @param path
     * @return
     * @throws Exception
     */
    public Map<String, Object> readJsonData(Path path) throws Exception {

        if (path == null) {
            return Collections.emptyMap();
        }


        BufferedReader reader = Files.newBufferedReader(path, Charset.forName("UTF8"));

        return readJsonData(reader);

    }

    /**
     * 加载业务流程数据
     *
     * @param file
     * @return
     * @throws IOException
     */
    protected Map<String, Object> readJsonData(File file) throws IOException {

        if (file == null) {

            return Collections.emptyMap();
        }

        FileInputStream inputStream = new FileInputStream(file);

        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));

        return readJsonData(reader);
    }

    /**
     * 抽取数据中所有的业务流程图数据
     * <p>
     * DCA_WORKFLOW
     *
     * @return
     */
    protected List<Map<String, Object>> loadALLBusinessData() throws Exception {
        return extractDataDao.findAllBusinessData();
    }

    /**
     * 通过工作流名称 获取该工作流所有数据
     *
     * @param name
     * @return
     */
    protected abstract List<Map<String, Object>> getWorkDataByName(String name);

    /**
     * 获取用户岗位
     *
     * @return
     */
    protected Map<String, String> getUserRole() {

        logger.debug("获取角色数据");
        List<Map<String, Object>> roleMapList = extractDataDao.findUserRoleList();
        Map<String, String> userRoleMap = new HashMap<>();
        for (Map<String, Object> roleMap : roleMapList) {
            String roleId = String.valueOf(roleMap.get("roleId"));
            String userList = String.valueOf(roleMap.get("userIdList"));
            String[] users = userList.split(";");
            for (String userId : users) {
                if (StringUtils.isEmpty(userId)) {
                    continue;
                }
                if (StringUtils.isNotEmpty(userRoleMap.get(userId))) {
                    // 已经存在该用户 ，将岗位id加入该用户的岗位列表中
                    String roles = userRoleMap.get(userId);
                    roles += ";" + roleId;
                    userRoleMap.put(userId, roles);
                } else {
                    // map中 不存在该用户，放入userId：roleId
                    userRoleMap.put(userId, roleId);
                }
            }
        }

        logger.debug("获取角色数据:" + userRoleMap);
        return userRoleMap;
    }

    /**
     * 查询周末休息日
     *
     * @return geshuo
     * 20170111
     */
    public List<Integer> getHolidaysOfWeek() {
        List<Integer> holidaysOfWeek = new ArrayList<>();

        Map<String, Object> weekendMap = extractDataDao.findNormalWeekends();
        if (null != weekendMap && null != weekendMap.get("holidays")) {
            String holidays = String.valueOf(weekendMap.get("holidays"));//获取每周的休息日
            for (String dayNumber : holidays.split(";")) {
                if (StringUtils.isNotEmpty(dayNumber)) {//过滤掉为空的值
                    holidaysOfWeek.add(Integer.parseInt(dayNumber));
                }
            }
        }
        return holidaysOfWeek;
    }

    /**
     * 获取特殊日期列表（节假日、需要上班的周末）
     *
     * @return geshuo
     * 20170111
     */
    public Map<String, List<LocalDateTime>> getSpecialDayList() {
        List<Map<String, Object>> holidayDataList = extractDataDao.findHolidays();

        List<LocalDateTime> holidayList = new ArrayList<>();
        List<LocalDateTime> workWeekendList = new ArrayList<>();
        for (Map<String, Object> holidayMap : holidayDataList) {
            // 日期分类：节假日列表 和 需要上班的周末
            String isHoliday = String.valueOf(holidayMap.get("isHoliday"));//是否是假日

            LocalDate specialDate = LocalDate.parse(String.valueOf(holidayMap.get("specialDay")), DateTimeFormatter.ISO_LOCAL_DATE);
            LocalDateTime specialDay = specialDate.atStartOfDay();
            if (isHoliday.equals("0")) {
                // 需要上班的周末
                workWeekendList.add(specialDay);
            } else if (isHoliday.equals("1")) {
                // 节假日列表
                holidayList.add(specialDay);
            }
        }

        //构造返回参数
        Map<String, List<LocalDateTime>> specialDayMap = new HashMap<>();
        specialDayMap.put("holidayList", holidayList);
        specialDayMap.put("workWeekendList", workWeekendList);
        return specialDayMap;
    }

    /**
     * 数据加载
     */
    public void readJsonData(Map<String, Object> data) {

//        this.data = data;

    }

    /**
     * 获取当前业务流ID的所有task
     *
     * @param fId
     * @return
     */

    protected abstract Node getTasksByFlowId(String fId);


    /**
     * 获取所有的工作流
     *
     * @return
     */
    protected abstract List<Map<String, Object>> loadAllWorkFlow();


}
