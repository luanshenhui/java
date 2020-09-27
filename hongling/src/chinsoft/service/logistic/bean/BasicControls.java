package chinsoft.service.logistic.bean;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Map;
import java.util.Properties;

import net.sf.json.JSON;
import net.sf.json.JSONObject;
import net.sf.json.util.JSONUtils;
import net.sf.json.xml.XMLSerializer;

import org.apache.commons.configuration.XMLConfiguration;
import org.apache.commons.io.IOUtils;
import org.w3c.dom.Document;

import chinsoft.core.Utility;
import chinsoft.entity.Errors;

public class BasicControls {

	private static IniEditor config = new IniEditor();
	private static final String filePath =BasicControls.class.getResource("/").getPath();
	static{
		try {
			config.load(filePath+"Config.ini");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			config=null;
		}
	}
	public static String get5Radom() {
		String newString = null;
		// 得到0.0到1.0之间的数字,并扩大100000倍
		double doubleP = Math.random() * 100000;

		// 如果数据等于100000,则减少1
		if (doubleP >= 100000) {
			doubleP = 99999;
		}

		// 然后把这个数字转化为不包含小数点的整数
		int tempString = (int) Math.ceil(doubleP);

		// 转化为字符串
		newString = "" + tempString;

		// 把得到的数增加为固定长度,为5位
		while (newString.length() < 5) {
			newString = "0" + newString;
		}
		SimpleDateFormat df = new SimpleDateFormat("yyMMdd");
		Date d = new Date();
		newString = df.format(d).toString() + newString;
		return newString;
	}

	/**
	 * 返回格式为：yyMMdd
	 * 
	 * @return date
	 */
	public static String DateItem() {
		String date = new SimpleDateFormat("yyyyMMdd").format(GregorianCalendar.getInstance().getTime());
		date = date.substring(2, 8);
		return date;
	}

	/**
	 * 返回格式为：yyyy-MM-dd HH:mm:ss
	 * 
	 * @return date
	 */
	public static String DateTime() {
		String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
				.format(GregorianCalendar.getInstance().getTime());

		return date;
	}

	/**
	 * 返回格式为：yyyy-MM-dd HH:mm:ss SSSS
	 * 
	 * @return date
	 */
	public static String dateTime() {
		String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSSS")
				.format(GregorianCalendar.getInstance().getTime());

		return date;
	}

	/**
	 * 返回格式为：yyyy-MM-dd
	 * 
	 * @return date
	 */
	public static String date() {
		String date = new SimpleDateFormat("yyyy-MM-dd")
				.format(GregorianCalendar.getInstance().getTime());
		return date;
	}

	/**
	 * 返回格式为：yyyy-MM-dd
	 * 
	 * @return date
	 */
	public static String substrDateToString(Object objDate) {
		String strDate = Utility.toSafeString(objDate);
		if (strDate != null && strDate.length() > 10) {
			return strDate.substring(0, 10);
		}
		return strDate;
	}

	// STRING到日期
	public static java.sql.Date stringToDate(String dateStr) {
		if (dateStr == "" || dateStr == null) {
			return new java.sql.Date(System.currentTimeMillis());
		} else {
			return java.sql.Date.valueOf(dateStr);
		}

	}

	// 得到日期后几天
	public static String dateAddDay(String strTime, int nDay) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar c = Calendar.getInstance();
		try {
			Date d = sdf.parse(strTime);
			c.setTime(d);
			c.add(Calendar.DATE, 1);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sdf.format(c.getTime());
	}

	public static String getJFL(Integer fzflid, Integer zzfgid) {
		// 西服加放量
		if (fzflid == 1 || fzflid == 3 || fzflid == 4) {
			switch (zzfgid) {
			case 1:
				return "10";
			case 2:
				return "14";
			case 3:
				return "18";
			case 10:
				return "6";
			case 11:
				return "8";
			case 12:
				return "12";
			case 13:
				return "16";
			case 14:
				return "19";
			case 15:
				return "20";
			}
		}
		// 衬衣加放量
		if (fzflid == 5) {
			switch (zzfgid) {
			case 1:
				return "11";
			case 2:
				return "15";
			case 3:
				return "19";
			case 10:
				return "8";
			case 11:
				return "9";
			case 12:
				return "13";
			case 13:
				return "17";
			case 14:
				return "20";
			case 15:
				return "21";
			}
		}
		// 大衣加放量
		if (fzflid == 4) {
			switch (zzfgid) {
			case 1:
				return "14";
			case 2:
				return "18";
			case 3:
				return "21";
			case 11:
				return "12";
			case 12:
				return "16";
			case 13:
				return "19";
			}
		}
		return null;
	}

