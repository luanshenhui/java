package rcmtm.encrypt;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.security.KeyPair;
import java.security.KeyFactory;
import java.security.KeyPairGenerator;

import java.security.PublicKey;
import java.security.PrivateKey;
import java.security.SecureRandom;
import java.security.NoSuchAlgorithmException;
import java.security.Security;

import java.security.interfaces.RSAPublicKey;
import java.security.interfaces.RSAPrivateKey;

import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPublicKeySpec;
import java.security.spec.RSAPrivateKeySpec;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;
import org.apache.log4j.Logger;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import chinsoft.core.ConfigHelper;
import chinsoft.core.Utility;

public class CCBRsaUtil {
	private static final Logger log = Logger.getLogger(CCBRsaUtil.class);

	public static CCBRsaUtil instance = null;

	public static synchronized CCBRsaUtil getInstance() {
		if (instance == null) {
			instance = new CCBRsaUtil();
		}
		return instance;
	}

	static {
		if (Security.getProvider("BC") == null) {
			Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
		}
	}

	public CCBRsaUtil() {
		// initSecurity();
		// TODO Auto-generated constructor stub
	}

	// private static void getKeyPath(String mod) {
	// String file = System.getProperty("user.dir") + "/cert/"+mod+".cert";
	// }

	// 生成证书文件
	public static KeyPair generateKeyPair(String corpName) throws Exception {
		try {
			KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA",
					getProvider());
			final int KEY_SIZE = 1024;//
			SecureRandom secrand = new SecureRandom();
			secrand.setSeed(corpName.getBytes()); //
			keyPairGen.initialize(KEY_SIZE, secrand);
			KeyPair keyPair = keyPairGen.generateKeyPair();
			saveKeyPair(keyPair, corpName);
			return keyPair;
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
	}

	// 读取证书文件内容
	public static KeyPair getKeyPair(String corpName) throws Exception {

		String file = System.getProperty("user.dir") + "\\cert\\" + corpName
				+ ".cert";
		KeyPair kp = null;

		FileInputStream fis = null;
		ObjectInputStream oos = null;
		try {
			fis = new FileInputStream(file);

			oos = new ObjectInputStream(fis);
			kp = (KeyPair) oos.readObject();
		} catch (Exception e) {
			log.info(" get pairkey error ");
			e.printStackTrace();
		} finally {
			if (null != oos) {
				oos.close();
			}
			if (null != fis) {
				fis.close();
			}

		}

		return kp;
	}

	/**
	 * 读取公钥证书文件内容
	 * 
	 * @param corpName
	 * @return
	 * @throws Exception
	 */
	public static RSAPrivateKey getRSAPrivateKeyPair(String corpName)
			throws Exception {

		// String file = System.getProperty("user.dir") +
		// "\\cert\\"+corpName+".cert";
//		String file = "D:\\project\\java\\hongling\\resource\\cert\\" + corpName + ".cert";
		String file = Utility.toSafeString(ConfigHelper.getContextParam().get("CfgPath"))+ "\\cert\\" + corpName + ".cert";
		// String file = corpName;

		RSAPrivateKey kp = null;

		FileInputStream fis = null;
		ObjectInputStream oos = null;
		try {
			fis = new FileInputStream(file);

			oos = new ObjectInputStream(fis);
			kp = (RSAPrivateKey) oos.readObject();
		} catch (Exception e) {
			log.info(" get pairkey error ");
			e.printStackTrace();
		} finally {
			if (null != oos) {
				oos.close();
			}
			if (null != fis) {
				fis.close();
			}

		}

		return kp;
	}

	public static RSAPublicKey getRSAPublicKeyPair(String corpName)
			throws Exception {

		// String file = System.getProperty("user.dir") +
		// "\\cert\\"+corpName+".cert";
		String file = Utility.toSafeString(ConfigHelper.getContextParam().get(
				"RsaCertPath"))
				+ "\\cert\\" + corpName + ".cert";
		// String file = corpName;

		RSAPublicKey kp = null;

		FileInputStream fis = null;
		ObjectInputStream oos = null;
		try {
			fis = new FileInputStream(file);

			oos = new ObjectInputStream(fis);
			kp = (RSAPublicKey) oos.readObject();
		} catch (Exception e) {
			log.info(" get pairkey error ");
			e.printStackTrace();
		} finally {
			if (null != oos) {
				oos.close();
			}
			if (null != fis) {
				fis.close();
			}

		}

		return kp;
	}

