//package com.hepowdhc.dcapp.engine.business;
//
//import com.dhc.analysis.AnalysisObject;
//import com.hepowdhc.dcapp.dao.ExtractDataDao;
//import com.hepowdhc.dcapp.engine.AbsSuperFlowEngine;
//import com.hepowdhc.dcapp.engine.FlowEngine;
//import com.hepowdhc.dcapp.engine.Node;
//import com.hepowdhc.dcapp.engine.instance.Instance;
//import com.hepowdhc.dcapp.engine.node.TaskNode;
//
//import java.util.*;
//import java.util.function.Consumer;
//
///**
// * 业务流引擎
// */
//@Deprecated
//public abstract class AbsBusinessFlowEngine extends AbsSuperFlowEngine {
//
//    private final Map<String, Instance> instanceMap = new HashMap<>();
//
//    private AnalysisObject analysisObject;
//
//    final private Consumer<Instance> instanceConsumer = ins -> {
//
//        ins.getNodes().forEach((id, node) -> {
//
//            node.validate(null);
//        });
//
//    };
//
//
//    /**
//     * 获取所有的工作流
//     *
//     * @return
//     */
//    @Override
//    protected List<Map<String, Object>> loadAllWorkFlow() {
//        return null;
//    }
//
//    /**
//     * 初始化
//     */
//    @Override
//    public FlowEngine initialization() throws Exception {
//
//        logger.debug("引擎初化中....");
//
//        analysisObject = new AnalysisObject();
//
//        final List<Map<String, Object>> fwList = loadALLBusinessData();
//
//        fwList.parallelStream()
//
//                .filter((map) -> {
//
//                    //筛选所有流程图name不为空的数据.
//
//                    return map.get("oaInstanceId") != null && map.get("dcaWfId") != null;
//
//                })
//
//                .forEach((map) -> createInstance(map));
//
//        logger.debug("引擎初始化完成!");
//
//        return this;
//
//    }
//
//    ;
//
//    private Instance createInstance(final Map<String, Object> nodeData) {
//
//        final String instanceId = String.valueOf(nodeData.get("oaInstanceId"));
//
//        logger.debug("实例ID=>" + instanceId);
//
//        final Optional<Instance> instanceOptional = Optional.ofNullable(instanceMap.get(instanceId));
//
//        final Instance instance = instanceOptional.orElse(new Instance() {
//
//            private final Map<String, Node> nodes = new HashMap();
//
//            private final Map<String, Object> flowContent = readJsonData(String.valueOf(nodeData.get("dcaXmlContent")));
//
//            private final Map<String, Map<String, Object>> flowNodes = (Map<String, Map<String, Object>>) flowContent.get("nodes");
//
//            private final Map<String, Map<String, Object>> flowLines = (Map<String, Map<String, Object>>) flowContent.get("lines");
//
//            @Override
//            public void addNodeData(Map<String, Object> data) {
//
//                final String nodeId = (String) data.get("dcaTaskId");
//
//                final Optional<Node> nodeOptional = Optional.ofNullable(nodes.get(nodeId));
//
//                final Node node = nodeOptional.orElse(new TaskNode(nodeId) {
//
//                    private final Map<String, Object> flowNodeMap = flowNodes.get(nodeId);
//
//                    @Override
//                    protected void init() {
//
//                    }
//
//                    @Override
//                    public String getNodeName() {
//
//                        return String.valueOf(flowNodeMap.get("name"));
//                    }
//
//                    @Override
//                    public NodeType getNodeType() {
//
//                        return NodeType.nodeType(String.valueOf(flowNodeMap.get("type")));
//                    }
//
//                    @Override
//                    public Map<String, Object> getNodeInfo() {
//
//                        return flowNodeMap;
//                    }
//
//                    @Override
//                    public void addNodeRuleData(Map<String, Object>... nodeDatas) {
//
//                        Arrays.stream(nodeDatas)
//
//                                .forEach(nodeData ->
//                                        ruleTypeMap.put(RuleType.ruleType(String.valueOf(nodeData.get("dcaAlarmType"))),
//                                                nodeData));
//                    }
//
////                     @Override
////                     public String getInstanceName() {
////                         return (String) dataMap.get("oaInstanceName");
////                     }
////
////                    @Override
////                    public Date getStartTime() {
////                        return (Date) dataMap.get("oaFlowStartTime");
////                    }
//
//                    @Override
//                    public Map<String, String> getUserRole() {
//
//                        return userRoleMap;
//                    }
//
//                    @Override
//                    protected AnalysisObject getAnalysisObject() {
//                        return analysisObject;
//                    }
//
//                    @Override
//                    protected ExtractDataDao getExtractDataDao() {
//                        return extractDataDao;
//                    }
//
//                });
//
//                if (!nodes.containsKey(nodeId)) {
//
//                    nodes.put(nodeId, node);
//                }
//
//                node.addNodeRuleData(data);
//
//
//            }
//
//            /**
//             * 实例中是否还有未 执行的节点.
//             *
//             * @return <code>true</code>有
//             * <code>false</code> otherwise.
//             */
//            @Override
//            public boolean hasMoreElements() {
//                return false;
//            }
//
//            /**
//             * 实例中的下一个节点
//             * @return the next element of this enumeration.
//             * @throws NoSuchElementException if no more elements exist.
//             */
//            @Override
//            public Node nextElement() {
//                return null;
//            }
//
//            /**
//             * 获取实例ID
//             *
//             * @return
//             */
//            @Override
//            public String getInstanceId() {
//                return instanceId;
//            }
//
//            /**
//             * 获取dca工作流ID
//             *
//             * @return
//             */
//            @Override
//            public String getFlowId() {
//                return String.valueOf(nodeData.get("dcaWfId"));
//            }
//
//            /**
//             * 获取实例名称
//             *
//             * @return
//             */
//            @Override
//            public String getInstanceName() {
//                return String.valueOf(nodeData.get("oaInstanceName"));
//            }
//
//            @Override
//            public Map<String, Node> getNodes() {
//                return nodes;
//            }
//
//            @Override
//            public String toString() {
//
//                return "ID:" + instanceId;
//            }
//        });
//
//        if (!instanceMap.containsKey(instanceId)) {
//
//            instanceMap.put(instanceId, instance);
//
//        }
//
//        instance.addNodeData(nodeData);
//
//
//        return instance;
//
//    }
//
//
//    /**
//     * 通过工作流名称 获取该工作流所有数据
//     *
//     * @param name
//     * @return
//     */
//    protected abstract List<Map<String, Object>> getWorkDataByName(String name);
//
//
//    /**
//     * 获取当前业务流ID的所有task
//     *
//     * @param fId
//     * @return
//     */
//
//    protected abstract Node getTasksByFlowId(String fId);
//
//    @Override
//    public Map<String, Instance> loadAllInstance() {
//
//        return this.instanceMap;
//    }
//
//    @Override
//    public void execute() {
//
//        this.instanceMap.forEach((s, instance) -> instanceConsumer.accept(instance));
//    }
//
//
//    @Override
//    public void executeOne(String instanceId) {
//
//
//        instanceConsumer.accept(this.instanceMap.get(instanceId));
//
//    }
//
//
//}
