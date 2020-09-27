package com.hepowdhc.dcapp.engine;

import com.hepowdhc.dcapp.utils.ObjectUtils;

import java.io.Serializable;
import java.util.Map;

/**
 * Created by fzxs on 16-12-23.
 */
public interface WorkFlow extends Serializable {


//    /**
//     * 添加map节点
//     *
//     * @param dataMap
//     */
//    void addNodeData(Map<String, Object> dataMap);

    /**
     * 获取FlowID
     *
     * @return
     */
    String getFlowId();

    String getPowerId();

    Map<String, Node> allNodes();


    default WorkFlow deepClone() {

        return ObjectUtils.deepClone(this);
    }


}