	/**
	 * 保存证书文件信息
	 * 
	 * @param kp
	 *            : 秘钥类
	 * @param corpName
	 *            : 证书文件名
	 * @throws Exception
	 */
	public static void saveKeyPair(KeyPair kp, String corpName)
			throws Exception {
		// String fileName = keyPath+corpName + ".cert" ;
		// //ConfigurationManager.getProperty(ConstrtsProperty.DIR);
		// String fileName = ConstantAcLogin.CCB_CERT_PATH + corpName + ".cert";
		String fileName = System.getProperty("user.dir") + "/cert/" + corpName
				+ ".cert";
		// log.info(fileName);
		FileOutputStream fos = null;
		ObjectOutputStream oos = null;
		try {
			File keyFile = new File(fileName);

			if (null == keyFile || !keyFile.exists()) {
				keyFile.createNewFile();
				// log.info("create file");
			}

			fos = new FileOutputStream(fileName);
			oos = new ObjectOutputStream(fos);

			//
			oos.writeObject(kp);

		} catch (IOException e) {
			log.info(" error ");
			e.printStackTrace();
		} finally {
			if (null != oos) {
				oos.close();
			}
			if (null != fos) {
				fos.close();
			}
		}
	}

	/**
	 * 根据密钥串，产生公钥
	 * 
	 * @param modulus
	 * @param publicExponent
	 * @return
	 * @throws Exception
	 */
	public static RSAPublicKey generateRSAPublicKey(byte[] modulus,
			byte[] publicExponent) throws Exception {
		KeyFactory keyFac = null;
		try {
			keyFac = KeyFactory.getInstance("RSA", getProvider());
		} catch (NoSuchAlgorithmException ex) {
			throw new Exception(ex.getMessage());
		}

		RSAPublicKeySpec pubKeySpec = new RSAPublicKeySpec(new BigInteger(
				modulus), new BigInteger(publicExponent));
		try {
			return (RSAPublicKey) keyFac.generatePublic(pubKeySpec);
		} catch (InvalidKeySpecException ex) {
			throw new Exception(ex.getMessage());
		}
	}

	/**
	 * 根据密钥串，产生公钥
	 * 
	 * @param pubkeys
	 * @return
	 * @throws Exception
	 */
	public static RSAPublicKey generateRSAPublicKeyEx(byte[] pubkeys)
			throws Exception {
		KeyFactory keyFac = null;
		try {
			keyFac = KeyFactory.getInstance("RSA", getProvider());
		} catch (NoSuchAlgorithmException ex) {
			throw new Exception(ex.getMessage());
		}

		X509EncodedKeySpec x509encodedkeyspec = new X509EncodedKeySpec(pubkeys);

		try {
			return (RSAPublicKey) keyFac.generatePublic(x509encodedkeyspec);
		} catch (InvalidKeySpecException ex) {
			throw new Exception(ex.getMessage());
		}
	}

	/**
	 * 根据密钥串，产生私钥
	 * 
	 * @param modulus
	 * @param privateExponent
	 * @return
	 * @throws Exception
	 */
	public static RSAPrivateKey generateRSAPrivateKey(byte[] modulus,
			byte[] privateExponent) throws Exception {
		KeyFactory keyFac = null;
		try {
			keyFac = KeyFactory.getInstance("RSA", getProvider());
		} catch (NoSuchAlgorithmException ex) {
			throw new Exception(ex.getMessage());
		}

		RSAPrivateKeySpec priKeySpec = new RSAPrivateKeySpec(new BigInteger(
				modulus), new BigInteger(privateExponent));
		try {
			return (RSAPrivateKey) keyFac.generatePrivate(priKeySpec);
		} catch (InvalidKeySpecException ex) {
			throw new Exception(ex.getMessage());
		}
	}

