package cn.com.cgbchina.restful.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.cgbchina.common.utils.NetworkUtil;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.utils.HttpClientUtil;

/**
 * 
 * 日期 : 2016年8月18日<br>
 * 作者 : 11150321050126<br>
 * 项目 : cgb-restful<br>
 * 功能 : Transfer HTTP request<br>
 */
@Controller
@Slf4j
public class TransferController {
	private static final String IPLISTPATH = "/iplist";
	private List<String> ipAddressList = new ArrayList<>(0);

	@RequestMapping("/testTransfer")
	@ResponseBody
	public String testTransfer(HttpServletRequest request) throws IOException {
		String ipAddress = NetworkUtil.getIpAddress(request);
		String ipAddressLog = "[" + ipAddress + "] ";
		String character = getCharacter(request);
		String bodyStr=this.getStream(request, character);
		if (log.isDebugEnabled()) {
			log.debug("--------------------------testTransfer-----------------------");
			log.debug(ipAddressLog + " Header Info:\n" + getHeaderInfo(request));
			log.debug(ipAddressLog+" BodyMap Info:\n"+getBodyInfo(request.getParameterMap()));
			log.debug(ipAddressLog+" BodyStream Info:\n"+bodyStr);
		}
		return "Receive request!";
	}

	/**
	 * 
	 * Description : Transfer request
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/transfer")
	@ResponseBody
	public String transfer(HttpServletRequest request, HttpServletResponse response) {
		String ipAddress = NetworkUtil.getIpAddress(request);
		String ipAddressLog = "[" + ipAddress + "] ";
		Map<String,String[]> bodyMap=request.getParameterMap();
		String bodyStr=null;
		try {
			// 获取请求的字符集,默认是UTF-8的编码
			String character = getCharacter(request);
			bodyStr=this.getStream(request, character);
			String contentType=request.getContentType();
			
			// 打印请求信息
			if (log.isDebugEnabled()) {
				log.debug(ipAddressLog + " Header Info:\n" + getHeaderInfo(request));
				log.debug(ipAddressLog+" BodyMap Info:\n"+getBodyInfo(bodyMap));
				log.debug(ipAddressLog+" BodyStream Info:\n"+bodyStr);
			}

			// 校验ip的合法性
			String validResult = validIp(ipAddress, ipAddressLog);
			if (StringUtils.isNotEmpty(validResult)) {
				// 不合法的设置请求失败，并且返回结果
				response.setStatus(HttpStatus.BAD_REQUEST.value());
				return validResult;
			}

			// 获取转发的url
			String url = request.getHeader(Constant.FORWARD_URL);
			// 判断是否为空，如果是则返回http status 400
			if (StringUtils.isEmpty(url)) {
				response.setStatus(HttpStatus.BAD_REQUEST.value());
				String alert = "No "+Constant.FORWARD_URL+" in the request header";
				log.info(ipAddressLog + alert);
				return alert;
			}

			String result = null;
			// 判断请求方式
			if (!request.getMethod().toUpperCase().equals("POST") && !request.getMethod().toUpperCase().equals("GET")) {
				response.setStatus(HttpStatus.METHOD_NOT_ALLOWED.value());
				String alert = "Request only supports GET and POST";
				log.info(ipAddressLog + alert);
				return alert;
			}


			if (request.getMethod().toUpperCase().equals("POST")) {
				// 转换数据并以POST发送
				if(!bodyMap.isEmpty()){
					result = sendPost(bodyMap,contentType, ipAddressLog, url, character);
				}else{
					result = sendPost(bodyStr,contentType, ipAddressLog, url, character);
				}
			} else {
				// 转换数据并以GET发送
				result = sendGet(request, ipAddressLog, url, character);
			}

			if (log.isDebugEnabled()) {
				log.debug(ipAddressLog + "Url:" + url + "\n Result Data:" + result);
			}
			return result;
		} catch (Exception e) {
			String requestErr = "Request Error";
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.append("[");
			stringBuilder.append(requestErr);
			stringBuilder.append("]");
			stringBuilder.append(ipAddressLog);
			stringBuilder.append("Header Info:\n");
			stringBuilder.append(getHeaderInfo(request));
			stringBuilder.append("\n");
			stringBuilder.append(createSpace(ipAddressLog.length()));
			stringBuilder.append("BodyMap Info:\n");
			stringBuilder.append(bodyMap);
			stringBuilder.append("BodyStream Info:\n");
			stringBuilder.append(bodyStr);
			log.error(stringBuilder.toString(), e);
			response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
			return requestErr;
		}

	}

	/**
	 * 
	 * Description : Send get request
	 * 
	 * @param request
	 * @param ipAddressLog
	 * @param url
	 * @param character
	 * @return
	 */
	private String sendGet(HttpServletRequest request, String ipAddressLog, String url, String character) {
		// 遍历得到的数据，包装转发数据
		String result;
		List<NameValuePair> nameValuePairs = packingParam(request);
		String param = URLEncodedUtils.format(nameValuePairs, character);
		url += "?" + param;
		if (log.isDebugEnabled()) {
			log.debug(ipAddressLog + "Url:" + url);
		}
		// 发送get数据
		result = HttpClientUtil.getInstance().sendHttpGet(url);
		return result;
	}

