package cn.rkylin.apollo.common.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;

import cn.rkylin.core.exception.BusinessException;

public class HttpUtils {

	/**
	 * 【通过url获得connection】
	 * 
	 * @param urlStr
	 * @return HttpURLConnection 对象
	 */
	public static HttpURLConnection getConnection(String urlStr) {
		HttpURLConnection conn = null;
		try {
			URL url = new URL(urlStr);
			conn = (HttpURLConnection) url.openConnection();
			conn.setConnectTimeout(30 * 1000);
			conn.setRequestMethod("GET");
			conn.connect();
		} catch (Exception e) {
			// Log.e("connectionError", "HttpURLConnection is error");
			return conn;
		}
		return conn;
	}

	/**
	 * 【检查url的网络状态是否通畅】
	 * 
	 * @param urlStr
	 * @return true为网络畅通 false为网络不通
	 */
	public static boolean validateUrl(String urlStr) {
		boolean netStatus = false;
		HttpURLConnection conn = null;
		try {
			URL url = new URL(urlStr);
			conn = (HttpURLConnection) url.openConnection();
			conn.setConnectTimeout(20 * 1000);
			conn.setReadTimeout(20 * 1000);
			conn.setRequestMethod("GET");
			conn.connect();
			if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
				netStatus = true;
			}
		} catch (Exception e) {
			// Log.e("netError", "network is not ok");
		} finally {
			if (conn != null) {
				conn.disconnect();
			}
		}
		return netStatus;
	}

	/**
	 * post请求
	 * 
	 * @param urlStr
	 * @param params
	 * @return
	 */
	public static HttpURLConnection getConnection(String urlStr, String params) {
		HttpURLConnection conn = null;
		try {
			URL url = new URL(urlStr);
			conn = (HttpURLConnection) url.openConnection();
			conn.setConnectTimeout(3000);
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Connection", "Keep-Alive");
			conn.setRequestProperty("Charset", "UTF-8");
			conn.setRequestProperty("Content-Length", String.valueOf(params.getBytes().length));
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			conn.connect();
			conn.getOutputStream().write(params.getBytes("UTF-8"));
		} catch (Exception e) {
			// Log.e("connectionError", "HttpURLConnection is error");
			return conn;
		}
		return conn;
	}

	/**
	 * 参数格式转换
	 * 
	 * @param urlStr
	 * @param postDatas
	 * @return
	 * @author zhangXinyuan
	 */
	public static String changeCode(String valueStr) throws BusinessException {
		try {
			// 乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化（现在已经使用）
			valueStr = new String(valueStr.getBytes("ISO-8859-1"), "UTF-8");
			String strTemp = new String(valueStr.getBytes());
			valueStr = java.net.URLEncoder.encode(strTemp, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			throw new BusinessException(e, "统一联合登录参数解析异常。", "参数格式转换异常");
		}
		return valueStr;
	}

	/**
	 * @description 【ajax回写相应信息】
	 * @param xmlString
	 * @throws IOException
	 * @author zhangXinyuan
	 */
	public static void writeString(HttpServletResponse response, String returnInfo) throws IOException {
		response.setHeader("Cache-Control", "no-cache");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.write(returnInfo);
		out.close();
	}

	/**
	 * get方式发送请求
	 * 
	 * @param url
	 * @param params
	 * @return
	 * @throws Exception
	 * @author zhangXinyuan
	 */
	public static String sendByGet(String url, String params) throws Exception {
		String retStr = "";
		try {
			// 创建url
			String tmpUrl = url;
			if (params != null) {
				tmpUrl += "?" + params;
			}
			URL urlObj = new URL(tmpUrl);

			// 打开http连接
			HttpURLConnection httpConn = (HttpURLConnection) (urlObj.openConnection());

			// 设置http连接属性
			httpConn.setConnectTimeout(30000);
			httpConn.setRequestMethod("GET");

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

			retStr = new String(bao.toByteArray());

			// 返回响应数据,并设置为utf-8编码
			// retStr=new String(bao.toByteArray(),"ISO-8859-1");
			// retStr=new String(retStr.getBytes("ISO-8859-1"),"UTF-8");

			retStr = new String(bao.toByteArray(), "UTF-8");
		} catch (Exception e) {
			throw new BusinessException(e, "error", "网络异常");
		}

		return retStr;
	}

	/**
	 * post方式发送请求
	 * 
	 * @param url
	 * @param params
	 * @return
	 * @throws Exception
	 * @author zhangXinyuan
	 */
	public static String sendByPost(String url, String params) throws Exception {
		String retStr = "";
		if (StringUtils.isNotEmpty(url) && params != null) {
			// 创建url
			URL urlObj = new URL(url);
			// 打开http连接
			HttpURLConnection httpConn = (HttpURLConnection) (urlObj.openConnection());
			// 设置http连接属性
			httpConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			httpConn.setRequestMethod("POST");
			httpConn.setDoOutput(true);
			httpConn.setDoInput(true);
			// 发送请求数据,并设置为utf-8编码
			OutputStream out = httpConn.getOutputStream();
			out.write(params.getBytes("UTF-8"));
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
		}
		return retStr;
	}
	
	/**
	 * post提交请求
	 * @param requestURL
	 * @param postData
	 * @param repeatParams
	 * @return
	 * @throws Exception
	 */
    public static String postMethod(String requestURL, Map<String, String> postData, List<String> repeatNames, List<String> repeatValues) throws Exception {  
    	  
        NameValuePair[] data = new NameValuePair[postData.entrySet().size() + repeatNames.size() + repeatValues.size()];
        int i=0;
        for(Map.Entry<String, String> entry : postData.entrySet()) {
            data[i] = new NameValuePair(entry.getKey(), entry.getValue());
            i++;
        }
        // 构造重复参数"parameterNames"
        for(String entry : repeatNames) {
            data[i] = new NameValuePair("parameterNames", entry);
            i++;
        }
        // 构造重复参数"parameterValues"
        for(String entry : repeatValues) {
            data[i] = new NameValuePair("parameterValues", entry);
            i++;
        }

        PostMethod postMethod = new PostMethod(requestURL);
        postMethod.setRequestBody(data);
        postMethod.addRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
  
        HttpClient httpClient = new HttpClient();
        String responseText = null;
  
        int statusCode = httpClient.executeMethod(postMethod);
  
        if (statusCode != 200) {
            String errorMessage = IOUtils.toString(postMethod.getResponseBodyAsStream(), postMethod.getResponseCharSet());
            throw new Exception("call failed : " + errorMessage);
        }
        responseText = IOUtils.toString(postMethod.getResponseBodyAsStream(), postMethod.getResponseCharSet());

        return responseText;
    } 
}
