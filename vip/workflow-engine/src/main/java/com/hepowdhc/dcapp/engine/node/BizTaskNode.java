package com.hepowdhc.dcapp.engine.node;

import com.hepowdhc.dcapp.utils.GenUUID;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by fzxs on 16-11-26.
 */
public abstract class BizTaskNode extends TaskNode {

    // protected BizTaskNode(String nodeId) {
    // super(nodeId);
    // }

//    private Map<String, Object> nodeDataMap;

    protected BizTaskNode() {
        super();
    }

    protected BizTaskNode(Map<String, Object> nodeDataMap) {
        super();
        this.nodeDataMap = nodeDataMap;
    }

    /**
     * 比较 OA工作流实例节点数据 和 流程图节点约束条件,生成告警、风险数据
     * <p>
     * geshuo 20161214
     */
    @Override
    public void validate(Map<String, Object> nodeData) {
        //将上一个节点的id添加到列表中，用于消除风险和预警
//		List<Map<String,Object>> preNodeList = prevElement();
//		for(Map<String,Object> preNode : preNodeList){
//			String preNodeDataId = String.valueOf(preNode.get("oaDataId"));//数据id
//			getBizInstance().getOaDataIdList().add(preNodeDataId);
//		}

        String instanceId = String.valueOf(nodeData.get("oaInstanceId"));// 实例 id ->oa
        String oaDataId = String.valueOf(nodeData.get("oaDataId"));//数据id

        if (String.valueOf(nodeData.get("markDone")).equals("1")) {
            //已经执行完成
            logger.debug("节点已经执行过 instanceId = " + instanceId + " oaDataId = " + oaDataId);
            return;
        }

        Map<String, Object> timeContentMap = ruleTypeMap.get(RuleType.TIME);

        String resultType = "";// 执行结果状态
        List<String> resultMsgList = new ArrayList<>();// 执行结果信息
        // 判断节点是否启用
        String isShow = String.valueOf(timeContentMap.get("dcaIsShow"));
        if (!isShow.equals(NODE_ENABLED)) {
            // 节点未启用 ，直接返回
            // 添加执行结果状态 0-忽略 1-成功 2-有预警或风险 3-无约束 ，和执行结果信息字段
            resultType = RESULT_TYPE_0;
            resultMsgList.add(msgBean.getMsg("NODE_SKIP"));
            logger.debug(msgBean.getMsg("NODE_SKIP") + " " + instanceId);
            // 获取组装节点日志数据
            Map<String, Object> newNodeMap = getNodeLogData(nodeData, instanceId, resultType, resultMsgList);
            getExtractDataDao().insertBizNodeLog(newNodeMap);// 执行插入
            getExtractDataDao().updateOaDataById(oaDataId);//更新oa表节点处理状态
            return;
        }

        List<Map<String, Object>> alarmList = new ArrayList<>();// 告警数据列表
        List<Map<String, Object>> riskList = new ArrayList<>();// 风险数据列表
        List<Map<String, Object>> resultList = new ArrayList<>();// 工作流运算结果数据列表

        // 时间约束
        AlarmAndRisk timeObj = timeConstraint(nodeData);
        alarmList.addAll(timeObj.getAlarmList());
        riskList.addAll(timeObj.getRiskList());
        resultMsgList.addAll(timeObj.getResultMsgList());// 结果信息
        resultList.addAll(timeObj.getResultList()); // 工作流运算结果

        // 职能约束
        AlarmAndRisk roleObj = roleConstraint(nodeData);
        alarmList.addAll(roleObj.getAlarmList());
        riskList.addAll(roleObj.getRiskList());
        resultMsgList.addAll(roleObj.getResultMsgList());// 结果信息
        resultList.addAll(roleObj.getResultList()); // 工作流运算结果

        // 行为约束
        AlarmAndRisk actionObj = actionOrBothConstraint(nodeData, RuleType.ACTION);
        alarmList.addAll(actionObj.getAlarmList());
        riskList.addAll(actionObj.getRiskList());
        resultMsgList.addAll(actionObj.getResultMsgList());// 结果信息
        resultList.addAll(actionObj.getResultList()); // 工作流运算结果

        // 互证约束
        AlarmAndRisk bothObj = actionOrBothConstraint(nodeData, RuleType.BOTH);
        alarmList.addAll(bothObj.getAlarmList());
        riskList.addAll(bothObj.getRiskList());
        resultMsgList.addAll(bothObj.getResultMsgList());// 结果信息
        resultList.addAll(bothObj.getResultList()); // 工作流运算结果

		/* 数据库操作 START ------------------------------------------------ */
        // 批量插入告警
        if (alarmList.size() > 0) {
            logger.debug("batch insert alarm data --> instanceId = " + instanceId);
            Map[] alarmArray = new HashMap[alarmList.size()];
            alarmList.toArray(alarmArray);
//			getExtractDataDao().insertAlarmList(alarmArray);// 执行插入
            this.insertAlarmList(alarmArray);

            //自动消警

            List<String> oaDataIdList = this.prevElement()

                    .stream()

                    .map(map -> (String) map.get("_id"))

                    .collect(Collectors.toList());

            getExtractDataDao().updateAlarmByDataIdList(oaDataIdList);

        }

        // 批量插入风险
        if (riskList.size() > 0) {
            logger.debug("batch insert risk data -->  instanceId = " + instanceId);
            Map[] riskArray = new HashMap[riskList.size()];
            riskList.toArray(riskArray);
//			getExtractDataDao().insertRiskList(riskArray);// 执行插入
            this.insertRiskList(riskArray);
        }

        // 批量插入工作流运算结果
        if(resultList.size() > 0){
            Map[] resultArray = new HashMap[resultList.size()];
            resultList.toArray(resultArray);
            getExtractDataDao().insertComputeResult(resultArray);
        }

        if (alarmList.size() == 0 && riskList.size() == 0) {
            // 没有风险和预警
            resultType = RESULT_TYPE_1;
            resultMsgList.add(msgBean.getMsg("NODE_NO_ALARM_RISK"));
            logger.debug("no alarm or risk --> instanceId = " + instanceId);
        } else {
            resultType = RESULT_TYPE_2;// 有预警或 风险
        }

        // 添加执行结果状态 0-忽略 1-成功 2-有预警或风险 3-无约束 ，和执行结果信息字段
        // 获取组装节点日志数据
        Map<String, Object> nodeMap = getNodeLogData(nodeData, instanceId, resultType, resultMsgList);
        getExtractDataDao().insertBizNodeLog(nodeMap);// 执行插入
        getExtractDataDao().updateOaDataById(oaDataId);//更新oa表节点处理状态

        // 更新实例表
        if (isEndNode()) {
            // 当前已经是最后一个节点，表明所有节点都已经处理完成
            getExtractDataDao().updateBizInstanceById(instanceId);// 更新实例数据 完成状态MARK_DONE
            getExtractDataDao().updateOaInstanceById(instanceId);//更新oa表实例处理状态
            logger.debug("this instance is all done --> instanceId = " + instanceId);
        }
        /* 数据库操作 END ------------------------------------------------ */
    }

