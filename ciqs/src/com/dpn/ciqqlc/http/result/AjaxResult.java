package com.dpn.ciqqlc.http.result;

import org.apache.poi.ss.formula.functions.T;

public class AjaxResult {
	
	AjaxResult(boolean success,String code,String message,Object data){
		this.success = success;
		this.code = code;
		this.message = message;
		this.data = data;
	}
	
	public static AjaxResult suc(String message){
		return new AjaxResult(true,null,message,null);
	}
	
	public static AjaxResult ok(Object data){
		return new AjaxResult(true,null,"操作成功",data);
	} 

	public static AjaxResult biz(String code,String message,Object data){
		return new AjaxResult(false,code,message,data);
	}
	
	public static AjaxResult error(String message){
		return new AjaxResult(false,null,message,null);
	} 
	
	//是否处理成功
	private boolean success;
	
	//错误码
	private String code;
	
	//提示信息
	private String message;
	
	//返回数据
	private Object data;

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}
}
