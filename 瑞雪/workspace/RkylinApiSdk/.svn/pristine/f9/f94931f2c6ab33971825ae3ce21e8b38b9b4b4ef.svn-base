package com.letv.common;

/**
 * 用于接收请求后返回响应结果的header类
 */
public class Responseheader {

	//返回信息
	private String msg;
	//返回结果 0成功，其它失败
	private String ret;
	//记录返回的未处理的报结果报文
	private String result;
	
	//跟据返回结果，转换其含义
	public String getMsg() {
		if(ret.equals("0"))
		{
			return "请求成功 ";	
		}
		else if (ret.equals("1"))
		{
			return "服务器错误 ";
		}
		else if (ret.equals("2"))
		{
			return "授权错误 ";
		}
		else if (ret.equals("3"))
		{
			return "请求参数错误 ";
		}
		else if (ret.equals("4"))
		{
			return "调用次数达到上线 ";
		}
		else if (ret.equals("5"))
		{
			return "签名错误";
		}
		else if (ret.equals("101"))
		{
			return "用户不存在";
		}
		else if (ret.equals("102"))
		{
			return "不支持的影视会员开通类型或开通时长";
		}
		else
		{
			return msg;
		}
	}

	public void setMsg(String msg) {
		this.msg = msg;
		
	}

	public String getRet() {
			return ret;
	}

	public void setRet(String ret) {
		this.ret = ret;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

}
