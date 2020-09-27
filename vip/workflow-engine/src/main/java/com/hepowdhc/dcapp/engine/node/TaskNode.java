package com.hepowdhc.dcapp.engine.node;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hepowdhc.dcapp.bean.MsgBean;
import com.hepowdhc.dcapp.utils.GenUUID;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Created by fzxs on 16-11-26.
 */
public abstract class TaskNode extends AbsNode {
    public static final String NODE_ENABLED = "1";
    public static final String NODE_CONSTRAINT_ENABLED = "1";
    public static final String RISK_ENABLED = "1";
    /**
     * 分割用符号
     */
    public static final String SSX_C = "\\|\\|";
    public static final String SSX = "||";
    public static final String MINUS = "-";
    public static final String COLON = ":";
    public static final String COMMA = ",";

    /**
     * 预警/风险级别 1:绿色 2:黄色 3:橙色4:红色
     */
    public static final String ALARM_LEVEL_1 = "1";
    public static final String ALARM_LEVEL_2 = "2";
    public static final String ALARM_LEVEL_3 = "3";
    public static final String ALARM_LEVEL_4 = "4";

    /**
     * 告警状态 1：告警中 2：已消警
     */
    public static final String ALARMSTATUS_1 = "1";
    public static final String ALARMSTATUS_2 = "2";

    /**
     * 风险转发标识 0-未转发 1-转发
     */
    public static final String RISK_TRANS_FLAG_0 = "0";
    public static final String RISK_TRANS_FLAG_1 = "1";

    /**
     * 风险界定状态 1-风险 2-非风险 3:未界定
     */
    public static final String DEFINE_STATUS_3 = "3";

    /**
     * 执行结果状态 0-忽略 1-成功 2-有预警或风险 3-无约束
     */
    public static final String RESULT_TYPE_0 = "0";
    public static final String RESULT_TYPE_1 = "1";
    public static final String RESULT_TYPE_2 = "2";
    public static final String RESULT_TYPE_3 = "3";


    //	@Autowired
//	@Qualifier("sysMessage")
    protected MsgBean msgBean;

    protected Map<RuleType, Map<String, Object>> ruleTypeMap;

    protected TaskNode(String nodeId) {
        super(nodeId);
    }

    protected TaskNode() {
        super();
    }

    @Override
    public Map<RuleType, Map<String, Object>> getNodeRule() {
        return ruleTypeMap;
    }

