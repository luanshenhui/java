package cn.com.cgbchina.rest.provider.service;

import cn.com.cgbchina.rest.common.process.CommonProcess;
import cn.com.cgbchina.rest.common.model.SoapModel;

/**
 * Comment:XML对象的包装类 Created by Lizy on 2016/4/22.
 */
public interface XMLProvideService<Req, Resp> extends CommonProcess<Req, Resp> {
	public Resp process(Req model);
}
