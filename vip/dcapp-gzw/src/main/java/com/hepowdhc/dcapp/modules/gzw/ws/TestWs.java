package com.hepowdhc.dcapp.modules.gzw.ws;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import javax.xml.ws.BindingType;
import java.util.HashMap;

/**
 * Created by fzxs on 17-1-12.
 */
@WebService(
        targetNamespace="http:/ws.dhc.com.cn/",//指定 wsdl的命名空间
        name="WeatherInterface",//指定portType的名称
        portName="WeatherInterfacePort",//指定port的名称
        serviceName="WeatherService"//服务视图的名称
)
@BindingType(javax.xml.ws.soap.SOAPBinding.SOAP12HTTP_BINDING)
public interface TestWs {

    @WebMethod
    String test(@WebParam HashMap<String, Object> params);
}