	public static String outErrorMessages(Errors errors) {
		if (errors.getList().size() > 0) {
			return XmlManager.doObjectToStrXml(errors);
		} else {
			return "";
		}
	}

	public static String getProValueByKey(String strKey,String a) {
		String strPath = BasicControls.class.getResource("/").getPath();
		InputStream inputStream;
		try {
			inputStream = new FileInputStream(strPath + "/config.properties");
			Properties properties = new Properties();
			properties.load(inputStream);
			String strValue = properties.getProperty(strKey);
			return strValue;
		} catch (Exception e) {
			// TODO Auto-generated catch block
		}
		return null;
	}

	public String insertFile(String file, String conent) {
		String filePath = BasicControls.getIniValueByKey("FilePath", "CAD_DCPCL");
		File findFile = new File(filePath);
		if (!findFile.exists()) {
			File creatFefile = new File(filePath);
			creatFefile.mkdirs();
		}
		String path = filePath + "\\" + file + ".txt";
		String conents = conent.replace("~", "\r\n");
		BufferedWriter out = null;
		try {
			out = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(path, false)));
			out.write(conents);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				out.close();
			} catch (IOException e) {
			}
		}
		String[] pathTxt = path.split("\\\\");
		return pathTxt[pathTxt.length - 1];
	}

	public void delAllFile(String path) {
		File file = new File(path);
		if (file.exists() && file.isDirectory()) {
			String[] tempList = file.list();
			File temp = null;
			for (int i = 0; i < tempList.length; i++) {
				if (path.endsWith(File.separator)) {
					temp = new File(path + tempList[i]);
				} else {
					temp = new File(path + File.separator + tempList[i]);
				}
				if (temp.isFile()) {
					temp.delete();
				}
			}
		}
	}

	/**
	 * 对SERVLET进行请求处理，并将结果在指定输出流中输出
	 * 
	 * @param os
	 * @param servletName
	 * @param parm
	 * @throws IOException
	 * @throws MalformedURLException
	 */
	public static String doSendProxy(String param, String url) throws Exception {
		// 取得连接
		HttpURLConnection huc = (HttpURLConnection) new URL(url)
				.openConnection();
		// 设置连接属性
		huc.setDoOutput(true);
		huc.setRequestMethod("POST");
		huc.setUseCaches(false);
		huc.setInstanceFollowRedirects(true);
		huc.setRequestProperty("Content-Type",
				"application/x-www-form-urlencoded");
		huc.connect();
		// 往目标servlet中提供参数
		OutputStream targetOS = huc.getOutputStream();
		targetOS.write(param.getBytes());
		targetOS.flush();
		targetOS.close();
		BufferedReader in = new BufferedReader(new InputStreamReader(
				huc.getInputStream()));
		String strResult = in.readLine();
		huc.disconnect();
		return strResult;
	}

	/**
	 * 向指定URL发送POST方法的请求
	 * 
	 * @param url
	 *            发送请求的URL
	 * @param param
	 *            请求参数，请求参数应该是name1=value1&name2=value2的形式。
	 * @return URL所代表远程资源的响应
	 */
	public static String sendPost(String strURL, String strParam) {
		PrintWriter out = null;
		BufferedReader in = null;
		String result = "";
		try {
			URL realUrl = new URL(strURL);
			// 打开和URL之间的连接
			URLConnection conn = realUrl.openConnection();
			// 设置通用的请求属性
			conn.setRequestProperty("accept", "*/*");
			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent",
					"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
			// 发送POST请求必须设置如下两行
			conn.setDoOutput(true);
			conn.setDoInput(true);
			// 获取URLConnection对象对应的输出流
			out = new PrintWriter(conn.getOutputStream());
			// 发送请求参数
			out.print(strParam);
			// flush输出流的缓冲
			out.flush();
			// 定义BufferedReader输入流来读取URL的响应
			in = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "UTF-8"));
			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}
		} catch (Exception e) {
			System.out.println("发送POST请求出现异常！" + e);
			e.printStackTrace();
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
				ex.printStackTrace();
			}
		}
		return result;
	}

	/**
	 * 将xml字符串转换为JSON对象
	 * 
	 * @param xmlFile
	 *            xml字符串
	 * @return JSON对象
	 */
	public static JSON getJSONFromXml(String xmlString) {
		XMLSerializer xmlSerializer = new XMLSerializer();
		JSON json = xmlSerializer.read(xmlString);
		return json;
	}

	/**
	 * 将xmlDocument转换为JSON对象
	 * 
	 * @param xmlDocument
	 *            XML Document
	 * @return JSON对象
	 */
	public static JSON getJSONFromXml(Document xmlDocument) {
		String xmlString = xmlDocument.toString();
		return getJSONFromXml(xmlString);
	}

	/**
	 * 将xml字符串转换为JSON字符串
	 * 
	 * @param xmlString
	 * @return JSON字符串
	 */
	public static String getJSONStringFromXml(String xmlString) {
		return getJSONFromXml(xmlString).toString();
	}

	/**
	 * 将xmlDocument转换为JSON字符串
	 * 
	 * @param xmlDocument
	 *            XML Document
	 * @return JSON字符串
	 */
	public static String getXMLtoJSONString(Document xmlDocument) {
		return getJSONStringFromXml(xmlDocument.toString());
	}

	/**
	 * 读取XML文件准换为JSON字符串
	 * 
	 * @param xmlFile
	 *            XML文件
	 * @return JSON字符串
	 */
	public static String getXMLFiletoJSONString(String xmlFile) {
		InputStream is = JSONUtils.class.getResourceAsStream(xmlFile);
		String xml;
		JSON json = null;
		try {
			xml = IOUtils.toString(is);
			XMLSerializer xmlSerializer = new XMLSerializer();
			json = xmlSerializer.read(xml);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return json.toString();
	}

	/**
	 * 将Java对象转换为JSON格式的字符串
	 * 
	 * @param javaObj
	 *            POJO,例如日志的model
	 * @return JSON格式的String字符串
	 */
	public static String getJsonStringFromJavaPOJO(Object javaObj) {
		return JSONObject.fromObject(javaObj).toString(1);
	}

	/**
	 * 将Map准换为JSON字符串
	 * 
	 * @param map
	 * @return JSON字符串
	 */
	public static String getJsonStringFromMap(Map<?, ?> map) {
		JSONObject object = JSONObject.fromObject(map);
		return object.toString();
	}

	public static String getJson2XML(String json) {
		JSONObject jobj = JSONObject.fromObject(json);
		String xml = new XMLSerializer().write(jobj);
		return xml;

	}

	/**
	 * 向指定URL发送GET方法的请求
	 * 
	 * @param url
	 *            发送请求的URL
	 * @param param
	 *            请求参数，请求参数应该是name1=value1&name2=value2的形式。
	 * @return URL所代表远程资源的响应
	 */
	public static String sendGet(String strURL, String strParam) {
		String result = "";
		BufferedReader in = null;
		try {
			String urlName = strURL + "?" + strParam;
			URL realUrl = new URL(urlName);
			// 打开和URL之间的连接
			URLConnection conn = realUrl.openConnection();
			// 设置通用的请求属性
			conn.setRequestProperty("accept", "*/*");
			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("version", "ems_track_cn_1.0");
			conn.setRequestProperty("authenticate", "qingdaohongling_ljaiu12az");
			conn.setRequestProperty("user-agent",
					"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
			// 建立实际的连接
			conn.connect();
			// 获取所有响应头字段
			// Map<String, List<String>> map = conn.getHeaderFields();
			// 遍历所有的响应头字段
			// for (String key : map.keySet()) {
			// System.out.println(key + "--->" + map.get(key));
			// }
			// 定义BufferedReader输入流来读取URL的响应
			in = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "UTF-8"));
			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}
		} catch (Exception e) {
			System.out.println("发送GET请求出现异常！" + e);
			e.printStackTrace();
		}
		// 使用finally块来关闭输入流
		finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		return result;
	}
//org.apache.commons.configuration.XMLConfiguration
	public static String getValueByKey(String strXml, String strKey)
			throws Exception {
		XMLConfiguration config = new XMLConfiguration();
		return config.getString(strKey);
	}

	public static String getIniValueByKey(String strGroupName,String strKey){
		String result=null;
		if (null!=config) {
			result=config.get(strGroupName, strKey);
		}
		return result;
	}

}
