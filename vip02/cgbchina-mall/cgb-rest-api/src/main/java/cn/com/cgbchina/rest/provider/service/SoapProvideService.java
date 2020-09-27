package cn.com.cgbchina.rest.provider.service;

import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.CommonProcess;

/**
 * Comment: Created by 11150321050126 on 2016/4/22.
 */
public interface SoapProvideService<Req, Resp> extends CommonProcess<Req, Resp> {
	public Resp process(SoapModel<Req> model, Req content);
}
