package cn.com.cgbchina.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.security.PrivateKey;
import java.security.PublicKey;

import cfca.sadk.algorithm.common.PKIException;
import cfca.sadk.cgb.toolkit.BASE64Toolkit;
import cfca.sadk.cgb.toolkit.SM2Toolkit;

/**
 * 
 * 日期 : 2016年6月29日<br>
 * 作者 : 11150321050126<br>
 * 项目 : TestEncrypt<br>
 * 功能 : 工具类<br>
 */
public class SM2EncryptUtils {
	private static SM2Toolkit sm2Toolkit = null;

	/**
	 * 
	 * Description : 生成单例的sm2工具
	 * 
	 * @return
	 */
	public synchronized static SM2Toolkit getSM2Toolkit() {
		if (sm2Toolkit == null) {
			synchronized (SM2EncryptUtils.class) {
				if (sm2Toolkit == null) {
					sm2Toolkit = new SM2Toolkit();
				}
			}
		}
		return sm2Toolkit;
	}

	/**
	 * 
	 * Description : 读取公钥
	 * 
	 * @param bytes
	 * @return
	 */
	public static PublicKey readPublicKey(byte[] bytes) {
		PublicKey puk;
		try {
			puk = getSM2Toolkit().SM2BuildPublicKey(BASE64Toolkit.encode(bytes));
		} catch (PKIException e) {
			throw new RuntimeException(e);
		}
		return puk;
	}

	/**
	 * 
	 * Description : 读取私钥
	 * 
	 * @param bytes
	 * @return
	 */
	public static PrivateKey readPrivateKey(byte[] bytes) {
		PrivateKey pvk;
		try {
			pvk = getSM2Toolkit().SM2BuildPrivateKey(BASE64Toolkit.encode(bytes));
		} catch (PKIException e) {
			throw new RuntimeException(e);
		}
		return pvk;
	}

	/**
	 * 
	 * Description : 读取公钥
	 * 
	 * @param path
	 * @return
	 */
	public static PublicKey readPublicKey(String path) {
		PublicKey puk;
		try {
			puk = getSM2Toolkit().SM2BuildPublicKey(BASE64Toolkit.encode(read(path)));
		} catch (PKIException e) {
			throw new RuntimeException(e);
		}
		return puk;
	}

	/**
	 * 
	 * Description : 读取私钥
	 * 
	 * @param path
	 * @return
	 */
	public static PrivateKey readPrivateKey(String path) {
		PrivateKey pvk;
		try {
			pvk = getSM2Toolkit().SM2BuildPrivateKey(BASE64Toolkit.encode(read(path)));
		} catch (PKIException e) {
			throw new RuntimeException(e);
		}
		return pvk;
	}

	/**
	 * 
	 * Description : 读取文件
	 * 
	 * @param keyPath
	 * @return
	 */
	private static byte[] read(String keyPath) {
		try {
			FileInputStream fis = new FileInputStream(new File(keyPath));
			byte result[] = new byte[fis.available()];
			byte buffer[] = new byte[1024];
			for (int length = 0, k = 0; (k = fis.read(buffer)) != -1; length += k) {
				System.arraycopy(buffer, 0, result, length, k);
			}
			fis.close();
			return result;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