	/**
	 * 根据密钥串，产生私钥
	 * 
	 * @param prikeys
	 * @return
	 * @throws Exception
	 */
	public static RSAPrivateKey generateRSAPrivateKeyEx(byte[] prikeys)
			throws Exception {
		KeyFactory keyFac = null;
		try {
			keyFac = KeyFactory.getInstance("RSA", getProvider());
		} catch (NoSuchAlgorithmException ex) {
			throw new Exception(ex.getMessage());
		}

		PKCS8EncodedKeySpec pkcs8encodedkeyspec = new PKCS8EncodedKeySpec(
				prikeys);

		try {
			return (RSAPrivateKey) keyFac.generatePrivate(pkcs8encodedkeyspec);
		} catch (InvalidKeySpecException ex) {
			throw new Exception(ex.getMessage());
		}
	}

	public static byte[] encryptBySiteIdEx(String siteId, String data)
			throws Exception {

		RSAPublicKey rsap1 = (RSAPublicKey) getKeyPair(siteId).getPublic();

		return encrypt(rsap1, data.getBytes());
	}

	/**
	 * encrypt by public key , to hex string
	 * 
	 * @param publicKey
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public static String encryptByPubKey(PublicKey publicKey, String data)
			throws Exception {

		RSAPublicKey rsap1 = (RSAPublicKey) publicKey;

		return RSAHelp.encodeHexStr(encrypt(rsap1, data.getBytes()), true);
	}

	/**
	 * 指定公钥证书名加密字符串
	 * 
	 * @param siteId
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public static String encryptBySiteId(String siteId, String data)
			throws Exception {

		RSAPublicKey rsap1 = (RSAPublicKey) getKeyPair(siteId).getPublic();
		return RSAHelp.encodeHexStr(encrypt(rsap1, data.getBytes()), true);
	}

	/**
	 * 指定私钥证书名加密字符串
	 * 
	 * @param siteId
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public static String encryptByPriKey(RSAPrivateKey rsap, String data)
			throws Exception {
		return RSAHelp.encodeHexStr(encryptVers(rsap, data.getBytes()), true);
	}

	/*
	 * 公钥加密
	 */
	public static byte[] encrypt(PublicKey pk, byte[] data) throws Exception {
		Cipher cipher;
		// long startTime = System.currentTimeMillis();
		try {
			cipher = Cipher.getInstance("RSA", getProvider());
			// log.info("--------------create Cipher start to encrypt ");

			cipher.init(Cipher.ENCRYPT_MODE, pk);
			int blockSize = cipher.getBlockSize();// key_size=1024
			int outputSize = cipher.getOutputSize(data.length);//

			// log.info("--------------Cipher blockSize=" +
			// cipher.getBlockSize());

			int leavedSize = data.length % blockSize;
			int blocksSize = leavedSize != 0 ? data.length / blockSize + 1
					: data.length / blockSize;
			byte[] raw = new byte[outputSize * blocksSize];
			int i = 0;
			while (data.length - i * blockSize > 0) {
				if (data.length - i * blockSize > blockSize)
					cipher.doFinal(data, i * blockSize, blockSize, raw, i
							* outputSize);
				else
					cipher.doFinal(data, i * blockSize, data.length - i
							* blockSize, raw, i * outputSize);

				i++;
			}
			return raw;
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			// log.info("Cipher finally execute time= " +
			// (System.currentTimeMillis() - startTime));
			cipher = null;
		}
	}

