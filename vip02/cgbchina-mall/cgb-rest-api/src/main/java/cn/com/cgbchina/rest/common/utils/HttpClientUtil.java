package cn.com.cgbchina.rest.common.utils;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ssl.DefaultHostnameVerifier;
import org.apache.http.conn.util.PublicSuffixMatcher;
import org.apache.http.conn.util.PublicSuffixMatcherLoader;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import cn.com.cgbchina.rest.common.exception.ConnectErrorException;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class HttpClientUtil {
	private RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(100000).setConnectTimeout(100000)
			.setConnectionRequestTimeout(100000).build();

	private static HttpClientUtil instance = null;
	private static String UTF8 = "UTF-8";

	private HttpClientUtil() {
	}

	public static HttpClientUtil getInstance() {
		if (instance == null) {
			instance = new HttpClientUtil();
		}
		return instance;
	}

	/**
	 * 发送 post请求
	 * 
	 * @param httpUrl 地址
	 */
	public String sendHttpPost(String httpUrl) {
		HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
		return sendHttpPost(httpPost, UTF8);
	}

	/**
	 * 发送 post请求
	 * 
	 * @param httpUrl 地址
	 * @param params 参数(格式:key1=value1&key2=value2)
	 */
	public String sendHttpPost(String httpUrl, String params) {
		HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
		try {
			// 设置参数
			StringEntity stringEntity = new StringEntity(params, UTF8);
			stringEntity.setContentType("application/x-www-form-urlencoded");
			httpPost.setEntity(stringEntity);
		} catch (Exception e) {
			throw new ConnectErrorException("【httpclient请求异常】", e);
		}
		return sendHttpPost(httpPost, UTF8);
	}

	/**
	 * 发送 post请求
	 * 
	 * @param httpUrl 地址
	 * @param params 参数(格式:key1=value1&key2=value2)
	 */
	public String sendHttpPost(String httpUrl, Map<String,String> headers, String body) {
		HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
		try {
			// 设置参数
			StringEntity stringEntity = new StringEntity(body, UTF8);
			stringEntity.setContentType("application/x-www-form-urlencoded");
			httpPost.setEntity(stringEntity);
			if (headers != null) {
				Set<Entry<String, String>> set = headers.entrySet();
				for (Entry<String, String> entry : set) {
					httpPost.addHeader(entry.getKey(), entry.getValue());
				}
			}
		} catch (Exception e) {
			throw new ConnectErrorException("【httpclient请求异常】", e);
		}
		return sendHttpPost(httpPost, UTF8);
	}
	
	/**
	 * 发送 post请求
	 * 
	 * @param httpUrl 地址
	 * @param params 参数(格式:key1=value1&key2=value2)
	 */
	public String sendHttpPost(String httpUrl, String params, String character) {
		HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
		try {
			// 设置参数
			StringEntity stringEntity = new StringEntity(params, character);
			stringEntity.setContentType("application/x-www-form-urlencoded");
			httpPost.setEntity(stringEntity);
		} catch (Exception e) {
			throw new ConnectErrorException("【httpclient请求异常】", e);
		}
		return sendHttpPost(httpPost, character);
	}

	/**
	 * 
	 * Description : httppost 带 header的请求
	 * 
	 * @param httpUrl
	 * @param params 参数(格式:key1=value1&key2=value2)
	 * @param headers 头
	 * @param character 字符集
	 * @return
	 */
	public String sendHttpPost(String httpUrl, String params, Map<String, String> headers, String character) {
		HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
		try {
			if (StringUtils.isEmpty(character)) {
				character = "UTF-8";
			}
			// 设置参数
			StringEntity stringEntity = new StringEntity(params, character);
			httpPost.setConfig(this.requestConfig);
			httpPost.setEntity(stringEntity);
			if (headers != null) {
				Set<Entry<String, String>> set = headers.entrySet();
				for (Entry<String, String> entry : set) {
					httpPost.addHeader(entry.getKey(), entry.getValue());
				}
			}
		} catch (Exception e) {
			log.error(e.getMessage(), e);
			throw new ConnectErrorException("【httpclient请求异常】",e);
		}
		return sendHttpPost(httpPost, character);
	}

	/**
	 * 
	 * Description : 发送 post请求
	 * 
	 * @param httpUrl
	 * @param headers 请求头
	 * @param maps 参数
	 * @return
	 */
	public String sendHttpPost(String httpUrl, Map<String, String> headers, Map<String, String> maps) {
		HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
		try {
			// 创建参数队列
			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			Set<Entry<String, String>> set = maps.entrySet();
			for (Entry<String, String> entry : set) {
				nameValuePairs.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
			}
			httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs, UTF8));
			// 设置头
			if (headers != null) {
				Set<Entry<String, String>> headerSet = headers.entrySet();
				for (Entry<String, String> entry : headerSet) {
					httpPost.addHeader(entry.getKey(), entry.getValue());
				}
			}
		} catch (Exception e) {
			throw new ConnectErrorException("【httpclient请求异常】", e);
		}

		return sendHttpPost(httpPost, UTF8);
	}

	/**
	 * 发送 post请求
	 * 
	 * @param httpUrl 地址
	 * @param maps 参数
	 */
	public String sendHttpPost(String httpUrl, Map<String, String> maps) {
		HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
		// 创建参数队列
		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
		Set<Entry<String, String>> set = maps.entrySet();
		for (Entry<String, String> entry : set) {
			nameValuePairs.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
		}
		try {
			httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs, UTF8));
		} catch (Exception e) {
			throw new ConnectErrorException("【httpclient请求异常】", e);
		}
		return sendHttpPost(httpPost, UTF8);
	}

	/**
	 * 发送 post请求
	 * 
	 * @param httpUrl 地址
	 * @param maps 参数
	 */
	public String sendHttpPost(String httpUrl, List<NameValuePair> nameValuePairs, String character) {
		HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
		try {
			httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs, character));
		} catch (Exception e) {
			throw new ConnectErrorException("【httpclient请求异常】", e);
		}
		return sendHttpPost(httpPost, character);
	}

	public static void main(String[] args) {
		System.out.println(HttpClientUtil.getInstance().sendHttpPost("http://www.baidu.com"));
	}

	/**
	 * 发送 post请求（带文件）
	 * 
	 * @param httpUrl 地址
	 * @param maps 参数
	 * @param fileLists 附件
	 */
	public String sendHttpPost(String httpUrl, Map<String, String> maps, List<File> fileLists) {
		HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
		MultipartEntityBuilder meBuilder = MultipartEntityBuilder.create();
		for (String key : maps.keySet()) {
			meBuilder.addPart(key, new StringBody(maps.get(key), ContentType.TEXT_PLAIN));
		}
		for (File file : fileLists) {
			FileBody fileBody = new FileBody(file);
			meBuilder.addPart("files", fileBody);
		}
		HttpEntity reqEntity = meBuilder.build();
		httpPost.setEntity(reqEntity);
		return sendHttpPost(httpPost, UTF8);
	}

	/**
	 * 发送Post请求
	 * 
	 * @param httpPost
	 * @return
	 */
	private String sendHttpPost(HttpPost httpPost, String character) {
		CloseableHttpClient httpClient = null;
		CloseableHttpResponse response = null;
		HttpEntity entity = null;
		String responseContent = null;
		try {
			// 创建默认的httpClient实例.
			httpClient = HttpClients.createDefault();
			httpPost.setConfig(requestConfig);
			// 执行请求
			response = httpClient.execute(httpPost);
			entity = response.getEntity();
			responseContent = EntityUtils.toString(entity, character);
		} catch (Exception e) {
			throw new ConnectErrorException("【httpclient请求异常】", e);
		} finally {
			try {
				// 关闭连接,释放资源
				if (response != null) {
					response.close();
				}
				if (httpClient != null) {
					httpClient.close();
				}
			} catch (IOException e) {
				throw new ConnectErrorException("【httpclient请求异常】", e);
			}
		}
		return responseContent;
	}

	/**
	 * 发送 get请求
	 * 
	 * @param httpUrl
	 */
	public String sendHttpGet(String httpUrl) {
		HttpGet httpGet = new HttpGet(httpUrl);// 创建get请求
		return sendHttpGet(httpGet, UTF8);
	}

	/**
	 * 发送 get请求Https
	 * 
	 * @param httpUrl
	 */
	public String sendHttpsGet(String httpUrl) {
		HttpGet httpGet = new HttpGet(httpUrl);// 创建get请求
		return sendHttpsGet(httpGet);
	}

	/**
	 * 发送Get请求
	 * 
	 * @param httpPost
	 * @return
	 */
	private String sendHttpGet(HttpGet httpGet, String character) {
		CloseableHttpClient httpClient = null;
		CloseableHttpResponse response = null;
		HttpEntity entity = null;
		String responseContent = null;
		try {
			// 创建默认的httpClient实例.
			httpClient = HttpClients.createDefault();
			httpGet.setConfig(requestConfig);
			// 执行请求
			response = httpClient.execute(httpGet);
			entity = response.getEntity();
			responseContent = EntityUtils.toString(entity, character);
		} catch (Exception e) {
			throw new ConnectErrorException("【httpclient请求异常】",e);
		} finally {
			try {
				// 关闭连接,释放资源
				if (response != null) {
					response.close();
				}
				if (httpClient != null) {
					httpClient.close();
				}
			} catch (IOException e) {
				throw new ConnectErrorException("【httpclient请求异常】",e);
			}
		}
		return responseContent;
	}

	/**
	 * 发送Get请求Https
	 * 
	 * @param httpPost
	 * @return
	 */
	private String sendHttpsGet(HttpGet httpGet) {
		CloseableHttpClient httpClient = null;
		CloseableHttpResponse response = null;
		HttpEntity entity = null;
		String responseContent = null;
		try {
			// 创建默认的httpClient实例.
			PublicSuffixMatcher publicSuffixMatcher = PublicSuffixMatcherLoader
					.load(new URL(httpGet.getURI().toString()));
			DefaultHostnameVerifier hostnameVerifier = new DefaultHostnameVerifier(publicSuffixMatcher);
			httpClient = HttpClients.custom().setSSLHostnameVerifier(hostnameVerifier).build();
			httpGet.setConfig(requestConfig);
			// 执行请求
			response = httpClient.execute(httpGet);
			entity = response.getEntity();
			responseContent = EntityUtils.toString(entity, UTF8);
		} catch (Exception e) {
			throw new ConnectErrorException("【httpclient请求异常】",e);
		} finally {
			try {
				// 关闭连接,释放资源
				if (response != null) {
					response.close();
				}
				if (httpClient != null) {
					httpClient.close();
				}
			} catch (IOException e) {
				throw new ConnectErrorException("【httpclient请求异常】",e);
			}
		}
		return responseContent;
	}
}