    protected AlarmAndRisk timeConstraint(Map<String, Object> nodeData) {
        AlarmAndRisk resultObj = new AlarmAndRisk();
        List<Map<String, Object>> alarmList = new ArrayList<>();// 告警数据列表
        List<Map<String, Object>> riskList = new ArrayList<>();// 风险数据列表
        List<Map<String, Object>> resultList = new ArrayList<>();// 工作流运算结果数据列表
        List<String> resultMsgList = new ArrayList<>();

        String timeAlarmType = String.valueOf(RuleType.TIME.getVal());
        String alarmMsg = "";
        String riskMsg = "";
        String alarmLevel = "";
        String nodeRule = "";

        /* 01 时间约束 start------------------------------ */
        // 取得时间约束条件
        Map<String, Object> timeContentMap = ruleTypeMap.get(RuleType.TIME);

        // 判断约束是否有效
        String isTimeEffective = String.valueOf(timeContentMap.get("dcaIsEffective"));
        if (isTimeEffective.equals(NODE_CONSTRAINT_ENABLED)) {// 约束有效
            // 本节点完成花费的时间 约束条件 示例格式 2:6-10||3:11-15||4:16-20
            String alarmLevelNeed = String.valueOf(timeContentMap.get("dcaAlarmLevelNeed"));
            // 流程发起~本节点完成 花费的时间 约束条件
            String alarmLevelSum = String.valueOf(timeContentMap.get("dcaAlarmLevelSum"));
            // 本节点最大时间
            Integer timeNeedMax = Integer.parseInt(timeContentMap.get("dcaTimeNeed").toString());

            // 解析各预警时间
            String[] levelAndTimes = alarmLevelNeed.split(SSX_C);
            Map<String, Integer> nodeTimeMap = parseLevelAndTimes(levelAndTimes);

            // 解析各预警时间
            String[] levelAndTimesSum = alarmLevelSum.split(SSX_C);
            Map<String, Integer> sumTimeMap = parseLevelAndTimes(levelAndTimesSum);

//            // 取得OA数据
//            Date flowStartDate = (Date) nodeData.get("oaFlowStartTime");
//            Date startDate = (Date) nodeData.get("oaNodeStartTime");
//            Date endDate = (Date) nodeData.get("oaNodeEndTime");
//
//            long timeNodeOAMillis = endDate.getTime() - startDate.getTime();// 本节点完成花费的时间
//            long timeSumOAMillis = endDate.getTime() - flowStartDate.getTime();// 流程发起~本节点完成 花费的时间
//
//            String timeNeedUnit = String.valueOf(timeContentMap.get("dcaTimeNeedUnit"));// 时间单位
//
//            long timeNodeOA = parseTimeUnit(timeNeedUnit, timeNodeOAMillis);

            // 取得OA数据
            ZoneId zone = ZoneId.systemDefault();
            LocalDateTime flowStartDate = LocalDateTime.ofInstant(((Date) nodeData.get("oaFlowStartTime")).toInstant(), zone);
            LocalDateTime startDate = LocalDateTime.ofInstant(((Date) nodeData.get("oaNodeStartTime")).toInstant(), zone);
            LocalDateTime endDate = LocalDateTime.ofInstant(((Date) nodeData.get("oaNodeEndTime")).toInstant(), zone);
            // 不考虑时间单位 只考虑 【天】;根据开始结束日期，计算工作日天数
            int timeNodeOA = computeWorkDay(startDate, endDate);// 节点花费时间(工作日)

            // 比较节点时间
            if (timeNodeOA >= nodeTimeMap.get("yellowStart") && timeNodeOA <= nodeTimeMap.get("yellowEnd")) {
                // 黄色预警
                alarmMsg = msgBean.getMsg("NODE_TIME_YELLOW");
                alarmLevel = ALARM_LEVEL_2;
                // 插入预警数据
                alarmList.add(getAlarmData(timeContentMap, nodeData, alarmLevel, timeAlarmType, "", alarmMsg));
                resultMsgList.add(alarmMsg);
                logger.debug("time constraint---yellow alarm of time");
            } else if (timeNodeOA >= nodeTimeMap.get("orangeStart") && timeNodeOA <= nodeTimeMap.get("orangeEnd")) {
                // 橙色预警
                alarmMsg =msgBean.getMsg("NODE_TIME_ORANGE");
                alarmLevel = ALARM_LEVEL_3;
                // 插入预警数据
                alarmList.add(getAlarmData(timeContentMap, nodeData, alarmLevel, timeAlarmType, "", alarmMsg));
                resultMsgList.add(alarmMsg);
                logger.debug("time constraint---orange alarm of time");
            } else if (timeNodeOA >= nodeTimeMap.get("redStart") && timeNodeOA <= nodeTimeMap.get("redEnd")) {
                // 红色预警
                alarmMsg = msgBean.getMsg("NODE_TIME_RED");
                alarmLevel = ALARM_LEVEL_4;
                // 插入预警数据
                alarmList.add(getAlarmData(timeContentMap, nodeData, alarmLevel, timeAlarmType, "", alarmMsg));
                resultMsgList.add(alarmMsg);
                logger.debug("time constraint---red alarm of time");
            } else if (timeNodeOA >= timeNeedMax) {
                // 超期 插入风险数据
                riskMsg = msgBean.getMsg("NODE_TIME_RISK");
                riskList.add(getRiskData(timeContentMap, nodeData, "", timeAlarmType, "", riskMsg));
                resultMsgList.add(riskMsg);
                logger.debug("time constraint---risk of time");
            }
            // 插入工作流运算结果数据
            nodeRule = msgBean.getMsg("NODE_RULE_TIME_1");
            resultList.add(getResultData(timeContentMap,nodeData,alarmLevel, timeAlarmType,alarmMsg,riskMsg,nodeRule));

            String timeSumUnit = String.valueOf(timeContentMap.get("dcaTimeSumUnit"));// 时间单位

//            long timeSumOA = parseTimeUnit(timeSumUnit, timeSumOAMillis);
            int timeSumOA = computeWorkDay(flowStartDate, endDate);// 流程开始～节点完成时间(工作日)

            // 流程开始~本节点 完成最大时间

            Integer timeSumMax = NumberUtils.toInt((String) timeContentMap.get("dcaTimeSum"), Integer.MAX_VALUE);

            // 比较流程发起~本节点完成 花费的时间
            if (timeSumOA >= sumTimeMap.get("yellowStart") && timeSumOA <= sumTimeMap.get("yellowEnd")) {
                // 黄色预警
                alarmMsg = msgBean.getMsg("NODE_TIME_SUM_YELLOW");
                alarmLevel = ALARM_LEVEL_2;
                // 插入预警数据
                alarmList.add(getAlarmData(timeContentMap, nodeData, alarmLevel, timeAlarmType, "", alarmMsg));
                resultMsgList.add(alarmMsg);
                logger.debug("time constraint---yellow alarm of sum time");
            } else if (timeSumOA >= sumTimeMap.get("orangeStart") && timeSumOA <= sumTimeMap.get("orangeEnd")) {
                // 橙色预警
                alarmMsg = msgBean.getMsg("NODE_TIME_SUM_ORANGE");
                alarmLevel = ALARM_LEVEL_2;
                // 插入预警数据
                alarmList.add(getAlarmData(timeContentMap, nodeData, alarmLevel, timeAlarmType, "", alarmMsg));
                resultMsgList.add(alarmMsg);
                logger.debug("time constraint---orange alarm of sum time");
            } else if (timeSumOA >= sumTimeMap.get("redStart") && timeSumOA <= sumTimeMap.get("redEnd")) {
                // 红色预警
                alarmMsg = msgBean.getMsg("NODE_TIME_SUM_RED");
                alarmLevel = ALARM_LEVEL_2;
                // 插入预警数据
                alarmList.add(getAlarmData(timeContentMap, nodeData, alarmLevel, timeAlarmType, "",alarmMsg));
                resultMsgList.add(alarmMsg);
                logger.debug("time constraint---red alarm of sum time");
            } else if (timeSumOA >= timeSumMax) {
                // 超期 插入风险数据
                riskMsg = msgBean.getMsg("NODE_TIME_SUM_RISK");
                riskList.add(getRiskData(timeContentMap, nodeData, "", timeAlarmType, "", riskMsg));
                resultMsgList.add(riskMsg);
                logger.debug("time constraint---risk of sum time");
            }
            // 插入工作流运算结果数据
            nodeRule = msgBean.getMsg("NODE_RULE_TIME_2");
            resultList.add(getResultData(timeContentMap,nodeData,alarmLevel,timeAlarmType,alarmMsg,riskMsg,nodeRule));
        } else {
            alarmMsg = msgBean.getMsg("RULE_NOT_ENABLED");//约束未启用
            nodeRule = msgBean.getMsg("NODE_RULE_TIME_1");
            resultList.add(getResultData(timeContentMap,nodeData,ALARM_LEVEL_1,timeAlarmType,alarmMsg,"",nodeRule));

            nodeRule = msgBean.getMsg("NODE_RULE_TIME_2");
            resultList.add(getResultData(timeContentMap,nodeData,ALARM_LEVEL_1,timeAlarmType,alarmMsg,"",nodeRule));
        }
        /* 01 时间约束 end------------------------------ */
        resultObj.setAlarmList(alarmList);
        resultObj.setRiskList(riskList);
        resultObj.setResultMsgList(resultMsgList);
        resultObj.setResultList(resultList);
        return resultObj;
    }

