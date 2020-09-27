package cn.com.cgbchina.rest.provider.service;

import cn.com.cgbchina.rest.common.process.CommonProcess;
import cn.com.cgbchina.rest.common.model.SoapModel;

/**
 * Comment: Created by 11150321050126 on 2016/4/22.
 */
public interface ProvideService<Rep, Resp> extends CommonProcess<Rep, Resp> {
	public SoapModel<Resp> process(SoapModel<Rep> model, Rep content);
}
