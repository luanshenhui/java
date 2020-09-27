package cn.rkylin.apollo.common.util;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import cn.rkylin.core.exception.BusinessException;

/**
 * Http工具类模拟浏览器的get post 提交 并传递cookie
 * 
 * @author zhangXinyuan
 */
public class HttpUtil {
	/**
	 * GET方式发送请求
	 * 
	 * @param url
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static String sendByGet(String url, String params, String cookies) throws Exception {
		return sendByGetOfBrowser(url, params, cookies);
	}

	/**
	 * POST方式发送请求
	 * 
	 * @param url
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static String sendByPost(String url, String params, String cookies) throws Exception {
		return sendByPostOfBrowser(url, params, cookies);
	}

	/**
	 * 模拟浏览器的GET提交
	 * 
	 * @param url
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static String sendByGetOfBrowser(String url, String params, String cookies) throws Exception {
		String retStr = "";
		try {
			// 创建url
			String tmpUrl = url;
			if (params != null && !"".equals(params.trim())) {
				tmpUrl += "?" + params;
			}
			URL urlObj = new URL(tmpUrl);

			// 打开http连接
			HttpURLConnection httpConn = (HttpURLConnection) (urlObj.openConnection());
			// 设置http连接属性
			httpConn.setConnectTimeout(30000);
			httpConn.setRequestMethod("GET");
			httpConn.setRequestProperty("User-Agent", "Mozilla/5.0");
			httpConn.setRequestProperty("Content-Language", "zh-cn");
			httpConn.setRequestProperty("Connection", "keep-alive");
			httpConn.setRequestProperty("Cache-Control", "no-cache");
			httpConn.setRequestProperty("Referer", "");
			// 设置cookie
			httpConn.setRequestProperty("Cookies", cookies);

			// 发送请求
			httpConn.connect();

			// 接受响应数据
			InputStream isr = httpConn.getInputStream();
			ByteArrayOutputStream bao = new ByteArrayOutputStream();
			int b;
			while ((b = isr.read()) != -1) {
				bao.write(b);
			}
			isr.close();

			// 关闭http连接
			httpConn.disconnect();

			// 返回响应数据,并设置为utf-8编码
			retStr = new String(bao.toByteArray(), "UTF-8");
		} catch (Exception e) {
			throw new BusinessException(e, "error", "网络异常");
		}

		return retStr;
	}

	/**
	 * 模拟浏览器的POST表单提交
	 * 
	 * @param url
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static String sendByPostOfBrowser(String url, String params, String cookies) throws Exception {
		String retStr = "";
		try {
			byte[] paramBytes = params.getBytes("UTF-8");

			// 创建url
			URL urlObj = new URL(url);

			// 打开http连接
			HttpURLConnection httpConn = (HttpURLConnection) (urlObj.openConnection());

			// 设置http连接属性
			httpConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			httpConn.setRequestMethod("POST");
			httpConn.setDoOutput(true);
			httpConn.setDoInput(true);

			httpConn.setRequestProperty("User-Agent", "Mozilla/5.0");
			httpConn.setRequestProperty("Content-Language", "zh-cn");
			httpConn.setRequestProperty("Content-Length", String.valueOf(paramBytes.length));
			httpConn.setRequestProperty("Connection", "keep-alive");
			httpConn.setRequestProperty("Cache-Control", "no-cache");
			httpConn.setRequestProperty("Referer", "");
			// 设置cookie
			httpConn.setRequestProperty("Cookies", cookies);

			// 发送请求数据,并设置为utf-8编码
			OutputStream out = httpConn.getOutputStream();
			out.write(paramBytes);
			out.close();

			// 接受响应数据
			InputStream isr = httpConn.getInputStream();
			ByteArrayOutputStream bao = new ByteArrayOutputStream();
			int b;
			while ((b = isr.read()) != -1) {
				bao.write(b);
			}
			isr.close();

			// 关闭http连接
			httpConn.disconnect();

			// 返回响应数据,并设置为utf-8编码
			retStr = new String(bao.toByteArray(), "ISO-8859-1");
			retStr = new String(retStr.getBytes("ISO-8859-1"), "UTF-8");
		} catch (Exception e) {
			throw new BusinessException(e, "error", "网络异常");
		}
		return retStr;
	}
}