    /**
     * 计算两个日期之间的工作日天数,左开右闭
     * @param startDate 开始时间
     * @param endDate 结束时间
     * @return 工作日天数
     */
    public int computeWorkDay(LocalDateTime startDate,LocalDateTime endDate){
        int count = 0;
        while (startDate.plusDays(1).compareTo(endDate) != 1){
            startDate = startDate.plusDays(1);

            //01.判断是否节假日，节假日直接跳过
            if(getHolidayList().contains(startDate)){
                continue;
            }

            //02.判断是否是周末
            int dayOfWeek = startDate.getDayOfWeek().getValue()%7;//取余7，获得在一个星期中的天数，oa中星期日是0
            boolean isWeekend = false;
            for(int dayNumber :getHolidaysOfWeek()){
                if(dayNumber == dayOfWeek){
                    //如果是周末，跳出循环
                    isWeekend = true;
                    break;
                }
            }

            //03.判断是否是需要上班的周末
            if(isWeekend && !getWorkWeekendList().contains(startDate)){
                //是周末 && 不是需要上班的周末
                continue;
            }
            // 是工作日， 天数 +1
            count ++;
        }
        return count;
    }

    /**
     * 职能约束
     *
     * @return
     */
    protected AlarmAndRisk roleConstraint(Map<String, Object> nodeData) {
        AlarmAndRisk resultObj = new AlarmAndRisk();
        List<Map<String, Object>> alarmList = new ArrayList<>();// 告警数据列表
        List<Map<String, Object>> riskList = new ArrayList<>();// 风险数据列表
        List<Map<String, Object>> resultList = new ArrayList<>();// 工作流运算结果数据列表
        List<String> resultMsgList = new ArrayList<>();
        /* 02 职能约束 start ---------------------------- */
        // 取得职能约束条件
        Map<String, Object> competencyMap = ruleTypeMap.get(RuleType.ROLE);

        String nodeRule = msgBean.getMsg("NODE_RULE_ROLE");
        String alarmLevel = String.valueOf(competencyMap.get("dcaAlarmLevel"));// 预警级别
        String alarmType = String.valueOf(RuleType.ROLE.getVal());
        String alarmMsg = "";
        String riskMsg = "";

        // 判断约束是否有效
        String isCompetencyEffective = String.valueOf(competencyMap.get("dcaIsEffective"));
        if (isCompetencyEffective.equals(NODE_CONSTRAINT_ENABLED)) { // 约束有效
            // 取出 岗位 约束条件
            final String postId = String.valueOf(competencyMap.get("dcaPostId"));

            // 取出岗位 OA数据 TODO

            Map<String, String> userRoleMap = getUserRole();
            String oaBizOpers = userRoleMap.get(nodeData.get("oaBizOperPersonId"));


//			String postIdOA = String.valueOf(nodeData.get("oaBizOperPost"));
            if (Arrays.stream(oaBizOpers.split(";")).noneMatch(s -> s.equals(postId))) {
                // 约束岗位不为空,产生预警
                alarmMsg = msgBean.getMsg("NODE_ROLE_ALARM", getAlarmLevelMsg(alarmLevel));
                // 插入预警数据
                alarmList.add(getAlarmData(competencyMap, nodeData, alarmLevel, alarmType, "", alarmMsg));
                resultMsgList.add(alarmMsg);
                logger.debug("role constraint--- alarm of role --- alarmLevel: " + getAlarmLevelMsg(alarmLevel));

                String isRisk = String.valueOf(competencyMap.get("dcaIsRisk"));// 风险标志位
                if (StringUtils.equals(isRisk, RISK_ENABLED)) {
                    // 是风险,插入风险数据
                    riskMsg = msgBean.getMsg("NODE_ROLE_RISK");
                    riskList.add(getRiskData(competencyMap, nodeData, alarmLevel, alarmType, "", riskMsg));
                    resultMsgList.add(riskMsg);
                    logger.debug("role constraint--- risk of role");
                }

            }
            // 插入工作流运算结果数据
            resultList.add(getResultData(competencyMap,nodeData,alarmLevel,alarmType,alarmMsg,riskMsg,nodeRule));
        } else {
            alarmMsg = msgBean.getMsg("RULE_NOT_ENABLED");//约束未启用
            resultList.add(getResultData(competencyMap,nodeData,ALARM_LEVEL_1,alarmType,alarmMsg,"",nodeRule));
        }
        /* 02 职能约束 end ------------------------------ */
        resultObj.setAlarmList(alarmList);
        resultObj.setRiskList(riskList);
        resultObj.setResultMsgList(resultMsgList);
        resultObj.setResultList(resultList);
        return resultObj;
    }

