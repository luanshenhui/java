package com.hepowdhc.dcapp.engine.biz;

import com.hepowdhc.dcapp.dao.ExtractDataDao;
import com.hepowdhc.dcapp.engine.AbsSuperFlowEngine;
import com.hepowdhc.dcapp.engine.AnalysisObject;
import com.hepowdhc.dcapp.engine.FlowEngine;
import com.hepowdhc.dcapp.engine.Node;
import com.hepowdhc.dcapp.engine.WorkFlow;
import com.hepowdhc.dcapp.engine.instance.Instance;
import com.hepowdhc.dcapp.engine.instance.impl.BizInstance;
import com.hepowdhc.dcapp.engine.node.BizTaskNode;
import com.hepowdhc.dcapp.engine.workflow.AbsWorkFlow;
import com.hepowdhc.dcapp.exception.SocketNotActiveException;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 业务流引擎
 */
public abstract class AbsBizFlowEngine extends AbsSuperFlowEngine implements Serializable {


    private final Map<String, Instance> instanceMap = new HashMap<>();

    final List<Instance> instanceList = new ArrayList<>();

    final private Consumer<Instance> instanceConsumer = ins -> ins.execute();


    private AnalysisObject analysisObject;


    /**
     * 初始化
     */
    @Override
    public FlowEngine initialization() throws Exception {

        logger.debug("引擎数据初化开始!");

        try {

            analysisObject = new AnalysisObject(engineConf);

            analysisObject.start();

            instanceMap.clear();

            instanceList.clear();

            flushBaseData();

            instanceMap.forEach((s, instance) -> instanceMap.remove(s));

            instanceList.stream().forEach(instanceList::remove);

            workFlowMap.forEach((fwid, workFlow) -> this.loadAllInstanceByWorkFowId(fwid));

            logger.debug("引擎数据初化完成!");

        } catch (SocketNotActiveException e) {

            return null;

        } finally {

        }
        return this;

    }

