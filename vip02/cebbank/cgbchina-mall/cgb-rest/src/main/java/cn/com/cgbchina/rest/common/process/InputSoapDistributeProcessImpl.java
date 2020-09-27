package cn.com.cgbchina.rest.common.process;

import cn.com.cgbchina.rest.common.utils.ScanTradeCode;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;

/**
 * Comment:
 * Created by 11150321050126 on 2016/4/28.
 */
public class InputSoapDistributeProcessImpl implements DistributeProcess<SoapProvideService> {
    @Override
    public SoapProvideService handler(String code) {
        SoapProvideService object= (SoapProvideService) ScanTradeCode.getBean(code);
        return object;
    }
}
