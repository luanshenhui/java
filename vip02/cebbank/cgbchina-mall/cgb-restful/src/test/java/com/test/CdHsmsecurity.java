package com.test;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;

import cn.com.cgbchina.restful.testEntity.CdHsmsecurityImp;
import cn.com.cgbchina.restful.testEntity.EEA1XML;

/**
 * 
 * @author liyifeng
 * 
 */
public class CdHsmsecurity {
	private String ip;
	private int port;
	private Socket s;
	private int timeOut;

	private DataInputStream dis;

	private DataOutputStream dos;

	public CdHsmsecurity(String ip, int port) {
		this.ip = ip;
		this.port = port;
	}

	public void setTimeOut(int timeOut) {
		this.timeOut = timeOut;
	}

	public boolean connect() {
		try {
			s = new Socket(ip, port);
			dis = new DataInputStream(s.getInputStream());
			dos = new DataOutputStream(s.getOutputStream());
			s.setSoTimeout(timeOut);
			s.setSoLinger(true, 0);
			s.setTcpNoDelay(true);
		} catch (IOException _ex) {
			return false;
		}
		return true;
	}

	public void close() {
		try {
			dos.close();
			dis.close();
			s.close();
			return;
		} catch (IOException _ex) {
			System.out.println("socket close error");
		}
	}

	/**
	 * 将des密文发去安全子系统转化为pvk密文的方法{方法功能中文描述}
	 * 
	 * @param des
	 * @return
	 * @author: lwf
	 * @throws Exception
	 */
	public String transDesToPvk(CdHsmsecurityImp ahi) throws Exception {
		if (!connect())
			return null;

		try {
			// 发送报文
			dos.write(ahi.getRequestXml());
			dos.flush();
		} catch (Exception _ex) {
			System.out.println("write socket error");

		}
		try {
			// 接收报文
			byte[] b = new byte[65535];
			dis.read(b);
			ahi.getResponseXml(b);
		} catch (Exception ex) {
			throw new RuntimeException(ex);
		}
		close();
		return "s1";
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// amHsmsecurity amHsmsecurity = new amHsmsecurity("10.2.21.59", 8805);
		CdHsmsecurity amHsmsecurity = new CdHsmsecurity("10.2.37.244", 8805);
		// amHsmsecurity amHsmsecurity = new amHsmsecurity("10.2.101.51", 8103);
		// amHsmsecurity amHsmsecurity = new amHsmsecurity("10.2.37.243", 8103);
		try {
			// E142XML e142 = new E142XML();
			// e142.setClientIPAddr("10.2.218.37");
			// e142.setPinBlock("FC527B0DA58D3136");
			// e142.setMode("4");
			// e142.setAccNo1("0000000000000");
			// e142.setAccNo2("0000000000000");
			// e142.setKeyName1("H2.IOMM000000000.ZPK");
			// e142.setKeyName2("NS.IBZPKPPVK0000.PVK");
			// e142.setFormat1("01");
			// e142.setFormat2("01");

			// amHsmsecurity.transDesToPvk(e142);
			// 得到转密后的密文
			/*
			 * String pwd = e142.getPinOffset();
			 * 
			 * EEA2XML eea2 = new EEA2XML(); eea2.setClientIPAddr("10.2.21.147"); eea2.setPinBlock(
			 * "B817E4D87A0EC524751B3F67BB076CC9B9089C960579E4E22A591DA5FEF322B0993001886D4E030DBB8734C15872F8C55F57A2D44D078BD5CAB64241449497A71F6A5BA35FFE69F63CFF5D06691E99B90A792ED4079E7BF9F56E9EE9B616C663C11D6E58A80029CA4F7EEA54D01FB017729E98FF8A9FC1D293657C482DDC0A11B0E5A7B797067354695F52E2A24FB8AE6FCC9A92FCE646EE9BBF23FCF22C52EA983FECE70053838CF6F5CFDE3A8C816819D7454D09DCE83A56C3463BFC36E816E0DD3F538EA38310458EE4DEF581BC0CB2D872ACA8106485BD7E9A2AA9637D61D07D5738D4D155705A107FC103C8D7760C40CBACB7FBC53212EBFE455A78CBFE"
			 * ); eea2.setRsaName("NS.RSA2048INDEXO.RSA"); eea2.setPan("1410078900000010");
			 * eea2.setZpk("H2.IOMM000000000.ZPK"); eea2.setRandom("123456"); amHsmsecurity.transDesToPvk(eea2); String
			 * pwd = eea2.getResponsePinBlock();
			 */
			EEA1XML eea1 = new EEA1XML();
			eea1.setClientIPAddr("22.96.59.150");
			eea1.setPinBlock(
					"6AD70D58CE1C09CD98AF51D0612CC30B12CE561973B9EBE278CB248E12DE14267F773225E511CE1CBDCFFD4C83C40A63CB4003D3EA14935699F19676F05FB54B8049A7A94BA060BD976C67FCAAFE4D6750C20871D216EE9147CAAC27939469E97A4B2B4764FDA5A3AD800E2CD7772C0DA0D941DF01AA484B2DF5191AC02A82CC318DA7351207C38C656201B957052240EE46D173D88EC5B716969C4536017CF873FE0EC3684F6C7E124595602C61E99E70D9843047426508D5A05E980B6D984605274F6F0084A37D62F79CC12EEAD8479E3850AFEDD2F57DA99217A0A4A1196E98D7852EC957C7F60CF022FD5C9CF7E4227F3E23A35E397A38989E6092267183");
			eea1.setRsaName("NS.RSA2048INDEX0.RSA");
			eea1.setZak("NS.EPin000000000.ZAK");
			eea1.setRandom("");
			amHsmsecurity.transDesToPvk(eea1);
			// 得到转密后的密文
			String pwd = eea1.getResponsePinBlock();
			System.out.println(pwd);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
