package com.hepowdhc.dcapp.engine;

import com.hepowdhc.dcapp.engine.instance.Instance;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;


/**
 * Created by fzxs on 16-11-26.
 */
public interface Node extends Enumeration, Serializable {

    /**
     * 约束类型
     */
    enum RuleType {


        /**
         * 时间约束
         */
        TIME("1"),


        /**
         * 职能约束
         */
        ROLE("2"),

        /**
         * 行为约束
         */
        ACTION("3"),

        /**
         * 互证约束
         */
        BOTH("4");

        private String val;

        RuleType(String val) {

            this.val = val;
        }


        public String getVal() {
            return val;
        }


        public static RuleType ruleType(String type) {

            switch (type) {

                case "1": {

                    return TIME;
                }
                case "2": {

                    return ROLE;
                }
                case "3": {

                    return ACTION;
                }
                case "4": {

                    return BOTH;
                }
            }
            return null;

        }
    }


    enum NodeType {


        /**
         * 开始节点
         */
        NODE_TYPE_START("start round"),
        /**
         * 结束节点
         */
        NODE_TYPE_END("end round"),
        /**
         * 任务节点
         */
        NODE_TYPE_TASK("mutiselect");

        private String type;


        NodeType(String type) {
            this.type = type;
        }


        public static NodeType nodeType(String type) {


            switch (type) {

                case "start round": {

                    return NODE_TYPE_START;
                }

                case "end round": {

                    return NODE_TYPE_END;
                }

                case "mutiselect": {

                    return NODE_TYPE_TASK;
                }
            }

            return null;

        }

        @Override
        public String toString() {
            return this.type;
        }
    }

    List<Map<String, Object>> prevElement();

    String getNodeName();

    /**
     * 节点类型
     *
     * @return
     */
    NodeType getNodeType();

    /**
     * @return
     */
    String getNodeId();

    /**
     * 获取流程图节点数据
     *
     * @return
     */
    Map<String, Object> getNodeInfo();

    /**
     * 获取工作流数据
     * @return
     */
    Map<String, Object> getNodeDataMap();

    /**
     * 获取流程图节点约束条件
     *
     * @return
     */
    Map<RuleType, Map<String, Object>> getNodeRule();


    boolean isEndNode();

    boolean isStartNode();

    @Deprecated
    default void addNodeRuleData(Map<String, Object>... nodeData) {
    }

    void validate(Map<String, Object> nodeData);

    Map<String, String> getUserRole();


    default String getBizId() {

        return (String) getNodeInfo().get("dcaBizTaskId");
    }

    /**
     * 插入预警数据
     *
     * @param alarmMap
     * @author geshuo
     * @date 2017年1月10日
     */
    void insertAlarm(Map<String, Object> alarmMap);

    /**
     * 插入风险数据
     *
     * @param riskMap
     * @author geshuo
     * @date 2017年1月10日
     */
    void insertRisk(Map<String, Object> riskMap);

    /**
     * 告警数据批量插入
     *
     * @param alarmArray
     * @author geshuo
     * @date 2017年1月10日
     */
    void insertAlarmList(Map[] alarmArray);

    /**
     * 风险数据批量插入
     *
     * @param riskArray
     * @author geshuo
     * @date 2017年1月10日
     */
    void insertRiskList(Map[] riskArray);

    /**
     * 获取节点的实例
     *
     * @return
     * @author geshuo
     * @date 2017年1月10日
     */
    Instance getBizInstance();

    /**
     * 更新告警状态
     *
     * @param bizDataIdList 需要更新的业务数据id列表
     * @author geshuo
     * @date 2017年1月10日
     */
    void updateAlarmData(List<String> bizDataIdList);

    /**
     * 获取结节假日列表
     * @return
     */
    List<LocalDateTime> getHolidayList();

    /**
     * 获取需要上班的工作日
     * @return
     */
    List<LocalDateTime> getWorkWeekendList();

    /**
     * 获取周末休息日列表
     * @return
     */
    List<Integer> getHolidaysOfWeek();
}
