package cn.com.cgbchina.trade.vo;
public abstract class OutSysEnvelopeVo implements OutSysEnvelope{
	String msgtype = "";//消息类型


	String version = "";//版本

	String shopid = "";//商家ID

	String timestamp = "";//时间戳

	String sign = "";//数字签名





	public String getMsgtype() {
		return msgtype;
	}

	public void setMsgtype(String msgtype) {
		this.msgtype = msgtype;
	}

	public String getShopid() {
		return shopid;
	}

	public void setShopid(String shopid) {
		this.shopid = shopid;
	}

	public String getSign() {
		return sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}






}