    /**
     * @param nodeDataList 一个工作流的所有数据
     * @return
     */
    protected WorkFlow createWorkFlow(final String flowWorkId, final Map<String, List<Map<String, Object>>> nodeDataList) {

        logger.debug("创建工作流");


//        BiFunction<Map<String, Object>, List<Map<String, Object>>, Node> createTask = (flowData, nodesList) ->


        Function<Map<String, List<Map<String, Object>>>, WorkFlow> createWorkFlow = nodesData ->

                new AbsWorkFlow(nodesData) {

                    private String fwId;

                    private String powerId;

                    private Map<String, Node> nodes;

                    private Map<String, Object> flowContent;

                    private Map<String, Map<String, Object>> flowNodes;

                    private Map<String, Map<String, Object>> flowLines;

                    @Override
                    protected void init() {

                        if (StringUtils.isEmpty(fwId)) {

                            this.fwId = flowWorkId;

                            this.nodes = new HashMap<>();

                        }
                        //rule X 4
                        nodesData.forEach((nodeId, ruleList) -> {

                            final Map<String, Object> nodeDataMap = ruleList.get(0);

                            if (MapUtils.isEmpty(flowContent)) {

                                //节点和线的json
                                flowContent = readJsonData((String) nodeDataMap.get("dcaXmlContent"));

                                //所有节点信息，节点Id为key
                                flowNodes = (Map<String, Map<String, Object>>) flowContent.get("nodes");

                                //所有线信息，包含前后节点关系
                                flowLines = (Map<String, Map<String, Object>>) flowContent.get("lines");

                                powerId = (String) nodeDataMap.get("dcaPowerId");

                                //   nodeId = (String) nodeDataMap.get("21482ce1d7d64e4ca809bf68dcea1d34");

                            }

                            this.nodes.put(nodeId,

                                    new BizTaskNode(nodeDataMap) {

                                        @Override
                                        protected void init() {

                                            //消息文字bean
                                            this.msgBean = AbsBizFlowEngine.this.msgBean;

                                            if (MapUtils.isEmpty(ruleTypeMap)) {
                                                // RuleType为key，存储所有约束数据
                                                ruleTypeMap = new HashMap<>();
                                            }

                                            //list 转 map
                                            ruleList.forEach(map -> ruleTypeMap.put(RuleType.ruleType((String) map.get("dcaAlarmType")),
                                                    map));

                                        }

                                        /**
                                         * 节点类型
                                         *
                                         * @return
                                         */
                                        @Override
                                        public NodeType getNodeType() {
                                            return NodeType.nodeType((String) flowNodes.get(getNodeId()).get("type"));
                                        }

                                        @Override
                                        public String getNodeId() {
                                            return (String) nodeDataMap.get("dcaTaskId");
                                        }

                                        //
                                        @Override
                                        public String getNodeName() {
                                            return (String) nodeDataMap.get("dcaTaskName");
                                        }

                                        @Override
                                        public Map<String, Object> getNodeInfo() {
                                            return nodeDataMap;
                                        }

                                        /**
                                         * XXX
                                         *  融合平台中用到的OA 没有结束节点.但是融合平台中有结束节点,所以如果判断出来当前节点处于OA中的最后一个节点,
                                         *  即:在融合平台中的下一个节点为结束节点 即判定当的节点为实例的最后一个节点
                                         * @return
                                         */
                                        @Override
                                        public boolean isEndNode() {

                                            //当前节点是结束节点  || 下一节点是结束节点
                                            return NodeType.NODE_TYPE_END == getNodeType() || nextElement().stream()
                                                    .anyMatch(map -> NodeType.NODE_TYPE_END == NodeType
                                                            .nodeType((String) map.get("type")));

                                        }

                                        @Override
                                        public boolean isStartNode() {

                                            //当前节点是开始节点  || 前一节点是开始节点
                                            return NodeType.NODE_TYPE_START == getNodeType() || prevElement().stream()
                                                    .anyMatch(map -> NodeType.NODE_TYPE_START == NodeType
                                                            .nodeType((String) map.get("type")));
                                        }

                                        @Override
                                        public Map<String, String> getUserRole() {
                                            return userRoleMap;
                                        }

                                        @Override
                                        public List<LocalDateTime> getHolidayList() {
                                            // 获取节假日列表
                                            return holidayList;
                                        }

                                        @Override
                                        public List<LocalDateTime> getWorkWeekendList() {
                                            // 获取需要上班的周末
                                            return workWeekendList;
                                        }

                                        @Override
                                        public List<Integer> getHolidaysOfWeek() {
                                            // 获取正常周末休息日
                                            return holidaysOfWeek;
                                        }

                                        @Override
                                        public Instance getBizInstance() {
                                            return null;
                                        }

                                        @Override
                                        protected AnalysisObject getAnalysisObject() {
                                            return analysisObject;
                                        }

                                        @Override
                                        protected ExtractDataDao getExtractDataDao() {
                                            return extractDataDao;
                                        }

                                        @Override
                                        public boolean hasMoreElements() {

                                            return !nextElement().isEmpty();
                                        }

                                        @Override
                                        public List<Map<String, Object>> prevElement() {
                                            final List<Map<String, Object>> list = new ArrayList<>();

                                            flowLines.forEach((s, map) -> {

                                                // to 本节点id，说明是上一个节点
                                                if (StringUtils.equals((CharSequence) map.get("to"), getNodeId())) {

                                                    Map<String, Object> _map = new HashMap<>();

                                                    _map.put("_id", map.get("from"));// 节点id

                                                    _map.putAll(flowNodes.get(map.get("from")));// 节点其他信息

                                                    list.add(_map);
                                                }
                                            });


                                            return list;
                                        }

                                        @Override
                                        public List<Map<String, Object>> nextElement() {

                                            final List<Map<String, Object>> list = new ArrayList<>();

                                            flowLines.forEach((s, map) -> {

                                                // from 本节点id，说明是下一个节点
                                                if (StringUtils.equals((CharSequence) map.get("from"), getNodeId())) {

                                                    final Map<String, Object> _map = new HashMap<>();

                                                    _map.put("_id", map.get("to")); // 节点id

                                                    _map.putAll(flowNodes.get(map.get("to"))); // 节点其他信息

                                                    list.add(_map);

                                                }
                                            });


                                            return list;
                                        }
                                    }

                            );

                        });

                    }

                    @Override
                    public String getFlowId() {
                        return fwId;
                    }

                    @Override
                    public String getPowerId() {
                        return powerId;
                    }

                    @Override
                    public Map<String, Node> allNodes() {
                        return nodes;
                    }
                };

        return createWorkFlow.apply(nodeDataList);
    }

    /**
     * 通过工作流名称 获取该工作流所有数据
     *
     * @param name
     * @return
     */
    protected abstract List<Map<String, Object>> getWorkDataByName(String name);


