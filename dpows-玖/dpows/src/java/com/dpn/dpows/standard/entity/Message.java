package com.dpn.dpows.standard.entity;

import java.util.Map;

public class Message {
	private String data;
	private String msg;//失败时带消息
	private boolean success;//{true,false}
	private Map<String, Object> map; 
	
	
	public Message(boolean success,String msg,String data) {
		this.success = success;
		this.msg = msg;
		this.data = data;
	}

	
	public Message(String data, String msg) {
		this.data = data;
		this.msg = msg;
	}
	public Message(Map<String,Object>map) {
		this.map = map;
		this.success = (Boolean) map.get("success");
		this.msg = map.get("msg").toString();
		this.data = map.get("data").toString();
	}

	public Map<String, Object> getMap() {
		return map;
	}

	public void setMap(Map<String, Object> map) {
		this.map = map;
	}

	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}
}
