package com.hepowdhc.dcapp.engine;

import com.hepowdhc.dcapp.engine.instance.Instance;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 工作流引擎
 * <p>
 * 该工作流支持并行操作和串行操作
 * <p>
 * 当 {@link FlowEngine#executeMode()} 的模式为并行的时候,将不会保存所有的实例,故调用
 * <p>
 * {@link FlowEngine#loadAllInstance()}和 {@link FlowEngine#allInstance()} 不会返回任何数据,
 * <p>
 * 在并行的情况下 无需手动调用 {@link FlowEngine#execute()}或者 {@link FlowEngine#executeOne(String)};
 * <p>
 * 并行操作回每次会自动调用,如果不自动调用,将结果全部收集起来统一调用,并行就没有了意义;
 * <p>
 * <p>
 * <p>
 * Created by fzxs on 16-11-26.
 */
public interface FlowEngine {


    /**
     * 初始化
     */
    FlowEngine initialization() throws Exception;

    List<Instance> loadAllInstanceByWorkFowId(String workflowId);


    /**
     * 获取所有实例
     *
     * @return
     */
    default Map<String, Instance> loadAllInstance() {
        return new HashMap<>();
    }

    /**
     * 获取所有实例
     *
     * @return
     */
    default List<Instance> allInstance() {
        return new ArrayList<>();
    }


    /**
     * 获取一个实例
     */
    Instance getInstanceById(String instanceId);

    /**
     * 获取所有实例
     *
     * @param dataId OA系统中的实例ID
     */
    void getInstanceByDataId(String dataId);

    void createInstanceByWorkflowId(String workflowId, String dataId);

    void execute();

    void executeOne(String instanceId);

    /**
     * 引擎运行方式
     * 1:并行,充分利用CPU数,自动调用 execute
     * <p>
     * 2.串行,必须手动调用 execute;
     *
     * @return
     */
    default int executeMode() {

        return 1;

    }


}
