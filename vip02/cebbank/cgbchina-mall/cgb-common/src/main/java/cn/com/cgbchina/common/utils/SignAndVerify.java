package cn.com.cgbchina.common.utils;

import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;

/**
 * ��ǩ�ͽ�ǩ
 *
 * @author ��ΰ��
 *
 */
@Slf4j
public class SignAndVerify {
	/**
	 * 加签
	 *
	 * @param inbuf
	 * @param filename
	 * @return
	 * @throws Exception
	 */
	public static String sign_md(String inbuf, String filename)
			throws Exception {
		String sigStr = null;
		try {
			if (inbuf == null || filename == null) {
				log.info("Error:in sign_md:innuf or filename is null");
				throw new Exception("明文或者私钥为空");
				// return null;
			}
			PrivateKey priv = SignAndVerify.getPrivateKey(filename);
			Signature dsa = Signature.getInstance("SHA/DSA");
			dsa.initSign(priv);
			MessageDigest md = MessageDigest.getInstance("SHA");
			byte[] signbuf = md.digest(inbuf.getBytes());
			dsa.update(signbuf);
			byte[] sig = dsa.sign();
			sigStr = byteToHex(sig);
		} catch (Exception e) {
			log.info("Exception in sign_md:" + e.toString());
			e.printStackTrace();
			throw new Exception("加签异常");

		}
		return sigStr;
	}

	/**
	 * 获取私钥
	 *
	 * @param keyname
	 * @return
	 */
	public static PrivateKey getPrivateKey(String keyname) {
		try {
			PrivateKey priv;
			//URL url = SignAndVerify.class.getResource("");
			//String path = url.getPath();
			File file = new File(keyname);
			log.info("文件的绝对路径："+file.getAbsolutePath());
			FileInputStream istream = new FileInputStream(file);
			ObjectInputStream p = new ObjectInputStream(istream);
			priv = (PrivateKey) p.readObject();
			p.close();
			return priv;
		} catch (Exception e) {
			log.info("in KeyManager.getPrivateKey()  Caught exception "
					+ e.toString());
			log.error("获取私钥"+e.toString());
			e.printStackTrace();
			return null;
		}
	}

	/**
	 *
	 * @param inbuf
	 * @return
	 */
	public static String byteToHex(byte[] inbuf) {
		int i;
		String byteStr;
		StringBuffer strBuf = new StringBuffer();
		for (i = 0; i < inbuf.length; i++) {
			byteStr = Integer.toHexString(inbuf[i] & 0x00ff);
			if (byteStr.length() != 2) {
				strBuf.append('0').append(byteStr);
			} else {
				strBuf.append(byteStr);
			}
		}
		return new String(strBuf);
	}

	/**
	 * 验签
	 *
	 * @param inbuf
	 * @param sign
	 * @param filename
	 * @return
	 * @throws Exception
	 */
	public static boolean verify_md(String inbuf, String sign, String filename)
			throws Exception {
		log.info("明文:"+inbuf);
		log.info("签名:"+sign);
		log.info("网银公钥:"+filename);
		try {
			if (inbuf == null || sign == null || filename == null) {
				log.info("Error:明文或者密文或者公钥为空");
				throw new Exception("明文或者密文或者公钥为空");
				// return null;
			}
			PublicKey pub = SignAndVerify.getPublicKey(filename);
			Signature dsa = Signature.getInstance("SHA/DSA");
			dsa.initVerify(pub);
			MessageDigest md = MessageDigest.getInstance("SHA");
			byte[] signbuf = md.digest(inbuf.getBytes());
			dsa.update(signbuf);
			byte sig[] = hexToByte(sign);
			return dsa.verify(sig);
		} catch (Exception e) {
			log.info("Exception in SignAndVerify.verify_md():"
					+ e.toString());
			e.printStackTrace();
			throw new Exception("验签出现异常");
			// return false;
		}
	}

	/**
	 * 获取公钥
	 *
	 * @param keyname
	 * @return
	 */
	public static PublicKey getPublicKey(String keyname) {
		try {
			PublicKey pub;
			//URL url = SignAndVerify.class.getResource("");
			//String path = url.getPath();
			File file = new File(keyname);
			log.info("文件的绝对路径："+file.getAbsolutePath());
			FileInputStream istream = new FileInputStream(file);
			ObjectInputStream p = new ObjectInputStream(istream);
			pub = (PublicKey) p.readObject();
			p.close();
			return pub;
		} catch (Exception e) {
			log.info("in KeyManager.getPublicKey()  Caught exception "
					+ e.toString());
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * Insert the method's description here. Creation date: (00-6-9 17:06:35)
	 *
	 * @return java.lang.String
	 * @param inbuf
	 *            byte[]
	 */
	public static byte[] hexToByte(String inbuf) {
		int i;
		int len = inbuf.length() / 2;
		byte outbuf[] = new byte[len];
		for (i = 0; i < len; i++) {
			String tmpbuf = inbuf.substring(i * 2, i * 2 + 2);
			outbuf[i] = (byte) Integer.parseInt(tmpbuf, 16);
		}
		return outbuf;
	}


	public static void main(String[] args) throws Exception  {
		String inbuf="895678451232654|2016071200000345|199.00||0|0|0||201607120000034501|199.00|1|199|6214622121001413107||20160712|140522|||";
//		String b = SignAndVerify.sign_md(inbuf, "C:\\gfwork\\cgbchina-mall\\cgb-mall-web\\target\\cgb-mall-web\\WEB-INF\\classes\\key\\merkey895678451232654.private");
		String b = SignAndVerify.sign_md(inbuf, "C:\\gfwork\\cgbchina-mall\\cgb-mall-web\\src\\main\\resources\\key\\merkey895678451232654.private");
		System.out.println("begin");
		System.out.println(b);
		System.out.println("end");
	}
}
