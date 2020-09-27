package cn.com.cgbchina.restful.testEntity;

import java.util.Iterator;

import lombok.extern.slf4j.Slf4j;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

/**
 * <b>功能描述：</b><br>
 * 该功能为调用新加密平台的EEA1方法进行EPIN加密<br>
 * 
 * @version 1.01 2014-05-06
 * @author liuqiu
 */
@Slf4j
public class EEA1XML implements CdHsmsecurityImp {

	// ******* 报文头*************
	/**
	 * 系统ID
	 */
	private String sysID;
	/**
	 * 应用ID
	 */
	private String appID;
	/**
	 * 客户端IP地址
	 */
	private String clientIPAddr;
	private String transTime;
	private String transFlag;
	private String userInfo;

	// ******* 请求报文体*************
	/**
	 * PIN密文
	 */
	private String pinBlock;
	/**
	 * 私钥名
	 */
	private String rsaName;
	/**
	 * zak密钥名
	 */
	private String Zak;
	/**
	 * 随机数
	 */
	private String random;

	// ******* 响应报文体*************
	private String responseCode;
	private String responseRemark;

	private String responsePinBlock;

	/**
	 * 获取EEA1发送报文体
	 */
	public byte[] getRequestXml() {
		// EEA1请求报文结构
        String input = "<?xml version=\"1.0\" encoding=\"GBK\"?>"+
		"<union>"+
		"<head>"+
		"<serviceCode>EEA1</serviceCode>"+
		"<sysID>NIBS</sysID>"+
		"<appID>NS</appID>"+
		"<clientIPAddr>"+getClientIPAddr()+"</clientIPAddr>"+
		"<transTime></transTime>"+
		"<transFlag>1</transFlag>"+
		"<userInfo></userInfo>"+
		"<hash></hash>"+
		"</head>"+
		"<body>"+
		"<pinBlock>"+getPinBlock()+"</pinBlock>"+
		"<rsaName>"+getRsaName()+"</rsaName>"+
		"<zakName>"+getZak()+"</zakName>"+
		"<random>"+getRandom()+"</random>"+
		"</body>"+
		"</union>"; 
        String inputOut = "<?xml version=\"1.0\" encoding=\"GBK\"?>"+
		"<union>"+
		"<head>"+
		"<serviceCode>EEA1</serviceCode>"+
		"<sysID>NIBS</sysID>"+
		"<appID>NS</appID>"+
		"<clientIPAddr>"+getClientIPAddr()+"</clientIPAddr>"+
		"<transTime></transTime>"+
		"<transFlag>1</transFlag>"+
		"<userInfo></userInfo>"+
		"<hash></hash>"+
		"</head>"+
		"<body>"+
		"<pinBlock>******"+getPinBlock().substring(6,getPinBlock().length()-6)+"******</pinBlock>"+
		"<rsaName>"+getRsaName()+"</rsaName>"+
		"<zakName>"+getZak()+"</zakName>"+
		"<random>"+getRandom()+"</random>"+
		"</body>"+
		"</union>"; 
        //System.out.println("发送报文："+input);
        log.info( "EEA1发送报文："+input);
        
		return toHexString(input);
	}

