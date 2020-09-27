package cn.com.cgbchina.rest.common.utils;

import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class EncryptionUtil {

	private static byte[] keyiv = { 1, 2, 3, 4, 5, 6, 7, 8 };

	/**
	 * CBC加密
	 *
	 * @param key
	 *            密钥
	 * @param keyiv
	 *            IV
	 * @param data
	 *            明文
	 * @return Base64编码的密文
	 * @throws Exception
	 */
	public static byte[] des3EncodeCBC(byte[] key, byte[] keyiv, byte[] data)
			throws Exception {

		Key deskey = null;
		DESedeKeySpec spec = new DESedeKeySpec(key);
		SecretKeyFactory keyfactory = SecretKeyFactory.getInstance("desede");
		deskey = keyfactory.generateSecret(spec);

		Cipher cipher = Cipher.getInstance("desede" + "/CBC/PKCS5Padding");
		IvParameterSpec ips = new IvParameterSpec(keyiv);
		cipher.init(Cipher.ENCRYPT_MODE, deskey, ips);
		byte[] bOut = cipher.doFinal(data);

		return bOut;
	}

	public static String des3EncodeCBC(String key, String data)
			throws Exception {
		byte[] k = new BASE64Decoder().decodeBuffer(key);
		byte[] iv = keyiv;
		byte[] d = data.getBytes("UTF-8");

		return new BASE64Encoder().encode(des3EncodeCBC(k, iv, d));
	}

	/**
	 * CBC解密
	 *
	 * @param key
	 *            密钥
	 * @param keyiv
	 *            IV
	 * @param data
	 *            Base64编码的密文
	 * @return 明文
	 * @throws Exception
	 */
	public static byte[] des3DecodeCBC(byte[] key, byte[] keyiv, byte[] data)
			throws Exception {

		Key deskey = null;
		DESedeKeySpec spec = new DESedeKeySpec(key);
		SecretKeyFactory keyfactory = SecretKeyFactory.getInstance("desede");
		deskey = keyfactory.generateSecret(spec);

		Cipher cipher = Cipher.getInstance("desede" + "/CBC/PKCS5Padding");
		IvParameterSpec ips = new IvParameterSpec(keyiv);

		cipher.init(Cipher.DECRYPT_MODE, deskey, ips);

		byte[] bOut = cipher.doFinal(data);

		return bOut;

	}

	public static String des3DecodeCBC(String key, String data)
			throws Exception {

		byte[] k = new BASE64Decoder().decodeBuffer(key);
		byte[] iv = keyiv;
		byte[] d = new BASE64Decoder().decodeBuffer(data);

		return new String(des3DecodeCBC(k, iv, d), "UTF-8");
	}

	public static String md5(String plainText) throws Exception {
		String str = "";
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(plainText.getBytes());
			byte b[] = md.digest();

			int i;

			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
				i = b[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buf.append("0");
				buf.append(Integer.toHexString(i));
			}
			str = buf.toString();

		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}
		return str;
	}


	public static String md5(String plainText,String charSet) throws Exception {
		String str = "";
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(plainText.getBytes(charSet));
			byte b[] = md.digest();

			int i;

			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
				i = b[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buf.append("0");
				buf.append(Integer.toHexString(i));
			}
			str = buf.toString();

		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}
		return str;
	}

	public final static String getMD5ByUtf8(String s) throws Exception {
		StringBuffer result = null;
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(s.getBytes("UTF-8"));
			byte b[] = md.digest();
			result = new StringBuffer();
			for (int i = 0; i < b.length; i++) {
				result.append(Integer.toHexString(
						(0x000000ff & b[i]) | 0xffffff00).substring(6));
			}

			return result.toString();
		} catch (Exception e) {
			throw e;
		}
	}

	// AES加密

	/*
	 * 转为十六进制
	 */
	private static String asHex(byte buf[]) {
		StringBuffer strbuf = new StringBuffer(buf.length * 2);
		int i;

		for (i = 0; i < buf.length; i++) {
			if (((int) buf[i] & 0xff) < 0x10)
				strbuf.append("0");

			strbuf.append(Long.toString((int) buf[i] & 0xff, 16));
		}
		return strbuf.toString();
	}

	/*
	 * 转为二进制
	 */
	private static byte[] asBin(String src) {
		if (src.length() < 1)
			return null;
		byte[] encrypted = new byte[src.length() / 2];
		for (int i = 0; i < src.length() / 2; i++) {
			int high = Integer.parseInt(src.substring(i * 2, i * 2 + 1), 16);
			int low = Integer.parseInt(src.substring(i * 2 + 1, i * 2 + 2), 16);

			encrypted[i] = (byte) (high * 16 + low);
		}
		return encrypted;
	}

	/*
	 * 加密
	 */
	public static String encryptAES(String data, String secretKey) {
		byte[] key = asBin(secretKey);
		SecretKeySpec sKey = new SecretKeySpec(key, "AES");
		try {
			Cipher cipher = Cipher.getInstance("AES");
			cipher.init(Cipher.ENCRYPT_MODE, sKey);
			byte[] encrypted = cipher.doFinal(data.getBytes());

			return asHex(encrypted);

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/*
	 * 加密
	 */
	public static String encryptAES(byte[] dataBs, String secretKey) {
		byte[] key = asBin(secretKey);
		SecretKeySpec sKey = new SecretKeySpec(key, "AES");
		try {
			Cipher cipher = Cipher.getInstance("AES");
			cipher.init(Cipher.ENCRYPT_MODE, sKey);
			byte[] encrypted = cipher.doFinal(dataBs);

			return asHex(encrypted);

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/*
	 * 解密
	 */
	public static String decryptAES(String encData, String secretKey) {
		byte[] tmp = asBin(encData);
		byte[] key = asBin(secretKey);
		SecretKeySpec sKey = new SecretKeySpec(key, "AES");
		try {
			Cipher cipher = Cipher.getInstance("AES");
			cipher.init(Cipher.DECRYPT_MODE, sKey);
			byte[] decrypted = cipher.doFinal(tmp);
			return new String(decrypted);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/*
	 * public static void main(String[] args) throws IOException { String key =
	 * ConfigProperties.getProperties("logistics.encryption.text");
	 * System.out.println("key:"+key); String data = "中文测试abc"; String en =
	 * encryptAES(data.getBytes(), key);
	 * 
	 * System.out.println("原文："+data); System.out.println("加密："+en);
	 * System.out.println("解密："+decryptAES(en, key));
	 * System.out.println("-------------");
	 * 
	 * 
	 * byte[] baBs = "4234".getBytes(); System.out.println(new String(baBs));
	 * 
	 *  // ObjectInputStream in = new ObjectInputStream(new FileInputStream( //
	 * "../../../aesSecurity.key"));
	 *  }
	 * 
	 */

	public static void main(String[] args) throws Exception {
		
		/*	String content="中文测试abc";
    	
        System.out.println("CBC加密结果如下(key="+key+")：");

        String d = des3EncodeCBC(key,content);
        System.out.println("密文："+d);
        System.out.println("校验码："+md5(content+key));
        
        System.out.println("CBC解密结果如下(key="+key+")：");
        String dd =des3DecodeCBC(key,d);
        System.out.println("原文："+dd);
        System.out.println("校验码："+md5(dd+key));
		*/
		//String te="<cgbMall><Order><OrderId>2011083100100071</OrderId><OrdTime>2011-08-24 05:53:24</OrdTime><Customer>fsdfsdf</Customer><Mobile>13911112222</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>河西区</District><Address>sdfsfsdfsdfsdf</Address><ZipCode>232342</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007101</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100072</OrderId><OrdTime>2011-09-08 05:53:08</OrdTime><Customer>fsdfsdf</Customer><Mobile>13911112222</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>河西区</District><Address>sdfsfsdfsdfsdf</Address><ZipCode>232342</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007201</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100073</OrderId><OrdTime>2011-08-10 05:58:10</OrdTime><Customer>fsdfsdf</Customer><Mobile>13911112222</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>河西区</District><Address>sdfsfsdfsdfsdf</Address><ZipCode>232342</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007301</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100074</OrderId><OrdTime>2011-08-17 06:05:17</OrdTime><Customer>111</Customer><Mobile>13333333333</Mobile><Phone>-</Phone><Province>西藏自治区</Province><City>山南地区</City><District>桑日县</District><Address>1234</Address><ZipCode>111111</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007401</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100075</OrderId><OrdTime>2011-09-27 06:07:27</OrdTime><Customer>111111</Customer><Mobile>11111111111</Mobile><Phone>-</Phone><Province>四川省</Province><City>泸州市</City><District>龙马潭区</District><Address>11111</Address><ZipCode>111111</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007501</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100076</OrderId><OrdTime>2011-09-10 06:18:10</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007601</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100077</OrderId><OrdTime>2011-09-10 07:45:10</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007701</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item><Item><SubOrderId>201108310010007702</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100078</OrderId><OrdTime>2011-09-09 08:03:09</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007801</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item><Item><SubOrderId>201108310010007802</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100079</OrderId><OrdTime>2011-08-16 09:32:16</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007901</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item><Item><SubOrderId>201108310010007902</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100080</OrderId><OrdTime>2011-08-05 09:58:05</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010008001</SubOrderId><ProdNO>01110831215030000087</ProdNO><ProdName>上架测试</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order></cgbMall>";
//		String cs = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><cgbMall><Order><OrderId>2011083100100071</OrderId><OrdTime>20110831</OrdTime><Customer>fsdfsdf</Customer><Mobile>13911112222</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>河西区</District><Address>sdfsfsdfsdfsdf</Address><ZipCode>232342</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007101</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100072</OrderId><OrdTime>20110831</OrdTime><Customer>fsdfsdf</Customer><Mobile>13911112222</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>河西区</District><Address>sdfsfsdfsdfsdf</Address><ZipCode>232342</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007201</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100073</OrderId><OrdTime>20110831</OrdTime><Customer>fsdfsdf</Customer><Mobile>13911112222</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>河西区</District><Address>sdfsfsdfsdfsdf</Address><ZipCode>232342</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007301</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100074</OrderId><OrdTime>20110831</OrdTime><Customer>111</Customer><Mobile>13333333333</Mobile><Phone>-</Phone><Province>西藏自治区</Province><City>山南地区</City><District>桑日县</District><Address>1234</Address><ZipCode>111111</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007401</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100075</OrderId><OrdTime>20110831</OrdTime><Customer>111111</Customer><Mobile>11111111111</Mobile><Phone>-</Phone><Province>四川省</Province><City>泸州市</City><District>龙马潭区</District><Address>11111</Address><ZipCode>111111</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007501</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100076</OrderId><OrdTime>20110831</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007601</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100077</OrderId><OrdTime>20110831</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007701</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item><Item><SubOrderId>201108310010007702</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100078</OrderId><OrdTime>20110831</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007801</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item><Item><SubOrderId>201108310010007802</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100079</OrderId><OrdTime>20110831</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010007901</SubOrderId><ProdNO>01110824073859000024</ProdNO><ProdName>ttt</ProdName><Quantity>1</Quantity><Comments></Comments></Item><Item><SubOrderId>201108310010007902</SubOrderId><ProdNO>01110829023223000003</ProdNO><ProdName>野火</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order><Order><OrderId>2011083100100080</OrderId><OrdTime>20110831</OrdTime><Customer>fdgdfg</Customer><Mobile>16911122233</Mobile><Phone>-</Phone><Province>天津</Province><City>天津市</City><District>和平区</District><Address>gdfgdfg</Address><ZipCode>345345</ZipCode><Comments></Comments><Item><SubOrderId>201108310010008001</SubOrderId><ProdNO>01110831215030000087</ProdNO><ProdName>上架测试</ProdName><Quantity>1</Quantity><Comments></Comments></Item></Order></cgbMall>";

//		"84a568d2---831843a0"

//		System.out.println("校验码1：" + md5("中文"+key));
//		System.out.println("校验码2：" + getMD5ByUtf8("中文"+key));
		
		/*System.out.println(te);
		System.out.println("校验码1：" + md5(te+key));
		System.out.println("校验码2：" + getMD5ByUtf8(te+key));
		System.out.println("校验码3：" + md5(te));
		System.out.println("校验码4：" + getMD5ByUtf8(te));*/
		String key="2C02DD96C31DD0AA8ECF2EA723CAE3D3";
		String soap  = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><request_message><message><result_code>true</result_code><result_msg>参数错误</result_msg></message></request_message>";
		//加密：
		String encryptDesXml = des3EncodeCBC(key,soap);
		//String encryptDesXml = "3rsEdkKWoAg/+NoWQzy7Vr5JNLIqlPl4udUmjMbkR1pDIZ5H2yj02/0OauCzwW29x827eU7LdSeqBcwRAW5bpYrrfo/osTeEv71WDsW32U1/pVCs7h9iM8S+aUCK1y3ypjL3IQNj5ECyk1MSwHOpYB9noRO3OlfDTwd/4lYZnjJjRR5toYtvevZz5jOJlatXgd6LHAFHaXKrJB5u4e7I9w72ZB4KKpw7";
		encryptDesXml = "5MOQ/dNB8VBb7NoBTzotMa6BBV9gsQYgcMCmGhcYINqHBaigTnLXdb/waSiCjtwcAqq31uQbvVZ8bDwRr7xqF5Ppq/9KfK1VqzSzrUXPV56m2nRc0aQ79Sk1Vmc2R1M/Blc8Pn0/29TmHRZJCFrueI+7c8w5Yne8mwaN2zW6Pozva4kVoKjbthNkNKFFj0qpq9MgSfmy/HOc4rZmmeyEJtehDg3kO2rZ1IHX8lKpZeqB78b0zxeR/Z5UgZHisWe854orpCuBbRIIIzU3B5fOllFyT1EeT0+6lLhBveVJtNFfFN4sRWSrZ4jvHTp2NCr46snoOUihO1FjGE5+Ytl5oqO8ArYg49ldHQbJYJaqQN742MvipMUVzlnKO83r3er/n1eoOi7bMuDIggR9Jc4URUM8Cnflbqy4z7leLFS8714ah17D/QEFQ00ifNJauSs1Tdm3pnvgIrpIRwOFa7ZHZ9chZex1bC54HTAWZjg+i/s=";

		System.out.println("密文：" + encryptDesXml);
		//解密
		//String s = "Anjzk8eXRgPZtDN2k+jHg4CoHMVigkAfND+GiKSQtoT7PERCuph09VMrTjikQ2cP5j3krowdGIguAOD2Xwt3JBjxDrUZNRTnIxvTN2uAqZD/bZXEA2x155+WhInQnzuZKJlhIkrLWjp1T6nnOA8LBsydr7y6ndubbWnLUS9vRU+WmsD6NjnjyC79kOovG6XsfaJO3fiYA4TwPNl/+NF+w38ojAYlyXxp";
		String str = des3DecodeCBC(key,encryptDesXml);
		//String s1  = URLEncoder.encode(s);
		System.out.println("明文：" + str);


	}

}