    /**
     * 行为约束 or 互证约束
     *
     * @param ruleType
     * @return
     */
    protected AlarmAndRisk actionOrBothConstraint(Map<String, Object> nodeData, RuleType ruleType) {
        AlarmAndRisk resultObj = new AlarmAndRisk();
        List<Map<String, Object>> alarmList = new ArrayList<>();// 告警数据列表
        List<Map<String, Object>> riskList = new ArrayList<>();// 风险数据列表
        List<Map<String, Object>> resultList = new ArrayList<>();// 工作流运算结果数据列表
        List<String> resultMsgList = new ArrayList<>();
        /* 03 行为约束 or 互证约束 start ---------------------------- */
        // 取得行为约束条件
        Map<String, Object> contentMap = ruleTypeMap.get(ruleType);

        String alarmLevel = String.valueOf(contentMap.get("dcaAlarmLevel"));// 预警级别
        String alarmType = String.valueOf(ruleType.getVal());// 约束类型
        // 约束名称
        String constrainName = "";
        String alarmMsg = "";
        String riskMsg = "";
        if (ruleType.equals(RuleType.ACTION)) {
            //行为约束
            constrainName = msgBean.getMsg("NODE_RULE_ACTION");
        } else if (ruleType.equals(RuleType.BOTH)) {
            //互证约束
            constrainName = msgBean.getMsg("NODE_RULE_BOTH");
        }

        String bizTaskId = String.valueOf(contentMap.get("dcaBizTaskId"));// 业务节点 id
        // 判断约束是否有效
        String isEffective = String.valueOf(contentMap.get("dcaIsEffective"));
        if (isEffective.equals(NODE_CONSTRAINT_ENABLED)) { // 约束有效
            // 取出 约束条件
            String actionContentId = String.valueOf(contentMap.get("dcaContentId"));// 节点内容主键
            String computeRule = String.valueOf(contentMap.get("dcaComputeRule"));

            ComputeResult computeResult = null;

            try {
                String oaInstanceId = (String) nodeData.get("oaInstanceId");
                computeResult = dealComputeRule(oaInstanceId,bizTaskId, computeRule);

                if (computeResult != null && computeResult.isAlarm()) {
                    // 产生预警
                    String cpuResult = computeResult.getCpuResult();

                    alarmMsg = msgBean.getMsg("NODE_SQL_ALARM", getAlarmLevelMsg(alarmLevel), constrainName);
                    // 插入预警数据
                    alarmList.add(getAlarmData(contentMap, nodeData, alarmLevel, alarmType, cpuResult,alarmMsg));
                    resultMsgList.add(alarmMsg);
                    logger.debug(
                            constrainName + " constraint--- alarm --- alarmLevel --> " + getAlarmLevelMsg(alarmLevel));

                    String isRisk = String.valueOf(contentMap.get("dcaIsRisk"));// 风险标志位

                    if (isRisk.equals(RISK_ENABLED)) {
                        // 是风险,插入风险数据
                        riskMsg = msgBean.getMsg("NODE_SQL_RISK", constrainName);
                        riskList.add(getRiskData(contentMap, nodeData, alarmLevel, alarmType, cpuResult, riskMsg));
                        resultMsgList.add(riskMsg);
                        logger.debug(constrainName + " constraint--- risk occurred");
                    }
                }

            } catch (Exception e) {
                // 插入工作流运算结果数据
                alarmMsg = msgBean.getMsg("RESULT_EXCEPTION");
                alarmLevel = ALARM_LEVEL_1;//解析异常，默认没有预警
                e.printStackTrace();
                logger.error("解析json数据结果异常", e);
            }
            // 插入工作流运算结果数据
            resultList.add(getResultData(contentMap,nodeData,alarmLevel,alarmType,alarmMsg,riskMsg,constrainName));
        } else {
            alarmMsg = msgBean.getMsg("RULE_NOT_ENABLED");//约束未启用
            resultList.add(getResultData(contentMap,nodeData,ALARM_LEVEL_1,alarmType,alarmMsg,"",constrainName));
        }
        /* 03 行为约束 or 互证约束 end ---------------------------- */
        resultObj.setAlarmList(alarmList);
        resultObj.setRiskList(riskList);
        resultObj.setResultMsgList(resultMsgList);
        resultObj.setResultList(resultList);
        return resultObj;
    }

