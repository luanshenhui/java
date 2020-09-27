package com.hepowdhc.dcapp.modules.gzw.ws.impl;

import com.hepowdhc.dcapp.modules.gzw.ws.TestWs;
import org.springframework.stereotype.Component;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import java.util.HashMap;

/**
 * Created by fzxs on 17-1-12.
 */
@Component
public class TestWsImpl implements TestWs {

    @WebMethod
    public String test(@WebParam HashMap<String, Object> params) {
        return params.toString();

    }
}