    @Override
    public List<Instance> loadAllInstanceByWorkFowId(final String workFlowId) {

        final List<Map<String, Object>> oaDataList = extractDataDao.findOADataByWfId(workFlowId);

        Set<String> filter = new HashSet<>();

        oaDataList

                .stream()

                .filter(map -> StringUtils.isNotEmpty((CharSequence) map.get("oaInstanceId")))

                .collect(Collectors.groupingBy(map -> (String) map.get("oaInstanceId")))

                .forEach((insId, nodes) -> {

                    Instance instance;

                    final Optional<Instance> instanceOptional = Optional.ofNullable(instanceMap.get(insId));

                    if (instanceOptional.isPresent()) {

                        instance = instanceOptional.get();

                        instance.build(nodes);

                    } else {

                        filter.add(insId);

                        instance = this.getInstanceById(insId);


                        if (Objects.isNull(instance)) {

                            instance = createInstance(nodes);

                            extractDataDao.insertSingleBizInstance(instance);

                            audit.powerWorkFlowAudit(instance);

                        } else {

                            instance.build(nodes);
                        }

                        instanceMap.put(insId, instance);

                    }

                    instanceList.add(instance);
                });


        return instanceList;

    }


    /**
     * 获取一个实例
     *
     * @param instanceId
     */
    @Override
    public Instance getInstanceById(String instanceId) {

        final List<Map<String, Object>> instanceDataList = extractDataDao.findInstanceByInstanceId(instanceId);

        if (instanceDataList == null || instanceDataList.isEmpty()) {

            return null;
        }

        return createInstance(instanceDataList);
    }


    private Instance createInstance(final List<Map<String, Object>> instanceDataList) {


        return new BizInstance() {

            private String instanceId;

            private String flowId;

            private String instanceName;

            private Date startTime;

            private WorkFlow workFlow;

            private Map<String, List<Map<String, Object>>> nodeData;

            @Override
            protected void init() {

                nodeData = new HashMap<>();

                instanceDataList.forEach(map -> build(map));

            }


            @Override
            public String getInstanceId() {
                return instanceId;
            }

            @Override
            public String getFlowId() {
                return flowId;
            }

            @Override
            public String getInstanceName() {
                return instanceName;
            }

            @Override
            public String getPowerId() {
                return workFlow.getPowerId();
            }

            @Override
            public Map<String, Node> getNodes() {
                return workFlow.allNodes();
            }

            @Override
            public Date getStartTime() {
                return startTime;
            }


            @Override
            public void build(final Map<String, Object> map) {

                if (StringUtils.isEmpty(instanceId)) {

                    instanceId = (String) map.get("oaInstanceId");

                    flowId = (String) map.get("oaWfId");

                    instanceName = (String) map.get("oaInstanceName");

                    startTime = (Date) map.get("oaFlowStartTime");

                    workFlow = workFlowMap.get(flowId);

                    if (Objects.isNull(workFlow)) {

                        logger.warn("没有对应的工作流配置!");

                        return;
                    }

                }
                logger.debug("=oaStepId==>" + instanceId + "-===>" + String.valueOf(map.get("oaStepId")));

                //构造 节点map的key
                String oaStepId = String.valueOf(map.get("oaStepId"));
                if(nodeData.get(oaStepId) != null && nodeData.get(oaStepId).size() > 0){
                    nodeData.get(oaStepId).add(map);
                } else {
                    //一个步骤可能有多人审批,所以是list
                    List<Map<String,Object>> singleStepNodeList = new ArrayList<>();
                    singleStepNodeList.add(map);
                    nodeData.put(oaStepId,singleStepNodeList);
                }

            }


            @Override
            public void execute() {

                workFlow.allNodes().forEach((id, node) -> {

                    logger.debug("节点执行中->" + id + "==>" + node.getBizId());

                    // 根据 nodeKey 取得数据
                    String bizTaskId = node.getBizId();//业务节点id,和oaStepId对应
                    if (nodeData.get(bizTaskId) != null && nodeData.get(bizTaskId).size() > 0) {

                        for(Map<String,Object> nodeItem : nodeData.get(bizTaskId)){
                            // 验证一个步骤中的 多个数据
                            node.validate(nodeItem);

                            audit.powerWorkFlowNodeAudit(node.getNodeDataMap());

                            audit.powerWorkFlowNodeDataAudit(node.getNodeDataMap());
                        }

                    } else {

                        //TODO 监控的节点没有找到!(漏点)

                    }
                });
            }
        };
    }

    /**
     * 获取当前业务流ID的所有task
     *
     * @param fId
     * @return
     */

    protected abstract Node getTasksByFlowId(String fId);


    @Override
    public List<Instance> allInstance() {

        return this.instanceList;
    }

    /**
     * 获取所有实例
     *
     * @return
     */
    @Override
    public Map<String, Instance> loadAllInstance() {
        return instanceMap;
    }

    @Override
    public void execute() {

        this.instanceMap.forEach((s, instance) -> instanceConsumer.accept(instance));

        // 保存统计结果
        audit.save();

        analysisObject.stop();
    }


    @Override
    public void executeOne(String instanceId) {

        instanceConsumer.accept(this.instanceMap.get(instanceId));

    }

}