    /**
     * 根据级别判断黄 橙 红 预警
     *
     * @param alarmLevel
     * @return
     */
    private String getAlarmLevelMsg(String alarmLevel) {
        String alarmLevelMsg = "";
        switch (Integer.parseInt(alarmLevel)) {
            case 2:
                alarmLevelMsg = msgBean.getMsg("ALARM_YELLOW");
                break;
            case 3:
                alarmLevelMsg = msgBean.getMsg("ALARM_ORANGE");
                break;
            case 4:
                alarmLevelMsg = msgBean.getMsg("ALARM_RED");
                break;
        }
        return alarmLevelMsg;
    }

    /**
     * 解析时间约束数据
     *
     * @param levelAndTimes 级别 时间
     * @return 解析时间结果
     */
    protected Map<String, Integer> parseLevelAndTimes(String[] levelAndTimes) {
        Map<String, Integer> resultMap = new HashMap<>();
        Integer yellowStart = -1;
        Integer yellowEnd = -1;
        Integer orangeStart = -1;
        Integer orangeEnd = -1;
        Integer redStart = -1;
        Integer redEnd = -1;
        if (levelAndTimes.length == 3) {// 三个级别都设置了天数限制
            yellowStart = getTime(levelAndTimes, 0, 1, 0);// 本节点需要时间黄色
            yellowEnd = getTime(levelAndTimes, 0, 1, 1);// 本节点需要时间黄色

            orangeStart = getTime(levelAndTimes, 1, 1, 0); // 本节点需要时间橙色
            orangeEnd = getTime(levelAndTimes, 1, 1, 1);// 本节点需要时间橙色

            redStart = getTime(levelAndTimes, 2, 1, 0);// 本节点需要时间红色
            redEnd = getTime(levelAndTimes, 2, 1, 1);// 本节点需要时间红色
        } else if (levelAndTimes.length == 2) {// 只设置了 两个告警级别天数限制
            String firstLevel = levelAndTimes[0].split(COLON)[0];// 第一个风险级别
            if (StringUtils.equals(firstLevel, ALARM_LEVEL_2)) {
                yellowStart = getTime(levelAndTimes, 0, 1, 0); // 本节点需要时间黄色
                yellowEnd = getTime(levelAndTimes, 0, 1, 1);// 本节点需要时间黄色
            } else if (StringUtils.equals(firstLevel, ALARM_LEVEL_3)) {
                orangeStart = getTime(levelAndTimes, 0, 1, 0); // 本节点需要时间橙色
                orangeEnd = getTime(levelAndTimes, 0, 1, 1);// 本节点需要时间橙色
            } else if (StringUtils.equals(firstLevel, ALARM_LEVEL_4)) {
                redStart = getTime(levelAndTimes, 0, 1, 0);// 本节点需要时间红色
                redEnd = getTime(levelAndTimes, 0, 1, 1); // 本节点需要时间红色
            }

            String secondLevel = levelAndTimes[1].split(COLON)[0];// 第二个风险级别
            if (StringUtils.equals(secondLevel, ALARM_LEVEL_2)) {
                yellowStart = getTime(levelAndTimes, 1, 1, 0);// 本节点需要时间黄色
                yellowEnd = getTime(levelAndTimes, 1, 1, 1);// 本节点需要时间黄色
            } else if (StringUtils.equals(secondLevel, ALARM_LEVEL_3)) {
                orangeStart = getTime(levelAndTimes, 1, 1, 0);// 本节点需要时间橙色
                orangeEnd = getTime(levelAndTimes, 1, 1, 1);// 本节点需要时间橙色
            } else if (StringUtils.equals(secondLevel, ALARM_LEVEL_4)) {
                redStart = getTime(levelAndTimes, 1, 1, 0);// 本节点需要时间红色
                redEnd = getTime(levelAndTimes, 1, 1, 1);// 本节点需要时间红色
            }
        } else if (levelAndTimes.length == 1) {// 只设置了一个级别
            if (StringUtils.equals(levelAndTimes[0].split(COLON)[0], ALARM_LEVEL_2)) {
                yellowStart = getTime(levelAndTimes, 0, 1, 0);// 本节点需要时间黄色
                yellowEnd = getTime(levelAndTimes, 0, 1, 1);// 本节点需要时间黄色
            } else if (StringUtils.equals(levelAndTimes[0].split(COLON)[0], ALARM_LEVEL_3)) {
                orangeStart = getTime(levelAndTimes, 0, 1, 0);// 本节点需要时间橙色
                orangeEnd = getTime(levelAndTimes, 0, 1, 1); // 本节点需要时间橙色
            } else if (StringUtils.equals(levelAndTimes[0].split(COLON)[0], ALARM_LEVEL_4)) {
                redStart = getTime(levelAndTimes, 0, 1, 0);// 本节点需要时间红色
                redEnd = getTime(levelAndTimes, 0, 1, 1); // 本节点需要时间红色
            }
        }
        resultMap.put("yellowStart", yellowStart);
        resultMap.put("yellowEnd", yellowEnd);
        resultMap.put("orangeStart", orangeStart);
        resultMap.put("orangeEnd", orangeEnd);
        resultMap.put("redStart", redStart);
        resultMap.put("redEnd", redEnd);
        return resultMap;
    }

