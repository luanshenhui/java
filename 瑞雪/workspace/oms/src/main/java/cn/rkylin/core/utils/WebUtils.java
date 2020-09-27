package cn.rkylin.core.utils;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * 
 * ClassName: WebUtils
 * 
 * @Description: web用到的工具类
 * @author shixiaofeng@tootoo.cn
 * @date 2015年12月22日 下午6:22:02
 */
public class WebUtils {

	private static final String uploadUrl = PropertiesUtils.getInstance()
			.getPropertyByKey("upload_url");
	private static final String upload_common_image_url = PropertiesUtils
			.getInstance().getPropertyByKey("upload_common_image_url");
	private static final String image_delete_url = PropertiesUtils
			.getInstance().getPropertyByKey("image_delete_url");

	private static final Logger logger = Logger.getLogger(LogUtils.LOG_BOSS);

	/**
	 * 
	 * @Description: 获取用户的ip地址
	 * @param request
	 * @return String
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2015年12月22日 下午6:21:39
	 */
	public static String getUserIp(HttpServletRequest request) {
		String ip = request.getHeader("X-Real-IP");

		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)
				|| ip.indexOf("115.182.92.") > -1) {
			ip = request.getHeader("X-Forwarded-For");
		}

		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)
				|| "127.0.0.1".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)
				|| "127.0.0.1".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)
				|| "127.0.0.1".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}

	/**
	 * 
	 * @Description: 获取uuid
	 * @return String
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2015年12月23日 下午1:12:01
	 */
	public static String getUUID() {
		return UUID.randomUUID().toString();
	}

	public static String upload2WWW(File file, String param) {
		String uuid = "";
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
				.getRequestAttributes()).getRequest();
		Object uuidObj = request.getAttribute("uuid");
		if (uuidObj != null) {
			uuid = uuidObj.toString();
		}
		try {
			String BOUNDARY = "---------7d4a6d158c9"; // 定义数据分隔线
			URL url = new URL(uploadUrl + "?params=" + param);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			// 发送POST请求必须设置如下两行
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");

			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent",
					"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
			conn.setRequestProperty("Charsert", "UTF-8");
			conn
					.setRequestProperty("Accept",
							"text/html, image/gif, image/jpeg, image/png, *; q=.2, */*; q=.2");
			conn.setRequestProperty("Content-Type",
					"multipart/form-data; boundary=" + BOUNDARY);
			OutputStream out = new DataOutputStream(conn.getOutputStream());
			byte[] end_data = ("\r\n--" + BOUNDARY + "--\r\n").getBytes();// 定义最后数据分隔线
			StringBuilder sb = new StringBuilder();
			sb.append("--");
			sb.append(BOUNDARY);
			sb.append("\r\n");
			sb.append("Content-Disposition: form-data; name=\"image"
					+ "\"; filename=\"" + file.getName() + "\" \r\n");
			sb.append("Content-Type: image/jpeg \r\n\r\n");
			byte[] data = sb.toString().getBytes();

			out.write(data);
			DataInputStream in = new DataInputStream(new FileInputStream(file));
			int bytes = 0;
			byte[] bufferOut = new byte[1024];
			while ((bytes = in.read(bufferOut)) != -1) {
				out.write(bufferOut, 0, bytes);
			}
			// out.write("\r\n".getBytes()); //多个文件时，二个文件之间加入这个
			in.close();
			out.write(end_data);
			out.flush();
			out.close();
			// 定义BufferedReader输入流来读取URL的响应
			StringBuffer ret = new StringBuffer("");
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					conn.getInputStream()));
			String line = null;
			while ((line = reader.readLine()) != null) {
				ret.append(line);
			}
			return ret.toString();
		} catch (Exception e) {
			LogUtils.error(logger, uuid, "【图片上传失败】,入参param=" + param, e);
			return "";
		}
	}

	/**
	 * 通用图片上传方法，用户可以自定义上传图片所放的路径
	 */
	public static String uploadCommonImage2WWW(File file, String param) {
		String uuid = "";
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
				.getRequestAttributes()).getRequest();
		Object uuidObj = request.getAttribute("uuid");
		if (uuidObj != null) {
			uuid = uuidObj.toString();
		}
		try {
			String BOUNDARY = "---------7d4a6d158c9"; // 定义数据分隔线
			URL url = new URL(upload_common_image_url + "?params=" + param);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			// 发送POST请求必须设置如下两行
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");

			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent",
					"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
			conn.setRequestProperty("Charsert", "UTF-8");
			conn
					.setRequestProperty("Accept",
							"text/html, image/gif, image/jpeg, image/png, *; q=.2, */*; q=.2");
			conn.setRequestProperty("Content-Type",
					"multipart/form-data; boundary=" + BOUNDARY);
			OutputStream out = new DataOutputStream(conn.getOutputStream());
			byte[] end_data = ("\r\n--" + BOUNDARY + "--\r\n").getBytes();// 定义最后数据分隔线
			StringBuilder sb = new StringBuilder();
			sb.append("--");
			sb.append(BOUNDARY);
			sb.append("\r\n");
			sb.append("Content-Disposition: form-data; name=\"image"
					+ "\"; filename=\"" + file.getName() + "\" \r\n");
			sb.append("Content-Type: image/jpeg \r\n\r\n");
			byte[] data = sb.toString().getBytes();

			out.write(data);
			DataInputStream in = new DataInputStream(new FileInputStream(file));
			int bytes = 0;
			byte[] bufferOut = new byte[1024];
			while ((bytes = in.read(bufferOut)) != -1) {
				out.write(bufferOut, 0, bytes);
			}
			// out.write("\r\n".getBytes()); //多个文件时，二个文件之间加入这个
			in.close();
			out.write(end_data);
			out.flush();
			out.close();
			// 定义BufferedReader输入流来读取URL的响应
			StringBuffer ret = new StringBuffer("");
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					conn.getInputStream()));
			String line = null;
			while ((line = reader.readLine()) != null) {
				ret.append(line);
			}
			return ret.toString();
		} catch (Exception e) {
			LogUtils.error(logger, uuid, "【图片上传失败】,入参param=" + param, e);
			return "";
		}
	}

	/**
	 * 
	 * @Description: 删除图片
	 * @param imageName
	 *            void
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2016年1月11日 上午11:53:53
	 */
	public static boolean deleteImage(String imageName) {
		String uuid = "";
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
				.getRequestAttributes()).getRequest();
		Object uuidObj = request.getAttribute("uuid");
		if (uuidObj != null) {
			uuid = uuidObj.toString();
		}
		try {
			HttpRequester requester = new HttpRequester();
			Map<String, String> params = new HashMap<String, String>();
			params.put("filePath", imageName);

			HttpRespons hr = requester.sendPost(image_delete_url, params);
			// 请求删除失败
			if (!(hr.getCode() == 200 && hr.getMessage().equalsIgnoreCase("OK"))) {
				LogUtils.error(logger, uuid, "【删除图片失败】,图片名称为[" + imageName
						+ "]");
				return false;
			}
			return true;
		} catch (IOException e) {
			LogUtils
					.error(logger, uuid, "【删除图片失败】,图片名称为[" + imageName + "]", e);
			return false;
		}
	}
}
