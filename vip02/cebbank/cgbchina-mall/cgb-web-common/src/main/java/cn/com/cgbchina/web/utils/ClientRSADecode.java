/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.web.utils;

import java.io.IOException;
import java.math.BigInteger;

import lombok.extern.slf4j.Slf4j;

/**
 * @author wusy
 * @version 1.0
 * @Since 16-6-16.
 */
@Slf4j
public class ClientRSADecode {
	// 私钥指数
	private String e;
	// 公共模
	private String n;

	public ClientRSADecode() {
		if (e == null || "".equals(e)) {
			e = ConfigProperties.getProperties("clientInfoPrivateKey").toString();
		}
		if (n == null || "".equals(n)) {
			n = ConfigProperties.getProperties("clientInfoPublicKey").toString();
		}
	}

	/**
	 * 获得明文IP
	 * 
	 * @param cryptographIP 密文IP
	 * @return 明文IP
	 */
	public String getProclaimedIP(String cryptographIP) {
		return getProclaimedInfo(cryptographIP);
	}

	/**
	 * 获得明文MAC
	 * 
	 * @param cryptographMAC 密文MAC
	 * @return 明文MAC
	 */
	public String getProclaimedMAC(String cryptographMAC) {
		log.info("cryptographMAC:" + cryptographMAC);
		String clientMacAdress = "";
		try {
			if ("".equals(cryptographMAC) || cryptographMAC == null) {
				return "";
			}
			String allClientMacAdress = getProclaimedInfo(cryptographMAC);
			if ("".equals(allClientMacAdress) || allClientMacAdress == null) {
				return "";
			}
			log.info("allClientMacAdress:" + allClientMacAdress);
			int beginLen = allClientMacAdress.indexOf("||");
			int endLen = allClientMacAdress.indexOf(";");
			log.info("beginLen:" + beginLen);
			log.info("endLen:" + endLen);
			if (beginLen == -1) {
				beginLen = 0;
			} else {
				beginLen = beginLen + 2;
			}
			if (endLen == -1) {
				endLen = allClientMacAdress.length();
			}
			log.info("beginLen1:" + beginLen);
			log.info("endLen1:" + endLen);
			clientMacAdress = allClientMacAdress.substring(beginLen, endLen);
			if (clientMacAdress.length() > 32) {
				log.info("clientMacAdress:" + clientMacAdress);
				log.info("clientMacAdress.length():" + clientMacAdress.length());
				clientMacAdress = clientMacAdress.substring(0, 32);
			}
			log.info("clientMacAdress:" + clientMacAdress);
		} catch (Exception e) {
			log.error("Exception", e);
		}
		return clientMacAdress;
	}

	/**
	 * 获取明文信息
	 * 
	 * @param cryptograph 密文
	 * @return 明文
	 */
	private String getProclaimedInfo(String cryptograph) {
		log.info("cryptograph:" + cryptograph);
		try {
			BigInteger E = new BigInteger(e, 16);
			BigInteger N = new BigInteger(n, 16);
			BigInteger ineger = new BigInteger(cryptograph, 16);
			return getClientInfo(ineger, E, N);
		} catch (Exception e) {
			log.error("Exception", e);
			return "";
		}
	}

	/**
	 * 解密客户机信息
	 *
	 * @param C 密文大整型
	 * @param E 私有指数大整型
	 * @param N 公共模大整型
	 * @return
	 */
	private String getClientInfo(BigInteger C, BigInteger E, BigInteger N) {
		String p = dencodeRSA(C, E, N).toString(16);
		while (p.length() < 256) {
			p = "0" + p;
		}
		String s16 = p.substring(4);
		String x16 = p.substring(0, 4);
		int infoLength = Integer.parseInt(x16.substring(2, 4), 16);
		String clientInfo = "";
		for (int i = 0; i < infoLength; i++) {
			clientInfo += (char) Integer.parseInt(s16.substring(i * 2, (i + 1) * 2), 16);
		}
		return clientInfo;
	}

	/**
	 * RSA解密
	 *
	 * @param C 密文大整型
	 * @param E 私有指数大整型
	 * @param N 公共模大整型
	 * @return
	 */
	private BigInteger dencodeRSA(BigInteger C, BigInteger E, BigInteger N) {
		return C.modPow(E, N);
	}

	/**
	 * @param args
	 * @throws IOException
	 */
	public static void main(String[] args) throws IOException {
		String cryptograph = "35F70C2808212D3BE3087D7605282B41B62759FF0E7C1DA587628C0ADDE002B53B86D933D52C488052D2845627F9D3395B511DE665F976414C62F1DA4B223756FE7A604A429EA92694E93555A15CAA61718C3B919034013BA16AC348C59B40D38167AD21661AAE70F7D12DB9CDDC918FF4D2DC18A8A2BAA1AB7EF285203250A1";
		// cryptograph
		// ="B916470B18C19DD79C9F65ABCE6F33620469458DC607B308CE29E7D8E8A2FE7FC879C1388E899BA53F873EF275F03E0369040E55234F661DA5D7F999F1EBECDA069E5817B19CD11B48DB51D8C2D99F84974C692C3560E43F02FE81777A82FCA6CD61C72815A2917B2E9ABC745006951040C0F8CC1E7449558A7EBBE4A4BFEA65";
		// cryptograph="";
		ClientRSADecode clientRSADecode = new ClientRSADecode();
		System.out.println(clientRSADecode.getProclaimedMAC(cryptograph));
	}

}