    /**
     * 取得时间
     *
     * @param levelAndTimes 预警等级＆时间
     * @param i             "||"分割索引
     * @param x             ＂：＂分割索引
     * @param y             "-"分割索引
     * @return 天数
     */
    private static Integer getTime(String[] levelAndTimes, int i, int x, int y) {
        String value = levelAndTimes[i].split(COLON)[x].split(MINUS)[y];
        if (StringUtils.isNotEmpty(value)) {
            return Integer.parseInt(value);
        }
        return -1;
    }

    /**
     * 组装预警数据
     *
     * @param contentMap 节点约束
     * @return geshuo 20161215
     */
    private Map<String, Object> getAlarmData(Map<String, Object> contentMap, Map<String, Object> nodeData,
                                             String alarmLevel, String alarmType, String cpuResult, String alarmMsg) {
        Map<String, Object> alarmDataMap = new HashMap<>();

        String bizRoleId = String.valueOf(contentMap.get("dcaBizRoleId"));// 获取节点关联业务角色 id
        String powerId = String.valueOf(contentMap.get("dcaPowerId"));// 权力 id
        String riskId = String.valueOf(contentMap.get("dcaRiskId"));// 风险清单 id,从节点内容表取

        String bizFlowId = String.valueOf(nodeData.get("oaInstanceId"));// 业务实例id;via.ETL
        String bizFlowName = String.valueOf(nodeData.get("oaInstanceName"));// 业务实例名称

        // 业务操作人 操作人id，姓名
        String oaBizOperPersonId = String.valueOf(nodeData.get("oaBizOperPersonId"));
        String bizOperPerson = String.valueOf(nodeData.get("oaBizOperPersonName"));

        // 业务操作人所属部门 user表
        String bizOperPost = String.valueOf(nodeData.get("oaBizOperPost"));

        String bizDataId = String.valueOf(nodeData.get("oaDataId"));// 业务数据id;via.ETL
        String bizDataName = String.valueOf(nodeData.get("oaDataName"));// 业务数据名称；画面表示为办理事项
//        String alarmMsg = String.valueOf(nodeData.get("oaAlarmMsg"));// 预警信息

        String wfId = String.valueOf(contentMap.get("dcaWfId")); // 工作流id;via.workflow
        String taskId = String.valueOf(contentMap.get("dcaTaskId"));// 节点 id
        String taskName = String.valueOf(contentMap.get("dcaTaskName"));// 节点名称

        // 获取当前用户的岗位，逗号分隔形式
        Map<String, String> userRoleMap = getUserRole();
        String visualScope = userRoleMap.get(oaBizOperPersonId);// 根据用户id取得岗位，确定可视范围

        alarmDataMap.put("alarmDetailId", GenUUID.uuid());// 主键
        alarmDataMap.put("bizRoleId", bizRoleId);
        alarmDataMap.put("powerId", powerId);
        alarmDataMap.put("riskId", riskId);
        alarmDataMap.put("bizFlowId", bizFlowId);
        alarmDataMap.put("bizFlowName", bizFlowName);
        alarmDataMap.put("bizOperPerson", bizOperPerson);
        alarmDataMap.put("bizOperPersonId", oaBizOperPersonId);// 20170116 添加操作人id字段
        alarmDataMap.put("bizOperPost", bizOperPost);
        alarmDataMap.put("bizDataId", bizDataId);
        alarmDataMap.put("bizDataName", bizDataName);
        alarmDataMap.put("wfId", wfId);
        alarmDataMap.put("taskId", taskId);
        alarmDataMap.put("taskName", taskName);
        alarmDataMap.put("alarmLevel", alarmLevel);// 预警级别
        alarmDataMap.put("alarmType", alarmType);// 预警类型
        alarmDataMap.put("cpuResult", cpuResult);// 运算结果
        alarmDataMap.put("alarmMsg", alarmMsg);// 预警信息
        alarmDataMap.put("alarmStatus", ALARMSTATUS_1);// 预警状态 ：预警中
        alarmDataMap.put("visualScope", visualScope);// 可视范围
        alarmDataMap.put("delFlag", "0");
        return alarmDataMap;
    }

