package com.hepowdhc.dcapp.engine;

import com.hepowdhc.dcapp.engine.instance.Instance;

import java.util.Map;

/**
 * Created by fzxs on 16-12-24.
 */
public interface Audit {


    /**
     * 权力 工作流 审计
     *
     * @param instance
     */
    void powerWorkFlowAudit(Instance instance);


    /**
     * 权力 工作流 节点  审计
     *
     * @param mapData
     */
    void powerWorkFlowNodeAudit(Map<String, Object> mapData);


    /**
     * 权力 工作流 节点数据 审计
     *
     * @param mapData
     */
    void powerWorkFlowNodeDataAudit(Map<String, Object> mapData);


    void save();
}