	/**
	 * 
	 * Description : Packing parameter
	 * 
	 * @param request
	 * @return
	 */
	private List<NameValuePair> packingParam(HttpServletRequest request) {
		Map<String, String[]> maps = request.getParameterMap();
		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(0);
		Set<Entry<String, String[]>> set = maps.entrySet();
		for (Entry<String, String[]> entry : set) {
			if (entry.getValue() != null) {
				for (String vals : entry.getValue()) {
					nameValuePairs.add(new BasicNameValuePair(entry.getKey(), vals));
				}
			}

		}
		return nameValuePairs;
	}
	
	/**
	 * 
	 * Description : Get request stream
	 * 
	 * @param request
	 * @param character
	 * @return
	 * @throws IOException
	 */
	private String getStream(HttpServletRequest request, String character) throws IOException{
		InputStream is = request.getInputStream();
		InputStreamReader isr = new InputStreamReader(is, character);
		StringBuffer sb = new StringBuffer();
		char chars[] = new char[1024];
		int k = 0;
		while ((k = isr.read(chars)) != -1) {
			sb.append(chars, 0, k);
		}
		isr.close();
		is.close();
		return sb.toString();
		
	}

	/**
	 * 
	 * Description : Send post request
	 * 
	 * @param request
	 * @param ipAddressLog
	 * @param url
	 * @param character
	 * @return
	 * @throws IOException 
	 */
	private String sendPost(String bodyStr,String contentType, String ipAddressLog, String url, String character) {
		// 遍历得到的数据，包装转发数据
		String result;
		if (log.isDebugEnabled()) {
			log.debug(ipAddressLog + "Url:" + url + "\n Send Data:" + bodyStr);
		}
		Map<String, String> header=new HashMap<String, String>();
		header.put("Content-Type", contentType);
		// 发送post数据
		result = HttpClientUtil.getInstance().sendHttpPost(url,header, bodyStr);
		return result;
	}
	
	/**
	 * 
	 * Description : Send post request
	 * 
	 * @param request
	 * @param ipAddressLog
	 * @param url
	 * @param character
	 * @return
	 * @throws IOException 
	 */
	private String sendPost(Map<String,String[]> bodyMap,String contentType, String ipAddressLog, String url, String character) {
		// 遍历得到的数据，包装转发数据
		StringBuffer sb=new StringBuffer();
		Set<Entry<String, String[]>> set = bodyMap.entrySet();
		for(Entry<String, String[]> entry:set){
			for(String str:entry.getValue()){
				sb.append(entry.getKey()).append("=").append(str).append("&");
			}
		}
		String bodyStr = sb.length()>0?sb.substring(0,sb.length()-1):sb.toString();
		return sendPost(bodyStr,contentType, ipAddressLog, url, character);
	}