    /**
     * 组装风险数据
     *
     * @param contentMap 节点约束
     * @param alarmType  预警类型
     * @return 风险数据
     * <p>
     * geshuo 20161219
     */
    private Map<String, Object> getRiskData(Map<String, Object> contentMap, Map<String, Object> nodeData,
                                            String alarmLevel, String alarmType, String cpuResult, String riskMsg) {
        String bizRoleId = String.valueOf(contentMap.get("dcaBizRoleId"));// 获取节点关联业务角色 id
        String powerId = String.valueOf(contentMap.get("dcaPowerId"));// 权力 id
        String riskId = String.valueOf(contentMap.get("dcaRiskId"));// 风险清单 id,从节点内容表取

        String bizFlowId = String.valueOf(nodeData.get("oaInstanceId"));// 业务实例id;via.ETL
        String bizFlowName = String.valueOf(nodeData.get("oaInstanceName"));// 业务实例名称

        // 业务操作人 操作人id，姓名
        String oaBizOperPersonId = String.valueOf(nodeData.get("oaBizOperPersonId"));
        String bizOperPerson = String.valueOf(nodeData.get("oaBizOperPersonName"));

        // 业务操作人所属部门 user表
        String bizOperPost = String.valueOf(nodeData.get("oaBizOperPost"));

        String bizDataId = String.valueOf(nodeData.get("oaDataId"));// 业务数据id;via.ETL
        String bizDataName = String.valueOf(nodeData.get("oaDataName"));// 业务数据名称；画面表示为办理事项
//        String riskMsg = String.valueOf(nodeData.get("oaAlarmMsg"));// 风险信息

        String instanceId = String.valueOf(contentMap.get("dcaWfId")); // 工作流id
        String taskId = String.valueOf(contentMap.get("dcaTaskId"));// 流程节点 id
        String taskName = String.valueOf(contentMap.get("dcaTaskName"));// 流程节点名
        String riskLevel = String.valueOf(contentMap.get("dcaRiskLevel"));// 风险等级 ,从节点内容表关联
        String isDefineByManual = String.valueOf(contentMap.get("dcaIsManualJudge"));// 是否可以人工界定风险 0-否 1-是

        Map<String, Object> riskMap = new HashMap<>();
        riskMap.put("riskManageId", GenUUID.uuid());// 主键
        riskMap.put("bizRoleId", bizRoleId);
        riskMap.put("powerId", powerId);
        riskMap.put("riskId", riskId);
        riskMap.put("bizFlowId", bizFlowId);//null
        riskMap.put("bizFlowName", bizFlowName);//null
        riskMap.put("bizOperPerson", bizOperPerson);
        riskMap.put("bizOperPersonId", oaBizOperPersonId);// 20170116 添加操作人id字段
        riskMap.put("bizOperPost", bizOperPost);
        riskMap.put("bizDataId", bizDataId);
        riskMap.put("bizDataName", bizDataName);//null
        riskMap.put("instanceId", instanceId);
        riskMap.put("taskId", taskId);
        riskMap.put("taskName", taskName);
        riskMap.put("alarmType", alarmType);// 预警/风险维度
        riskMap.put("alarmLevel", alarmLevel);// 预警级别
        riskMap.put("riskLevel", riskLevel);
        riskMap.put("cpuResult", cpuResult);// 运算结果
        riskMap.put("riskMsg", riskMsg);
        riskMap.put("riskTransFlag", RISK_TRANS_FLAG_0);// 未转发
        riskMap.put("isDefineByManual", isDefineByManual);
        riskMap.put("defineStatus", DEFINE_STATUS_3);// 风险状态：3-未界定
        riskMap.put("delFlag", "0");
        riskMap.put("delFlag", "0");
        return riskMap;
    }

