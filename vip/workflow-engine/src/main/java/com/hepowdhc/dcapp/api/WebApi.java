package com.hepowdhc.dcapp.api;

import com.hepowdhc.dcapp.engine.biz.impl.BizFlowEngine;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by fzxs on 16-12-22.
 */
@RestController
@RequestMapping("/api")
public class WebApi {

    @Autowired
    private BizFlowEngine engine;

    @RequestMapping("")
    public String index() {

        return "<H1>你好,这个是数据引擎!</H1>";
    }

    @RequestMapping("/reload")
    public String reload() {
        engine.flushBaseData();
        return "<H1>基础数据已经刷新!</H1>";
    }

}
