package com.letv.common;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.codec.digest.HmacUtils;

public class LevpUtils {

	private String Url ;
	private String Channel;
	private String Api_secret;

	/**
	 * 向指定 URL 发送POST方法的请求
	 *
	 * @param url
	 * @param params
	 * @param Signature
	 * @param timestamp
	 * @return
	 */
	public String sendPost(String method ,String token, String Signature,
						   String timestamp, String body) {
		//初始化日志
		com.letv.common.LoggerUtil.Init();

		OutputStreamWriter out = null;
		BufferedReader in = null;
		StringBuilder result = new StringBuilder();
		try {
			//URL
			URL realUrl = new URL(Url+method);
			HttpURLConnection conn = (HttpURLConnection) realUrl
					.openConnection();
			// 发送POST请求必须设置如下两行
			conn.setDoOutput(true);
			conn.setDoInput(true);
			// POST方法
			conn.setRequestMethod("POST");

			// 设置通用的请求属性
			conn.setRequestProperty("Content-Type","application/json; charset=utf-8");
			//乐视方通道
			conn.setRequestProperty("X-Le-Channel", Channel);
			//签名
			conn.setRequestProperty("X-Le-Signature", Signature);
			//时间戳
			conn.setRequestProperty("X-Le-Timestamp", timestamp);
			if (token != "") {
				//token
				conn.setRequestProperty("X-Le-Token", token);
			}
			conn.connect();

			// 获取URLConnection对象对应的输出流
			out = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
			// 发送请求参数
			out.write(body);

			// flush输出流的缓冲
			out.flush();
			// 定义BufferedReader输入流来读取URL的响应
			in = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "UTF-8"));
			String line;
			while ((line = in.readLine()) != null) {
				result.append(line);
			}

			//记录日志
			String LogInfo = System.getProperty("line.separator");
			LogInfo += conn.getURL() + System.getProperty("line.separator");
			LogInfo += "Content-Type:"+conn.getRequestProperty("Content-Type") + System.getProperty("line.separator");
			LogInfo += "X-Le-Channel:"+conn.getRequestProperty("X-Le-Channel")+ System.getProperty("line.separator");
			LogInfo += "X-Le-Signature:"+conn.getRequestProperty("X-Le-Signature") + System.getProperty("line.separator");
			LogInfo += "X-Le-Timestamp:"+conn.getRequestProperty("X-Le-Timestamp") + System.getProperty("line.separator");
			if (token != "") {
				LogInfo += "X-Le-Token:"+conn.getRequestProperty("X-Le-Token")+ System.getProperty("line.separator");
			}
			LogInfo += "RequestBody:"+body + System.getProperty("line.separator");
			LogInfo += "ResponseMsg:"+result + System.getProperty("line.separator");
			com.letv.common.LoggerUtil.Info(LogInfo);

		} catch (Exception e) {
			//记录异常
			com.letv.common.LoggerUtil.ErrorException(e);
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
				//记录异常
				com.letv.common.LoggerUtil.ErrorException(ex);
			}
		}
		return result.toString();
	}

	/**

	 * 向指定 URL 发送GET请求
	 *
	 * @param Signature
	 * @param timestamp
	 * @param token
	 * @return
	 */
	public String sendGet(String Signature, String timestamp, String token,
						  String account) {
		String result = "";
		BufferedReader in = null;
		try {
			URL realUrl = new URL(
					Url
							+ "/backend-membership-charge/open/v1/channel_user?account="
							+ account);
			// 打开和URL之间的连接
			URLConnection connection = realUrl.openConnection();
			// 设置通用的请求属性
			connection.setRequestProperty("Content-Type",
					"application/json; charset=utf-8");
			connection.setRequestProperty("X-Le-Channel", Channel);
			connection.setRequestProperty("X-Le-Token", token);
			connection.setRequestProperty("X-Le-Signature", Signature);
			connection.setRequestProperty("X-Le-Timestamp", timestamp);

			// 建立实际的连接
			connection.connect();
			// 定义 BufferedReader输入流来读取URL的响应
			in = new BufferedReader(new InputStreamReader(
					connection.getInputStream()));
			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}

			// 记录日志
			StringBuffer mess = new StringBuffer();
			mess.append(System.getProperty("line.separator")
					+ "Content-Typel:application/json; charset=utf-8"
					+ System.getProperty("line.separator"));
			mess.append("X-Le-Channel:" + Channel
					+ System.getProperty("line.separator"));
			mess.append("X-Le-Token:" + token
					+ System.getProperty("line.separator"));
			mess.append("X-Le-Signature:" + Signature
					+ System.getProperty("line.separator"));
			mess.append("X-Le-Timestamp:" + timestamp
					+ System.getProperty("line.separator"));
			mess.append("RequestUrl:"
					+ Url
					+ "/backend-membership-charge/open/v1/channel_user?account="
					+ account + System.getProperty("line.separator"));
			mess.append( "ResponseMsg:"+result + System.getProperty("line.separator"));
			com.letv.common.LoggerUtil.Info(mess.toString());

		} catch (Exception e) {
			com.letv.common.LoggerUtil.ErrorException(e);
		}
		// 使用finally块来关闭输入流
		finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (Exception e2) {
				com.letv.common.LoggerUtil.ErrorException(e2);
			}
		}
		return result;

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
	public String getSignature(String QS, String BS, String TS)
			throws Exception {
		// 请求签名
		String data = "QS="+QS+"&BS=" + BS + "&TS=" + TS;
		return HmacUtils.hmacSha1Hex(Api_secret, data);

	}


	/**
	 * 取得UNIX时间戳
	 *
	 * @return
	 */
	public String GetTimestampStr()
	{
		return Long.toString(System.currentTimeMillis()).substring(0,10);
	}

	public String getUrl() {
		return Url;
	}

	public void setUrl(String url) {
		Url = url;
	}

	public String getChannel() {
		return Channel;
	}

	public void setChannel(String channel) {
		Channel = channel;
	}

	public String getApi_secret() {
		return Api_secret;
	}

	public void setApi_secret(String api_secret) {
		Api_secret = api_secret;
	}


	/**
	 * 将UNIX时间戳转换为日期格式
	 *
	 * @return
	 */
	public String TimeStamp2Date(String timestampString, String formats) throws Exception{
		Long timestamp = Long.parseLong(timestampString)*1000;
		String date = new java.text.SimpleDateFormat(formats).format(new java.util.Date(timestamp));
		return date;
	}
}
