//package com.hepowdhc.dcapp.engine.business.impl;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.hepowdhc.dcapp.engine.FlowEngine;
//import com.hepowdhc.dcapp.engine.Node;
//import com.hepowdhc.dcapp.engine.node.TaskNode;
//import com.hepowdhc.dcapp.engine.instance.Instance;
//import org.apache.commons.lang3.StringUtils;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
//import javax.annotation.PostConstruct;
//import java.io.*;
//import java.nio.charset.Charset;
//import java.nio.file.Files;
//import java.nio.file.Path;
//import java.nio.file.Paths;
//import java.util.*;
//import java.util.function.Consumer;
//
///**
// * 业务流引擎
// */
//public abstract class AbsBusinessFlowEngine1 implements FlowEngine {
//
//
//
//    protected final Logger logger = LoggerFactory.getLogger(getClass());
//
//    private static FlowEngine instance;
//
//    private static  Map<String, Instance> instanceMap = new HashMap<>();
//
//    private static Map<String, Workflow> workflowMap = new HashMap<WorkFlow>();
//
//    Map<String, String> userRoleMap;
//
//    final private Consumer<Instance> instanceConsumer = ins -> {
//
//        ins.getNodes().forEach((id, node) -> {
//
//            node.validate();
//        });
//
//    };
//    public static FlowEngine getInstance()
//    {
//        if(instance == null) instance = new AbsBusinessFlowEngine1();
//      return instance;
//    }
//
//    /**
//     * 初始化
//     */
//    @Override
//    @PostConstruct
//    public void initlialize() throws Exception {
//
//        //step1 : 初始化所有工作流
//
//        this.loadAllWorkflow();
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
//            private final Map<String, Map<String, String>> flowNodes = (Map<String, Map<String, String>>) flowContent.get("nodes");
//
//            private final Map<String, Map<String, String>> flowLines = (Map<String, Map<String, String>>) flowContent.get("lines");
//
//            @Override
//            public void addNodeData(Map<String, Object> data) {
//
//                final String nodeId = (String) data.get("dcaTaskId");
//
//                final Optional<Node> nodeOptional = Optional.ofNullable(nodes.get(nodeId));
//
//                final Node node = nodeOptional.orElse(new TaskNode() {
//
//                    private final Map<String, String> flowNodeMap = flowNodes.get(nodeId);
//
//                    @Override
//                    public String getNodeName() {
//
//                        return flowNodeMap.get("name");
//                    }
//
//                    @Override
//                    public NodeType getNodeType() {
//
//                        return NodeType.nodeType(flowNodeMap.get("type"));
//                    }
//
//                    @Override
//                    public String getNodeId() {
//
//                        return nodeId;
//                    }
//
//                    @Override
//                    public Map<String, String> getNodeInfo() {
//
//                        return flowNodeMap;
//                    }
//
//                    @Override
//                    public void addNodeRuleData(Map<String, Object> nodeData) {
//
//                        ruleTypeMap.put(RuleType.ruleType(String.valueOf(nodeData.get("dcaAlarmType"))), nodeData);
//
//                    }
//
//                    @Override
//                    public Map<String, String> getUserRole() {
//
//                        return userRoleMap;
//                    }
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
//    /**
//     * 加载业务流程数据
//     *
//     * @param url
//     * @param path
//     * @return
//     * @throws Exception
//     */
//    public Map<String, Object> readJsonData(String url, String... path) throws Exception {
//
//        if (StringUtils.isEmpty(url)) {
//            return Collections.emptyMap();
//        }
//
//        return readJsonData(Paths.get(url, path));
//    }
//
//    /**
//     * 加载业务流程数据
//     *
//     * @param reader
//     * @return
//     * @throws IOException
//     */
//    public Map<String, Object> readJsonData(Reader reader) throws IOException {
//
//        if (reader == null) {
//            return Collections.emptyMap();
//        }
//
//        ObjectMapper mapper = new ObjectMapper();
//        HashMap<String, Object> value = mapper.readValue(reader, HashMap.class);
//
//        readJsonData(value);
//
//        return value;
//    }
//
//    /**
//     * 加载业务流程数据
//     *
//     * @param str
//     * @return
//     * @throws IOException
//     */
//    public Map<String, Object> readJsonData(String str) {
//
//        if (StringUtils.isEmpty(str)) {
//            return Collections.emptyMap();
//        }
//
//        ObjectMapper mapper = new ObjectMapper();
//        try {
//            HashMap<String, Object> value = mapper.readValue(new StringReader(str), HashMap.class);
//
//            return value;
//        } catch (IOException e) {
//            e.printStackTrace();
//            return Collections.emptyMap();
//        }
//
////        readJsonData(value);
//
//
//    }
//
//    /**
//     * 加载业务流程数据
//     *
//     * @param path
//     * @return
//     * @throws Exception
//     */
//    public Map<String, Object> readJsonData(Path path) throws Exception {
//
//        if (path == null) {
//            return Collections.emptyMap();
//        }
//
//
//        BufferedReader reader = Files.newBufferedReader(path, Charset.forName("UTF8"));
//
//        return readJsonData(reader);
//
//    }
//
//    /**
//     * 加载业务流程数据
//     *
//     * @param file
//     * @return
//     * @throws IOException
//     */
//    protected Map<String, Object> readJsonData(File file) throws IOException {
//
//        if (file == null) {
//
//            return Collections.emptyMap();
//        }
//
//        FileInputStream inputStream = new FileInputStream(file);
//
//        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
//
//        return readJsonData(reader);
//    }
//
//    /**
//     * 抽取数据中所有的业务流程图数据
//     * <p>
//     * DCA_WORKFLOW
//     *
//     * @return
//     */
//    protected abstract List<Map<String, Object>> loadALLBusinessData() throws Exception;
//
//    /**
//     * 通过工作流名称 获取该工作流所有数据
//     *
//     * @param name
//     * @return
//     */
//    protected abstract List<Map<String, Object>> getWorkDataByName(String name);
//
//    /**
//     * 获取用户岗位
//     *
//     * @return
//     */
//    protected abstract Map<String, String> getUserRole();
//
//    /**
//     * 数据加载
//     */
//    public void readJsonData(Map<String, Object> data) {
//
////        this.data = data;
//
//    }
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
//    public Map<String, Workflow> loadAllWorkflow() {
//
//        Map<String, Workflow> workflows = new HashMap<String, Workflow>();
//
//        //todo:
//
//        this.workflowMap.putAll(workflows);
//
//        return workflowMap;
//
//    }
//
//    @Override
//    public void execute() {
//
//        //this.instanceMap.forEach((s, instance) -> instanceConsumer.accept(instance));
//        List<Map> allBData = this.loadALLBusinessData();
//
//
//        Iterator<Map> its = allBData.iterator();
//        while(its.hasNext())
//        {
//            Map dataMap = its.next();
//
//            String dataId = dataMap.get("dataId");
//            String  workflowId = dataMap.get("workflowId");
//
//            //Instance tmpInstance = this.getInstanceByDataId(dataId);
//
//            Instance tmpInstance = this.instanceMap.get("dataId");
//
//            if(tmpInstance == null) tmpInstance = this.createInstanceByWorkflowId(workflowId, dataId);
//
//            tmpInstance.execute();
//
//
//
//        }
//
//
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
//