    /**
     * 组合工作流运算结果数据
     *
     * @param contentMap
     * @param nodeData
     * @param alarmLevel
     * @param alarmType
     * @return
     */
    private Map<String, Object> getResultData(Map<String, Object> contentMap, Map<String, Object> nodeData,
                                              String alarmLevel, String alarmType, String alarmMsg, String riskMsg, String nodeRule) {
        String wfId = String.valueOf(contentMap.get("dcaWfId")); // 工作流id
        String taskId = String.valueOf(contentMap.get("dcaTaskId"));// 流程节点 id
        String taskName = String.valueOf(contentMap.get("dcaTaskName"));// 流程节点名
        String bizFlowId = String.valueOf(contentMap.get("dcaWfId"));// 业务实例id;via.ETL
        String bizDataId = String.valueOf(nodeData.get("oaDataId"));// 业务数据id;via.ETL
        String idxDataType = String.valueOf(contentMap.get("idxDataType"));

        String resultMsg = ""; // 运算结果
        if(StringUtils.isEmpty(alarmMsg) && StringUtils.isEmpty(riskMsg)){
            resultMsg += msgBean.getMsg("NODE_PARAM_NO_ALARM_RISK", nodeRule) +";";
            alarmLevel = ALARM_LEVEL_1;
        }else {
            if(StringUtils.isNotEmpty(alarmMsg)){
                resultMsg += alarmMsg + ";";
            }
            if(StringUtils.isNotEmpty(riskMsg)){
                resultMsg += riskMsg + ";";
            }
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("uuid", GenUUID.uuid());// 主键
        resultMap.put("wfId", wfId);
        resultMap.put("taskId", taskId);
        resultMap.put("taskName", taskName);
        resultMap.put("bizFlowId", bizFlowId);
        resultMap.put("bizDataId", bizDataId);
        resultMap.put("alarmType", alarmType);// 预警/风险维度
        resultMap.put("alarmLevel", alarmLevel);// 预警级别
        resultMap.put("computeResult", resultMsg);// 运算结果
        resultMap.put("idxDataType", idxDataType);
        resultMap.put("delFlag", "0");
        return resultMap;
    }

    /**
     * 处理触发条件
     *
     *
     * @param oaInstanceId 实例ID
     * @param bizTaskId   业务节点 id
     * @param computeRule 触发条件
     * @return geshuo 20161215
     * @throws Exception
     */
    private ComputeResult dealComputeRule(String oaInstanceId, final String bizTaskId, final String computeRule)
            throws Exception {
        // 触发条件 {select count(*) from TEST} > 1 and {select count(*) from TEST} > 5
        // 计算结果 {'id':'业务id','expression':[{'name':'表达式结果1','result':'false'}]}
          /*ruleParams = "<rule id='" + bizTaskId + "'><expression id='" + contentId + "'>" + computeRule
                + "</expression></rule>";
*/

        String ruleParams = "<rule id='" + bizTaskId + "'><expression id='' instanceID='" + oaInstanceId +
                "'>" + computeRule + "</expression></rule>";

//        String ruleParams = "<rule id=''><expression id='' instanceID='TraceI000222K4JL'>{select count(*) from " +
//                "(select ZDXMCLSC,LDQZSPDSC from ZDXMSQD where TRACE_INSTANCE_INDEX_ID = [instanceID]) ZDXMSQD where  ZDXMCLSC is null or LDQZSPDSC is null}>0</expression></rule>";
//
//        String jsonResult = "{\"id\":\"" + bizTaskId + "\",\"expression\":[{\"id\":\"" + contentId
//                + "\",\"result\":\"false\"}]}";// getAnalysisObject().execute(ruleParams);

        final ComputeResult computeResult = new ComputeResult();

        getAnalysisObject().exec(jsonResult -> {

            // 取出 计算结果
            ObjectMapper mapper = new ObjectMapper();
            try {

                HashMap<String, Object> result = mapper.readValue(jsonResult, HashMap.class);

                if (Objects.equals(result.get("id"), bizTaskId) && Objects.isNull(result.get("expression"))) {
                    // 判断id对应的表达式结果是否存在
                    logger.warn("返回规则不匹配:" + result);
                    return;
                }
                List<Map<String, Object>> array = (List<Map<String, Object>>) result.get("expression");
                if (CollectionUtils.isEmpty(array)) {
                    return;
                }
                Map<String, Object> obj = array.get(0);

//                if (!Objects.equals(obj.get("name"), contentId)) {
//
//                    logger.warn("返回规则不匹配:" + contentId + "=>" + result);
//                    return;
//                }
                String isAlarmStr = String.valueOf(obj.get("result"));

                // 触发条件为true
                computeResult.setIsAlarm(BooleanUtils.toBoolean(isAlarmStr));
                computeResult.setCpuResult(jsonResult);


            } catch (IOException e) {
                e.printStackTrace();
            }


        }, ruleParams);


        return computeResult;
    }

    /**
     * 解析时间单位
     *
     * @param timeUnit   时间单位
     * @param timeMillis 时间差，毫秒数
     * @return 时间值
     * <p>
     * geshuo 20161220
     */
    private long parseTimeUnit(String timeUnit, long timeMillis) {
        double dayTime = 1000 * 60 * 60 * 24;
        double hourTime = 1000 * 60 * 60;
        double secondTime = 1000;
        if (timeUnit.equals("1")) {
            // 天
            return Math.round(timeMillis / dayTime);
        } else if (timeUnit.equals("2")) {
            // 小时
            return Math.round(timeMillis / hourTime);
        } else if (timeUnit.equals("3")) {
            // 秒
            return Math.round(timeMillis / secondTime);
        }
        return -1;
    }

    protected class ComputeResult {
        private boolean isAlarm;// 是否是预警
        private String cpuResult;// 处理结果

        public boolean isAlarm() {
            return isAlarm;
        }

        public void setIsAlarm(boolean isAlarm) {
            this.isAlarm = isAlarm;
        }

        public String getCpuResult() {
            return cpuResult;
        }

        public void setCpuResult(String cpuResult) {
            this.cpuResult = cpuResult;
        }
    }

    protected class AlarmAndRisk {
        private List<Map<String, Object>> alarmList;
        private List<Map<String, Object>> riskList;
        private List<String> resultMsgList;
        private List<Map<String, Object>> resultList;

        public List<Map<String, Object>> getAlarmList() {
            return alarmList;
        }

        public void setAlarmList(List<Map<String, Object>> alarmList) {
            this.alarmList = alarmList;
        }

        public List<Map<String, Object>> getRiskList() {
            return riskList;
        }

        public void setRiskList(List<Map<String, Object>> riskList) {
            this.riskList = riskList;
        }

        public List<String> getResultMsgList() {
            return resultMsgList;
        }

        public void setResultMsgList(List<String> resultMsgList) {
            this.resultMsgList = resultMsgList;
        }

        public List<Map<String, Object>> getResultList() {
            return resultList;
        }

        public void setResultList(List<Map<String, Object>> resultList) {
            this.resultList = resultList;
        }
    }
}
