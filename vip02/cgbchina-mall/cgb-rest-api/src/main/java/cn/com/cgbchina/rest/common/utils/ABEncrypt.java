package cn.com.cgbchina.rest.common.utils;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;

import com.sun.jna.Library;
import com.sun.jna.Native;

public class ABEncrypt {
	public interface IABEncrypt extends Library {
		/*IABEncrypt instance = (IABEncrypt) Native.loadLibrary(System.getProperty("sys.dir")
                +File.separator+"src"+File.separator+"libcryptAPIc", IABEncrypt.class);*/
		IABEncrypt instance = (IABEncrypt) Native.loadLibrary(PropertieUtils.getParam().get("key.file.path") , IABEncrypt.class);
		/*IABEncrypt instance = (IABEncrypt) Native.loadLibrary(System.getProperty("user.dir")
				 +File.separator+"src"+File.separator+"libcryptAPIc" + File.separator + "libcryptAPIc.dll", IABEncrypt.class);*/
		/**
		 *
		 * @param flag 		0-加密；1-解密
		 * @param srcdata	源数据
		 * @param srclen	源数据长度
		 * @param retdata	返回数据
		 * @param retlen	输入时，用于指明redata缓冲区大小；输出时，指明实际返回的数据长度
		 * @param yin		加密因子，可以是任务字符，加密使用的因子与解密使用的因子须相同。ABC不同，加密因子定义值应不相同。
		 * @param yinlen	加密因子长度
		 * @return	0表示成功，其它表示失败
		 */
		public int DesCrypt1(int flag, byte[] srcdata, int srclen, byte[] retdata, int[] retlen, byte[] yin,int yinlen);



		/**
		 *
		 * @param macData 	MAC数据
		 * @param maclen	MAC数据长度
		 * @param retdata	返回MAC值
		 * @param retlen	输入时，用于指明retdata缓冲区大小；输出时，指明实际返回的MAC值长度
		 * @return	0表示成功，其它表示失败
		 */
		public int MD5Crypt(String macData, int maclen, byte[] retdata, int[] retlen);

	}
	/**
	 * 加密
	 * @param srcData
	 * @param yin
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static String Encrypt(String srcData,String yin) throws UnsupportedEncodingException{
		if(srcData ==  null || yin == null){
			return null;
		}
		int ret = -30;
		byte[] retdata = new byte[10240];
		int [] retlen = new int[1];
		retlen[0] = retdata.length;
		ret = IABEncrypt.instance.DesCrypt1(0, srcData.getBytes("GBK"), srcData.getBytes("GBK").length, retdata, retlen, yin.getBytes("GBK"), yin.getBytes("GBK").length);
		System.out.println("ret ="+ret );
		if(ret == 0){
			byte[] temp = new byte[retlen[0]];
			System.arraycopy(retdata, 0, temp, 0, retlen[0]);
			return byteArr2HexStr(temp);
		}else if(ret == -15){
			retdata = new byte[srcData.getBytes().length*2];
			ret = IABEncrypt.instance.DesCrypt1(0, srcData.getBytes("GBK"), srcData.getBytes("GBK").length, retdata, retlen, yin.getBytes("GBK"), yin.getBytes("GBK").length);
			if( ret == 0){
				byte[] temp = new byte[retlen[0]];
				System.arraycopy(retdata, 0, temp, 0, retlen[0]);

				return byteArr2HexStr(temp);
			}
		}

		return null;
	}
	/**
	 * 解密
	 * @param srcData
	 * @param yin
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static String DesCrypt(byte[] srcData , String yin) throws UnsupportedEncodingException{
		String retStr = "";
		if(srcData ==  null || yin == null){
			return retStr;
		}
		int ret = -30;
		byte[] retdata = new byte[10240];
		int [] retlen = new int[1];
		retlen[0] = retdata.length;
		System.out.println(""+srcData);
		//转为字节数组
		ret = IABEncrypt.instance.DesCrypt1(1, srcData, srcData.length, retdata, retlen, yin.getBytes("GBK"), yin.getBytes("GBK").length);
		System.out.println("ret="+ret);
		if(ret == 0){
			byte[] temp = new byte[retlen[0]];
			System.arraycopy(retdata, 0, temp, 0, retlen[0]);
			return new String(temp,"GBK");
		}else if(ret == -15){
			retdata = new byte[srcData.length*2];
			ret = IABEncrypt.instance.DesCrypt1(1, srcData, srcData.length, retdata, retlen, yin.getBytes("GBK"), yin.getBytes("GBK").length);
			if( ret == 0){
				byte[] temp = new byte[retlen[0]];
				System.arraycopy(retdata, 0, temp, 0, retlen[0]);
				return new String(temp,"GBK");
			}
		}

		return retStr;

	}
	/**
	 *
	 * @param srcData 对data进行md5加密得到md5
	 * @return
	 */
	public static String getMd5(String srcData){
		String retStr = null;
		if(srcData ==  null ){
			return retStr;
		}
		int ret = -30;
		byte[] retdata = new byte[10240];
		int [] retlen = new int[1];
		retlen[0] = retdata.length;
		ret = IABEncrypt.instance.MD5Crypt(srcData, srcData.length(), retdata, retlen);
		if(ret == 0){
			byte[] temp = new byte[retlen[0]];
			System.arraycopy(retdata, 0, temp, 0, retlen[0]);
			return byteArr2HexStr(temp);
		}else if(ret == -15){
			retdata = new byte[srcData.getBytes().length*2];
			ret = IABEncrypt.instance.MD5Crypt(srcData, srcData.length(), retdata, retlen);
			if( ret == 0){
				byte[] temp = new byte[retlen[0]];
				System.arraycopy(retdata, 0, temp, 0, retlen[0]);

				return byteArr2HexStr(temp);
			}
		}
		return retStr;
	}
	/**
	 * 将byte数组转换为表示16进制值的字符串， 如：byte[]{8,18}转换为：0813， 和public static byte[]
	 * hexStr2ByteArr(String strIn) 互为可逆的转换过程
	 *
	 * @param arrB
	 *            需要转换的byte数组
	 * @return 转换后的字符串
	 * @throws Exception
	 *             本方法不处理任何异常，所有异常全部抛出
	 */
	public static String byteArr2HexStr(byte[] arrB) {
		int iLen = arrB.length;
		// 每个byte用两个字符才能表示，所以字符串的长度是数组长度的两倍
		StringBuffer sb = new StringBuffer(iLen * 2);
		for (int i = 0; i < iLen; i++) {
			int intTmp = arrB[i];
			// 把负数转换为正数
			while (intTmp < 0) {
				intTmp = intTmp + 256;
			}
			// 小于0F的数需要在前面补0
			if (intTmp < 16) {
				sb.append("0");
			}
			sb.append(Integer.toString(intTmp, 16));
		}
		return sb.toString();
	}