	/*
	 * 私钥加密
	 */
	public static byte[] encryptVers(PrivateKey pk, byte[] data)
			throws Exception {
		Cipher cipher;
		// long startTime = System.currentTimeMillis();
		try {
			cipher = Cipher.getInstance("RSA", getProvider());
			// log.info("--------------create Cipher privateKey start to encrypt ");
			cipher.init(Cipher.ENCRYPT_MODE, pk);
			int blockSize = cipher.getBlockSize();// key_size=1024
			int outputSize = cipher.getOutputSize(data.length);//
			int leavedSize = data.length % blockSize;
			int blocksSize = leavedSize != 0 ? data.length / blockSize + 1
					: data.length / blockSize;
			byte[] raw = new byte[outputSize * blocksSize];
			int i = 0;
			while (data.length - i * blockSize > 0) {
				if (data.length - i * blockSize > blockSize)
					cipher.doFinal(data, i * blockSize, blockSize, raw, i
							* outputSize);
				else
					cipher.doFinal(data, i * blockSize, data.length - i
							* blockSize, raw, i * outputSize);

				i++;
			}
			return raw;
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			cipher = null;
		}
	}

	/**
	 * decrypt by privatekey on hex String
	 * 
	 * @param privateKey
	 * @param data
	 * @return string
	 * @throws Exception
	 */
	public static String decryptByPirvKey(PrivateKey privateKey, String data)
			throws Exception {

		byte[] in_enc = RSAHelp.decodeHex(data.toCharArray());
		byte[] in_dec = decrypt((RSAPrivateKey) privateKey, in_enc);
		String decString = new String(in_dec);
		return decString;
	}

