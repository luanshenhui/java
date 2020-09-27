package com.hepowdhc.dcapp.engine.instance;

import com.hepowdhc.dcapp.engine.Node;
import com.hepowdhc.dcapp.engine.WorkFlow;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by fzxs on 16-12-12.
 */
public interface Instance {

    /**
     * 获取实例ID
     *
     * @return
     */
    String getInstanceId();


    /**
     * 获取dca工作流ID
     *
     * @return
     */
    String getFlowId();

    /**
     * 获取实例名称
     *
     * @return
     */
    String getInstanceName();

    String getPowerId();


    default Date getStartTime() {

        return new Date();
    }

    ;


    Map<String, Node> getNodes();

    @Deprecated
    default void addNodeData(Map<String, Object> nodeData) {
    }


    /**
     * 如果有实例,将实例数据与工作流绑定
     *
     * @param dataMap
     * @param workFlow
     */
    default void build(Map<String, Object> dataMap, WorkFlow workFlow) {

    }

    default void build(Map<String, Object> dataMap, String workFlowId) {

//        build(dataMap,getWorkFlow().get());
    }

    default void build(Map<String, Object> dataMap) {

    }

    default void build() {

    }

    default void build(List<Map<String, Object>> nodes) {

        nodes.forEach(map -> build());

    }

    default int markDone() {

        return 0;
    }

    default void execute() {
    }

    List<String> getOaDataIdList();

}
