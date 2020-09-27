package com.hepowdhc.dcapp.engine.node;

import com.hepowdhc.dcapp.dao.ExtractDataDao;
import com.hepowdhc.dcapp.engine.AnalysisObject;
import com.hepowdhc.dcapp.engine.Node;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by fzxs on 16-11-26.
 */
public abstract class AbsNode implements Node {


    private final Map<String, Node> nodes = new HashMap<>();


    protected final Logger logger = LoggerFactory.getLogger(getClass());


    protected String nodeName;

    protected String nodeId;

    protected Map<String, Object> nodeDataMap;

//    protected AnalysisObject ao;

    protected AbsNode(String nodeId) {
        this();
        this.nodeId = nodeId;

    }

    protected AbsNode() {
        init();
    }

    protected abstract void init();

    @Override
    public boolean hasMoreElements() {
        return false;
    }

    @Override
    public List<Map<String,Object>> prevElement() {
        return new ArrayList<>();
    }

    @Override
    public List<Map<String,Object>> nextElement() {

        return new ArrayList<>();
    }


    @Override
    public String getNodeName() {
        return nodeName;
    }


    @Override
    public String getNodeId() {
        return nodeId;
    }

    @Override
    public Map<String, Object> getNodeInfo() {
        return null;
    }

    public Map<String, Object> getNodeDataMap(){
        return nodeDataMap;
    };

    protected abstract AnalysisObject getAnalysisObject();


    protected abstract ExtractDataDao getExtractDataDao();


}
