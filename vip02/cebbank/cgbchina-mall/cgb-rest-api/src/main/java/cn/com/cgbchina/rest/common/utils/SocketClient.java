package cn.com.cgbchina.rest.common.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConnectErrorException;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;

@Slf4j
public class SocketClient {
	public static String send(String xml, String ip, int port) {
		Socket socket = null;
		BufferedReader br = null;
		PrintWriter pw = null;
		StringBuilder sb = new StringBuilder();
		String res = null;
		try {
			// 客户端socket指定服务器的地址和端口号
			socket = new Socket(ip, port);

			// 同服务器原理一样
			br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			pw = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())));
			res = br.readLine();
			pw.println(xml);
			pw.flush();
			while (res != null) {
				sb.append(res);
				res = br.readLine();
			}

		} catch (Exception e) {
			throw new ConverErrorException("【通讯异常】ip:" + ip + " port:" + port + " " + xml);
		} finally {
			try {
				br.close();
				pw.close();
				socket.close();
			} catch (IOException e) {
				throw new ConverErrorException("【通讯异常】ip:" + ip + " port:" + port + " " + xml);
			}
		}
		return sb.toString();

	}

	public static List<String> sendNatp(byte[] sendData, String ip, int port) {
		try {
			List<String> result = new ArrayList<>();
			DataTransfer dataTransfer = new DataTransfer() {
				{
					this.setNatpVersion(16);
					this.setTradeCode("MSEND");
					this.setTemplateCode("300001");
					this.setReserve("SMSP");
				}
			};
			// ip = "21.96.165.85";
			Socket socket = new Socket(ip, port);
			dataTransfer.setOutputStream(socket.getOutputStream());
			dataTransfer.setInputStream(socket.getInputStream());
			dataTransfer.natpSendDatas(sendData);
			byte[] retData = dataTransfer.natpRecv();
			ByteArrayInputStream bin = new ByteArrayInputStream(retData);
			DataInputStream din = new DataInputStream(bin);
			while (din.available() > 0) {
				int nLen = din.readShort();
				byte[] byName = new byte[nLen];
				din.read(byName);
				String sName = new String(byName, Constant.CHARSET_GBK);
				nLen = din.readShort();
				byte[] byValue = new byte[nLen];
				din.read(byValue);
				String sValue = new String(byValue, Constant.CHARSET_GBK);
				String str = sName + ":" + sValue;
				result.add(str);
			}
			din.close();
			return result;
		} catch (Exception e) {
			throw new ConnectErrorException("【短信发送失败】:" + "ip->" + ip + ":" + port + "\n" + e.getMessage(), e);
		}
	}

	public static byte[] sendSocket(String xml, String ip, int port) {

		byte[] data = toHexString(xml);
		Socket socket = null;
		DataOutputStream dos = null;
		DataInputStream dis = null;
		try {
			log.info("发送EEA报文:\n" + xml);
			// 客户端socket指定服务器的地址和端口号
			socket = new Socket(ip, port);
			dos = new DataOutputStream(socket.getOutputStream());
			dis = new DataInputStream(socket.getInputStream());
			dos.write(data);
			dos.flush();
			// 接收报文
			byte[] b = new byte[65535];
			dis.read(b);
			return b;
		} catch (Exception e) {
			throw new ConverErrorException("【通讯异常】ip:" + ip + ":" + port + " " + xml, e);
		} finally {
			try {
				if (dis != null)
					dis.close();
				if (dos != null)
					dos.close();
				if (socket != null)
					socket.close();
			} catch (IOException e) {
				throw new ConverErrorException("【通讯异常】ip:" + ip + ":" + port + " " + xml, e);
			}
		}

	}

	public static void main(String[] args) {

		byte[] a = SocketClient.sendSocket(
				("<?xml version=\"1.0\" encoding=\"GBK\"?><union><head><serviceCode>EEA1</serviceCode><sysID>NIBS</sysID><appID>NS</appID><clientIPAddr>22.96.59.150</clientIPAddr><transTime></transTime><transFlag>1</transFlag><userInfo></userInfo><hash></hash></head><body><pinBlock>6AD70D58CE1C09CD98AF51D0612CC30B12CE561973B9EBE278CB248E12DE14267F773225E511CE1CBDCFFD4C83C40A63CB4003D3EA14935699F19676F05FB54B8049A7A94BA060BD976C67FCAAFE4D6750C20871D216EE9147CAAC27939469E97A4B2B4764FDA5A3AD800E2CD7772C0DA0D941DF01AA484B2DF5191AC02A82CC318DA7351207C38C656201B957052240EE46D173D88EC5B716969C4536017CF873FE0EC3684F6C7E124595602C61E99E70D9843047426508D5A05E980B6D984605274F6F0084A37D62F79CC12EEAD8479E3850AFEDD2F57DA99217A0A4A1196E98D7852EC957C7F60CF022FD5C9CF7E4227F3E23A35E397A38989E6092267183</pinBlock><rsaName>NS.RSA2048INDEX0.RSA</rsaName><zakName>NS.EPin000000000.ZAK</zakName><random></random></body></union>"),
				"10.2.37.244", 8805);
		try {
			String c = new String(a, "GBK");
			parseXml(c);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

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

	public static String parseXml(String xml) {
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
				}
			} else {
				throw new RuntimeException(responseCode + " " + responseRemark);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return xml;
	}
}
