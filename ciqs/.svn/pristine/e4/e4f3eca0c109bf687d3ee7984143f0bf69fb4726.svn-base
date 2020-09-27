package com.dpn.ciqqlc.common.util.ApInterface;

import java.io.UnsupportedEncodingException;

import org.springframework.stereotype.Service;

import com.dpn.ciqqlc.common.util.ApInterface.SentSmsService;

import javax.crypto.Cipher;

import com.dpn.ciqqlc.common.util.ApInterface.ApInterfaceService;
import com.dpn.ciqqlc.common.util.ApInterface.ApInterfaceServiceLocator;
import com.dpn.ciqqlc.common.util.ApInterface.ApInterface_PortType;

@Service
public class SentSmsServiceImpl implements SentSmsService {
	private byte[] defaultIV = { 49, 50, 51, 52, 53, 54, 55, 56 };
	private String DES_ALGORITHM = "DESede/CBC/PKCS5Padding";

	@Override
	public String SentSMS(String mobilephone, String content) throws Exception {
		// TODO Auto-generated method stub
			ApInterfaceService service = new ApInterfaceServiceLocator();
			ApInterface_PortType client = service.getApInterface();
			String message = "";
			String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Root><Head><PINID>1171324309371311548</PINID><AccountId>webservice</AccountId><AccountPwd>cRh+9uaf6d4IL1pfxndvig==</AccountPwd></Head><Body>";
			String oriBody = "<Mobiles>" + mobilephone + "</Mobiles><Content>" + content + "</Content>";
			String body = Encode(oriBody, "8171324380446946146");
			String tagEnd = "</Body></Root>";
			message = xml + body + tagEnd;
			String result = client.smsSend(message);
			String res = Decode(result, "8171324380446946146");
			return res;

	}

	private String getTrueKey(String key) throws UnsupportedEncodingException {
		byte[] srcKey = key.getBytes();
		byte[] newKey = new byte[24];
		if (key.length() < 24) {
			// 用空格补齐
			for (int i = 0; i < key.length(); i++) { // 将原始的数组放到新的数组中
				newKey[i] = srcKey[i];
			}
			for (int j = key.length(); j < 24; j++) {
				// Parses the string argument as a signed decimal byte. The
				// characters in the string must all be decimal digits
				newKey[j] = Byte.parseByte("32");
			}
		} else {
			// 超过24位的话，取前边24位
			for (int i = 0; i < key.length(); i++) {
				newKey[i] = srcKey[i];
			}
		}
		String reallKey = new String(newKey, "UTF-8");
		return reallKey;
	}

	private String Decode(String message, String srckey)
			throws UnsupportedEncodingException {
		String key = getTrueKey(srckey);
		byte[] desKey = key.getBytes();
		byte[] msgByte = EncryptUtils.decodeBase64(message);
		byte[] decodeByte = EncryptUtils.DESede(msgByte, DES_ALGORITHM,
				Cipher.DECRYPT_MODE, desKey, defaultIV);
		return new String(decodeByte, "UTF-8");
	}

	private String Encode(String message, String srckey)
			throws UnsupportedEncodingException {
		String key = getTrueKey(srckey);
		byte[] desKey = key.getBytes();
		byte[] messagebody = message.getBytes("UTF-8");
		byte[] encodeByte = EncryptUtils.DESede(messagebody, DES_ALGORITHM,
				Cipher.ENCRYPT_MODE, desKey, defaultIV);
		return EncryptUtils.base64Encode(encodeByte);
	}

}
