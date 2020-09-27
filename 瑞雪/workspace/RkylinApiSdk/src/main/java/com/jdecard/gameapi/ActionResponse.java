package com.jdecard.gameapi;


public class ActionResponse {
	//响应结果中的head
		private String retCode ;
		//响应结果中的body
		private String retMessage ;	
		
		private String result;

		public String getRetCode() {
			return retCode;
		}

		public void setRetCode(String retCode) {
			this.retCode = retCode;
		}

		public String getRetMessage() {
			
			String msg= retMessage;
			switch(retCode)
			{
			case "101": 
				msg=  "订单不存在 ";break;
			case "102": 
				msg=  "订单号不允许重复 ";break;
			case "103": 
				msg=  "该游戏区服不存在或者区服已暂停 ";break;
			case "104": 
				msg=  "传入的参数有误 ";break;
			case "105": 
				msg=  "IP地址不符合要求  ";break;
			case "106": 
				msg=  "验证摘要串验证失败";break;
			case "107": 
				msg=  "没有对应商品 ";break;
			case "108": 
				msg=  "数据库繁忙，请稍后重试";break;
			case "109": 
				msg=  "本商品不可销售";break;
			case "110": 
				msg=  "库存不足";break;
			case "111": 
				msg=  "商品价钱不一致";break;
			case "112": 
				msg=  " 账户余额不足";break;
			case "113": 
				msg=  "角色或账号不存在";break;
			case "114": 
				msg=  "角色或账号验证失败";break;
			case "115": 
				msg=  "游戏品牌不存在";break;
			case "999": 
				msg= "系统错误";break;
			}

			return msg;
		}

		public void setRetMessage(String retMessage) {
			this.retMessage = retMessage;
		}

		public String getResult() {
			return result;
		}

		public void setResult(String result) {
			this.result = result;
		}
}
