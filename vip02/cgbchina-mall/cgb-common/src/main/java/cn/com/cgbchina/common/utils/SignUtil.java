package cn.com.cgbchina.common.utils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;

import lombok.extern.slf4j.Slf4j;

import org.apache.xml.security.signature.XMLSignature;
import org.apache.xml.security.transforms.Transforms;
import org.apache.xml.security.utils.Constants;
import org.apache.xml.security.utils.XMLUtils;
import org.apache.xpath.XPathAPI;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

/**
 * <b>功能描述：对数据的签名、验签操作</b> <br>
 * 
 * @author xiewl
 * @version 2016年5月27日 上午9:48:31
 */
@Slf4j
public class SignUtil {

	/**
	 * 对一段字符串进行签名，返回签名之后的字符串。
	 * 
	 * @param src
	 * @return
	 * @throws Exception
	 */
	public static String sign(String src, PrivateKey priKey) throws Exception {
		String RSA_ALGORITHM_NAME = "RSA";
		SignManagerImpl signManager = new SignManagerImpl();
		String sign = signManager.sign(src, RSA_ALGORITHM_NAME, priKey);
		return sign;
	}

	public static String signGDB(String sigTxt, PrivateKey pk) throws Exception {
		String sigStr = null;
		Signature s = null;
		try {
			s = Signature.getInstance("SHA1WithRSA", new BouncyCastleProvider());
			s.initSign(pk);
			MessageDigest md = MessageDigest.getInstance("SHA");
			byte[] signbuf = md.digest(sigTxt.getBytes());
			s.update(signbuf);
			byte[] sig = s.sign();
			sigStr = byteToHex(sig);// 签名结果转换
			return sigStr;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	/**
	 * 对一段签名之后的字符串进行校验，返回校验的结果。
	 * 
	 * @param src
	 * @return
	 * @throws Exception
	 */
	public static boolean check(String src, String sign, PublicKey pubKey) throws Exception {
		String RSA_ALGORITHM_NAME = "RSA";
		SignManagerImpl signManager = new SignManagerImpl();
		boolean isSuccess = signManager.check(sign, src, RSA_ALGORITHM_NAME, pubKey);
		return isSuccess;
	}

	/**
	 * 对xml文件进行公钥验证
	 * 
	 * @param doc
	 * @param pubKey
	 * @return
	 */
	public static boolean check(Document doc, PublicKey pubKey) {
		try {
			Element nscontext = XMLUtils.createDSctx(doc, "ds", Constants.SignatureSpecNS);
			Element signElement = (Element) XPathAPI.selectSingleNode(doc, "//ds:Signature[1]", nscontext);

			if (signElement == null) {
				return false;
			}
			XMLSignature signature = new XMLSignature(signElement, null);
			return signature.checkSignatureValue(pubKey);
		} catch (Exception e) {
			log.error("验证签名的时候发生了异常！");
		}
		return false;
	}

	/**
	 * 对xml文件进行公钥验证
	 * 
	 * @param xml
	 * @param pubKey
	 * @return
	 * @throws Exception
	 */
	public static boolean check(String xml, PublicKey pubKey) throws Exception {
		Document doc = DocumentUtil.getDocFromFile(new File(xml));
		return check(doc, pubKey);
	}

	/**
	 * 用公钥对交易数据进行验签 sigTxt:签名 data：明文 key:.cer 文件路径
	 */
	public static boolean verifySign(String sigTxt, String data, PublicKey pubKey) throws Exception {
		Signature s = Signature.getInstance("SHA1WithRSA");
		s.initVerify(pubKey);
		MessageDigest md = MessageDigest.getInstance("SHA");
		byte[] signbuf = md.digest(data.getBytes());
		s.update(signbuf);
		byte sig[] = hexToByte(sigTxt);

		return s.verify(sig);
	}

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

	/**
	 * xml报文签名
	 * 
	 */
	public static String sign(Document doc, PrivateKey privateKey, String msgType) {
		try {

			XMLSignature sig = new XMLSignature(doc, null, XMLSignature.ALGO_ID_SIGNATURE_RSA);
			Node messageNode = doc.getElementsByTagName("Message").item(0);
			messageNode.appendChild(sig.getElement());
			Transforms transforms = new Transforms(doc);
			transforms.addTransform(Transforms.TRANSFORM_ENVELOPED_SIGNATURE);
			sig.addDocument("#" + msgType, transforms, Constants.ALGO_ID_DIGEST_SHA1);

			// 签名
			sig.sign(privateKey);

			// 将签名好的XML文档写出
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			XMLUtils.outputDOM(doc, os);
			return os.toString("utf-8");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * xml报文签名
	 * 
	 * @param xml 文件路径
	 * @param privateKey
	 * @param msgType
	 * @return
	 * @throws Exception
	 */
	public static String sign(String xml, PrivateKey privateKey, String msgType) throws Exception {
		Document doc = DocumentUtil.getDocFromFile(new File(xml));
		return sign(doc, privateKey, msgType);
	}

	/**
	 * 采用私钥对象对交易数据进行签名 sigTxt:需要签名的字符串
	 **/
	public static String sign_test(String sigTxt, String merchantId) {
		String sigStr = null;
		Signature s;
		KeyReader keyReader = new KeyReader();
		try {
			PrivateKey pk = keyReader.readPrivateKey("", false, "SHA");// 临时
			s = Signature.getInstance("SHA1WithRSA");
			s.initSign(pk);
			MessageDigest md = MessageDigest.getInstance("SHA");
			byte[] signbuf = md.digest(sigTxt.getBytes());
			s.update(signbuf);
			byte[] sig = s.sign();
			sigStr = byteToHex(sig);// 签名结果转换
			return sigStr;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

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

}