	/**
	 * 将表示16进制值的字符串转换为byte数组， 和public static String byteArr2HexStr(byte[] arrB)
	 * 互为可逆的转换过程
	 *
	 * @param strIn
	 *            需要转换的字符串
	 * @return 转换后的byte数组
	 * @throws Exception
	 *             本方法不处理任何异常，所有异常全部抛出
	 * @author <a href="mailto:leo841001@163.com">LiGuoQing</a>
	 */
	public static byte[] hexStr2ByteArr(String strIn) {
		byte[] arrB = strIn.getBytes();
		int iLen = arrB.length;

		// 两个字符表示一个字节，所以字节数组长度是字符串长度除以2
		byte[] arrOut = new byte[iLen / 2];
		for (int i = 0; i < iLen; i = i + 2) {
			String strTmp = new String(arrB, i, 2);
			arrOut[i / 2] = (byte) Integer.parseInt(strTmp, 16);
		}
		return arrOut;
	}

	//BIN_LIB为JAR包中存放DLL的路径
	//getResourceAsStream以JAR中根路径为开始点
	private synchronized static String loadLib()  {
		String systemType = System.getProperty("os.name");
		System.out.println(systemType);
		String libExtension = (systemType.toLowerCase().indexOf("win")!=-1) ? ".dll" : ".so";

		String libFullName = "libcryptAPIc" + libExtension;

		String nativeTempDir = System.getProperty("user.dir")+libFullName;
		return nativeTempDir;
		/*
		InputStream in = null;
		InputStream in1 = null;
		BufferedInputStream reader = null;
		BufferedInputStream reader1 = null;
		FileOutputStream writer = null;
		FileOutputStream writer1 = null;
		
		File extractedLibFile = new File(nativeTempDir+File.separator+libFullName);
		File extractedLibFile1 = new File(nativeTempDir+File.separator+libFullName1);
		System.out.println(extractedLibFile+"----"+extractedLibFile1);
		if(!extractedLibFile.exists()){
			try {
				in = ABEncrypt.class.getResourceAsStream("classpath:config/" + libFullName);
				in1 = ABEncrypt.class.getResourceAsStream("classpath:config/" + libFullName1);
				if(in==null){
					System.out.println("null");
					in =  ABEncrypt.class.getResourceAsStream(libFullName);
					in1 =  ABEncrypt.class.getResourceAsStream(libFullName1);
				}
				ABEncrypt.class.getResource("classpath:config/"+libFullName);
				ABEncrypt.class.getResource("classpath:config/"+libFullName1);
				reader = new BufferedInputStream(in);
				reader1 = new BufferedInputStream(in1);
				writer = new FileOutputStream(extractedLibFile);
				writer1 = new FileOutputStream(extractedLibFile1);
				
				byte[] buffer = new byte[1024];
				
				while (reader.read(buffer) > 0){
					writer.write(buffer);
					buffer = new byte[1024];
				}
				while (reader1.read(buffer) > 0){
					writer1.write(buffer);
					buffer = new byte[1024];
				}
			} catch (IOException e){
				e.printStackTrace();
			} finally {
				try{
				if(in!=null)
					in.close();
				if(writer!=null)
					writer.close();
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		System.out.println("path---"+System.getProperty("java.library.path"));
		*/
		//return(nativeTempDir.toString());
	}

}
