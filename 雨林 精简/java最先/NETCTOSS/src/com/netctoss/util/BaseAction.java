package com.netctoss.util;

import java.util.Map;

import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.SessionAware;

public class BaseAction implements SessionAware,RequestAware{
	protected Map<String, Object> session;
	protected Map<String,Object> request;
	public void setSession(Map<String, Object> session) {
		this.session=session;
	}
	public void setRequest(Map<String, Object> request) {
		this.request=request;
	}

}