	/**
	 * 
	 * Description : Get character , default is UTF-8
	 * 
	 * @param response
	 * @return
	 */
	private String getCharacter(HttpServletRequest request) {
		String character = "UTF-8";
		String contentType = request.getContentType();
		if (StringUtils.isNotEmpty(contentType)) {
			String strs[] = contentType.split(";");
			for (String s : strs) {
				int local = s.indexOf("charset=");
				if (local > -1) {
					String split[] = s.split("=");
					character = split[1].trim();
					break;
				}
			}
		}
		return character;
	}

	/**
	 * 
	 * Description : Validate IP
	 * 
	 * @param ipAddress
	 * @param ipAddressLog
	 * @param response
	 * @return
	 */
	private String validIp(String ipAddress, String ipAddressLog) {
		// 判断ip是否为空
		if (StringUtils.isEmpty(ipAddress)) {
			String alert = "Request IP is empty";
			log.info(ipAddressLog + alert);
			return alert;
		}
		// 查询ip是否在白名单中
		for (String str : ipAddressList) {
			if (ipAddress.equals(str)) {
				return null;
			}
		}
		String alert = "Request IP does not exist in the white list";
		log.info(ipAddressLog + alert);
		return alert;
	}

	/**
	 * 
	 * Description : Read Ip list file
	 */
	@PostConstruct
	public void readProperties() {
		try {
			InputStream ipListStream = this.getClass().getResourceAsStream(IPLISTPATH);
			if (ipListStream == null) {
				throw new IOException("[IP list file does not exist]");
			}

			String comment = "#";
			BufferedReader readIpList = new BufferedReader(new InputStreamReader(ipListStream));
			String line = null;
			while ((line = readIpList.readLine()) != null) {
				if (StringUtils.isNotEmpty(line)) {
					String firstChar = line.substring(0, 1);
					// 如果是#开头的或者不是ip格式的不插入到list中
					if (!comment.equals(firstChar) && NetworkUtil.isIpAddress(line)) {
						ipAddressList.add(line);
					}
				}
			}
		} catch (IOException e) {
			log.error("[Failed to read IP list file. File path is \"" + IPLISTPATH + "\"]", e);
		}
	}

	private String createSpace(int length) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < length; i++) {
			sb.append(" ");
		}
		return sb.toString();
	}

	/**
	 * 
	 * Description : Get HTTP request header info
	 * 
	 * @param request
	 * @return
	 */
	private String getHeaderInfo(HttpServletRequest request) {
		StringBuffer sb = new StringBuffer();
		Enumeration<String> names = request.getHeaderNames();
		while (names.hasMoreElements()) {
			String name = names.nextElement();
			sb.append("-----------");
			sb.append(name);
			sb.append("=");
			sb.append(request.getHeader(name));
			sb.append("\n");
		}
		return sb.toString();
	}

	/**
	 * 
	 * Description : Get HTTP request body info
	 * 
	 * @param request
	 * @return
	 */
	private String getBodyInfo(Map<String, String[]> map) {
		StringBuffer sb = new StringBuffer();
		Set<Entry<String, String[]>> set = map.entrySet();
		for (Entry<String, String[]> entry : set) {
			sb.append("-----------");
			sb.append(entry.getKey());
			sb.append("=");
			sb.append(arrConvertStr(entry.getValue()));
			sb.append("\n");
		}
		return sb.toString();
	}
	
	/**
	 * 
	 * Description : Array conver to string
	 * 
	 * @param arr
	 * @return
	 */
	private String arrConvertStr(String[] arr) {
		StringBuffer sb = new StringBuffer("[");
		for (int i = 0; i < arr.length; i++) {
			sb.append(arr[i]);
			if (i + 1 < arr.length) {
				sb.append(",");
			}
		}
		sb.append("]");
		return sb.toString();
	}
}