	/**
	 * 只返回加密后的密文
	 * 
	 * @throws TranFailException
	 */
	public String getResponseXml(byte[] b) {
		// TODO Auto-generated method stub
		String str = "";
		try {
			str = new String(b, "GBK");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return parseXml(str);
	}

	/**
	 * 解析xml报文
	 * 
	 * @param xml
	 * @throws TranFailException
	 * @throws Exception 返回加密后的密文
	 */
	public String parseXml(String xml) {
		// 截取有效报文
		xml = xml.substring(xml.indexOf("<?xml"), xml.indexOf("</union>") + 8);
		// System.out.println("接收到报文："+xml);
		if (xml.indexOf("pinBlock") > -1) {
			log.info("接收到报文：" + xml.substring(0, xml.indexOf("pinBlock") + 9) + "******"
					+ xml.substring(xml.indexOf("pinBlock") + 9 + 6));
		} else {
			log.info("接收到报文：" + xml);
		}
		String responseCode = "";
		String responseRemark = "";
		String pinBlock = "";

		try {
			Document document = DocumentHelper.parseText(xml);
			Element root = document.getRootElement();
			// 获取head节点的数据 主要是异常码和异常信息
			Iterator head = root.elementIterator("head");
			while (head.hasNext()) {
				Element ele = (Element) head.next();
				responseCode = ele.elementTextTrim("responseCode");
				responseRemark = ele.elementTextTrim("responseRemark");
				// System.out.println(responseCode+"||"+responseRemark);
				log.info(responseCode + "||" + responseRemark);
			}
			// 返回码000000代表成功
			if ("000000".equals(responseCode)) {
				// 成功之后获取报文体的内容
				Iterator body = root.elementIterator("body");
				while (body.hasNext()) {
					Element ele = (Element) body.next();
					pinBlock = ele.elementTextTrim("pinBlock");

					setResponsePinBlock(pinBlock);
				}
			} else {
				// throw new TranFailException(responseCode, responseRemark);
				throw new RuntimeException(responseCode + " " + responseRemark);
			}

			setResponseCode(responseCode);
			setResponseRemark(responseRemark);

		} catch (Exception e) {
			// if(e instanceof TranFailException){
			// throw (TranFailException)e;
			// }
			e.printStackTrace();
		}

		return pinBlock;
	}

	/**
	 * 计算十六进制报文头长度
	 * 
	 * @param input
	 * @return
	 */
	public static byte[] toHexString(String input) {
		byte[] b1 = new byte[input.getBytes().length + 2];
		byte[] bxml = input.getBytes();
		b1[0] = (new Integer(input.length() / 256)).byteValue();
		b1[1] = (new Integer(input.length() % 256)).byteValue();
		for (int i = 0; i < bxml.length; i++) {
			b1[i + 2] = bxml[i];
		}
		return b1;
	}

	public String getSysID() {
		return sysID;
	}

	public void setSysID(String sysID) {
		this.sysID = sysID;
	}

	public String getAppID() {
		return appID;
	}

	public void setAppID(String appID) {
		this.appID = appID;
	}

	public String getClientIPAddr() {
		return clientIPAddr;
	}

	public void setClientIPAddr(String clientIPAddr) {
		this.clientIPAddr = clientIPAddr;
	}

	public String getTransTime() {
		return transTime;
	}

	public void setTransTime(String transTime) {
		this.transTime = transTime;
	}

	public String getTransFlag() {
		return transFlag;
	}

	public void setTransFlag(String transFlag) {
		this.transFlag = transFlag;
	}

	public String getUserInfo() {
		return userInfo;
	}

	public void setUserInfo(String userInfo) {
		this.userInfo = userInfo;
	}

	public String getPinBlock() {
		return pinBlock;
	}

	public void setPinBlock(String pinBlock) {
		this.pinBlock = pinBlock;
	}

	public String getRsaName() {
		return rsaName;
	}

	public void setRsaName(String rsaName) {
		this.rsaName = rsaName;
	}

	public String getZak() {
		return Zak;
	}

	public void setZak(String zak) {
		Zak = zak;
	}

	public String getRandom() {
		return random;
	}

	public void setRandom(String random) {
		this.random = random;
	}

	public String getResponsePinBlock() {
		return responsePinBlock;
	}

	public void setResponsePinBlock(String responsePinBlock) {
		this.responsePinBlock = responsePinBlock;
	}

	public String getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(String responseCode) {
		this.responseCode = responseCode;
	}

	public String getResponseRemark() {
		return responseRemark;
	}

	public void setResponseRemark(String responseRemark) {
		this.responseRemark = responseRemark;
	}
}
