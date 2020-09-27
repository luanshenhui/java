package com.hepowdhc.dcapp.engine.workflow;

import com.hepowdhc.dcapp.engine.WorkFlow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 工作流
 * Created by fzxs on 16-12-23.
 */
public abstract class AbsWorkFlow implements WorkFlow {

    protected final Map<String, List<Map<String, Object>>> nodesData;


    protected AbsWorkFlow(Map<String, List<Map<String, Object>>> flowData) {
        this.nodesData = flowData;
        init();
    }

//    protected AbsWorkFlow() {
//        nodesData = new HashMap();
//        init();
//    }


//    public String getFlowId() {
//        return (String) nodesData.get("dcaWfId");
//    }


    protected abstract void init();
}
