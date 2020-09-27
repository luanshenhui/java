package com.hepowdhc.dcapp.engine.rule;

import java.util.Map;

/**
 * Created by fzxs on 16-11-21.
 */
public interface RuleEngine {


//    default ScriptEngine createEngine() {
//
//        ScriptEngineManager scriptEngineManager = new ScriptEngineManager();
//
//        ScriptEngine nashorn = scriptEngineManager.getEngineByName(getEngineType().name());
//
//        return nashorn;
//
//    }
//
//
//    default NodeType getEngineType() {
//
//        return NodeType.nashorn;
//
//    }


    Object execute(String rule, Map<String,Object> params);

}
