package com.jdecard.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.DigestUtils;

public class JdEcardUtils {
	private String Url = "http://card.jd.com/api/";
	private String customerId;
	private String privateKey;

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getPrivateKey() {
		return privateKey;
	}

	public void setPrivateKey(String privateKey) {
		this.privateKey = privateKey;
	}

	public String getUrl() {
		return Url;
	}

	public void setUrl(String url) {
		Url = url;
	}

	/**
	 * 向指定 URL 发送POST方法的请求
	 *
	 * @param url
	 * @param params
	 * @param Signature
	 * @param timestamp
	 * @return
	 */
	public String sendPost(String method, String customerId, String data,
						   String timestamp, String Signature, String version) {
		//初始化日志
		com.jdecard.common.LoggerUtil.Init();

		OutputStreamWriter out = null;
		BufferedReader in = null;
		StringBuilder result = new StringBuilder();
		try {
			String requestUrl = Url + method + "?" + "customerId=" + customerId
					+ "&data=" + base64Encode(data) + "&timestamp=" + timestamp + "&sign="
					+ Signature + "&version=";
			// URL
			URL realUrl = new URL(requestUrl);
			HttpURLConnection conn = (HttpURLConnection) realUrl
					.openConnection();
			// 发送POST请求必须设置如下两行
			conn.setDoOutput(true);
			conn.setDoInput(true);
			// POST方法
			conn.setRequestMethod("POST");

			// 设置通用的请求属性
			conn.setRequestProperty("Content-Type",
					"application/json; charset=utf-8");
			conn.connect();

			/*// 获取URLConnection对象对应的输出流
			out = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
			// 发送请求参数
			out.write(data);

			// flush输出流的缓冲
			out.flush();*/
			// 定义BufferedReader输入流来读取URL的响应
			in = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "GBK"));
			String line;
			while ((line = in.readLine()) != null) {
				result.append(line);
			}

			// 记录日志
			String LogInfo = System.getProperty("line.separator");
			LogInfo += conn.getURL() + System.getProperty("line.separator");
			LogInfo += "Content-Type:"	+ conn.getRequestProperty("Content-Type")
					+ System.getProperty("line.separator");
			LogInfo += "customerId:"+ customerId
					+ System.getProperty("line.separator");
			LogInfo += "data:"	+ data
					+ System.getProperty("line.separator");
			LogInfo += "timestamp:"	+ timestamp
					+ System.getProperty("line.separator");
			LogInfo += "sign:" + Signature
					+ System.getProperty("line.separator");
			LogInfo += "ResponseMsg:" + result
					+ System.getProperty("line.separator");
			com.jdecard.common.LoggerUtil.Info(LogInfo);


		} catch (Exception e) {
			// 记录异常
			com.jdecard.common.LoggerUtil.ErrorException(e);
		}
		// 使用finally块来关闭输出流、输入流
		finally {
			try {
				if (out != null) {
					out.close();
				}
				if (in != null) {
					in.close();
				}
			} catch (IOException ex) {
				// 记录异常
				com.jdecard.common.LoggerUtil.ErrorException(ex);
			}
		}
		return result.toString();
	}

	/**
	 * 取得UNIX时间戳
	 *
	 * @return
	 */
	public String GetTimestampStr()  throws Exception{
		return Long.toString(System.currentTimeMillis()).substring(0, 10);
	}

	/**
	 * 将UNIX时间戳转换为日期格式
	 *
	 * @return
	 */
	public String TimeStamp2Date(String timestampString, String formats)  throws Exception{
		Long timestamp = Long.parseLong(timestampString) * 1000;
		String date = new java.text.SimpleDateFormat(formats)
				.format(new java.util.Date(timestamp));
		return date;
	}

	public String md5(String data)  throws Exception{

		return DigestUtils.md5Hex(data);
	}

	/**
	 * base64解码
	 * @param data
	 * @return
	 */
	public String base64Decode(String data)  throws Exception{

		return new String(Base64.decodeBase64(data.getBytes())) ;
	}

	/**
	 * base64编码
	 * @param base64
	 * @return
	 */
	public String base64Encode(String base64)  throws Exception{

		return Base64.encodeBase64String(base64.getBytes());
	}

	/**
	 * 生成签名数据
	 *
	 * @param data
	 *            待加密的数据
	 * @param key
	 *            加密使用的key
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 */
	public String getSignature(String customerId, String data, String timestamp,String privateKey)
			throws Exception {
		// 请求签名
		return md5("customerId="+customerId+"&data="+base64Encode(data)+"&timestamp="+timestamp+"&"+privateKey);

	}
}
