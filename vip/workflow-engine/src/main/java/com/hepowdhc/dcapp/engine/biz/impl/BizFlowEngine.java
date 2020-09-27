package com.hepowdhc.dcapp.engine.biz.impl;

import com.hepowdhc.dcapp.engine.Node;
import com.hepowdhc.dcapp.engine.biz.AbsBizFlowEngine;
import com.hepowdhc.dcapp.engine.instance.Instance;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 业务流引擎
 */
@Component("BizFlowEngine")
public class BizFlowEngine extends AbsBizFlowEngine implements Serializable {


    static {
        System.out.println("************************************");
        System.out.println("******数据引擎启动中....*************");
        System.out.println("************************************");

    }



    /**
     * 获取所有实例
     *
     * @param dataId
     */
    @Override
    public void getInstanceByDataId(String dataId) {

    }

    @Override
    public void createInstanceByWorkflowId(String workflowId, String dataId) {

    }


    /**
     * 通过工作流名称 获取该工作流所有数据
     *
     * @param name
     * @return
     */
    @Override
    protected List<Map<String, Object>> getWorkDataByName(String name) {
        return null;
    }

    /**
     * 获取当前业务流ID的所有task
     *
     * @return
     */
    @Override
    protected Node getTasksByFlowId(String fId) {
        return null;
    }

    /**
     * 获取所有的工作流
     *
     * @return
     */
    @Override
    protected List<Map<String, Object>> loadAllWorkFlow() {
        return extractDataDao.findAllWorkFlow();
    }


}