    /**
     * 组装节点日志数据
     *
     * @param nodeData
     * @param instanceId    实例 id
     * @param resultType
     * @param resultMsgList
     * @return 节点日志数据
     * <p>
     * geshuo 20161222
     */
    private Map<String, Object> getNodeLogData(Map<String, Object> nodeData, String instanceId, String resultType,
                                               List<String> resultMsgList) {
        Map<String, Object> nodeMap = new HashMap<>();
        nodeMap.put("uuid", GenUUID.uuid());// 主键
        nodeMap.put("bizInstanceId", instanceId);// 实例id
        nodeMap.put("bizDataId", nodeData.get("oaDataId"));// 数据id
        nodeMap.put("bizDataName", nodeData.get("oaDataName"));// 数据名称
        nodeMap.put("stepId", nodeData.get("oaStepId"));// 步骤id
        nodeMap.put("bizOptPerson", nodeData.get("oaBizOperPersonId"));// 操作人id
        nodeMap.put("bizOptPersonDepart", nodeData.get("oaBizOperPost"));// 操作人所属部门
        nodeMap.put("startTime", nodeData.get("oaNodeStartTime"));// 审批开始时间
        nodeMap.put("endTime", nodeData.get("oaNodeEndTime"));// 审批结束时间
        nodeMap.put("resultType", resultType);// 执行结果状态
        nodeMap.put("resultMsg", resultMsgList.toString());// 执行结果信息
        nodeMap.put("markDone", "1");// 处理完成状态
        return nodeMap;
    }

    @Override
    public Map<String, Object> getNodeInfo() {
        return nodeDataMap;
    }

    @Override
    public String getBizId() {
        return (String) nodeDataMap.get("dcaBizTaskId");
    }

    /**
     * 告警数据批量插入
     *
     * @param alarmArray
     * @author geshuo
     * @date 2017年1月10日
     */
    @Override
    public void insertAlarmList(Map[] alarmArray) {
        getExtractDataDao().insertAlarmList(alarmArray);// 执行插入
    }

    /**
     * 风险数据批量插入
     *
     * @param riskArray
     * @author geshuo
     * @date 2017年1月10日
     */
    @Override
    public void insertRiskList(Map[] riskArray) {
        getExtractDataDao().insertRiskList(riskArray);// 执行插入
    }

    /**
     * 插入预警数据
     *
     * @param alarmMap
     * @author geshuo
     * @date 2017年1月10日
     */
    @Override
    public void insertAlarm(Map<String, Object> alarmMap) {
        getExtractDataDao().insertAlarm(alarmMap);// 执行插入
    }

    /**
     * 插入风险数据
     *
     * @param riskMap
     * @author geshuo
     * @date 2017年1月10日
     */
    @Override
    public void insertRisk(Map<String, Object> riskMap) {
        getExtractDataDao().insertRisk(riskMap);// 执行插入
    }

    /**
     * 更新告警状态
     *
     * @param bizDataIdList 需要更新的业务数据id列表
     * @author geshuo
     * @date 2017年1月10日
     */
    @Override
    public void updateAlarmData(List<String> bizDataIdList) {
        getExtractDataDao().updateAlarmByDataIdList(bizDataIdList);
    }
}