	/**
	 * 
	 * @param pubKey
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public static String decryptBySiteId(String sId, String data)
			throws Exception {

		KeyPair tmpKeyPair = getKeyPair(sId);// 证书存放路径可以在此方法中设置

		byte[] en_test1 = RSAHelp.decodeHex(data.toCharArray());

		RSAPrivateKey rsap2 = (RSAPrivateKey) tmpKeyPair.getPrivate();

		String strPriKey = bytesToHexStr(rsap2.getEncoded());// 通过私钥证书得到私钥串

		RSAPrivateKey priEEE = generateRSAPrivateKeyEx(hexStrToBytes(strPriKey));// 产生私钥

		byte[] de_test = decrypt(priEEE, en_test1); // 私钥解密

		String de = new String(de_test);

		return de;
	}

	/**
	 * 
	 * @param pubKey
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public static String decryptByPubKey(PublicKey pubKey, String data)
			throws Exception {

		byte[] in_enc = RSAHelp.decodeHex(data.toCharArray());
		byte[] in_dec = decryptVers((RSAPublicKey) pubKey, in_enc);
		String decString = new String(in_dec);
		return decString;
	}

	/*
	 * 私钥解密
	 */
	public static byte[] decrypt(PrivateKey pk, byte[] raw) throws Exception {
		try {
			Cipher cipher = Cipher.getInstance("RSA", getProvider());
			cipher.init(Cipher.DECRYPT_MODE, pk);
			int blockSize = cipher.getBlockSize();
			ByteArrayOutputStream bout = new ByteArrayOutputStream(64);
			int j = 0;

			while (raw.length - j * blockSize > 0) {
				bout.write(cipher.doFinal(raw, j * blockSize, blockSize));
				j++;
			}
			return bout.toByteArray();
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
	}

	/*
	 * 公钥解密
	 */
	public static byte[] decryptVers(PublicKey pk, byte[] raw) throws Exception {
		try {
			Cipher cipher = Cipher.getInstance("RSA", getProvider());
			cipher.init(Cipher.DECRYPT_MODE, pk);
			int blockSize = cipher.getBlockSize();
			ByteArrayOutputStream bout = new ByteArrayOutputStream(64);
			int j = 0;

			while (raw.length - j * blockSize > 0) {
				bout.write(cipher.doFinal(raw, j * blockSize, blockSize));
				j++;
			}
			return bout.toByteArray();
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

	}

	/**
	 * Transform the specified byte into a Hex String form.
	 */
	public static final String bytesToHexStr(byte[] bcd) {
		StringBuffer s = new StringBuffer(bcd.length * 2);

		for (int i = 0; i < bcd.length; i++) {
			s.append(bcdLookup[(bcd[i] >>> 4) & 0x0f]);
			s.append(bcdLookup[bcd[i] & 0x0f]);
		}

		return s.toString();
	}

	/**
	 * Transform the specified Hex String into a byte array.
	 */
	public static final byte[] hexStrToBytes(String s) {
		byte[] bytes;

		bytes = new byte[s.length() / 2];

		for (int i = 0; i < bytes.length; i++) {
			bytes[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2),
					16);
		}

		return bytes;
	}

	private static final char[] bcdLookup = { '0', '1', '2', '3', '4', '5',
			'6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

	private static BouncyCastleProvider bcp = null;

	private static BouncyCastleProvider getProvider() {
		if (bcp == null) {
			try {
				bcp = new BouncyCastleProvider();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return bcp;
	}

	public static void initSecurity() {
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
	}

	/**
	 * 保存私钥到文件中
	 * 
	 * @param kp
	 *            : 私钥类
	 * @param fileName
	 *            私钥文件名
	 * @throws Exception
	 */
	public static void savePriKeyFile(RSAPrivateKey kp, String fileName)
			throws Exception {
		fileName = System.getProperty("user.dir") + "/cert/" + fileName
				+ ".cert";
		FileOutputStream fos = null;
		ObjectOutputStream oos = null;
		try {
			File keyFile = new File(fileName);

			if (null == keyFile || !keyFile.exists()) {
				keyFile.createNewFile();
				// log.info("create file");
			}

			fos = new FileOutputStream(fileName);
			oos = new ObjectOutputStream(fos);

			oos.writeObject(kp);

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (null != oos) {
				oos.close();
			}
			if (null != fos) {
				fos.close();
			}
		}
	}

	/**
	 * 保存公钥到文件中
	 * 
	 * @param kp
	 *            : 公钥类
	 * @param fileName
	 *            : 公钥文件名
	 * @throws Exception
	 */
	public static void savePubKeyFile(RSAPublicKey kp, String fileName)
			throws Exception {
		fileName = System.getProperty("user.dir") + "/cert/" + fileName
				+ ".cert";
		FileOutputStream fos = null;
		ObjectOutputStream oos = null;
		try {
			File keyFile = new File(fileName);

			if (null == keyFile || !keyFile.exists()) {
				keyFile.createNewFile();
				// log.info("create file");
			}

			fos = new FileOutputStream(fileName);
			oos = new ObjectOutputStream(fos);

			oos.writeObject(kp);

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (null != oos) {
				oos.close();
			}
			if (null != fos) {
				fos.close();
			}
		}
	}

	public static void main(String[] args) throws Exception {
		// 读取私钥
//		RSAPrivateKey privk = getRSAPrivateKeyPair("redcollar_priv");

		// 读取公钥
		// KeyPair tmpKeyPair = getKeyPair("redcollar_pub");
		// RSAPublicKey pubk = (RSAPublicKey) tmpKeyPair.getPublic();
//		RSAPublicKey pubk = getRSAPublicKeyPair("redcollar_pub");

		// 待加密字符串
//		String data = "{buyer_id:1001,seller_id:1003,sellername:\"神州数码\"}";
		// 公钥加密
		// String enStr = RSAHelp.encodeHexStr(encrypt(pubk, data.getBytes()),
		// true);
//		String enStr = encryptByPubKey(pubk, data);
//		System.out.println("公钥加密字符串:" + enStr);
		// byte[] en_test1 = RSAHelp.decodeHex(enStr.toCharArray());
		// String deStr = new String(decrypt(privk,en_test1));
//		String deStr = decryptByPirvKey(privk, enStr);
		// 私钥解密
//		System.out.println("私钥解密字符串:" + deStr);
		// System.out.println(Help.encodeHexStr(encrypt1(priEEE,
		// data.getBytes()), true));

		// 私钥加密
		// enStr = RSAHelp.encodeHexStr(encryptVers(privk, data.getBytes()),
		// true);
//		enStr = encryptByPriKey(privk, data);
//		System.out.println("私钥加密字符串:" + enStr);
		// 公钥解密
		// en_test1 = RSAHelp.decodeHex(enStr.toCharArray());
		// deStr = new String(decryptVers(pubk,en_test1));
//		deStr = decryptByPubKey(pubk, enStr);
//		System.out.println("公钥解密字符串:" + deStr);

	}

}
