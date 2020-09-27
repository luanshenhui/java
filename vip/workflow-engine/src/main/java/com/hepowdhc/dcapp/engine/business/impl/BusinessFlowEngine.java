//package com.hepowdhc.dcapp.engine.business.impl;
//
//import com.hepowdhc.dcapp.dao.ExtractDataDao;
//import com.hepowdhc.dcapp.engine.Node;
//import com.hepowdhc.dcapp.engine.business.AbsBusinessFlowEngine;
//import com.hepowdhc.dcapp.engine.instance.Instance;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import java.util.List;
//import java.util.Map;
//
///**
// * 业务流引擎
// */
//@Component
//public class BusinessFlowEngine extends AbsBusinessFlowEngine {
//
//    static {
//        System.out.println("************************************");
//        System.out.println("******数据引擎启动中....*************");
//        System.out.println("************************************");
//
//    }
//
//    @Autowired
//    private ExtractDataDao extractDataDao;
//
//    @Override
//    public List<Instance> loadAllInstanceByWorkFowId(String workFlowId) {
//        return null;
//    }
//
//
//    /**
//     * 获取一个实例
//     *
//     * @param instanceId
//     */
//    @Override
//    public Instance getInstanceById(String instanceId) {
//        return null;
//    }
//
//    /**
//     * 获取所有实例
//     *
//     * @param dataId
//     */
//    @Override
//    public void getInstanceByDataId(String dataId) {
//
//    }
//
//    @Override
//    public void createInstanceByWorkflowId(String workflowId, String dataId) {
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
//    @Override
//    protected List<Map<String, Object>> getWorkDataByName(String name) {
//        return null;
//    }
//
//    /**
//     * 获取当前业务流ID的所有task
//     *
//     * @return
//     */
//    @Override
//    protected Node getTasksByFlowId(String fId) {
//        return null;
//    }
//
//
//}
