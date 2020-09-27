package chinsoft.service.logistic;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

public class InterfaceUtil {
	public static InterfaceUtil instance = null;

	public static synchronized InterfaceUtil getInstance() {
		if (instance == null) {
			instance = new InterfaceUtil();
		}
		return instance;
	}

	public String sendData(String interfaceUrl, String para, String method)
			throws Exception {
		// 开启连接
		URL uploadServlet = new URL(interfaceUrl);
		URLConnection servletConnection = uploadServlet.openConnection();
		// 设置连接参数
		HttpURLConnection hc = (HttpURLConnection) servletConnection;
		hc.setRequestMethod(method);//post、get
		hc.setUseCaches(false);
		hc.setDoOutput(true);
		hc.setDoInput(true);
		// 开启流，写入JSON数据
		PrintWriter output = new PrintWriter(new OutputStreamWriter(hc.getOutputStream(), "UTF-8"));
		output.println(para);
		output.close();
		hc.getInputStream();
		try {
			// 接收返回参数
			StringBuffer backJsonBuffer = new StringBuffer();
			BufferedReader in = new BufferedReader(new InputStreamReader(hc.getInputStream(), "UTF-8"));
			String inputLine;
			while ((inputLine = in.readLine()) != null) {
				backJsonBuffer.append(inputLine);
			}
			in.close();
			System.out.println("发送信息："+ para);
			System.out.println("返回信息："+ backJsonBuffer.toString());
			return backJsonBuffer.toString();
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
}