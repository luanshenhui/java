package com.hepowdhc.dcapp.engine.audit;

import com.hepowdhc.dcapp.engine.Audit;
import com.hepowdhc.dcapp.engine.instance.Instance;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

/**
 * Created by fzxs on 16-12-24.
 */
public abstract class AbsAudit implements Audit {

    protected final Logger logger = LoggerFactory.getLogger(getClass());

    /**
     * 权力 工作流 审计
     *
     * @param instance
     */
    @Override
    public void powerWorkFlowAudit(Instance instance) {

    }

    /**
     * 权力 工作流 节点  审计
     *
     * @param mapData
     */
    @Override
    public void powerWorkFlowNodeAudit(Map<String, Object> mapData) {

    }

    @Override
    public void save() {

    }

    /**
     * 权力 工作流 节点数据 审计
     *
     * @param mapData
     */
    @Override
    public void powerWorkFlowNodeDataAudit(Map<String, Object> mapData) {

    }
}
